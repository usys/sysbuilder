
                     XMGR and UIDE -- DOS Device Drivers
                   =======================================

1. Description
   -----------

   XMGR and UIDE are DOS device drivers.    They can be used with a system
   having an 80386+ CPU and running MS-DOS V5.0+ or equivalent.

   XMGR is a DOS driver that works as an XMS memory manager.   It provides
   up to 4-GB of XMS memory and is written to the V3.0 XMS Specifications.
   XMGR has direct support for V3.70+ UMBPCI by Uwe Sieber.   After UMBPCI
   enables upper-memory, XMGR can load there directly and offer both upper
   and XMS memory to a DOS system.   XMGR uses an I-O catcher with UMBPCI,
   to "catch" hard-disk or diskette I-O above 640K.   Such I-O goes thru a
   low memory area, to avoid DMA problems with UMBPCI "Shadow RAM".   XMGR
   also supports V4.49 or V4.95 EMM386 (MS-DOS V6.22/V7.10).   For EMM386,
   XMGR using its /B switch can first "boot" into temporary space.   After
   EMM386 enables upper-memory, XMGR loads there with no /B switch, copies
   all its "boot" data, and takes-over XMS work.    Only its XMS "Handles"
   table stays in low memory, so EMM386 will find them at fixed addresses.
   For a small XMS-only system, XMGR can load entirely in low memory.

   UIDE is a DOS "Universal IDE" caching driver.   It intercepts "Int 13h"
   BIOS I-O requests and can cache data for up to 38 BIOS disks, including
   standard A: and B: diskettes if present, and including newer hard disks
   with over 128-GB of data.    UIDE accepts 48-bit LBA and 24-bit CHS I-O
   calls from new or old DOS systems.   It uses its own IDE logic for SATA
   or IDE hard-disks, and it handles up to 10 "Legacy" or "Native PCI" IDE
   controllers.   All possible IDE I-O is done thru its cache buffers, for
   faster speed.   UIDE "calls the BIOS" for diskettes, SCSI or other type
   disks, so it caches ALL disks for a DOS system!   "Int 13h" drivers can
   load before UIDE, and it will intercept and cache I-O for those drivers
   also.   Drivers using "ASPI" or I-O other than Int 13h are unsupported.

   UIDE also supports up to 8 CD/DVD drives, including SATA, IDE, or older
   "PIO mode" drives.   On loading, it checks up to 10 "Legacy" or "Native
   PCI" IDE controllers and runs the first 8 CD/DVD drives found.     UIDE
   does file input for SHCDX33C or other "CD-ROM Redirectors" like MSCDEX,
   and it caches all file data and directories for faster speed!   It also
   supports DOS "audio" requests and will "play back" an audio CD.   Data,
   audio playback, and "trackwriter" programs can be handled by UIDE using
   multiple drives on one system.    Audio and "trackwriting" is uncached.

   UIDE can cache 5 Megabytes to 2 GIGABYTES of data!   It uses 1056 bytes
   of upper-memory and 3872 bytes of HMA space for any size cache.     All
   of its cache tables and data are now in XMS memory.   The "stand alone"
   UIDE (no caching or diskettes) also uses 1056 bytes of upper-memory and
   2896 bytes of HMA.   If HMA space is inadequate, UIDE can load entirely
   in upper-memory and also in "DOS memory" below 640K.

   Users wishing a smaller driver can use the non-caching UIDEJR ["junior"
   UIDE].   UIDEJR also runs up to 10 SATA or IDE controllers, 36 SATA/IDE
   hard-disks and 8 SATA/IDE/"PIO mode" CD/DVD drives.   It needs only 768
   bytes of upper-memory and 2528 bytes of HMA.   Its /N2 switch dismisses
   all CD/DVD logic, giving a disk-only driver taking 768 upper-memory and
   848 HMA bytes.   UIDEJR can also load entirely in upper- or DOS memory.
   It allocates a 128K XMS memory buffer, so "misaligned" I-O can still be
   done at UltraDMA speeds.    UIDEJR can play audio CDs and also do "raw"
   (trackwriter) CD/DVD input.

   Except as noted, all UIDE comments in this README also apply to UIDEJR.

   The small CC.COM "Clear Cache" program can help verify files written by
   UIDE.   Entering  CC  at the DOS command-prompt sends a BIOS "reset" to
   all disks, making UIDE discard its cache.    Data on the disk (NOT data
   still in the cache!) can then be compared with the original output.


