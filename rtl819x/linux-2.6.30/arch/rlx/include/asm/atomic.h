/*
 * Atomic operations that C can't guarantee us.  Useful for
 * resource counting etc..
 *
 * But use these as seldom as possible since they are much more slower
 * than regular operations.
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" in the main directory of this archive
 * for more details.
 *
 * Copyright (C) 1996, 97, 99, 2000, 03, 04, 06 by Ralf Baechle
 */
#ifndef _ASM_ATOMIC_H
#define _ASM_ATOMIC_H

#include <linux/irqflags.h>
#include <linux/types.h>
#include <linux/linkage.h>
#include <asm/barrier.h>
#include <asm/cpu-features.h>
#include <asm/system.h>

#define ATOMIC_INIT(i)    { (i) }

/*
 * atomic_read - read atomic variable
 * @v: pointer of type atomic_t
 *
 * Atomically reads the value of @v.
 */
#define atomic_read(v)		((v)->counter)

/*
 * atomic_set - set atomic variable
 * @v: pointer of type atomic_t
 * @i: required value
 *
 * Atomically sets the value of @v to @i.
 */
#define atomic_set(v, i)		((v)->counter = (i))

/*
 * atomic_add - add integer to atomic variable
 * @i: integer value to add
 * @v: pointer of type atomic_t
 *
 * Atomically adds @i to @v.
 */
static __inline__ void atomic_add(int i, atomic_t * v)
{
#ifdef CONFIG_CPU_HAS_LLSC
		int temp;

    smp_llsc_mb();

		__asm__ __volatile__(
		"	.set	mips3					\n"
		"1:	ll	%0, %1		# atomic_add		\n"
#if defined(CONFIG_CPU_RLX4181) || defined(CONFIG_CPU_RLX5181) || defined(CONFIG_CPU_RLX5281)
                "       nop                                             \n"
#endif
		"	addu	%0, %2					\n"
		"	sc	%0, %1					\n"
		"	beqz	%0, 2f					\n"
		"	.subsection 2					\n"
		"2:	b	1b					\n"
		"	.previous					\n"
		"	.set	mips0					\n"
		: "=&r" (temp), "=m" (v->counter)
		: "Ir" (i), "m" (v->counter));

    smp_llsc_mb();
#else
		unsigned long flags;

		raw_local_irq_save(flags);
		v->counter += i;
		raw_local_irq_restore(flags);
#endif
}

/*
 * atomic_sub - subtract the atomic variable
 * @i: integer value to subtract
 * @v: pointer of type atomic_t
 *
 * Atomically subtracts @i from @v.
 */
static __inline__ void atomic_sub(int i, atomic_t * v)
{
#ifdef CONFIG_CPU_HAS_LLSC
		int temp;

    smp_llsc_mb();

		__asm__ __volatile__(
		"1:	ll	    %0, %1		# atomic_sub		\n"
#if defined(CONFIG_CPU_RLX4181) || defined(CONFIG_CPU_RLX5181) || defined(CONFIG_CPU_RLX5281)
                "       nop                                             \n"
#endif
		"	subu	%0, %2					\n"
		"	sc	    %0, %1					\n"
		"	beqz	%0, 2f					\n"
		"	.subsection 2					\n"
		"2:	b	1b					\n"
		"	.previous					\n"
		: "=&r" (temp), "=m" (v->counter)
		: "Ir" (i), "m" (v->counter));

    smp_llsc_mb();
#else
		unsigned long flags;

		raw_local_irq_save(flags);
		v->counter -= i;
		raw_local_irq_restore(flags);
#endif
}

/*
 * Same as above, but return the result value
 */
static __inline__ int atomic_add_return(int i, atomic_t * v)
{
#ifdef CONFIG_CPU_HAS_LLSC
	int result;
    int temp;
	smp_llsc_mb();

		__asm__ __volatile__(
		"1:	ll	%1, %2		# atomic_add_return	\n"
#if defined(CONFIG_CPU_RLX4181) || defined(CONFIG_CPU_RLX5181) || defined(CONFIG_CPU_RLX5281)
                "       nop                                             \n"
#endif
		"	addu	%0, %1, %3				\n"
		"	sc	%0, %2					\n"
		"	beqz	%0, 2f					\n"
		"	addu	%0, %1, %3				\n"
		"	.subsection 2					\n"
		"2:	b	1b					\n"
		"	.previous					\n"
		: "=&r" (result), "=&r" (temp), "=m" (v->counter)
		: "Ir" (i), "m" (v->counter)
		: "memory");

	smp_llsc_mb();
#else
	int result;
    unsigned long flags;

		raw_local_irq_save(flags);
		result = v->counter;
		result += i;
		v->counter = result;
		raw_local_irq_restore(flags);
#endif

	return result;
}

