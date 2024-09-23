# Floating point arithmetic in Pintos

Pintos kernel doesn't support floating point arithmetic. Instead, we use fixed-point real
arithmetic, which, in a nutshell, simulates floats using integers.

Refer to [1] for technical details.

## Why though?

Because it would complicate and slow the kernel.

## References

1. Fixed-Point Real Arithmetic. Stanford: <https://www.scs.stanford.edu/24wi-cs212/pintos/pintos_7.html#SEC137>
