# Pintos memory allocation

Reference: <https://www.scs.stanford.edu/24wi-cs212/pintos/pintos_6.html#SEC111>

Pintos contains two allocators:

- One that allocates memory in units of pages, in [threads/palloc.h](../src/threads/palloc.h).
- One that allocate blocks of arbitrary size, in [threads/palloc.h](../src/threads/malloc.h).

Both allocators are initialized in `palloc_init()` and `malloc_init()` respectively
(See [init.c](../src/threads/init.c)).

## Page allocator

The palloc API exposes two main functions for allocating:

- `void* palloc_get_multiple (enum palloc_flags flags, size_t page_cnt)`

  Which allocates `page_cnt` multiple contiguous pages of memory of size `PGSIZE`
  (set to 4096 bytes).

  It may fail due to pages fragmentation, since Pintos uses a "first fit" allocation strategy,
  maintaing a `used_map` of bits where each bit represents the status of a page (free or used).

- `void* palloc_get_page (enum palloc_flags flags)`

  Calls `palloc_get_multiple (flags, 1)`. Can't fail due to fragmentation.

The page allocator divides the memory it allocates into two pools, called the kernel
and user pools. Always use the kernel pool unless you are writing user programs.

## Block allocator

Block allocator is layered on top of the page allocator.

It uses two different allocation strategies:

- If the block is of 1KB or smaller, it rounds up the size to the nearest power of two. We
  maintain a total of 10 of these free lists (from 2^0 to 2^9) in `malloc.c`.

- For blocks larger than 1KB, it rounds the size up to get the necessary number of pages
  and uses the page allocator to allocate the memory.

## Notes for debugging

- When a page is freed, all of its bytes are cleared to 0xcc, as a debugging aid
  (see [section E.8 Tips](https://www.scs.stanford.edu/24wi-cs212/pintos/pintos_10.html#SEC157)).

- Allocated pages contain a magic number (`0x9a548eed`) at the beginning and end of the page, to
  help detect buffer overflows. See [ARENA_MAGIC] in [palloc.c](../src/threads/malloc.c).

See also:

- E.8 Tips: <https://www.scs.stanford.edu/24wi-cs212/pintos/pintos_10.html#SEC157>
