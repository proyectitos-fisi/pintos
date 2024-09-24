# Pintos project 1: Threads

This project only requires accessing a little bit of thread state from interrupt handlers.

For the alarm clock, the timer interrupt needs to wake up sleeping threads.

In the advanced scheduler, the timer interrupt needs to access a few global and **per-thread**
**variables**. When you access these variables from kernel threads, you will need to disable
interrupts to prevent the timer interrupt from interfering.

## Task 1: Alarm Clock

### Files to modify

- threads/thread.*
- devices/timer.*

There's a system call called `timer_alarm(int ticks)` what wakes up a process in [`ticks`] amount
of time.

Before project 1:

- Pintos uses busy waiting for alarm, swithcing from READY to RUNNING state, wasting CPU time
  continuously checking if the alarm has elapsed.

After project 1:

- Pintos will use the sleep/wakup paradigm for implementing alarms.

### Current `timer_alarm` implementation

```c
/* Sleeps for approximately TICKS timer ticks.  Interrupts must
   be turned on. */
void
timer_sleep (int64_t ticks)
{
  int64_t start = timer_ticks ();

  ASSERT (intr_get_level () == INTR_ON);
  while (timer_elapsed (start) < ticks)
    thread_yield ();
}
```

As you can see, it yields until the timer ticks have elapsed.

By the way, at this point of the Pintos kernel, this `timer_sleep` is not called anywhere.

## Who calls `timer_interupt`?

As you may already know, `timer_interrupt` is "heart of everything" in this task, but who calls it?

If you look at the `void timer_init ()` called in `init.c`, the `timer_interrupt` is registered
as a handler for the 0x20 interrupt at a frequency of 100 Hz.

Therefore, the answer is the 8254 timer chip.

### What's yield anyway?

Yield is a way for the current thread to voluntary give up the CPU, and send it to the end of
the `ready_list`, giving other threads a chance to run.

## Task 2: Priority Scheduling

## References

1. Yield (multithreading)
