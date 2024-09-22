# Synchronization

Pintos provides several synchronization primitives to help out sharing resources between threads.

## Kernel preemption

A preemptive kernel allows the CPU to be interrumped (preempted) in the middle of executing
**kernel code** to execute other task, and later return to finish it.

A non preemptive kernel, on the other hand, always wait for the driver or kernel function to
finish before executing another task, such as user code.

A non preemptive kernel may suffer of:

- A device can enter an infinite loop, or any other unrecoverable state, crashing the whole system.

- Starvation: kernel code (such as system calls or drivers) can be slow to execute, and cannot
  return control to the user code.

### Linux is preemptive

Linux provides both user preemption as well as full kernel preemption. Preemption reduces latency,
increases responsiveness, and makes Linux more suitable for desktop and real-time applications⁴.

### Pintos is preemptive

Pintos is a preemptive kernel, that is, **kernel threads** can be preempted at any time.
Furthermore, interrupts are enabled by default, requiring more explicit synchronization.

See [Disabling interrupts](./interrupts.md#disabling-interrupts).

### Preemption and user code

In both models (preemtive and non preemtive kernels) user code is always preemptive, that is,
can be interrupted at any time. As a result, an infinite loop in an user-space program cannot
hang the whole system.

### Achieving concurrency in single-core systems

Does a **non preemtive kernel** need synchronization when running on a single-processor PC?

The answer is obviously **no**, because kernel code can't be interrumpted, and nor can it be
executed by more than one processor.

As a result, when running in non preemtive mode, the Linux kernel converts all the spin locks
in no-ops. (See the `CONFIG_PREEMPT` option in the Linux kernel configuration).

However, when the kernel runs in preemptive mode, interrupts can preempt the kernel code, and
synchronization is needed, even in single-processor systems³.

## References

1. Pintos Synchronization. Stanford: <https://www.scs.stanford.edu/24wi-cs212/pintos/pintos_6.html#SEC100>
2. Kernel Preemption. Wikipedia: <https://en.wikipedia.org/wiki/Kernel_preemption>
3. Preemption under Linux. Kernel Newbies: <https://kernelnewbies.org/FAQ/Preemption>
4. Linux Scheduling. Wikipedia: <https://en.wikipedia.org/wiki/Linux_kernel#Scheduling>
