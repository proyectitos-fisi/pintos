# Running pintos

There's a wrapper binary located in [src/utils/pintos](../src/utils/pintos). It accepts simulator
command line arguments.

```console
$ pintos

pintos, a utility for running Pintos in a simulator
Usage: pintos [OPTION...] -- [ARGUMENT...]
where each OPTION is one of the following options
  and each ARGUMENT is passed to Pintos kernel verbatim.
Simulator selection:
  --bochs                  (default) Use Bochs as simulator
  --qemu                   Use QEMU as simulator
  --player                 Use VMware Player as simulator
Debugger selection:
  --no-debug               (default) No debugger
  --monitor                Debug with simulator's monitor
  --gdb                    Debug with gdb
Display options: (default is both VGA and serial)
  -v, --no-vga             No VGA display or keyboard
  -s, --no-serial          No serial input or output
  -t, --terminal           Display VGA in terminal (Bochs only)
Timing options: (Bochs only)
  -j SEED                  Randomize timer interrupts
  -r, --realtime           Use realistic, not reproducible, timings
Testing options:
  -T, --timeout=N          Kill Pintos after N seconds CPU time or N*load_avg
                           seconds wall-clock time (whichever comes first)
  -k, --kill-on-failure    Kill Pintos a few seconds after a kernel or user
                           panic, test failure, or triple fault
Configuration options:
  -m, --mem=N              Give Pintos N MB physical RAM (default: 4)
File system commands:
  -p, --put-file=HOSTFN    Copy HOSTFN into VM, by default under same name
  -g, --get-file=GUESTFN   Copy GUESTFN out of VM, by default under same name
  -a, --as=FILENAME        Specifies guest (for -p) or host (for -g) file name
Partition options: (where PARTITION is one of: kernel filesys scratch swap)
  --PARTITION=FILE         Use a copy of FILE for the given PARTITION
  --PARTITION-size=SIZE    Create an empty PARTITION of the given SIZE in MB
  --PARTITION-from=DISK    Use of a copy of the given PARTITION in DISK
  (There is no --kernel-size, --scratch, or --scratch-from option.)
Disk configuration options:
  --make-disk=DISK         Name the new DISK and don't delete it after the run
  --disk=DISK              Also use existing DISK (may be used multiple times)
Advanced disk configuration options:
  --loader=FILE            Use FILE as bootstrap loader (default: loader.bin)
  --geometry=H,S           Use H head, S sector geometry (default: 16,63)
  --geometry=zip           Use 64 head, 32 sector geometry for USB-ZIP boot
                           (see http://syslinux.zytor.com/usbkey.php)
  --align=bochs            Pad out disk to cylinder to support Bochs (default)
  --align=full             Align partition boundaries to cylinder boundary to
                           let fdisk guess correct geometry and quiet warnings
  --align=none             Don't align partitions at all, to save space
Other options:
  -h, --help               Display this help message.
```

Not to be confused with the actual kernel arguments.

```console
$ pintos --qemu -v -- -h

Kernel command line: -h

Command line syntax: [OPTION...] [ACTION...]
Options must precede actions.
Actions are executed in the order specified.

Available actions:
  run TEST           Run TEST.

Options:
  -h                 Print this help message and power off.
  -q                 Power off VM after actions or on panic.
  -r                 Reboot after actions.
  -rs=SEED           Set random number seed to SEED.
  -mlfqs             Use multi-level feedback queue scheduler.
```