2. NO Warranties
   -------------

   XMGR and UIDE are offered without charge, "as-is", and "use at your own
   risk", and with NO warranties, not even the implied warranty of FITNESS
   for ANY particular purpose nor of MERCHANTABILITY!

   Driver questions or comments may be addressed to the website of Johnson
   Lam, <johnson@tmfc.net>.


3. Revisions
   ---------

    6-May-09   Added the non-caching UIDEJR ["junior" UIDE] driver, using
                 only 768 upper-memory and 2528 HMA bytes!    UIDE/UIDEJR
                 now run up to 10 controllers, 36 disks, 8 CD/DVD drives.

    1-May-09   Fixed XMGR "Port 92h" logic error.  Added XMGR /PA and /PN
                 switches to control use of "Port 92h" logic.

   28-Apr-09   Fixed UIDE save/restore error during CD/DVD init messages.

   25-Apr-09   XMGR/UIDE license and FreeDOS prohibition deleted, drivers
                 and sources are again available to all.   Corrected UIDE
                 error in posting CD/DVD "return codes".   UIDE /R switch
                 re-added to support ROM-DOS.

   21-Apr-09   Minor UIDE error (disk "A20 error" code not set) is fixed.

   17-Apr-09   UIDE now caches 2 GIGABYTES, using 1056 upper-memory bytes
                 and 3760 HMA bytes for any cache size; search tables now
                 use XMS!  /L deleted.  Fixed BAD audio byte-count error.


