# Context switching in Pintos

While running a process, the scheduler makes a decision:

- Whether to continue running the current process
- or to switch to a different one

If the decision is made to switch, the OS executes **context switch**.

## Steps

Context switch is a low-level piece of assembly code ([switch.S](../src/threads/switch.S) in
Pintos) that:

- Saves the current process state, including registers, stack pointer (ESP), and program counter
  (PC).

- Restores the state of the new process.

- Switches the ESP (stack pointer) value to point to the new process stack.

## How context switching is done in Pintos

The `schedule()` function is responsible for scheduling a new process by popping from the
`ready_list` (list of processes with READY state) and switching to it by calling`switch_threads()`.

Actual `switch_treads` implementation is written in assembly, as stated in [Steps](#steps).

Finally, the current thread is set to running and, if the previous thread was dying
(`prev->status == THREAD_DYING`), then it's freed (the entire allocated 4KB page).

Definitions:

- `static void schedule (void)`
- `struct thread *switch_threads (struct thread *cur, struct thread *next)`

> only a thread in the
> ready state is on the run queue, whereas only a thread in the
> blocked state is on a semaphore wait list.

## References

1. Context switch. Wikipedia: <https://en.wikipedia.org/wiki/Context_switch>
