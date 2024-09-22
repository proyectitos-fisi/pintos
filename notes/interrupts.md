# Interrupt Handling

Interrupts notify the CPU of some event. Operating systems rely on interrupts to handle I/O devices, timers, and other hardware events.

Pintos classifies interrupts in two categories:

- **Internal interrupts**: caused directly by CPU instructions, such as

  - System calls
  - Page faults (attempt to read at invalid memory address)
  - Attempts to divide by zero

  Thus, `intr_disable()` does not disable internal interrupts.

- **External interrupts**: originated outside the CPU, generated from hardware devices, such as

  - Timer interrupts, integrated in the computer's motherboard and programmable to notify the CPU
    at regular, programmable intervals.
  - Keyboard interrupts.
  - Serial ports interrupts, generated when a serial port receives data.
  - Disk interrupts, notifying the CPU that a disk operation has finished.

  External interrupts can be postponed with `intr_disable()`. See
  [Disabling interrupts](#disabling-interrupts).

  External inputs can't sleep and thus can't use most other forms of syncrhonization.

The above categories refer to their source, however CPU treats both classes largely the same way.

## What's an interrupt handler anyway?

An interrupt handler is a piece of code that runs when an interrupt is triggered. An interrupt
vector table maps each interrupt to its handler. While this vector is a CPU feature, the OS
populates it with the appropriate handlers.

## Pintos interrupt handling

Upon receiving an interrupt, the CPU doesn't save what you may expect. CPU only saves the
program counter and the processor status register (PSR). The OS must save the rest of the CPU state,
if necessary. This includes all registers, the stack pointer, and the frame pointer.

```c
// interrupt.c

/* Interrupt stack frame. */
struct intr_frame {
  /* Pushed by intr_entry in intr-stubs.S.
    These are the interrupted task's saved registers. */
  uint32_t edi;               /* Saved EDI. */
  uint32_t esi;               /* Saved ESI. */
  uint32_t ebp;               /* Saved EBP. */
  uint32_t esp_dummy;         /* Not used. */
  uint32_t ebx;               /* Saved EBX. */
  uint32_t edx;               /* Saved EDX. */
  uint32_t ecx;               /* Saved ECX. */
  uint32_t eax;               /* Saved EAX. */
  uint16_t gs, :16;           /* Saved GS segment register. */
  uint16_t fs, :16;           /* Saved FS segment register. */
  uint16_t es, :16;           /* Saved ES segment register. */
  uint16_t ds, :16;           /* Saved DS segment register. */

  /* Pushed by intrNN_stub in intr-stubs.S. */
  uint32_t vec_no;            /* Interrupt vector number. */

  // ...
};
```

The 80x86 architecture supports 256 interrupts, numbered 0 through 255, each with an independent
handler defined  in an array called IDT (interrupt descriptor table).

The following IDT is initialized by `intr_init()`, which works with
[`intr.stubs.S`](../src/threads/intr-stubs.S) to register all interrupt handlers which calls the
corresponding  `intr##_handler` (e.g., `intr0_handler`, `intr1_handler`, etc.).

```c
// interrupt.c

/* The Interrupt Descriptor Table (IDT).  The format is fixed by
  the CPU.  See [IA32-v3a] sections 5.10 "Interrupt Descriptor
  Table (IDT)", 5.11 "IDT Descriptors", 5.12.1.2 "Flag Usage By
  Exception- or Interrupt-Handler Procedure". */
static uint64_t idt[INTR_CNT];

/* Interrupt handler functions for each interrupt. */
static intr_handler_func *intr_handlers[INTR_CNT];

/* Names for each interrupt, for debugging purposes. */
static const char *intr_names[INTR_CNT];

/* Number of unexpected interrupts for each vector.  An
  unexpected interrupt is one that has no registered handler. */
static unsigned int unexpected_cnt[INTR_CNT];
```

[`intr.stubs.S`](../src/threads/intr-stubs.S) code also defines the interrupts entry and exit
points, in `intr_entry` and `intr_exit` respectively. In a nutshell, they save the CPU state,
calls the interrupt handler (`intr_handler()`), and restores the CPU state in asm code.

They save the CPU state by pushing the registers on the stack, and then calling `intr_handler()`,
which takes the interrupt frame as an argument.

```c
// interrupt.c
void intr_handler (struct intr_frame *frame);
```

Then, the registered handler is called from `intr_handlers[]` array, panicking when not found.
Finally, they notify the PIC (Programmable Interrupt Controller) that the interrupt has been
handled by calling `pic_end_of_interrupt(int irq)` (`irq` being the frame number).

Only one external input may be processed at a time, and that's wwhy they MUST Run even with
interrupts disabled. They can't also sleep or yield (disallowing the use of locks, `thread_yield()`,
etc.). They are controlled by the CPU's PIC (programmable interrupt controllers).

## Disabling interrupts

As a preemptive kernel, Pintos has interrupts enabled by default, and you'll need to use
synchronization primitives to ensure your code runs correctly.

If we take a look at [`interrupt.sh`](../src/threads/interrupt.h), however, we see that Pintos
provides functions to enable and disable interrupts.

```c
enum intr_level intr_get_level (void);
enum intr_level intr_set_level (enum intr_level); // ON/OFF
enum intr_level intr_enable (void);
enum intr_level intr_disable (void);
```

You should have little need to set interrupt state directly, and use synchronization primitives
instead. The main reason to disable interrupts is to synchronize kernel threads with **external**
interrupt handlers, since, at mentioned before, cannot sleep.

That's why you can see `intr_disable()` in the Pintos codebase when manipulating, for example,
I/O devices.

There are other places where disabling interrupts also make sense, like inside the implementation
of synchronization primitives, such as locks, semaphores, and condition variables.

By the way, the state of interrupts are no more than a CPU flag. See [IF flag](asm.md).

## References

1. Pintos Interrupt Handling. Stanford: <https://www.scs.stanford.edu/24wi-cs212/pintos/pintos_6.html#SEC107>
2. Context switch. Wikipedia: <https://en.wikipedia.org/wiki/Context_switch>