4. Switch Options
   --------------

   XMGR usually needs only its /B switch if "booting" with EMM386.    XMGR
      switch options are as follows:

      /B     Specifies "boot" mode.   XMGR loads in temporary memory until
                upper-memory is enabled by EMM386.   Without /B, XMGR will
                load stand-alone in low memory or directly in upper-memory
                with UMBPCI.   See the CONFIG.SYS examples in section 5.

      /Mn    Specifies the temporary area used to load XMGR in "boot" mode
                and used for UMBPCI upper memory I-O before DOS can post a
                "workspace" buffer.   Values are:

                    /M1 = 64K.    /M3 = 192K.   /M5 = 320K.   /M7 = 448K.
                    /M2 = 128K.   /M4 = 256K.   /M6 = 512K.   /M8 = 512K.

                Without /M, /M5 is assumed and the 320K area will be used.
                NOTE:  A DOS system often may NOT load at address 0 up and
                may leave temporary data anywhere in memory!   /Mn changes
                the temporary area to find a "safe" place for XMGR to use.
                /M is ignored if XMGR loads stand-alone.

      /Nnn   Specifies how many XMS "Handles" can be used by DOS programs.
                The value nn may be 48, 80, or 128.   If /N is omitted, 48
                "Handles" are used.   A big system doing much XMS work may
                need 80 or 128 "Handles".

      /PA    Specifies use or non-use of PS/2 Port 92h logic to handle the
      /PN       system's "A20" line.   /PA indicates "Always" use Port 92h
                logic.   /PN indicates "Never" use it and handle "A20" via
                normal keyboard-port logic.   If /P is omitted, XMGR "asks
                the BIOS" if the system has Port 92h logic.   If not, XMGR
                will use normal "A20" logic.   NOTE:  If "A20" was enabled
                by DOS before XMGR loads, XMGR does not handle it at all!

      /Tn    Specifies the BIOS requests to use in getting extended memory
                as follows:

                   /T0   Neither "E820h" nor "E801h" requests.
                   /T1   Memory-list requests only (Int 15h, AX=E820h).
                   /T2   A dual-area request only  (Int 15h, AX=E801h).
                   /T3   "E820h" requests first, then an "E801h" request.

                /T can usually be omitted, which causes /T3 to be assumed.
                In addition, XMGR always uses an old 64-MB request, to get
                extended memory for /T0, or if the requests specified with
                /T1 through /T3 are unsuccessful.   Users may need to test
                /T1 and /T2 separately, to see if their BIOS accepts them.
                A pre-1994 BIOS may not "ignore" /T1 thru /T3 properly and
                may require /T0 to be used.   For compatibility with older
                QHIMEM drivers, /T4 thru /T7 may be used and work the same
                as /T0 thru /T3.

      /W     Specifies use of the DOS "workspace" buffer, for upper-memory
                I-O if loading with UMBPCI.    If /W is omitted, or if the
                DOS system does not have proper workspace logic, XMGR will
                set its own buffer in low memory.   An EDR-DOS system must
                OMIT this switch!   Without UMBPCI, /W is ignored.

             --------------------

   UIDE and UIDEJR usually need only a /D: switch to specify a device name
   for the SHCDX33C CD-ROM Redirector.    UIDE also needs its /S switch to
   specify a cache size.   UIDE and UIDEJR switch options are:

      /A     Specifies use of ALTERNATE "legacy IDE" I-O addresses.    The
                first legacy controller will use alternate 01E8h/03EEh and
                0168h/036Eh addresses, and a second legacy controller will
                use normal 01F0h/03F6h and 0170h/0376h I-O addresses.   If
                /A is omitted, the first legacy controller uses normal and
                the second legacy controller uses alternate addresses, the
                usual case with most mainboards and BIOS programs.   /A is
                for "odd" cases where "legacy IDE" addresses are REVERSED.
                /A does not affect "native PCI" controllers.

      /B     For UIDE only, requests a "basic" stand-alone UltraDMA driver
                for disks or CD/DVD drives (no cache or diskettes).   This
                may help with tests or diagnostics.   The stand-alone UIDE
                takes 128K of XMS memory and can now load in the HMA.   /B
                is ignored by UIDEJR.

      /D:    Specifies the desired device name, used by SHCDX33C to access
                the CD/DVD drives.   Example:  /D:CDROM1  /D:MYCDROM  etc.
                Device names must be from 1 to 8 bytes O.K. for use in DOS
                filenames.   If /D: is omitted, or the device name after a
                /D: is missing or invalid,  UDVD1  is used as the default.

      /N1    Requests NO handling of any hard-disk drives.

      /N2    Requests NO handling of any CD/DVD drives.   For UIDEJR only,
               all CD/DVD logic shall be dismissed, saving 1600 HMA bytes!
               NOTE:  Do NOT load a "CD Redirector" (SHCDX33C etc.) if /N2
               is used, as it may CRASH upon finding "zero" CD/DVD drives!

      /Q     Enables awaiting "data request" before starting UltraDMA disk
                transfers.   /Q is for "old" systems and must be used only
                if UIDE loads O.K. but seems unable to transfer data.   /Q
                must be OMITTED with a SATA-to-IDE adapter from Sabrent or
                others, as such cards do not emulate "data request" from a
                SATA disk!   /Q does not affect CD/DVD drives.

      /R     Restricts the driver to "normal" memory and avoids using HMA.
                /R is REQUIRED if using ROM-DOS!   /R is unneeded by V6.22
                or V7.1 MS-DOS, V7.1 PC-DOS, PTS-DOS, or EDR-DOS.   Others
                must be tested first.    /R can also force the driver into
                "normal" memory, if HMA space must be saved for DOS usage.

      /Sn    For UIDE only, specifies the desired cache size, in megabytes
                of XMS memory.   Values for /S are 5, 15, 40 or any number
                from 80 to 2047.   /S1024 or more gives a 1- to 2-GIGABYTE
                cache!   Use as much cache as possible for BIG data files:

                    Below 128-MB memory:     Use /S5 /S15 or /S40

                    With 128-MB memory:      Use /S40 or /S80
                    With 256-MB memory:      Use /S80  up to /S127
                    With 512-MB memory:      Use /S160 up to /S255

                    With 1-GB memory:        Use /S320  up to /S511
                    With 2-GB memory:        Use /S640  up to /S1023
                    With 4-GB memory:        Use /S1280 up to /S2047

                If /S is omitted/invalid, an 80-MB cache is set.    Values
                below 80 are "rounded" to 40- 15- or 5-MB.   UIDE displays
                "XMS init error" and aborts, when not enough XMS memory is
                available for the cache!    If so, a smaller cache must be
                requested.   For old V2.0 XMS managers (ROM-DOS etc.) only
                /S5 /S15 or /S40 may be given.   /S is ignored by UIDEJR.

      /UX    Disables all CD/DVD UltraDMA, even for drives that can do it.
                PIO-mode is then used on all CD/DVD requests.   Except for
                some "unusual" drives by Sony, etc. that do not follow all
                ATAPI "rules", /UX is rarely needed.   /UX does not affect
                hard-disks.

             --------------------

   For all switches in each driver, a dash may replace the slash and lower
   case letters may be used if desired.