static __inline__ int atomic_sub_return(int i, atomic_t * v)
{
#ifdef CONFIG_CPU_HAS_LLSC
	int result;
    int temp;

	smp_llsc_mb();

		__asm__ __volatile__(
		"1:	ll	%1, %2		# atomic_sub_return	\n"
#if defined(CONFIG_CPU_RLX4181) || defined(CONFIG_CPU_RLX5181) || defined(CONFIG_CPU_RLX5281)
                "       nop                                             \n"
#endif
		"	subu	%0, %1, %3				\n"
		"	sc	%0, %2					\n"
		"	beqz	%0, 2f					\n"
		"	subu	%0, %1, %3				\n"
		"	.subsection 2					\n"
		"2:	b	1b					\n"
		"	.previous					\n"
		: "=&r" (result), "=&r" (temp), "=m" (v->counter)
		: "Ir" (i), "m" (v->counter)
		: "memory");

	smp_llsc_mb();
#else
    unsigned long flags;
	int result;

		raw_local_irq_save(flags);
		result = v->counter;
		result -= i;
		v->counter = result;
		raw_local_irq_restore(flags);

#endif

	return result;
}

/*
 * atomic_sub_if_positive - conditionally subtract integer from atomic variable
 * @i: integer value to subtract
 * @v: pointer of type atomic_t
 *
 * Atomically test @v and subtract @i if @v is greater or equal than @i.
 * The function returns the old value of @v minus @i.
 */
static __inline__ int atomic_sub_if_positive(int i, atomic_t * v)
{
#ifdef CONFIG_CPU_HAS_LLSC
	int result;
    int temp;

	smp_llsc_mb();

		__asm__ __volatile__(
		"1:	ll	%1, %2		# atomic_sub_if_positive\n"
#if defined(CONFIG_CPU_RLX4181) || defined(CONFIG_CPU_RLX5181) || defined(CONFIG_CPU_RLX5281)
                "       nop                                             \n"
#endif
		"	subu	%0, %1, %3				\n"
		"	bltz	%0, 1f					\n"
		"	sc	%0, %2					\n"
		"	.set	noreorder				\n"
		"	beqz	%0, 2f					\n"
		"	 subu	%0, %1, %3				\n"
		"	.set	reorder					\n"
		"	.subsection 2					\n"
		"2:	b	1b					\n"
		"	.previous					\n"
		"1:							\n"
		: "=&r" (result), "=&r" (temp), "=m" (v->counter)
		: "Ir" (i), "m" (v->counter)
		: "memory");

	smp_llsc_mb();
#else
    unsigned long flags;
	int result;

		raw_local_irq_save(flags);
		result = v->counter;
		result -= i;
		if (result >= 0)
			v->counter = result;
		raw_local_irq_restore(flags);
#endif

	return result;
}

#define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))

/**
 * atomic_add_unless - add unless the number is a given value
 * @v: pointer of type atomic_t
 * @a: the amount to add to v...
 * @u: ...unless v is equal to u.
 *
 * Atomically adds @a to @v, so long as it was not @u.
 * Returns non-zero if @v was not @u, and zero otherwise.
 */
static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
{
	int c, old;
	c = atomic_read(v);
	for (;;) {
		if (unlikely(c == (u)))
			break;
		old = atomic_cmpxchg((v), c, c + (a));
		if (likely(old == c))
			break;
		c = old;
	}
	return c != (u);
}
#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)

#define atomic_dec_return(v) atomic_sub_return(1, (v))
#define atomic_inc_return(v) atomic_add_return(1, (v))

/*
 * atomic_sub_and_test - subtract value from variable and test result
 * @i: integer value to subtract
 * @v: pointer of type atomic_t
 *
 * Atomically subtracts @i from @v and returns
 * true if the result is zero, or false for all
 * other cases.
 */
#define atomic_sub_and_test(i, v) (atomic_sub_return((i), (v)) == 0)

/*
 * atomic_inc_and_test - increment and test
 * @v: pointer of type atomic_t
 *
 * Atomically increments @v by 1
 * and returns true if the result is zero, or false for all
 * other cases.
 */
#define atomic_inc_and_test(v) (atomic_inc_return(v) == 0)

/*
 * atomic_dec_and_test - decrement by 1 and test
 * @v: pointer of type atomic_t
 *
 * Atomically decrements @v by 1 and
 * returns true if the result is 0, or false for all other
 * cases.
 */
#define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) == 0)

/*
 * atomic_dec_if_positive - decrement by 1 if old value positive
 * @v: pointer of type atomic_t
 */
#define atomic_dec_if_positive(v)	atomic_sub_if_positive(1, v)

/*
 * atomic_inc - increment atomic variable
 * @v: pointer of type atomic_t
 *
 * Atomically increments @v by 1.
 */
#define atomic_inc(v) atomic_add(1, (v))

/*
 * atomic_dec - decrement and test
 * @v: pointer of type atomic_t
 *
 * Atomically decrements @v by 1.
 */
#define atomic_dec(v) atomic_sub(1, (v))

/*
 * atomic_add_negative - add and test if negative
 * @v: pointer of type atomic_t
 * @i: integer value to add
 *
 * Atomically adds @i to @v and returns true
 * if the result is negative, or false when
 * result is greater than or equal to zero.
 */
#define atomic_add_negative(i, v) (atomic_add_return(i, (v)) < 0)

/*
 * atomic*_return operations are serializing but not the non-*_return
 * versions.
 */
#define smp_mb__before_atomic_dec()	smp_llsc_mb()
#define smp_mb__after_atomic_dec()	smp_llsc_mb()
#define smp_mb__before_atomic_inc()	smp_llsc_mb()
#define smp_mb__after_atomic_inc()	smp_llsc_mb()

#include <asm-generic/atomic-long.h>

#endif /* _ASM_ATOMIC_H */
