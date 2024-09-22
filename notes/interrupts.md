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

The above categories refer to their source, however CPU treats both classes largely the same way.

## What's an interrupt handler anyway?

An interrupt handler is a piece of code that runs when an interrupt is triggered. An interrupt
vector table maps each interrupt to its handler. While this vector is a CPU feature, the OS
populates it with the appropriate handlers.

## Pintos interrupt handling

Upon receiving an interrupt, the CPU saves its most essential state on a stack, and jumps to a
handler routine.

## Disabling interrupts

## References

1. Pintos Interrupt Handling. Stanford: <https://www.scs.stanford.edu/24wi-cs212/pintos/pintos_6.html#SEC107>