5. Setup and Configuration
   -----------------------

   XMGR and UIDE are loaded through the CONFIG.SYS file.   Your CONFIG.SYS
   file should have command lines similar to the following examples:

      DEVICE=C:\BIN\XMGR.SYS /N128 /B

      DEVICEHIGH=C:\DRIVERS\UIDE.SYS /S250 /D:MYDVD

      DEVICEHIGH=C:\MYSYSTEM\UIDEJR.SYS /D:TOSHIBA1

   With V3.70+ UMBPCI and XMGR, a "boot" procedure is not needed!   UMBPCI
   loads first to enable upper-memory, then XMGR loads to offer it and XMS
   to DOS, then other drivers may load.   An example CONFIG.SYS file using
   V3.70+ UMBPCI and XMGR is as follows:

      SHELL=C:\DOS\COMMAND.COM C:\DOS /E:512 /P
      DEVICE=C:\BIN\UMBPCI.SYS
      DEVICE=C:\BIN\XMGR.SYS /W
      DOS=HIGH,UMB
      DEVICEHIGH=C:\BIN\UIDE.SYS /S500 /D:CDROM1        [Or UIDEJR]
          ..
          ..  Etc.
          ..

   XMGR can be used stand-alone, for a small XMS-only system.   It must be
   the first DOS system driver to load, and it must load in LOW memory, as
   in the following example:

      SHELL=C:\DOS\COMMAND.COM C:\DOS /E:512 /P
      DEVICE=C:\BIN\XMGR.SYS
      DOS=HIGH
      DEVICE=C:\BIN\UIDE.SYS /S80 /D:MYCDROM            [Or UIDEJR]
          ..
          ..  Etc.
          ..

   With EMM386 and XMGR, XMGR must load first in "boot" mode, then EMM386,
   and then XMGR can finally load in upper-memory.   An example CONFIG.SYS
   file using the XMGR "boot" procedure is as follows:

      SHELL=C:\DOS\COMMAND.COM C:\DOS /E:512 /P
      DEVICE=C:\BIN\XMGR.SYS /B                         [/B for "boot"]
      DOS=HIGH,UMB
      DEVICE=C:\DOS\EMM386.EXE I=B000-B7FF NOEMS ...
      DEVICEHIGH=C:\BIN\XMGR.SYS                        [No /B used here!]
      DEVICEHIGH=C:\BIN\UIDE.SYS /S2047 /D:MYDVD        [Or UIDEJR]
          ..
          ..  Etc.
          ..

   When other Int 13h DOS drivers will be used, UIDE must load after them,
   so it can cache disk I-O for the other drivers.   When XMGR, other disk
   drivers, and UIDE are loaded, all other CONFIG.SYS drivers (SETVER.EXE,
   ANSI.SYS, etc.) can then load in any desired order.

   Please be sure to set each hard disk's geometry correctly in your BIOS.
   Set it to "Auto", "LBA" or "LBA Assisted", but NOT to "None", "Normal",
   "CHS", "ECHS".   "User Cylinders/Heads/Sectors", "Revised ECHS" or "Bit
   Shift" should run but are NOT preferred.   If a BIOS has a setting like
   "UDMA Capable" for a disk, enable it.   Power-saving features such as a
   "drive spin-down timeout" should be DISABLED or driver I-O requests may
   time out!   Also, be sure to use an 80-connector cable for any UltraDMA
   drive running in "mode 3" ATA-44 (44 MB/sec) or higher.    When cabling
   a single drive to an IDE channel, note that you MUST use both "ends" of
   the cable, NOT one "end" and the middle connector!   This avoids ERRORS
   as an unused cable-end can pick up "noise", like a RADIO antenna!

   Be sure to enable all CD/DVD drive(s) through the BIOS set-up routines!
   A drive that is "disabled" may cause the BIOS to clear all its UltraDMA
   flags and force the drive into "PIO mode" zero, which is terribly SLOW!


