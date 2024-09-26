#ifndef THREADS_FIXED_POINT_H
#define THREADS_FIXED_POINT_H

#include <stdint.h>

/* Fixed-point arithmetic macros */
#define F (1 << 14)

/* Convert integer n to fixed-point. */
#define INT_TO_FP(n) ((n) * F)

/* Convert fixed-point x to integer (round down). */
#define FP_TO_INT(x) ((x) / F)

/* Convert fixed-point x to integer (round). */
#define FP_TO_INT_ROUND(x) ((x) >= 0 ? ((x) + F / 2) / F : ((x) - F / 2) / F)

/* Add two fixed-point numbers. */
#define FP_ADD(x, y) ((x) + (y))

/* Subtract y from x (both fixed-point). */
#define FP_SUB(x, y) ((x) - (y))

/* Add fixed-point x and integer n. */
#define FP_ADD_INT(x, n) ((x) + INT_TO_FP(n))

/* Subtract integer n from fixed-point x. */
#define FP_SUB_INT(x, n) ((x) - INT_TO_FP(n))

/* Multiply two fixed-point numbers. */
#define FP_MULT(x, y) (((int64_t)(x)) * (y) / F)

/* Multiply fixed-point x by integer n. */
#define FP_MULT_INT(x, n) ((x) * (n))

/* Divide fixed-point x by fixed-point y. */
#define FP_DIV(x, y) (((int64_t)(x)) * F / (y))

/* Divide fixed-point x by integer n. */
#define FP_DIV_INT(x, n) ((x) / (n))

#endif /* threads/fixed_point.h */
