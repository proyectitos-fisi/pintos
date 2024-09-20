# Loading Pintos

The first part of Pintos that runs is the loader
(in [src/threads/loader.S](../src/threads/loader.S)), which is loaded by the BIOS into memory
and is responsible for finding and loading the kernel into memory.

About disk locations:

- The loader is loaded by the BIOS at address `0x7c00` of the first sector of the disk, called
  the master boot record (MBR).

  > An MBR is loaded by the BIOS at physical address 0x7c00, with DL set to the "drive number"
  > that the MBR was loaded from. The BIOS then jumps to the very beginning of the loaded
  > MBR (0x7c00), because that part of the MBR contains the "bootstrap" executable code.
  >
  > From: <https://wiki.osdev.org/MBR_(x86)>

- Kernel entrypoint doesn't need to be stored in any specific partition or section of the disk.
  It can be anywhere on the disk. The loader is responsible for finding the kernel and loading
  it into memory.

  > Typical MBR bootstrap code will do the following:
  >
  > - relocate itself away from the 0x7c00 physical address (using a memory copy, and usually
  >   a far jump)
  > - determine which partition (or hard disk) to boot from (either by looking for the active
  >   partition, or by presenting the user with a selection of installed operating systems to
  >   choose from)
  > - if the user selected an "inactive" partition, then set the selected partition entry to
  >   "active", and clear the "active" bits of other partition entries use BIOS INT 13h
  >   commands to rewrite the MBR if the partition table entries were modified use BIOS INT
  >   13h commands to load the Volume Boot Record (VBR, the "bootsector" of the bootloader) from
  >   the beginning of the selected partition to physical address 0x7c00
  > - set DS:SI pointing to the selected partition table entry
  > - jump to 0x7c00 (with CS set to 0, and DL set to the "drive number")
  >
  > From: <https://wiki.osdev.org/MBR_(x86)>

## Loader overview (loader.S)

When the BIOS executes the bootloader, CPU enters in real mode. Real mode is a 16-bit mode of
operation that is provided for backward compatibility with the 8086 processor. In real mode,

IA32 bootloaders generally have to fit within 512 bytes in memory for a partition or floppy disk
bootloader (i.e., only the first disk sector, and the last 2 bytes are fixed signatures for
recognizing it is a bootloader).

In addition, since BIOS and bootloader are running on bare-metals, there are no standard library
call like `printf` or system call like `read` available.

That's why the loader is written in assembly, because even C code would introduce too much
bloat.

Good reading: <https://pkuflyingpig.gitbook.io/pintos/project-description/lab0-booting/background>