6. Error Reporting
   ---------------

   XMGR and UIDE return normal XMS or CD/DVD driver error codes if needed.
   These are shown in the V3.0 XMS Specification and the Microsoft "MS-DOS
   CD-ROM Extensions 2.1" documentation, available from Microsoft or other
   Internet sources.

   UIDE works as a "BIOS driver" and returns whatever codes the BIOS posts
   for its diskettes or hard-disks.   For SATA or UltraDMA disks, UIDE can
   return the following error codes:

       Code 0Fh - DMA error.           CCh - Disk is FAULTED.
            20h - Controller busy.     E0h - Hard I-O error.
            AAh - Disk not ready.      FFh - XMS memory error.

   Many DOS programs display only "Disk Error" messages with NO code, thus
   disk errors may require running a diagnostic to get better information!


7. Technical Notes
   ---------------

   UIDE handles only "Legacy" or "Native PCI" IDE controllers.   Old "RAID
   only" chipsets (Via VT6420, etc.), port-multiplier chips, and ADMA/AHCI
   chipsets are not currently supported.   To use UIDE, the mainboard BIOS
   must set SATA controllers in "IDE" mode, not RAID/ADMA/AHCI!   UIDE can
   then handle SATA drives properly, at full speed.    Where no "IDE" BIOS
   setting for SATA is offered, a Sabrent converter card (or similar) will
   allow UIDE to run SATA hard-disks and CD/DVD drives from the "standard"
   IDE controller channels, at full UltraDMA speeds.

   *** NOTE ***   It is NOT RECOMMENDED for UIDE to handle DOS disks using
   only the BIOS!   Often a "cheap" BIOS will omit DOS "Virtual DMA" code.
   If so, when EMM386 goes into "V86 protected-mode", the BIOS can do only
   PIO-mode data transfers and LOSES much speed!   If needed, get SATA-to-
   IDE adapters for SATA disks (as above), or get an "Int 13h" disk driver
   for SCSI or other disks, so UIDE can handle them at full speed!

   XMGR loads in UMBPCI upper-memory BEFORE that memory is declared to the
   DOS system!   Memory displays using UMBPCI may not list XMGR, since its
   memory is not part of the DOS memory lists.   Such memory displays will
   begin with a block having a 00A7h offset, or greater if using 80 or 128
   XMS "Handles".   The upper-memory skipped by this offset contains XMGR.

   The UMBPCI upper-memory manager uses system "Shadow RAM" that CANNOT do
   DMA!   Newer BIOS programs may use UltraDMA to load programs into upper
   memory.   If this is UMBPCI "Shadow RAM", a CRASH will occur!   To stop
   this, and handle new BIOS programs, users should follow these two RULES
   for running UMBPCI together with XMGR and UIDE:

     A) The loading "order" for V3.70+ UMBPCI and XMGR, shown in section 5
        above, MUST be used!    This lets the XMGR "I-O Catcher" intercept
        and process upper memory disk I-O, until the UIDE driver loads and
        takes-over disk UltraDMA.   Older UMBPCI versions, or other UMBPCI
        loading schemes, are NOT recommended!

     B) When CHS I-O is done (MS-DOS V6.22 or older), every disk MUST have
        valid CHS parameters!   If not, UIDE and the "I-O Catcher" let the
        BIOS handle CHS I-O.   If BIOS UltraDMA is not disabled, a similar
        "Shadow RAM" CRASH will occur!

   Some "CD-ROM boot" programs handle the CD/DVD as a "fake" hard disk and
   provide incorrect EDD BIOS data for it!   In scanning for disks to use,
   UIDE may display "EDD BIOS error!  Unit ignored.", then go on searching
   for more UltraDMA disks.   Users who did NOT "boot" from CD/DVD need to
   see which disk was passed-over and why.   Users who DID "boot" from CD/
   DVD, where all SATA/UltraDMA disks were found, may IGNORE this message!
   It is caused by an ERROR in the "CD-ROM boot" program, NOT by a problem
   with UIDE or its SATA/UltraDMA disks!

   Some BIOS programs do not "configure" a mainboard controller if no user
   drives are found!     An unconfigured controller causes UIDE to display
   "BAD controller", then it goes on looking for others to use.    If this
   message is displayed, users should verify that each SATA/UltraDMA drive
   was made "active" thru the BIOS set-up logic.   If so, "BAD controller"
   says a chip was not set to both "Bus Master" and "I-O Space" modes, and
   the BIOS needs to be UPDATED!

