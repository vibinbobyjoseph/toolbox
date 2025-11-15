# Linux Notes

> **Document Information**
> - **Last Updated:** 2025-11-15
> - **Target Systems:** Ubuntu, Debian, RHEL, CentOS, Fedora (most commands are distribution-agnostic)
> - **Purpose:** Comprehensive Linux command reference and system administration guide
> - **Status:** Living document - regularly updated with new learnings

---

## Quick Reference - Most Used Commands

```bash
# File Operations
ls -lah              # List files with details
cd /path             # Change directory
cp -r src dest       # Copy recursively
mv old new           # Move/rename
rm -rf dir           # Remove directory (⚠️ DANGEROUS)
find . -name "*.txt" # Find files

# Text Processing
grep -r "pattern" .  # Search recursively
sed 's/old/new/g'    # Find and replace
awk '{print $1}'     # Print first column
cat file.txt         # View file
less file.txt        # View file with pagination

# Process Management
ps aux               # List all processes
top                  # Monitor processes
kill -9 PID          # Force kill process
systemctl status srv # Check service status

# System Info
df -h                # Disk usage
du -sh *             # Directory sizes
free -h              # Memory usage
uname -a             # System information

# Permissions
chmod 755 file       # Change permissions
chown user:group     # Change ownership
sudo command         # Run as root

# Network
ping host            # Test connectivity
ssh user@host        # Remote login
scp file user@host:  # Secure copy
netstat -tulpn       # List ports
```

---

## Table of Contents

- [1. File System Structure and
  Description](#LinuxNotes-1.FileSystemStructureandDesc)

- [2. Linux File System and
  Permissions](#LinuxNotes-2.LinuxFileSystemandPermissi)

  - [2.1. File Types](#LinuxNotes-2.1.FileTypes)

  - [2.2. Links](#LinuxNotes-2.2.Links)

    - [2.2.1. Hard link](#LinuxNotes-2.2.1.Hardlink)

    - [2.2.2. Soft Link](#LinuxNotes-2.2.2.SoftLink)

  - [2.3. File Permissions](#LinuxNotes-2.3.FilePermissions)

    - [2.3.1. Standard
      Permissions](#LinuxNotes-2.3.1.StandardPermissions)

    - [2.3.2. umask](#LinuxNotes-2.3.2.umask)

    - [2.3.3. Special Permissions](#LinuxNotes-2.3.3.SpecialPermissions)

    - [2.3.4. Access Control List
      (ACLs)](#LinuxNotes-2.3.4.AccessControlList(ACLs)

    - [2.3.5. Changing Ownership](#LinuxNotes-2.3.5.ChangingOwnership)

- [3. Essential File Management
  Commands](#LinuxNotes-3.EssentialFileManagementCom)

  - [3.1. File and Directory
    Operations](#LinuxNotes-3.1.FileandDirectoryOperatio)

    - [3.1.1. ls Command](#LinuxNotes-3.1.1.lsCommand)

    - [3.1.2. cd Command](#LinuxNotes-3.1.2.cdCommand)

    - [3.1.3. cp Command](#LinuxNotes-3.1.3.cpCommand)

    - [3.1.4. rm Command](#LinuxNotes-3.1.4.rmCommand)

    - [3.1.5. mv Command](#LinuxNotes-3.1.5.mvCommand)

    - [3.1.6. mkdir Command](#LinuxNotes-3.1.6.mkdirCommand)

    - [3.1.7. rmdir Command](#LinuxNotes-3.1.7.rmdirCommand)

    - [3.1.8. file Command](#LinuxNotes-3.1.8.fileCommand)

    - [3.1.9. tree Command](#LinuxNotes-3.1.9.treeCommand)

    - [3.1.10. truncate Command](#LinuxNotes-3.1.10.truncateCommand)

    - [3.1.11. split Command](#LinuxNotes-3.1.11.splitCommand)

    - [3.1.12. pwd Command](#LinuxNotes-3.1.12.pwdCommand)

    - [3.1.13. stat Command](#LinuxNotes-3.1.13.statCommand)

  - [3.2. Viewing and Processing File
    Contents](#LinuxNotes-3.2.ViewingandProcessingFile)

    - [3.2.1. cat Command](#LinuxNotes-3.2.1.catCommand)

    - [3.2.2. tac Command](#LinuxNotes-3.2.2.tacCommand)

    - [3.2.3. more and less
      Commands](#LinuxNotes-3.2.3.moreandlessCommands)

    - [3.2.4. head Command](#LinuxNotes-3.2.4.headCommand)

    - [3.2.5. tail Command](#LinuxNotes-3.2.5.tailCommand)

    - [3.2.6. wc Command](#LinuxNotes-3.2.6.wcCommand)

  - [3.3. Finding files](#LinuxNotes-3.3.Findingfiles)

    - [3.3.1. find Command](#LinuxNotes-3.3.1.findCommand)

    - [3.3.2. locate Command](#LinuxNotes-3.3.2.locateCommand)

- [4. Getting Help](#LinuxNotes-4.GettingHelp)

- [5. Important command-line
  features](#LinuxNotes-5.Importantcommand-linefeatu)

  - [5.1. Wildcards](#LinuxNotes-5.1.Wildcards)

  - [5.2. Input and Output
    redirection](#LinuxNotes-5.2.InputandOutputredirectio)

  - [5.3. Separators for Multiple
    Commands](#LinuxNotes-5.3.SeparatorsforMultipleCom)

  - [5.4. Command History](#LinuxNotes-5.4.CommandHistory)

  - [5.5. Up and Down Arrows](#LinuxNotes-5.5.UpandDownArrows)

  - [5.6. Recursive Search (Ctrl +
    R)](#LinuxNotes-5.6.RecursiveSearch(Ctrl+R))

  - [5.7. Editing Commands](#LinuxNotes-5.7.EditingCommands)

  - [5.8. Tab Completion](#LinuxNotes-5.8.TabCompletion)

- [6. Text Processing and
  Transformation](#LinuxNotes-6.TextProcessingandTransform)

  - [6.1. Essential command-line utilities for text
    processing](#LinuxNotes-6.1.Essentialcommand-lineuti)

    - [6.1.1. cut Command](#LinuxNotes-6.1.1.cutCommand)

    - [6.1.2. awk Command](#LinuxNotes-6.1.2.awkCommand)

    - [6.1.3. grep Command](#LinuxNotes-6.1.3.grepCommand)

    - [6.1.4. sort Command](#LinuxNotes-6.1.4.sortCommand)

    - [6.1.5. uniq Command](#LinuxNotes-6.1.5.uniqCommand)

    - [6.1.6. sed command](#LinuxNotes-6.1.6.sedcommand)

- [7. File Comparison](#LinuxNotes-7.FileComparison)

- [8. Compress and UnCompress
  Files](#LinuxNotes-8.CompressandUnCompressFiles)

- [9. Managing Users](#LinuxNotes-9.ManagingUsers)

  - [9.1. User Account
    Management](#LinuxNotes-9.1.UserAccountManagement)

    - [9.1.1. User Account
      Commands](#LinuxNotes-9.1.1.UserAccountCommands)

    - [9.1.2. Group Management
      Commands](#LinuxNotes-9.1.2.GroupManagementCommand)

    - [9.1.3. Password Management](#LinuxNotes-9.1.3.PasswordManagement)

    - [9.1.4. Home Directories](#LinuxNotes-9.1.4.HomeDirectories)

    - [9.1.5. Temporary User
      Accounts](#LinuxNotes-9.1.5.TemporaryUserAccounts)

    - [9.1.6. Enable Password
      Aging](#LinuxNotes-9.1.6.EnablePasswordAging)

    - [9.1.7. Tips](#LinuxNotes-9.1.7.Tips)

  - [9.2. Switch Users and super user
    Access](#LinuxNotes-9.2.SwitchUsersandsuperuserA)

    - [9.2.1. Switching Users](#LinuxNotes-9.2.1.SwitchingUsers)

    - [9.2.2. Sudo Access](#LinuxNotes-9.2.2.SudoAccess)

    - [9.2.3. Granting Sudo Access to a
      User](#LinuxNotes-9.2.3.GrantingSudoAccesstoaU)

  - [9.3. Monitoring Users](#LinuxNotes-9.3.MonitoringUsers)

  - [9.4. Communicating with other
    users](#LinuxNotes-9.4.Communicatingwithotherus)

- [10. System and Service
  Management](#LinuxNotes-10.SystemandServiceManagemen)

  - [10.1. Important Terms](#LinuxNotes-10.1.ImportantTerms)

  - [10.2. systemd](#LinuxNotes-10.2.systemd)

    - [10.2.1. Key Features](#LinuxNotes-10.2.1.KeyFeatures)

    - [10.2.2. How systemd Works](#LinuxNotes-10.2.2.HowsystemdWorks)

    - [10.2.3. Unit Types in
      systemd](#LinuxNotes-10.2.3.UnitTypesinsystemd)

    - [10.2.4. Important Components of
      systemd](#LinuxNotes-10.2.4.ImportantComponentsof)

  - [10.3. systemd commands](#LinuxNotes-10.3.systemdcommands)

  - [10.4. Creating a Systemd
    Service](#LinuxNotes-10.4.CreatingaSystemdService)

  - [10.5. Creating a Systemd
    Timer](#LinuxNotes-10.5.CreatingaSystemdTimer)

    - [10.5.1. Service Unit
      (\*.service)](#LinuxNotes-10.5.1.ServiceUnit(*.service)

    - [10.5.2. Timer Unit
      (\*.timer)](#LinuxNotes-10.5.2.TimerUnit(*.timer))

  - [10.6. Creating a Systemd
    Mount](#LinuxNotes-10.6.CreatingaSystemdMount)

  - [10.7. Creating a Systemd
    Path](#LinuxNotes-10.7.CreatingaSystemdPath)

  - [10.8. Creating Other systemd
    Units](#LinuxNotes-10.8.CreatingOthersystemdUni)

- [11. Process Management](#LinuxNotes-11.ProcessManagement)

  - [11.1. ps Command](#LinuxNotes-11.1.psCommand)

  - [11.2. top Command](#LinuxNotes-11.2.topCommand)

    - [11.2.1. Key Features:](#LinuxNotes-11.2.1.KeyFeatures:)

    - [11.2.2. Interactive
      Commands](#LinuxNotes-11.2.2.InteractiveCommands)

    - [11.2.3. Alternatives](#LinuxNotes-11.2.3.Alternatives)

  - [11.3. kill Command](#LinuxNotes-11.3.killCommand)

    - [11.3.1. Commonly Used
      Signals](#LinuxNotes-11.3.1.CommonlyUsedSignals)

    - [11.3.2. Advanced Use Cases](#LinuxNotes-11.3.2.AdvancedUseCases)

  - [11.4. nice/renice](#LinuxNotes-11.4.nice/renice)

- [12. Scheduling Tasks](#LinuxNotes-12.SchedulingTasks)

  - [12.1. crontab](#LinuxNotes-12.1.crontab)

    - [12.1.1. Common Options](#LinuxNotes-12.1.1.CommonOptions)

    - [12.1.2. Special Strings in
      Crontab](#LinuxNotes-12.1.2.SpecialStringsinCront)

    - [12.1.3. Managing Crontab](#LinuxNotes-12.1.3.ManagingCrontab)

    - [12.1.4. Log and Debugging](#LinuxNotes-12.1.4.LogandDebugging)

    - [12.1.5. Crontab File
      Format:](#LinuxNotes-12.1.5.CrontabFileFormat:)

    - [12.1.6. Examples](#LinuxNotes-12.1.6.Examples)

  - [12.2. at](#LinuxNotes-12.2.at)

  - [12.3. anacron](#LinuxNotes-12.3.anacron)

    - [12.3.1. Key Features of
      Anacron](#LinuxNotes-12.3.1.KeyFeaturesofAnacron)

- [13. Shell](#LinuxNotes-13.Shell)

  - [13.1. Types of Shells](#LinuxNotes-13.1.TypesofShells)

  - [13.2. Key Features](#LinuxNotes-13.2.KeyFeatures)

  - [13.3. How a Shell Works](#LinuxNotes-13.3.HowaShellWorks)

  - [13.4. Useful Commands](#LinuxNotes-13.4.UsefulCommands)

  - [13.5. Shell Scripting](#LinuxNotes-13.5.ShellScripting)

    - [13.5.1. Why Use Shell
      Scripting?](#LinuxNotes-13.5.1.WhyUseShellScripting?)

    - [13.5.2. Basic Structure of a Shell
      Script](#LinuxNotes-13.5.2.BasicStructureofaShel)

    - [13.5.3. Key Concepts](#LinuxNotes-13.5.3.KeyConcepts)

  - [13.6. Aliases](#LinuxNotes-13.6.Aliases)

    - [13.6.1. Types of Aliases](#LinuxNotes-13.6.1.TypesofAliases)

    - [13.6.2. Useful Commands](#LinuxNotes-13.6.2.UsefulCommands)

  - [13.7. Managing Jobs in a
    Shell](#LinuxNotes-13.7.ManagingJobsinaShell)

    - [13.7.1. Ctlr+Z](#LinuxNotes-13.7.1.Ctlr+Z)

    - [13.7.2. jobs](#LinuxNotes-13.7.2.jobs)

    - [13.7.3. bg (Background)](#LinuxNotes-13.7.3.bg(Background))

    - [13.7.4. fg (Foreground)](#LinuxNotes-13.7.4.fg(Foreground))

    - [13.7.5. nohup](#LinuxNotes-13.7.5.nohup)

    - [13.7.6. disown](#LinuxNotes-13.7.6.disown)

    - [13.7.7. nohup vs. disown](#LinuxNotes-13.7.7.nohupvs.disown)

- [14. Terminal](#LinuxNotes-14.Terminal)

  - [14.1. tty vs pts](#LinuxNotes-14.1.ttyvspts)

- [15. File System](#LinuxNotes-15.FileSystem)

  - [15.1. Native File Systems](#LinuxNotes-15.1.NativeFileSystems)

    - [15.1.1. Ext2](#LinuxNotes-15.1.1.Ext2)

    - [15.1.2. Ext3](#LinuxNotes-15.1.2.Ext3)

    - [15.1.3. Ext4](#LinuxNotes-15.1.3.Ext4)

    - [15.1.4. XFS](#LinuxNotes-15.1.4.XFS)

    - [15.1.5. Btrfs](#LinuxNotes-15.1.5.Btrfs)

    - [15.1.6. ReiserFS](#LinuxNotes-15.1.6.ReiserFS)

    - [15.1.7. swap](#LinuxNotes-15.1.7.swap)

  - [15.2. Virtual File Systems](#LinuxNotes-15.2.VirtualFileSystems)

    - [15.2.1. tmpfs](#LinuxNotes-15.2.1.tmpfs)

    - [15.2.2. devtmpfs](#LinuxNotes-15.2.2.devtmpfs)

    - [15.2.3. efivarfs](#LinuxNotes-15.2.3.efivarfs)

  - [15.3. Network File Systems](#LinuxNotes-15.3.NetworkFileSystems)

    - [15.3.1. NFS](#LinuxNotes-15.3.1.NFS)

    - [15.3.2. Samba (CIFS/SMB)](#LinuxNotes-15.3.2.Samba(CIFS/SMB))

  - [15.4. Non-Native File Systems (Foreign File
    Systems)](#LinuxNotes-15.4.Non-NativeFileSystems(F)

    - [15.4.1. FAT32 (vfat):](#LinuxNotes-15.4.1.FAT32(vfat):)

    - [15.4.2. exFAT:](#LinuxNotes-15.4.2.exFAT:)

    - [15.4.3. HFS (Hierarchical File
      System):](#LinuxNotes-15.4.3.HFS(HierarchicalFileS)

    - [15.4.4. HFS+ (HFS Plus):](#LinuxNotes-15.4.4.HFS+(HFSPlus):)

    - [15.4.5. APFS (Apple File
      System):](#LinuxNotes-15.4.5.APFS(AppleFileSystem))

- [16. Disk Management](#LinuxNotes-16.DiskManagement)

  - [16.1. du Command](#LinuxNotes-16.1.duCommand)

  - [16.2. df Command](#LinuxNotes-16.2.dfCommand)

  - [16.3. fdisk Command](#LinuxNotes-16.3.fdiskCommand)

  - [16.4. mkfs Command](#LinuxNotes-16.4.mkfsCommand)

  - [16.5. lsblk Command](#LinuxNotes-16.5.lsblkCommand)

  - [16.6. blkid Command](#LinuxNotes-16.6.blkidCommand)

  - [16.7. fsck Command](#LinuxNotes-16.7.fsckCommand)

  - [16.8. dd Command](#LinuxNotes-16.8.ddCommand)

  - [16.9. wipefs](#LinuxNotes-16.9.wipefs)

  - [16.10. mount Command](#LinuxNotes-16.10.mountCommand)

  - [16.11. fstab](#LinuxNotes-16.11.fstab)

- [17. System Information](#LinuxNotes-17.SystemInformation)

  - [17.1. dmesg Command](#LinuxNotes-17.1.dmesgCommand)

  - [17.2. iostat Command](#LinuxNotes-17.2.iostatCommand)

  - [17.3. vmstat Command](#LinuxNotes-17.3.vmstatCommand)

  - [17.4. free Command](#LinuxNotes-17.4.freeCommand)

  - [17.5. lsof Command](#LinuxNotes-17.5.lsofCommand)

  - [17.6. Other sysinfo
    Commands](#LinuxNotes-17.6.OthersysinfoCommands)

- [18. Networking](#LinuxNotes-18.Networking)

  - [18.1. netstat Command](#LinuxNotes-18.1.netstatCommand)

  - [18.2. ss Command](#LinuxNotes-18.2.ssCommand)

  - [18.3. ip Command](#LinuxNotes-18.3.ipCommand)

  - [18.4. ping Command](#LinuxNotes-18.4.pingCommand)

  - [18.5. ifconfig Command](#LinuxNotes-18.5.ifconfigCommand)

  - [18.6. tcpDump](#LinuxNotes-18.6.tcpDump)

  - [18.7. nslookup](#LinuxNotes-18.7.nslookup)

  - [18.8. dig](#LinuxNotes-18.8.dig)

  - [18.9. traceroute](#LinuxNotes-18.9.traceroute)

  - [18.10. nmap](#LinuxNotes-18.10.nmap)

  - [18.11. Other Network
    Commands](#LinuxNotes-18.11.OtherNetworkCommands)

- [19. Log Monitoring](#LinuxNotes-19.LogMonitoring)

- [20. Environment Variables](#LinuxNotes-20.EnvironmentVariables)

- [21. ssh](#LinuxNotes-21.ssh)

  - [21.1. Common Use Cases](#LinuxNotes-21.1.CommonUseCases)

  - [21.2. ssh config](#LinuxNotes-21.2.sshconfig)

  - [21.3. Generating SSH Keys](#LinuxNotes-21.3.GeneratingSSHKeys)

  - [21.4. SSH Tunnels and
    Proxies](#LinuxNotes-21.4.SSHTunnelsandProxies)

  - [21.5. Security Tips](#LinuxNotes-21.5.SecurityTips)

- [22. Terminal Multiplexers](#LinuxNotes-22.TerminalMultiplexers)

  - [22.1. screen](#LinuxNotes-22.1.screen)

  - [22.2. tmux](#LinuxNotes-22.2.tmux)

- [23. File Transfer And
  Download](#LinuxNotes-23.FileTransferAndDownload)

  - [23.1. wget Command](#LinuxNotes-23.1.wgetCommand)

  - [23.2. curl Command](#LinuxNotes-23.2.curlCommand)

  - [23.3. aria2c Command](#LinuxNotes-23.3.aria2cCommand)

  - [23.4. scp Command](#LinuxNotes-23.4.scpCommand)

  - [23.5. rsync Command](#LinuxNotes-23.5.rsyncCommand)

- [24. Package Managers](#LinuxNotes-24.PackageManagers)

  - [24.1. Ubuntu/Debian](#LinuxNotes-24.1.Ubuntu/Debian)

  - [24.2. Fedora/RHEL/CentOS](#LinuxNotes-24.2.Fedora/RHEL/CentOS)

- [25. Other Important Commands and
  Utils](#LinuxNotes-25.OtherImportantCommandsand)

  - [25.1. date Command](#LinuxNotes-25.1.dateCommand)

  - [25.2. timedatectl Command](#LinuxNotes-25.2.timedatectlCommand)

  - [25.3. bc Command](#LinuxNotes-25.3.bcCommand)

  - [25.4. cal Command](#LinuxNotes-25.4.calCommand)

  - [25.5. script Command](#LinuxNotes-25.5.scriptCommand)

- [26. tuned service](#LinuxNotes-26.tunedservice)

- [27. System Security](#LinuxNotes-27.SystemSecurity)

  - [27.1. OS Hardening](#LinuxNotes-27.1.OSHardening)

  - [27.2. Firewall](#LinuxNotes-27.2.Firewall)

    - [27.2.1. iptables](#LinuxNotes-27.2.1.iptables)

    - [27.2.2. nftables](#LinuxNotes-27.2.2.nftables)

    - [27.2.3. firewalld](#LinuxNotes-27.2.3.firewalld)

    - [27.2.4. fail2ban](#LinuxNotes-27.2.4.fail2ban)

- [28. Swap Space](#LinuxNotes-28.SwapSpace)

- [29. System States](#LinuxNotes-29.SystemStates)

  - [29.1. Power States](#LinuxNotes-29.1.PowerStates)

  - [29.2. Run Levels](#LinuxNotes-29.2.RunLevels)

- [30. Advanced Topics](#LinuxNotes-30.AdvancedTopics)

  - [30.1. NFS](#LinuxNotes-30.1.NFS)

    - [30.1.1. How NFS Works](#LinuxNotes-30.1.1.HowNFSWorks)

    - [30.1.2. Setting Up NFS](#LinuxNotes-30.1.2.SettingUpNFS)

  - [30.2. Logical Volume Management
    (LVM)](#LinuxNotes-30.2.LogicalVolumeManagement)

  - [30.3. SELinux](#LinuxNotes-30.3.SELinux)

    - [30.3.1. How SELinux Works](#LinuxNotes-30.3.1.HowSELinuxWorks)

    - [30.3.2. SELinux Modes](#LinuxNotes-30.3.2.SELinuxModes)

    - [30.3.3. SELinux Policy
      Types](#LinuxNotes-30.3.3.SELinuxPolicyTypes)

    - [30.3.4. Key SELinux
      Concepts](#LinuxNotes-30.3.4.KeySELinuxConcepts)

    - [30.3.5. SELinux Tools](#LinuxNotes-30.3.5.SELinuxTools)

  - [30.4. systemd-analyze
    Command](#LinuxNotes-30.4.systemd-analyzeCommand)

    - [30.4.1. Key Features](#LinuxNotes-30.4.1.KeyFeatures)

  - [30.5. Other Advance
    Features/Services](#LinuxNotes-30.5.OtherAdvanceFeatures/Se)

- [31. Further Notes to read](#LinuxNotes-31.FurtherNotestoread)

# **1. File System Structure and Description**

- /boot: Essential files required for booting the operating system that
  includes the Linux kernel, bootloader files, and other resources
  necessary to load the OS into memory.

- /root: home directory for the root user. Not same as the root /
  directory.

- /dev: special directory that contains device files, also known as
  device nodes, which represent hardware devices and virtual devices.
  Instead of being regular files, these files act as interfaces to
  interact with the system’s hardware and kernel.

- /etc: contains system-wide configuration files and shell scripts that
  are used to control the behaviour of the system, services, and
  applications.

- /bin → /usr/bin: stands for “binary” and contains essential system
  binaries (executable files) that are required for basic system
  functionality and recovery, especially when the system is in a minimal
  state. (eg: bash ,ls ,cp ,mv ,rm ,cat ,echo ,pwd ,tar ,mkdir ,ps
  ,kill)

- /sbin → /usr/sbin: system binaries that are primarily used by the
  system administrator and are critical for system management and
  maintenance tasks. (eg: fsck, mkfs, ifconfig, ip, mount/unmount,
  reboot, shutdown, systemctl, fdisk, iptables)

- /opt: Used to store optional software packages. It is designed to hold
  add-on software that is not part of the default installation of the
  operating system and is often used for software installed manually by
  the user or third-party developers.

  - /opt vs /usr/local: Software in /usr/local is usually compiled from
    source or installed locally by the system administrator. Software in
    /opt is typically precompiled binaries or third-party software
    packages.

- /proc: virtual filesystem that provides information about the system
  and running processes. Unlike regular directories, the files and
  subdirectories in /proc are dynamically generated by the kernel and
  represent the current state of the system, including hardware details,
  kernel data, and process information.

- /lib → /usr/lib: shared libraries and kernel modules that are
  essential for the basic operation of the system. These libraries are
  used by binaries located in directories like /bin and /sbin, which
  require them to function correctly.

  - libraries usually have filenames ending with .so (short for “shared
    object”).

  - /lib/modules directory contains kernel modules. These are drivers or
    extensions that can be dynamically loaded into the Linux kernel.

  - /usr/local/lib: libraries for locally installed software, typically
    built from source.

- /usr : Contains user-space applications, libraries, documentation, and
  other data that is not essential for booting the system. The /usr
  directory is intended for files that are shared and read-only across
  all users.

  - /usr/bin : see /bin/

  - /usr/sbin/: see /sbin/

  - /usr/lib/: see /lib/

  - /usr/libexec/: Contains helper programs used internally by other
    programs. Often includes utilities and daemons.

  - /usr/local : Reserved for locally installed software and
    customizations. Mirrors the structure of /usr (e.g., /usr/local/bin,
    /usr/local/lib). Ensures that local additions don’t overwrite or
    conflict with system-provided files.

  - /usr/share/ : Contains architecture-independent, shared data files.
    Includes icons, man pages, locale files, and documentation. Example
    subdirectories:

    - man: Manual pages.

    - doc: Documentation for installed software.

    - locale: Localization files.

  - /usr/include: Contains header files for C and C++ programming.
    Typically used during software compilation.

  - /usr/src: Contains source code, such as Linux kernel source code if
    installed.

  - /usr/games: Stores binaries for installed games. Rarely used in
    modern distributions.

  - /usr/tmp : Deprecated! Historically used for temporary files but now
    typically empty or absent. Temporary files are now stored in /tmp.

- /tmp: used to store temporary files created by programs and the
  operating system during runtime. These files are typically
  non-persistent and are often deleted automatically after a certain
  period or during a system reboot.

  - /tmp is world-writable but has the sticky bit set. This means:

    - Any user can create files in /tmp.

    - Users cannot delete or modify files they do not own (except root).

  - /var/tmp

    - Similar to /tmp but used for persistent temporary files.

    - Files in /var/tmp are not deleted on reboot and are retained for a
      longer time.

- /home: user-specific data, configurations, and files are stored. Each
  user on the system typically has a home directory within /home, named
  after their username. For example, if a user is named john, their home
  directory would be /home/john.

- /var: used to store variable data that is expected to change during
  system operation. This includes logs, temporary files, spool files,
  caches, and other data that grows or changes dynamically.

  - Spooling: Used for queuing tasks like print jobs or mail messages.

  - Subdirectories:

    - /var/log: Stores system and application log files (e.g., syslog,
      auth.log).

    - /var/tmp: Temporary files that are retained across reboots.

    - /var/spool: Queues for tasks like print jobs, mail messages, or
      scheduled tasks.

    - /var/cache: Application cache data (e.g., package managers like
      apt).

    - /var/lib: Variable data for system and user applications (e.g.,
      databases, metadata).

    - /var/mail: Stores incoming user email (if local mail delivery is
      configured).

    - /var/lock: files to prevent simultaneous access to resources.

    - /var/run: Information about the system since the last boot (e.g.,
      PID files). (/run replaced /var/run)

    - /var/www: Default directory for web server content (e.g., HTML
      files for Apache).

- /run: temporary filesystem (often a tmpfs) that holds runtime data for
  the system. It is created during the boot process and is used for
  storing information that is relevant only while the system is running,
  such as process IDs (PIDs), sockets, and other runtime data.

  - /run replaced /var/run because of boot-time availability,
    standardization and temporary nature.

- /mnt: standard location for temporarily mounting filesystems. It is
  part of the Filesystem Hierarchy Standard (FHS) and serves as a
  convenient placeholder for mounting external devices, network shares,
  or other filesystems during system operation.

  - purpose: temporary manual mounts

  - typical usage: manually mounted filesystems or devices

  - automation: not managed automatically

  - default contents: usually empty unless used manually

- /media: used as a mount point for removable media such as USB drives,
  CDs, DVDs, SD cards, or external hard drives. It is part of the
  Filesystem Hierarchy Standard (FHS) and is designed for automounting
  removable devices.

  - purpose: Automatic mounting for removable devices. Most desktop
    environments automatically mount devices under /media when they are
    plugged in.

  - typical usage: USB drives, DVDs, SD cards, etc.

  - automation: Managed by the system (e.g., udev)

  - default contents: Dynamically created mount points

  - In a multi-user environment, /media ensures each user has their own
    isolated mount points under /media/username.

- /lost+found: Contains files that have been recovered after a
  filesystem check (fsck) finds orphaned or corrupted files.

- /srv : Contains data for services provided by the system. This is
  where servers store data for various services like web servers (e.g.,
  Apache or Nginx), FTP servers, or database servers. Primarily used for
  data associated with services like HTTP, FTP, or version control
  repositories.

  - /srv/http/ – Web server data

  - /srv/ftp/ – FTP server data

- /sys: A virtual filesystem that provides information about kernel
  parameters, devices, and other kernel-related information. Used by the
  kernel to expose device information, configuration, and runtime
  status.

  - /sys/class/ – Information about hardware classes (e.g., network
    devices, block devices)

  - /sys/devices/ – Information about the physical devices connected to
    the system

- /lib64: Contains 64-bit shared libraries required by system programs
  and binaries. It is typically used on 64-bit systems.

# **2. Linux File System and Permissions**

## **2.1. File Types**

In Linux, files are categorized based on their functionality and
behavior. The first character in the output of ls -l , in the file’s
permission string, provides information about a file’s type.

srwxr-xr-x 1 josephv 0 Dec 14 13:18 textmate-501.sock

- \- : regular-file - stores standard data, such as text, binary, or
  executable files.

- d : directory - contains other files or directories (folders).

- l : symbolic link - a pointer (shortcut) to another file or directory.

- b : block device - represents a block device (e.g., a hard drive,
  CD-ROM, or USB).

- c : character device - represents a character device (e.g., keyboards,
  mice, or serial ports).

- s : socket - used for network communication between processes, either
  locally or over a network.

- p : pipe - First-In-First-Out (FIFO) special file used for
  inter-process communication.

Note: Files that begin with a dot (.) and are hidden from regular ls
output.

## **2.2. Links**

Links allow multiple references to a single file or directory, enabling
flexibility in how files are accessed and managed. Linux supports two
main types of links:

### **2.2.1. Hard link**

A hard link is an additional name for an existing file. Both the
original file and its hard link point to the same inode (the data
structure storing file metadata). Changes to the file’s content affect
all hard links because they share the same data. Deleting the original
file does not delete the data as long as at least one hard link exists.

- ln source_file hard_link_name

- Notes:

  - Cannot reference directories.

  - Cannot span across different filesystems (e.g., two different
    mounted partitions).

  - Multiple hard links to a file are indistinguishable from the
    original file.

- ls -li : → list inode-number of a files

### **2.2.2. Soft Link**

A soft link (aka symbolic link) is a shortcut or pointer to another file
or directory. It is a separate file containing the path to the target
file or directory. Changes to the target file affect the soft link, but
if the target is deleted, the soft link becomes broken (dangling).

- ln -s file1 file1_symlink

- Notes:

  - Can reference directories.

  - Can span across different filesystems.

  - Soft links are distinct files and have their own inodes.

## **2.3. File Permissions**

### 2.3.1. Standard Permissions

Control who can access and perform specific operations on files and
directories

- Types of Permissions: r: Read, w: Write, x: Execute

- Permission Categories: Owner (u), Group (g), Others(o)

- Changing Permissions (Symbolic Mode):

  - chmod a-rwx filename → remove all permissions for everyone

  - chmod a+r filename → add read permission for everyone

  - chmod o-rwx filename → remove all permission for others

  - chmod g+r filename → add read permission for group

  - chmod u+x filename → add execute permission for user

- Changing Permissions (Octal Mode):

  - eg., chmod 644 \<filename\>

  - Octal Values

    - 0 --- No Permission

    - 1 --x Execute

    - 2 -w- Write

    - 3 -wx Write + Execute

    - 4 r-- Read

    - 5 r-x Read + Execute

    - 6 rw- Read + Write

    - 7 rwx Read + Write + Execute

### 2.3.2. umask

The umask command in Linux is used to control the default permissions
for new files and directories created by the user. It specifies the
**“user file-creation mask”**, which subtracts permissions from the
default system-wide permissions.

- Default Permissions:

  - Files are typically created with a default permission of 666 (read
    and write for everyone).

  - Directories are typically created with a default permission of 777
    (read, write, and execute for everyone).

- umask 022

  - Effect:

    - Files: 666 - 022 = 644 (rw-r--r--)

    - Directories: 777 - 022 = 755 (rwxr-xr-x)

- echo "umask 0022" \>\> ~/.zshrc → for permanent change

### 2.3.3. Special Permissions

- setuid (s on owner)

  - When a file has the **setuid bit set**, it is executed with the
    permissions of the file’s **owner**, regardless of who runs it.

  - Common use case: Allowing users to execute programs requiring root
    privileges.

  - e.g., The passwd program runs as the root user, even when executed
    by a normal user, so it can modify system files like /etc/shadow.

  - chmod u+s filename → setuid

  - chmod 4755 filename → setuid using octal notation

  - chmod u-s filename → remove setuid

  - ls -l /usr/bin/passwd

```bash
-rwsr-xr-x 1 root root 54208 Jan 1 10:00 /usr/bin/passwd
```

- **s** in the owner's execute field indicates the setuid bit is set.

<!-- -->

- setgid (s on group):

  - When a file has the **setgid bit set**, it is executed with the
    permissions of the file’s **group**.

  - When applied to a **directory**, it ensures that files created
    within the directory inherit the directory’s group ownership rather
    than the creator’s primary group.

  - chmod g+s myfile → setgid bit

  - chmod 2755 filename → setgid using octal notation

  - chmod g-s filename → remove setgid

  - All files and subdirectories created inside mydirectory inherit its
    group ownership.

```bash
-rwxr-sr-x 1 user group 12345 Jan 1 12:00 program
```

- **s** in the group's execute field indicates the setgid bit is set.

<!-- -->

- Sticky Bit (t on others)

  - When sticky bit is set on a directory, only the **owner of a file**
    (or the directory owner or a superuser) can delete or rename files
    within that directory, even if other users have write permissions.

  - The sticky bit is commonly used on shared directories (e.g., /tmp)
    to prevent users from accidentally or maliciously deleting or
    renaming other users’ files.

  - chmod +t directory → add the sticky bit

  - chmod -t directory_name → remove the sticky bit

  - chmod 1777 directory_name → set using octal notation

  - ls -ld /tmp

```bash
drwxrwxrwt 10 root root 4096 Jan 4 10:00 /tmp
```

- t replaces x in the **others' execute** position if the sticky bit is
  set.

<!-- -->

- Note:

  - The setuid, setgid bit works only for **compiled binaries** (e.g., C
    programs).

  - For **interpreted scripts** (like Bash scripts), the kernel does not
    directly handle their execution. Instead, the script is executed by
    the interpreter (e.g., /bin/bash), which runs with the privileges of
    the user who invoked the script.

### **2.3.4. Access Control List (ACLs)**

Advanced mechanism for specifying permissions on files and directories
beyond the standard user, group, and others model. They allow
fine-grained control, enabling different permissions for multiple users
or groups on the same file or directory.

- ACL adds + sign at the end of the permissions

```bash
-rw-rw-r--+ 1 jonah home 7 Dec 14 12:00 home
```

- Note: Setting w permission with ACL does not let the user to delete
  the file.

- setfacl -m u:jonah:rwx /path/to/file → Grant permissions to a user

- setfacl -m g:jonah:rw /path/to/file → Grant permissions to a group

- setfacl -x u:jonah /path/to/file → To remove a specific entry

- setfacl -Rm u:jonah:rwx /path/to/file → To recursively set inside a
  directory

- setfacl -d -m u:john:rwx /mydir → set default ACL for a directory

- setfacl -b /path/to/file → Removes all entries

### **2.3.5. Changing Ownership**

Ownership of files and directories can be modified using the chown and
chgrp commands.

- chgrp family lorem.txt → Change group of a file

- chown jonah lorem.txt → Change owner of a file

- chown jonah:family lorem.txt → Change both group and owner of a file

**Note:** the user will need to login again after creation of a new
group

# **3. Essential File Management Commands**

## **3.1. File and Directory Operations**

### 3.1.1. ls Command

used to list files and directories within a file system. It is one of
the most frequently used commands for navigating and managing files in a
terminal.

- ls directory_name → list the contents of the specific directory

- ls -l-\> displays detailed information, including permissions,
  ownership, size and modification date.

- ls -la → show all files, including hidden files (those starting with
  .).

- ls -t → sort by modification time (most recent first)

- ls -S → sort by file size

- ls -r → reverse the sorting order

- ls -R → list directories recursively

- ls -h → human readable format ( eg: KB, MB, GB)

- ls -i → show the inode number for each file

- ls -F → appends a character to earch file name indicating it’s type

  - / for directories

  - \* for executables

  - @ for symbolic links

- ls -d lists only directories in the current location

- ls --color - enables color coding to distinguish between file types

### 3.1.2. cd Command

used to navigate between directories in Linux.

- cd directory_path → Changes the current working directory to the
  specified path.

- cd → Navigate to the home directory; equivalent to cd ~

- cd .. → Navigate to the parent directory

- cd - → navigate to the previous directory

- cd ~username → changes to another user’s home directory (if
  permissions allow)

- cd ../.. → move two levels up

### 3.1.3. cp Command

Duplicate file contents from a source to a destination

- cp file1 file2 → copy file1 to file2

- cp -r dir1 /path/to/directory/ → copy a directory recursively

- cp -i file1 /path/to/destination/ → prompt before overwriting an
  existing file

- cp -u file1 /path/to/destination/ → copy only if the source file is
  newer than the destination file or if the destination file doesn’t
  exist

- cp -v file1 /path/to/destination/ → show detailed output of what is
  being copied

- cp -f file1 /path/to/destination/ → forcefully overwrite files, even
  if write-protected

- cp --preserve=file1 /path/to/destination/ → create backups of existing
  destination files before overwriting them

- cp --parents /source/dir/file /destination/ → create the full
  directory structure of the source file in the destination

- cp -l file1 /path/to/destination/ → create hard. links instead of
  copying

- cp -a dir1 /path/to/destination/ → copy a directory while preserving
  attributes

### 3.1.4. rm Command

Remove files, directories, and symbolic links permanently without moving
them to a trash or recycle bin

> **⚠️ DANGER WARNING:**
> - `rm` permanently deletes files - there is NO undo!
> - `rm -rf /` can destroy your entire system
> - ALWAYS double-check paths before executing
> - Consider using `rm -i` for interactive confirmation
> - Never run `rm -rf` commands from untrusted sources

- rm path/to/file1 path/to/file2 → remove specific files

- rm -f path/to/file1 path/to/file2 → remove specific files ignoring
  nonexistent files (⚠️ use with caution)

- rm -i path/to/file1 path/to/file2 → remove specific files
  interactively prompting before each removal (RECOMMENDED)

- rm -rf /path/to/directory → remove a directory that is not empty (⚠️ EXTREMELY DANGEROUS)

### 3.1.5. mv Command

Move files and directories from one location to another or to rename
them

- mv oldname.txt newname.txt → rename a file

- mv path/to/source path/to/target → rename a file or directory

- mv path/to/source1 path/to/source2 ... path/to/existing_directory →
  move multiple files into an existing directory

- mv -i file.txt /path/ → prompts for confirmation before overwriting
  files

- mv -f file.txt /path/ → forces the operation without prompting, even
  if overwriting files

- mv --backup=numbered file.txt /path/ → creates a backup of existing
  destination files before overwriting. (default is numbered)

- mv --backup=numbered --suffix=.bak file.txt /path/ → Specifies a
  custom suffix for backups.

- mv !(\*.txt) /destination/ → move all files except a specific type

### 3.1.6. mkdir Command

Create directories

- mkdir new_directory → create a single directory

- mkdir dir1 dir2 dir3 → create multiple directories

- mkdir -p parent/child/grandchild → create nested directories; avoids
  errors if the directory already exists

- mkdir -m 700 secure_directory → create a directory with specific
  permissions

Note: New directory inherits the permissions of the parent directory,
unless specified with -m.

### 3.1.7. rmdir Command

Remove empty directories. It is a simple and safe utility, as it will
not delete a directory unless it is completely empty.

- rmdir path/to/directory1 path/to/directory2 → remove specific
  directories

- rmdir -p path/to/directory1 path/to/directory2 → remove specific
  directories recursively

### 3.1.8. file Command

Determine the type of a file. It analyzes the file’s content, rather
than just relying on its extension, to provide an accurate description
of the file type.

- file example.txt → determine the file type of a single file

- file file1 file2 file3 → analyse multiple files

- file -s /dev/sda → analyse special files instead of skipping them

- file -i image.png → display the MIME type instead of a human-readable
  description

- file -z archive.gz → examine the contents of a compressed file

If the file doesn’t match any patterns in the magic database, the result
may be vague (e.g., “data”).

### 3.1.9. tree Command

Display the structure of directories and files in a hierarchical
tree-like format. It’s a helpful utility for visualizing directory
contents, especially when dealing with complex structures.

- tree → basic usage

- tree /home/user/documents → view a specific directory

- tree -L 2 → limit the depth of display

- tree -a → show hidden files

- tree -h → show human-readable file sizes

- tree -P "\*.txt" → list files matching a pattern

- tree -I "node_modules\|\*.log" → exclude specific files or directories

### 3.1.10. truncate Command

used to shrink or extend the size of a file to a specified length. It
can create empty files or modify the size of existing ones without
altering their content. Caution: data beyond the specified size is
permanently lost.

- truncate -s 1M newfile.txt → create a file of a specific size

- truncate -s 50K existingfile.txt → shrink a file; data beyond the 50
  KB mark is discarded.

- truncate -s 10M largefile.txt → extend a file; the new space is filled
  with null bytes (\0)

- truncate -s 0 file.txt → clears the content in a file but the file
  still exists

### 3.1.11. split Command

used to split large files into smaller chunks or pieces. This is
especially useful when working with very large files that need to be
divided into manageable sizes for easier handling, storage, or transfer.

- split -l 1000 largefile → Creates files named xaa, xab, xac, etc.,
  each containing 1000 lines.

- split -l 500 largefile part\_ → Creates files named part_aa, part_ab,
  part_ac, etc., each containing 500 lines.

- split -b 1M largefile → Creates files named xaa, xab, xac, etc., each
  1 MB in size.

- split -C 2M largefile → Ensure lines are not split while creating
  chunks of 2 MB

- split -l 100 --numeric-suffixes largefile output\_ → Create files with
  numeric suffixes instead of alphabetic

- split -l 200 --suffix-length=4 largefile chunk\_ → Creates files named
  chunk_aaaa, chunk_aaab, chunk_aaac, etc.

- split -l 100 --additional-suffix=.txt largefile split\_ → Creates
  files like split_aa.txt, split_ab.txt, etc.

- cat x\* \> reassembled_file → To reassemble split files back into the
  original file.

### 3.1.12. pwd Command

Display the absolute path of the current directory in which the user is
working

- pwd→ print the current directory

- pwd -P → print the current directory, and resolve all symlinks (i.e.
  show the "physical" path)

### 3.1.13. stat Command

Display detailed information about a file or file system. Unlike
commands like ls, which provide basic information, stat offers
comprehensive metadata such as access time, modification time, size,
ownership, and file permissions.

- stat example.txt → basic file information

- stat -L symlink → follow symbolic links

- stat -f /path/to/mount → display system information instead of
  metadata

- stat --printf="File Size: %s bytes\nAccess Time: %x\n" example.txt →
  custom output formatting

## **3.2. Viewing and Processing File Contents**

### 3.2.1. cat Command

view, create, concatenate, and manipulate files

- cat path/to/file → print the contents of a file

- cat \> newfile → prompts you to input ext. Ctrl+D to save and exit

- cat \>\> existingfile → Appends input to the end of the specified file

- cat file1 \> file2 → overwrites the content of file2 with the content
  of file1

- cat file1 file2 \> file3 → combine file 1 and file2 into file3

- cat -s filename → supress multiple blank lines

- cat -v filename → display non-printable characters

- cat -n /path/to/file/-\> print the contents of a file with line
  numbers

### 3.2.2. tac Command

Reverse of the cat command. It reads files line by line but outputs them
in reverse order, displaying the last line first and the first line
last.

- tac file.txt → outputs the linesof file.txt in the reverse order

- tac file1.txt file2.txt → reverse multiple files and concatenate them

- tac -s ":" file.txt → specify a custom delimiter, colon (:), as the
  line separator instead of the default newline.

- tac -r -s "\[0-9\]+" file.txt → Use regular expression as a separator;
  in this case treats any numeric sequence as the separator

### 3.2.3. more and less Commands

View the contents of a file or output one screen at a time. less is more
powerful than more.

- Examples:

  - less file.txt

  - dmesg \| less

- Navigation:

  - SPACE → Move to the next screen

  - ENTER → Move one line down

  - b → Move one screen backward

  - /pattern → search for pattern forward

  - ?pattern → search for pattern backward

  - n → repeat the last search same direction

  - N → repeat the last search reverse direction

  - q → quit

### 3.2.4. head Command

used to display the first few lines of a file

- head file.txt → view the first 10 lines of a file

- head -n 5 file.txt → display the first 5 lines

### 3.2.5. tail Command

used to display the last few lines of a file.

- tail file.txt → view the last 10 lines of a file

- tail -n 5 file.txt → view the last 5 lines

- tail -f file.txt → monitor a file in real-time.

### 3.2.6. wc Command

stands for **word count**. It is used to count and display information
about a file or input, such as the number of lines, words, characters,
or bytes.

- wc lorem.txt → Count number of lines, words and bytes in the file

- wc -l lorem.txt → Count the number of lines

- wc -w lorem.txt → Count the number of words.

- wc -c lorem.txt → Count the number of bytes.

- wc -m lorem.txt → Count the number of characters.

- wc -L lorem.txt → Display the length of the longest line.

## **3.3. Finding files**

### **3.3.1. find Command**

search for files and directories within the filesystem based on various
criteria such as name, type, size, modification time, and permissions.
Unlike the “locate command”, find performs a real-time search, scanning
the filesystem directly.

- find /home/user -name "test.txt" → Finds a file named test.txt in
  /home/user.

- find /home/user -iname "README" → case insensitive search

- find /path/to/start -type f → find regular files

- find /path/to/start -type d → find directories

- find /path/to/start -size +1G → find files larger than 1G

- find /path/to/start -size -100k → files smaller than 100KB

- find /path/to/start -size 1M → files exactly 1MB in size

- find /path/to/start -mtime -7 → files modified in the last 7 days

- find /path/to/start -mtime +30 → files modified more than 30 days ago

- find /path/to/start -mtime 1 → files modified exactly 1 day ago

- find /path/to/start -perm 644 → files with specific permissions (eg.,
  644)

- find /path/to/start -perm -o=w → files writeable by others

- find /path/to/start -name "\*.tmp" -exec rm {} \\ → delete all .tmp
  files

- find /path/to/start -name "\*.log" -exec ls -lh {} \\ → list more
  details

- find /path/to/start -name "\*.txt" -mtime -5 → find .txt files
  modified in the last 5 days

- find /path/to/start -type d -user username → find directories owned by
  a specific user

### 3.3.2. locate Command

quickly find files and directories by searching a pre-built database of
file paths typically /var/lib/mlocate/mlocate.db, which contains a
snapshot of all file paths on the system. The database is updated
periodically by a scheduled job (usually via updatedb). Searches are
nearly instantaneous because it queries the pre-built database.

- locate ssh_config → Finds all files and directories with “ssh config”
  in their name.

- locate -c ssh_config → Counts all files and directories with “ssh
  config” in their name.

- locate -n 10 ssh_config → Shows only the first 10 results

- locate -i readme → case-insensitive search

- locate "\*.txt" → matches all .txt files.

- Notes:

  - If the locate database is outdated, it won’t reflect recent changes
    to the filesystem. You can manually update it with: sudo updatedb

  - The database may not include paths you don’t have permission to
    access. Run sudo locate for a broader search.

# **4. Getting Help**

- whatis \<command\> → display one-line manual page descriptions.

- man \<command\> → displays detailed documentation for commands and
  programs.

- info \<command\> → Provides a more comprehensive and structured
  documentation than man.

- \<command\> --help → Many commands provide a summary of usage and
  options with the —help flag

- apropos keyword → searches for commands related to a specific keyword

- which \<command\> → locates the path of an executable command

- whereis \<command\> → Locates the binary, source, and manual files for
  a command

- tldr \<command\> → A simplified and community-driven manual for common
  commands.

- cheat \<command\> → Displays useful examples for commands.

# **5. Important command-line features**

## **5.1. Wildcards**

Wildcards are special characters or symbols used to represent patterns
in file and directory names. They are commonly used in commands to
perform operations like listing, copying, moving, or deleting multiple
files without specifying each one individually.

- Asterisk \* : match zero or more characters

- Question mark ? : match any one character

- Square brackets \[\]: Matches any one character within the brackets.
  Can also specify a range of characters. Examples:

  - ls file\[123\].txt → Matches file1.txt, file2.txt, file3.txt.

  - ls file\[a-c\].txt → Matches filea.txt, fileb.txt, filec.txt.

- Exclamation mark or Caret (! or ^): Matches any character **not**
  inside the brackets. Examples:

  - ls file\[!9\].txt → Matches files that don’t have a digit after
    file.

  - ls file\[^z\].txt → Matches files that don’t have a lowercase letter
    after file.

  - ls file\[^Z\].txt → Matches files that don’t have a uppercase letter
    after file.

- Curly Braces {}: match a group of strings or patterns. Example:

  - ls file{1,2,3}.txt → Matches file1.txt, file2.txt, file3.txt.

  - touch abcd{1..3}.xyz → Create 10 files abcd1.xyz, abcd2.xyz,
    abcd3.xyz

  - mv {file1,file2}.txt backup/ → Moves file1.txt and file2.txt to
    backup.

- Tilde ~ : Expands to the **home directory** of the current user.
  Example:

  - cd ~/Documents → Navigates to the Documents directory in the user’s
    home folder.

- Escaping Special Characters: escape them with a backslash (\\.
  Example:

  - ls file\\txt → Looks for a file literally named file.txt.

## **5.2. Input and Output redirection**

Input and Output redirections allow you to redirect the standard input,
output, and error streams of commands to and from files, devices, or
other commands.

- Linux processes use three standard streams:

  - stdin - fileDescriptor 0 → data fed into a program

  - stdout - fileDescriptor 1 → Normal output from a program

  - stderr - fileDescriptor 2 → Error messages from a program

- Examples:

  - wc \< input.txt → Counts lines, words, and characters in input.txt.

  - ls \> filelist.txt → Redirect to a file

  - echo "New line" \>\> filelist.txt → Append to a file

  - sort \< unsorted.txt \> sorted.txt → combine input and output
    redirection

  - ls nonexistentfile 2\> errors.log → saves error messages to
    errors.log

  - ls validfile nonexistentfile \> output.log 2\>&1 → combine standard
    output and error

  - command \> output.log 2\> errors.log → separate output and errors.

  - command \> /dev/null 2\>&1 → redirect output or errors to nowhere

## **5.3. Separators for Multiple Commands**

In Linux, you can run multiple commands on the same line by using
various separators, depending on how you want the commands to interact.

- semicolon (;)

  - echo "Hello"; ls; date → Outputs “Hello”, lists directory contents,
    and displays the current date.

- Logical AND (&&)

  - mkdir mydir && cd mydir → Creates a directory named mydir and
    changes into it only if the directory creation is successful.

- Logical OR (\|\|)

  - cd nonexistent \|\| echo "Directory does not exist" → Tries to
    change into a nonexistent directory, and if it fails, prints
    “Directory does not exist.”

- Combining of AND and OR

  - mkdir mydir && echo "Directory created" \|\| echo "Failed to create
    directory" → If mkdir mydir succeeds, it prints “Directory created”.
    Otherwise, it prints “Failed to create directory.”

- Background Execution (&)

  - sleep 10 & echo "Background task started" → Starts a 10-second sleep
    in the background and immediately prints “Background task started.”

- Pipe (\|) connect the output of one command to the input of another.

  - ls \| grep "file" → Lists files and filters the output to show only
    lines containing “file”.

  - cat file.txt \| sort \| uniq → Sorts and removes duplicate lines
    from file.txt.

- tee: reads input from standard input (stdin) and writes it to both
  standard output (stdout) and one or more files simultaneously. It is
  often used in conjunction with pipes (\|) to save the output of a
  command to a file while still displaying it on the screen. eg.,

  - lorem -s10 \| tee -a lorem.txt

Tips:

- (command1; command2) && command3 → Use parentheses to group commands
  if needed

- To ensure proper execution and debugging, use set -e in scripts to
  stop on errors

## 5.4. Command History

- history → Shows a numbered list of past commands.

- history \| grep "keyword" → search history with grep

- history -c → clear history

- history -d 3 → delete a specific entry

- history -a → append current session history to the history file

- history -r → reload the history file into the session

- history -w → overwrite the history file with the session history

- !! → re-execute the last command

- !n → execute command number n

- !ls → re-execute the last command starting with a specific string

The behavior of the history command is influenced by the following
environment variables:

- HISTSIZE → Number of commands stored in memory during a session.

- HISTFILESIZE → Maximum number of lines stored in the history file.

- HISTFILE → Path to the history file (default is ~/.bash_history).

- HISTCONTROL → Controls how duplicate and empty commands are handled.

- HISTIGNORE → Specifies patterns for commands to be excluded from
  history.

Avoid saving sensitive commands:

- Use a leading space before a command to prevent it from being saved
  (if HISTCONTROL includes ignorespace).

## 5.5. Up and Down Arrows

- **Up Arrow**: Scrolls backward through the history of commands you
  have entered.

- **Down Arrow**: Scrolls forward through the command history.

## 5.6. Recursive Search (Ctrl + R)

Allows you to search your command history interactively and quickly.
Press Ctrl + R and start typing part of a previous command. The most
recent match will appear. Press **Enter** to execute the displayed
command or **Ctrl + R** again to search for the next match.

## 5.7. Editing Commands

- Ctrl + A: Move to the beginning of the line.

- Ctrl + E: Move to the end of the line.

## **5.8. Tab Completion**

- Type part of the command or path and press Tab to complete.

- Double Tab shows all possible completions.

# **6. Text Processing and Transformation**

## 6.1. Essential command-line utilities for text processing

### 6.1.1. cut Command

- cut -c1,3,5 lorem.txt → prints first, third and fith characters in the
  file lorem.txt

- cut -c5-10 lorem.txt → prints a range of chars between 5 and 10

- cut -c1-5,10-15 lorem.txt → prints two different ranges in the file

- cut -d: -f1,6 /etc/passwd → prints first and sixth column in the
  /etc/passwd

- ls -lhrt \| grep temp \| cut -d " " -f 11 → prints the file names from
  the list of files

### 6.1.2. awk Command

manipulate and analyze structured text data. It processes input line by
line and operates based on patterns and actions.

**Built-in Variables**

- NR Current record number (line number).

- NF Number of fields in the current line.

- FS Field separator (default: space/tab).

- OFS Output field separator (default: space).

- RS Record separator (default: newline).

- ORS Output record separator (default: newline).

**Common Use Cases**

- awk '{print \$1, \$3}' file.txt → Prints the 1st and 3rd fields from
  each line of file.txt

- awk -F':' '{print \$1, \$3}' /etc/passwd → Uses : as the field
  delimiter and prints the 1st and 3rd fields.

- ls -al \| awk '{print \$8}' → prints the 8th column in the list output

- ls -al \| awk '{print \$1,\$8}' → prints the 1st and 8th column in the
  list output

- ls -al \| awk '{print \$NF}' → print the last column in the list
  output

- cat /etc/passwd \| awk '/darwin/ {print}' → search the word darwin in
  the /etc/passwd. note that grep might be a better choice for this.

- awk -F: '{print \$1}' /etc/passwd → print the 1st column in the
  /etc/passwd using the the delimiter :.

- echo "Tom Hanks" \| awk '{\$2="Cruise";print \$0}' → replace Hanks
  with Cruise.

- awk 'length(\$0) \> 15' lorem.txt → print only those entries with
  length \< 15 chars.

- ls -al \| awk '{if(\$8 == "lorem.txt") print \$0}' → print the lines
  where 8th column matches lorem.txt

- awk -F':' '\$3 \> 1000 {print \$1, \$3}' /etc/passwd → Filters lines
  where the 3rd field (UID) is greater than 1000 and prints the username
  and UID.

- ls -l \| awk '{print NF}' → prints the number of the columns in each
  row

- awk '{sum += \$2} END {print "Total:", sum}' file.txt → Calculates the
  sum of the 2nd column and prints the total.

- awk '{printf "User: %s, UID: %d\n", \$1, \$3}' /etc/passwd → Formats
  output using printf

- awk '{if (\$3 \> 1000) print \$1 " is large"; else print \$1 " is
  small"}' file.txt → Prints messages based on the value of the 3rd
  field.

- awk '{for (i = 1; i \<= NF; i++) print \$i}' file.txt → Prints all
  fields of each line on separate lines

### 6.1.3. grep Command

searching and filtering text. It searches for patterns (using regular
expressions) in files or streams and prints matching lines.

- grep -i keyword file → search for a keyword ignoring case sensitivity

- grep -r keyword /path/to/code → searches for TODO in all files under
  /path/to/code

- grep -c keyword file → count the number of matches

- grep -n keyword file → display the match lines and their line numbers

- grep -v keyword file → display everything but lines matching keyword

- grep -l keyword /path/to/code → list only the names of files
  containing matches

- grep -L keyword /path/to/code → list files that do NOT contain matches

- grep -o keyword file → Show only the matched parts of the lines.

- grep -E keyword file → Use extended regular expressions (same as
  egrep).

- grep -w keyword file → match whole words only

- grep keyword --exclude=\*.log /path/to/code → exclude specific files

- grep keyword --exclude=\*.xml /path/to/code → include specific files

- grep -A10 keyword file → show 10 lines after a match

- grep -B10 keyword file → show 10 lines before a match

- grep -C10 keyword file → show 10 lines before and after a match

**grep vs egrep**

- grep: Pattern Type: Basic Regular Expressions (BRE).In BRE, some
  special characters (like ?, +, {}, \|, ()) need to be escaped with a
  backslash (\\ to be treated as meta-characters. Slightly slower for
  complex patterns. Example:

  - grep "abc\\def" file.txt → searching for lines containing “abc” or
    “def”

  - grep "\[0-9\]\\" file.txt → searching for one or more digits

- egrep: Pattern Type: Extended Regular Expressions (ERE). Supports
  meta-characters (?, +, {}, \|, ()) without needing to escape them.
  Slightly faster for complex patterns Example:

  - egrep "abc\|def" file.txt → searching for lines containing “abc” or
    “def”

  - egrep "\[0-9\]+" file.txt → searching for one or more digits

- zgrep: allows you to search for a pattern in a compressed .gz file. It
  works similarly to the grep command but operates directly on .gz files
  without requiring you to decompress them first.

### 6.1.4. sort Command

sort lines of text files or input data. It allows you to arrange lines
alphabetically, numerically, or in custom orders.

- sort filename → displays contents of a file sorted in the alphabetical
  order

- sort -r filename → displays contents of a file sorted in the reverse
  alphabetical order

- sort -n numbers.txt → sort lines numerically

- sort -f filename → ignore case when sorting

- sort -k2 filename → performs sorting using the second column

- sort -t: -k2 filename → specify the delimiter to separate columns
  (default is whitespace)

- sort -k2 -k3 file.txt → sort by multiple keys; first by the second
  colum and then by the third column

- sort -u filename → remove duplicates from the output

### 6.1.5. uniq Command

used to report or omit repeated lines in a file or input stream. It
filters out adjacent duplicate lines from input, making it useful for
processing sorted data or finding unique occurrences of data.

- uniq filename → remove duplicate lines from a file

- sort file \| uniq → removes duplicates from a sorted file. **IMP:**
  always sort first before using uniq

- sort file \| uniq -c → list count of occurrences alongside each line

- sort file \| uniq -d → only show duplicate lines

- uniq -i file.txt → ignore case while finding duplicates

- uniq -s 3 file.txt → ignore the first 3 characters of each line while
  comparing them for uniqueness

- uniq -w 5 file.txt → compare lines by considering only the first 5
  characters

### **6.1.6. sed command**

Sed command in Linux is a powerful stream editor used to perform basic
text transformations on an input stream (a file or input from a
pipeline). It is commonly used for tasks such as searching, finding and
replacing, inserting, or deleting text in files.

- sed 's/oldtext/newtext/' file.txt → Replace the first occurrence of a
  string in each line. s stands for substitution

- sed 's/oldtext/newtext/g' file.txt → Replace all occurrences in a
  line. g stands for global replacement.

- sed 's/pattern//g' file.txt → Remove all occurrences of pattern

- sed -n '/pattern/p' file.txt → Print lines containing a pattern. -n
  suppresses the default output. p prints only those lines. (This is
  similar to grep pattern file.txt)

- sed -n 3,10p lorem.txt → print a range of lines (3 through 10)

- sed '/pattern/d' file.txt → Delete all lines containing a pattern.

- sed '2d' file.txt → Delete specific lines containing pattern

- sed '5,10d' file.txt → Delete a range of lines (5 through 10)

- sed '3i\This is inserted text' file.txt → Inserts “This is inserted
  text” before line 3.

- sed '3a\This is appended text' file.txt → Appends “This is appended
  text” after line 3

- sed -i 's/oldtext/newtext/g' file.txt → modifies a file in place

- sed 's/\[0-9\]\\/\[NUMBER\]/g' file.txt → replaces one ore more digits
  with \[NUMBER\]

- sed -e 's/oldtext/newtext/' -e 's/another/replace/' file.txt → execute
  multiple commands using -e

- sed '2,4s/oldtext/newtext/' file.txt → replace only specific lines (2
  through 4)

- sed '/^\$/d' file.txt → remove blank lines

- sed 's/^\[^ \]\* //' file.txt → removes the first word from each line

- sed = file.txt \| sed 'N;s/\n/\t/' → add a line number prefix with tab
  separator

- sed = file.txt \| sed 'N;s/\n/\t/' \> file2.txt → save the output with
  line numbers to another file

- sed G file.txt → insert an empty line after each line

- sed '9!s/oldtext/newtext/g' file.txt → exclude line 9 from the pattern
  replacement

- sed '9,19!s/oldtext/newtext/g' file.txt → exclude lines 9 and 19 from
  the pattern replacement

# 7. File Comparison

Common command-line utilities used to compare files and directories

- diff: Displays line-by-line differences between two files.

  - diff file1.txt file2.txt → Lines that differ are displayed with \>
    or \< to indicate which file they belong to.

- cmp: Compares two files byte by byte

  - cmp file1.txt file2.txt → Displays the first differing byte and its
    position

- md5sum or sha256sum : Compares file checksums to determine if two
  files are identical

  - md5sum file1.txt file2.txt → If the checksums are identical, the
    files are identical.

- rsync: Synchronizes files and directories but can also compare them
  for differences.

  - rsync -ani dir1/ dir2/ → Displays the differences without actually
    copying files (-n for dry-run).

- vimdiff: Opens two or more files in vim for side-by-side comparison
  with syntax highlighting.

  - vimdiff file1.txt file2.txt → Tip: Use keyboard shortcuts to
    navigate and merge differences

# **8. Compress and UnCompress Files**

In Linux, you can compress and uncompress files using various tools and
commands. These tools reduce the size of files to save storage space or
make file transfers more efficient.

| **Tool** | **File Extension** | **Features** |
|----|----|----|
| gzip | .gz | Fast and widely used |
| bzip2 | .bz2 | Better compression but slower |
| xz | .xz | High compression ratio, slower |
| zip | .zip | Archives and compresses together |
| tar | .tar, .tar.gz, .tar.bz2 | Combines multiple files into one archive; works with compression |

**Essential Commands**

- gzip

  - gzip file.txt → creates file.txt.gz

  - gzip file1.txt file2.txt → compress multiple files

  - gzip -9 file.txt → compress with maximum compression

  - gunzip file.txt.gz → uncompress a file

- bzip2

  - bzip2 file.txt → creates file.txt.bz2

  - bzip2 file1.txt file2.txt → compress multiple files

  - bunzip2 file.txt.bz2 → uncompress a file

- xz

  - xz file.txt → create file.txt.xz

  - xz -9 file.txt → compress with maximum compression

  - unxz file.txt.xz → uncompress a file

- zip

  - zip compressed.zip file.txt → compress a single file.

  - zip compressed.zip file1.txt file2.txt → compress multiple files

  - zip -r compressed.zip /path/to/directory → compress an entire
    directory

  - unzip compressed.zip → uncompress a file

  - unzip -l compressed.zip → list contents without extracting

- tar

  - gz

    - tar -czvf archive.tar.gz file1.txt file2.txt → create a tar.gz
      file

    - tar -xzvf archive.tar.gz → uncompress a tar.gz file

    - tar -tzvf archive.tar.gz → list contents without extracting

  - bz2

    - tar -cjvf archive.tar.bz2 file1.txt file2.txt → create a tar.bz2
      file

    - tar -xjvf archive.tar.bz2 → uncompress a tar.bz2 file

  - xz

    - tar -cJvf archive.tar.xz file1.txt file2.txt → create a tar.xz
      file

    - tar -xJvf archive.tar.xz → uncompress a tar.xz file

# 9. Managing Users

## **9.1. User Account Management**

**User Account Management** in Linux involves creating, modifying, and
deleting user accounts, managing user permissions, and assigning users
to groups. 

- **Username:** Each user account is identified by a unique
  **username**. Users can be human (regular users) or system accounts
  (used by services and daemons)

- **User IDs (UIDs):** Each user is assigned a **UID**, a unique
  numerical identifier.

  - **0**: Reserved for the root user (administrator).

  - **1-999**: Reserved for system accounts.

  - **1000 and above**: Default range for regular users (may vary by
    distribution).

- **Groups:**

  - Users are assigned to groups to manage permissions collectively.

  - Each user belongs to a **primary group** and can belong to multiple
    **secondary groups**.

- **Configuration Files**

  - /etc/passwd: Stores user account details (username, UID, home
    directory, shell, etc.).

  - /etc/shadow: Stores encrypted passwords and account expiration
    information.

  - /etc/group: Stores group details.

  - /etc/skel: Contains default files for new user home directories.

  - /etc/login.defs: Contains system-wide configuration for user account
    defaults

### **9.1.1. User Account Commands**

- Create a New User

  - sudo useradd username → Adds a new user without setting a password

  - sudo useradd -m -s /bin/bash username → Add a user with a home
    directory and set default shell

  - sudo passwd username → Add a user and set a password

- Modify an Existing User

  - sudo usermod -d /new/home/dir username →Change the user’s home
    directory

  - sudo usermod -aG groupname username → Add user to a secondary group

  - sudo usermod -L username → Lock a user account (prevent login)

  - sudo usermod -U username →Unlock a user account.

- Delete a User

  - sudo userdel username → Delete a user but keep their files

  - sudo userdel -r username → Remove a user and their home directory

- View User Information

  - id username → display details of a user

### **9.1.2. Group Management Commands**

- sudo groupadd groupname → create a group

- sudo usermod -aG groupname username → add a user to a group

- sudo gpasswd -d username groupname → remove a user from a group

- sudo groupdel groupname → delete a group

### **9.1.3. Password Management**

- sudo passwd username → set or change a user’s password

- sudo passwd -e username → force a user to change their password at the
  next login

- sudo passwd -l username → lock a user’s password

- sudo passwd -u username → unlock a user’s password

### **9.1.4. Home Directories**

- By default, a new user gets a home directory (/home/username).

- Files in /etc/skel are copied to the user’s home directory during
  account creation.

### **9.1.5. Temporary User Accounts**

- sudo useradd -e 2024-12-31 tempuser Create a user account that
  automatically expires

### **9.1.6. Enable Password Aging**

The chage command in Linux is used to manage user password aging
policies. It allows administrators to control how often users need to
change their passwords, set expiration dates for accounts, and enforce
password management rules for security purposes.

- chage -l username → view password aging information

- sudo chage -M 60 username → sets the password to expire after 60 days

- sudo chage -m 7 username → Requires users to wait at least 7 days
  before changing their password again.

- sudo chage -E 2024-12-31 username → Sets the account to expire on Dec
  31, 2024

- sudo chage -W 10 username → sends a warning message 10 days before the
  password expires

- sudo chage -d 0 username → sets the “last password change” date to 0,
  forcing the user to change their password on the next login

- default password policies are set in /etc/login.def

### **9.1.7. Tips**

- sudo usermod -s /sbin/nologin systemaccount Disable shell access for
  system accounts

## 9.2. Switch Users and super user Access

### **9.2.1. Switching Users**

To switch from one user account to another, use the su (substitute user)
command.

- su username → switch to another user

- su - → switch to the root user. The - (hyphen) option starts a login
  shell, loading the root user’s environment.

  - Note: The root account is disabled by default in Ubuntu, so there is
    no root password. Hence su may fail with an authentication error.
    Use sudo -i instead.

### **9.2.2. Sudo Access**

The sudo command allows a permitted user to execute commands as the
**root user** or another user with elevated privileges.

- sudo apt update → execute a single command with sudo

- sudo -i → gain a temporary root shell; prompts for your password, not
  root password.

- sudo su - username → use sudo to switch users.

- sudo su - → switch to the root user

### **9.2.3. Granting Sudo Access to a User**

If you have root access, you can grant sudo privileges to another user
by adding them to the **sudo group** or modifying the sudoers file.

- sudo usermod -aG sudo username → add a user to the **Sudo Group**

  - sudo usermod -aG wheel username → In some distributions (like
    CenOS/RHEL), the group is wheel.

- sudo visudo → modify the Sudoers file

  - username ALL=(ALL:ALL) ALL - Add this line to allow a user to
    execute any command

- sudo whoami → test sudo access. If successful, it should return root.

Tip: Avoid Running Full Sessions as Root: Use sudo for specific commands
to minimize security risks

## 9.3. Monitoring Users

- who: Displays information about users currently logged into the
  system.

- john tty1 2024-12-19 10:23 (:0)

> alice pts/0 2024-12-19 10:45 (192.168.1.101)

- w: Displays who is logged in and what they are doing, including
  resource usage.

- whoami: Displays the currently logged-in username

- id: Displays the current user’s ID, group ID, and group memberships.

- last: Shows the login history of users.

- users: Displays a list of usernames currently logged in.

- finger**:** Provides detailed information about logged-in users (may
  need to be installed)

- ps -u username : Displays running processes, including those owned by
  specific users.

- lsof -u username: Lists open files, including those opened by specific
  users.

## 9.4. Communicating with other users

There are several ways to communicate with other users logged into the
system. These methods involve sending messages to their terminal
sessions or files. Here are the most common ways to talk to users:

- write Command

  - write alice-\> type your message and press Ctrl+D to send it.

  - The write command allows one user to send messages directly to
    another user’s terminal.

  - Check if Messaging is Enabled: A user can enable or disable
    receiving messages with the mesg command:

    - mesg y → enable

    - mesg n → disable

- wall Command

  - wall "System maintenance will occur at midnight. Please log out." →
    The wall (write all) command sends a message to all logged-in users.

- talk Command

  - The talk command allows interactive text-based chatting between
    users.

  - talk username → initiate a talk session

- Broadcasting Messages

  - echo "System going down for maintenance!" \> /dev/pts/10 \> Send a
    message to specific terminal. find terminal (tty) details using who

# 10. System and Service Management

## **10.1. Important Terms**

- **Application:** A software program designed to perform specific tasks
  or functions for a user. e.g., Web browsers (Firefox, Chrome), text
  editors (Vim, Nano), office suites (LibreOffice).

  - Runs in user space.

  - Provides a graphical user interface (GUI) or command-line interface
    (CLI).

  - Can be standalone or depend on other system components (like
    libraries).

- **Service:** A long-running background process that performs a
  specific function for other applications or the system itself. e.g.,
  Web server (httpd), database server (mysqld), DNS server (named).

  - Managed by the system’s **init** system (e.g., systemd, SysVinit).

  - Typically starts during system boot and runs until shutdown.

  - Does not have a direct user interface but provides functionalities
    to applications.

- **Script:** A file containing a series of commands or instructions
  executed sequentially by an interpreter. e.g., Shell scripts (.sh),
  Python scripts, Perl scripts.

  - Often used for automation and repetitive tasks.

  - Interpreted rather than compiled.

  - Can be invoked manually or scheduled (e.g., using cron).

- **Process:** An instance of a program that is executing. e.g., A
  running text editor (vim), a terminal emulator (gnome-terminal).

  - Identified by a unique **Process ID (PID)**.

  - Consists of the program code, memory, and resources required for
    execution.

  - Can spawn child processes.

- **Daemon**: A type of process that runs in the background, typically
  started at boot, and is not tied to any user session. e.g., cron (task
  scheduler), sshd (SSH server daemon).

  - Often ends with a d in its name (e.g., httpd, systemd).

  - Runs autonomously and waits to handle specific requests or events.

  - Does not have a user interface.

- **Thread:** A lightweight execution unit within a process that shares
  the same memory and resources. e.g., A web server handling multiple
  requests using threads.

  - Multiple threads can exist within a single process.

  - Threads share memory but have their own execution context (stack,
    registers).

  - Used to perform multitasking within a single application.

- **Job:** A task or command running in the shell, either in the
  foreground or background. e.g., A file copy operation running in the
  background.

  - Managed by the shell.

  - Can be listed using the jobs command.

  - Can be moved between foreground and background using fg and bg.

- **Task:** A generic term for a unit of work to be done by the system.
  e.g., Processes, threads, and jobs are all considered tasks.

  - Often used interchangeably with process or thread.

  - In the Linux kernel, tasks are a fundamental scheduling unit.

- **Program:** A set of instructions stored in a file that can be
  executed by the system. e.g., Executable files like /bin/ls,
  /usr/bin/python.

  - A program becomes a process when it is executed.

- **System Call:** A request from a program to the operating system’s
  kernel to perform a specific operation. e.g., Opening a file (open()),
  creating a process (fork()).

  - Acts as a bridge between user-space applications and the kernel.

- **Session:** A collection of processes associated with a terminal or
  remote login. e.g., A logged-in user session via SSH.

  - A session leader process manages all processes within a session.

- **Kernel Thread:** A thread managed by the Linux kernel, running in
  kernel space. e.g., Threads for I/O operations, memory management.

  - Does not run in user space.

  - Handles low-level system tasks.

- **Additional Terms:**

  - **Zombie Process**: A terminated process that hasn’t been cleaned up
    by its parent process.

  - **Orphan Process**: A process whose parent has terminated but is
    adopted by the init system.

  - **Foreground Process**: A process actively controlled by the
    terminal.

  - **Background Process**: A process running independently of the
    terminal (& operator).

  - **Shell**: The command-line interface that allows users to interact
    with the operating system.

## **10.2. systemd**

systemd is a modern system and service manager for Linux, designed to
provide better performance, scalability, and simplicity compared to
traditional init systems like **SysVinit** or **Upstart**. It is
responsible for initializing the system, managing services, and
maintaining the overall state of the operating system.

Introduced in 2010, systemd has become the default init system for most
major Linux distributions, including Ubuntu, Fedora, CentOS, and Debian.
(Note: Alpine Linux, usually used for light weight containers, uses
OpenRC instead.)

### **10.2.1. Key Features**

- **Parallel Service Startup**: Starts services concurrently to speed up
  the boot process.

- **Unit-Based Management**: Uses “units” to represent resources,
  services, devices, mount points, and more.

- **Dependency Management**: Manages dependencies between services,
  ensuring they start/stop in the correct order.

- **Socket Activation**: Starts services only when their associated
  socket is accessed, reducing resource usage.

- **On-Demand Services**: Dynamically starts services only when needed.

- **Unified Logging**: Integrates with journalctl for centralized
  logging and easier troubleshooting.

- **cgroup Integration**: Leverages Linux **control groups (cgroups)**
  for resource management and service isolation.

### **10.2.2. How systemd Works**

- **Boot Initialization**:

  - systemd is the first process executed by the Linux kernel (PID 1).

  - Reads its configuration from /etc/systemd/system/default.target

  - Initializes the system by mounting filesystems, starting services,
    and handling hardware.

- **Service Management**:

  - Manages services (e.g., nginx, sshd) and ensures they are in the
    correct state (e.g., running, stopped).

- **Unit Management**:

  - Units are the building blocks of systemd. Each unit is a
    configuration file that defines a resource or action.

### **10.2.3. Unit Types in systemd**

- **Service Units (**.service**)**: Manage system services (e.g.,
  nginx.service).

- **Target Units (**.target**)**: Group services and represent system
  states (e.g., multi-user.target for CLI or graphical.target for GUI).

- **Socket Units (**.socket**)**: Represent communication sockets,
  enabling socket-based activation.

- **Timer Units (**.timer**)**: Schedule services to run at specific
  times or intervals.

- **Device Units (**.device**)**: Represent hardware devices.

- **Mount Units (**.mount**)**: Represent and manage mounted
  filesystems.

- **Automount Units (**.automount**)**: Automatically mount filesystems
  on access.

- **Path Units (**.path**)**: Monitor filesystem paths for changes.

### **10.2.4. Important Components of systemd**

- systemctl: Command-line utility to manage systemd services and units.

- journalctl: Centralized logging system for querying system logs.

- cgroups: Resource control and isolation for processes and services.

- **Targets**: Represent system states, such as:

  - multi-user.target: Multi-user text mode.

  - graphical.target: Graphical desktop environment.

## **10.3. systemd commands**

- Manage Services

  - systemctl start \<service_name\> → start a service

  - systemctl stop \<service_name\> → stop a service

  - systemctl status \<service_name\> → check the status of a service

  - systemctl enable \<service_name\> → enable a service (start at boot)

  - systemctl is-enabled \<service_name\> → check if the service is
    enabled

  - systemctl disable \<service_name\> → disable a service (prevent
    start at boot)

  - systemctl reload \<service_name\> → reload a service configuration
    (without stopping it)

  - systemctl restart \<service_name\> → restart a service

  - systemctl mask \<service_name\> → mask a service (prevent if from
    getting started by other programs)

  - systemctl unmask \<service_name\>-\> umask a service

- Manage System State

  - systemctl reboot → reboot the system

  - systemctl poweroff →power off the system

  - systemctl halt → halt the system

  - systemctl suspend-\> suspend the system

- Target Management (System States)

  - systemctl list-units --type=target → List all available targets

  - systemctl get-default → get the current default target

  - systemctl set-default \<target\> → set a new default target

  - systemctl isolate graphical.target → switch to graphical mode

  - systemctl isolate multi-user.target → switch to multi-user target
    (non-GUI)

  - Common Targets:

    - graphical.target: Graphical desktop environment.

    - multi-user.target: Multi-user text mode.

    - rescue.target: Single-user mode for maintenance.

    - emergency.target: Minimal shell for system recovery.

- Viewing Logs

  - journalctl → view all logs

  - journalctl -u \<service_name\> → view logs for a specific service

  - journalctl -u \<service_name\> --since "1 hour ago" → view recent
    logs for a service

  - journalctl -b → viewing logs for the current boot

  - journalctl -f → follow live logs (real-time updates)

  - journalctl --since "2024-12-18 10:00:00" --until "2024-12-18
    12:00:00" → filter logs by time

- Unit Management

  - systemctl list-units → list active units

  - systemctl list-units --all → list all units including inactive and
    failed ones

  - systemctl --failed → list failed units

  - systemctl daemon-reload → reload all unit configurations (after
    editing)

- Timers and Scheduling

  - systemctl list-timers → list all active timers

  - systemctl start \<timer_name\> → start a timer unit

  - systemctl stop \<timer_name\> → stop a timer unit

- Device Management

  - systemctl list-units --type=device → list all device units

- Checking Dependencies

  - systemctl list-dependencies \<unit_name\> → show the dependency tree
    of a service

  - systemctl list-dependencies --reverse \<unit_name\> → show reverse
    dependencies

- Troubleshooting and Debugging

  - systemctl show \<service_name\> → show systemd process information

  - systemd-analyze → analyze system startup time

  - systemd-analyze blame → view a breakdown of service startup times

  - systemd-analyze critical-chain → view the critical chain during
    startup

- Advance Commands

  - systemctl kill \<service_name\> → kill a service’s process

  - systemctl reset-failed \<service_name\> → reset the failed state of
    a service

  - systemctl show-environment → reset the failed state of a service

  - systemctl set-environment VARIABLE=value → set an environment
    variable for systemd

  - systemctl unset-environment VARIABLE -. unset an environment
    variable

## **10.4. Creating a Systemd Service**

- Create a new service unit file. Systemd service configurations are
  stored as unit files, typically in the /etc/systemd/system/ directory
  for system-wide services or /etc/systemd/user/ for user-specific
  services.

- Define the service unit configuration

sudo vi /etc/systemd/system/my_service.service (Sample config below)

\[Unit\]

Description=My Python Script

After=network.target

\[Service\]

ExecStart=/usr/bin/python3 /path/to/myscript.py

WorkingDirectory=/path/to/

Restart=always

User=myuser

\[Install\]

WantedBy=multi-user.target

- sudo systemctl daemon-reload → Reload system config

- sudo systemctl enable my_service.service → enable the service
  (optional) if you want the service to start automatically when the
  system boots.

- sudo systemctl start my_service.service → start the service manually

- sudo systemctl status my_service.service → check the status of the
  service

## **10.5. Creating a Systemd Timer**

A **systemd timer** is a unit in **systemd** that allows you to schedule
tasks in a similar way to cron jobs. However, systemd timers are more
flexible and can be integrated directly with systemd services. Timers
are used to trigger services based on time intervals or specific date
and time conditions.

A systemd timer is composed of two main unit files:

### **10.5.1. Service Unit (**\*.service**)**

Defines the task or command that will be executed when the timer
triggers.

sudo vi /etc/systemd/system/myscript.service

\[Unit\]

Description=Run My Script

\[Service\]

Type=simple

ExecStart=/bin/bash /path/to/myscript.sh

### **10.5.2. Timer Unit (**\*.timer**)**

Specifies when and how often the associated service should run.

sudo vi /etc/systemd/system/myscript.timer

\[Unit\]

Description=Run My Script Daily

\[Timer\]

OnCalendar=daily

Persistent=true

\[Install\]

WantedBy=timers.target

- sudo systemctl daemon-reload → reload systemd configuration

- sudo systemctl enable myscript.timer && sudo systemctl start
  myscript.timer → enable the timer to start at boot time and start it
  immediately

- sudo systemctl status myscript.timer → verify the timer is running

**Useful Timer Directives**

Here are some useful timer directives you can use in the \[Timer\]
section:

- OnCalendar=: Specifies when the timer should be triggered, in a
  cron-like format.

- Example values:

  - OnCalendar=daily (Runs every day at midnight)

  - OnCalendar=weekly (Runs once per week)

  - OnCalendar=hourly (Runs every hour)

  - OnCalendar=Mon \*-\*-\* 12:00:00 (Runs every Monday at noon)

  - OnCalendar=2024-12-25 00:00:00 (Runs on December 25, 2024, at
    midnight)

- AccuracySec=: Defines the time precision. For example, AccuracySec=1h
  ensures that the service is triggered within one hour of the defined
  time.

- RandomizedDelaySec=: Randomizes the time when the service will start.
  Useful for spreading out workloads.

- Persistent=: Ensures the timer runs after a system reboot if the timer
  was missed.

## **10.6. Creating a Systemd Mount**

Mount filesystems automatically. Replaces /etc/fstab entries for
mounting filesystems. Automount network shares, USB drives, or specific
partitions.

sudo vi /etc/systemd/system/mnt-data.mount

\[Unit\]

Description=Mount Data Partition

After=network.target

\[Mount\]

What=/dev/sdb1

Where=/mnt/data

Type=ext4

\[Install\]

WantedBy=multi-user.target

## **10.7. Creating a Systemd Path**

Monitor file or directory changes and trigger a service. Run a service
when a file is modified, created, or deleted. Automate tasks based on
file system events.

sudo vi /etc/systemd/system/backup.path

\[Unit\]

Description=Monitor /data Directory for Changes

\[Path\]

PathChanged=/data

PathExists=/data

\[Install\]

WantedBy=multi-user.target

sudo vi /etc/systemd/system/backup.service

\[Unit\]

Description=Run Backup Script

\[Service\]

ExecStart=/bin/bash /path/to/backup.sh

## 10.8. Creating Other systemd Units

- **Creating a Systemd Swap\***

- **Creating a Systemd Automount \***

- **Creating a Systemd Slice \***

- **Creating a Systemd Socket \***

- **Creating a Systemd Target \***

- **Creating a Systemd Scope \***

- **Creating a Systemd Device \***

# 11. Process Management

## **11.1. ps Command**

**display information about currently running processes** on the system.
It stands for **“process status”** and provides details such as the
process ID (PID), the user who owns the process, CPU and memory usage,
and the command that started the process.

- ps -e or ps -A → display all processes on the system.

- ps aux → show detailed information for all processes (BSD-style
  output).

- ps -f → displays processes in full format with additional details

- ps -ef → combines full format with all processes

- ps -u username → show processes belonging to a specific user

- ps -ejH → display processes in hierarchical tree structure (useful for
  parent-child relationships)

- ps axjf → another way to view process hierarchy (BSD-style)

- ps -C \<command_name\> → shows processes matching a specific command

- ps -p PID → display information for a specific process by PID

- ps aux —sort=%cpu → sort by CPU usage (highest first)

- ps aux —sort=%mem → sort by memory usage (highest first)

| **State** | **Meaning**                                 |
|-----------|---------------------------------------------|
| R         | Running or runnable (on CPU)                |
| S         | Sleeping (waiting for an event to complete) |
| D         | Uninterruptible sleep (eg; I/O wait)        |
| T         | Stopped (by a signal or debugger)           |
| Z         | Zombie process (terminated but not reaped)  |
| I         | Idle process                                |

## **11.2. top Command**

The top command in Linux is an **interactive, real-time task manager**.
It provides a dynamic view of the system’s processes, including
information about CPU usage, memory usage, running processes, and system
load. Unlike the ps command, which provides a static snapshot, top
continuously updates its display, making it ideal for monitoring system
performance in real time.

### **11.2.1. Key Features:**

- **Real-time System Monitoring**: Displays processes and their resource
  consumption, sorted dynamically by criteria like CPU or memory usage.

- **Interactive Controls**: Allows you to modify how the data is
  displayed or interact with processes (e.g., kill processes) directly.

- **Customizable Display**: Sort by different metrics (CPU, memory,
  etc.) or show/hide specific fields.

### **11.2.2. Interactive Commands**

| **Key** | **Action**                                                 |
|---------|------------------------------------------------------------|
| h       | display help                                               |
| q       | quit top                                                   |
| P       | sort by CPU usage (default)                                |
| M       | sort by memory usage                                       |
| T       | sort by total CPU time                                     |
| k       | kill a process (you will be prompted for the PID)          |
| r       | Renice a process (change its priority; required PID input) |
| 1       | Toggle display of CPU usage per core                       |
| u       | Filter processes by user (enter the username)              |
| s       | Change update interval (default is 3 seconds)              |
| f       | Customize displayed fields                                 |
| o       | specify sorting criteria                                   |

### 11.2.3. Alternatives

- htop\*

- atop\*

- glances\*

## **11.3. kill Command**

The kill command in Linux is used to send signals to processes. These
signals can instruct processes to perform specific actions, such as
**terminating**, **pausing**, or **restarting**. Despite its name, the
kill command can do more than just terminate processes—it allows you to
send any signal supported by the system.

### **11.3.1. Commonly Used Signals**

Signals are numeric codes or names that represent specific actions.
Below are some of the most commonly used signals with kill. kill -l →
lists all all signal names or signal number

- kill PID or kill -15 PID → kill a process with default signal;
  gracefully terminate a process

- kill -9 → forcefully kill a process (cannot be ignored)

- kill -1 → restart; reload configuration files

- kill -2 → interrupt a process (like Ctrl+C)

- kill -19 → pause; stop or suspend a process

- kill -18 → resume; continue a paused process

- kill -3 → often generates a **core dump** (a file containing the
  process’s memory state at the time of termination). The core dump can
  be used for debugging to analyze why the process terminated or what it
  was doing.

### 11.3.2. Advanced Use Cases

- pkill -u username → kill all processes for a user

- pkill -9 process_name → terminate all processes with a specific name

- killall → kills the process and child processes

## **11.4. nice/renice**

The nice command in Linux is used to run a process with a specific
scheduling priority. By default, processes run with a priority of 0, but
using nice, you can adjust the **niceness** of a process, which
influences how much CPU time the process gets relative to others.

A higher niceness value makes the process more “polite,” meaning it gets
less CPU time, while a lower (or negative) value makes it more
aggressive, giving it more CPU time.

- Values range from -20 (highest priority) to 19 (lowest priority).

- Higher niceness values (e.g., 10 or 15): Process gets less CPU time.

- Lower niceness values (e.g., -5): Process gets more CPU time.

- Regular users can only set positive niceness values (0 to 19).

- Only the root user can set negative niceness values (-20 to -1).

- Examples:

  - nice -n 10 tar -czf backup.tar.gz large_folder → Runs the tar
    command with a niceness value of 10.

  - ps -eo pid,ni,cmd → use the ps command to check view the niceness
    (NI column)

  - sudo nice -n -5 ./critical_process -. run a high-priority process
    (root only)

  - renice -n 5 -p 1234 → adjusts the niceness of process with id 1234
    to 5

# 12. Scheduling Tasks

## **12.1. crontab**

The crontab command in Linux is used to manage **cron jobs**, which are
scheduled tasks that run automatically at specified times or intervals.
It allows users to edit, list, or remove the scheduling of commands or
scripts.

crontab requires the crond (crontab daemon/service) that manages
scheduling to be up and running. This can be managed using systemcl.

- systemctl status crontab → Manage crond service

### **12.1.1. Common Options**

| Option | Description |
|----|----|
| -e | Edit the current user’s crontab file |
| -l | List the current user’s crontab entries |
| -r | Remove the current user’s crontab file |
| -u user | Specify a user (requires root privileges) to manage their crontab |
| -i | Prompt for confirmation before removing a crontab file (use with -r) |

### **12.1.2. Special Strings in Crontab**

You can use predefined strings for common schedules:

- @reboot: Run once after system reboot.

- @daily; Run once a day at midnight: Equivalent Cron: 0 0 \* \* \*

- @weekly: Run once a week (Sunday at midnight). Equivalent Cron: 0 0 \*
  \* 0

- @monthly: Run once a month (1st at midnight). Equivalent Cron: 0 0 1
  \* \*

- @yearly or @annually: Run once a year (January 1 at midnight).
  Equivalent Cron: 0 0 1 1 \*

### 12.1.3. Managing Crontab

- crontab -e → Edit crontab file for the current user

- crontab -l → view the current user’s crontab

- crontab -r → remove all scheduled jobs for the current user

- sudo crontab -u username -e → edit another user’s crontab

### 12.1.4. Log and Debugging

- On most systems, cron logs are located in /var/log/cron or
  /var/log/syslog

- \* \* \* \* \* /path/to/script.sh \> /path/to/logfile 2\>&1 → redirect
  output to a file for debugging

### 12.1.5. Crontab File Format:

A crontab file consists of **fields** specifying the schedule followed
by the command to be executed:

\* \* \* \* \* /path/to/command

\- - - - -

\| \| \| \| \|

\| \| \| \| +--- Day of the week (0 - 7) \[0 and 7 both represent
Sunday\]

\| \| \| +----- Month (1 - 12)

\| \| +------- Day of the month (1 - 31)

\| +--------- Hour (0 - 23)

+----------- Minute (0 - 59)

### 12.1.6. Examples

- 0 0 \* \* \* /path/to/script.sh → run a script every day at midnight

- 0 \* \* \* \* /path/to/command → every hour

- 30 8 \* \* 1 /path/to/script.sh → every Monday at 8:30AM

- \*/15 \* \* \* \* /path/to/command → every 15 minutes

- 0 0 \* 6 \* /path/to/script.sh → only in June

- 0 9 \* \* \* command1 && command2 → Run multiple commands

## **12.2. at**

The at command in Linux is used to schedule one-time tasks to be
executed at a specific time in the future. Unlike **cron**, which is
used for recurring tasks, at is ideal for scheduling jobs that need to
run only once. at requires the atd (at daemon/service) that manages task
scheduling to be up and running. This can be managed using systemcl.

- at 3pm → schedule a task. This opens an interactive shell where you
  can type the commands to execute. eg:

  - echo "Hello World" \> /tmp/helloworld.txt press Ctrl+D to save and
    exit.

  - The task will now now execute at 3PM.

- at -f /path/to/commands.txt 5pm → You can specify commands in a file

- atq → list all pending jobs

- atrm \<id\> → remoev a job by its id

- Time Formats:

  - Exact time: at 14:30 → Run at 2:30 PM (24-hour format).

  - AM/PM format: at 3pm → Run at 3 PM.

  - Relative time: at now + 1 hour → Run 1 hour from now.

  - Date and time: at 8:00 AM tomorrow → Run tomorrow at 8:00 AM.

  - Specific date: at 12:00 12/25/2024 → Run on December 25, 2024, at
    12:00 PM.

- Logfile: /var/log/at.log

## **12.3. anacron**

used for scheduling and running jobs periodically. It is similar to cron
but designed to handle scenarios where the system might not be running
continuously. Unlike cron, which is meant for systems that are expected
to be online at all times, anacron is ideal for desktops, laptops, or
other devices that may be powered off for extended periods.

### **12.3.1. Key Features of Anacron**

- **Resilient to Downtime**: Ensures periodic jobs are executed even if
  the system was off or down at the scheduled time.

- **Runs Jobs Once per Interval**: Executes jobs at the first available
  opportunity after the missed interval.

- **Time Units**: Supports daily, weekly, and monthly schedules.

- **Non-Root Usage**: Can be configured to run user-specific tasks.

Anacron uses **time-stamped files** to track when a job was last
executed. If the scheduled interval has passed since the last execution,
the job is run. Job definitions in /etc/cron.{daily,weekly,monthly} are
often executed by Anacron.

\# /etc/anacrontab: configuration file for anacron

\# Format: period delay job-identifier command

1 5 cron.daily run-parts /etc/cron.daily

7 10 cron.weekly run-parts /etc/cron.weekly

30 15 cron.monthly run-parts /etc/cron.monthly

-

- Common Use Cases:

  - daily backups on laptops

  - weekly maintenance tasks

- anacron -s → manually invoke all anacron and run all due jobs.

- anacron -n → run a specific job immediately

- Logfile: /var/log/syslog

# 13. Shell

A **shell** is a command-line interface (CLI) or command interpreter in
Linux and Unix-like operating systems. It allows users to interact with
the operating system by entering commands, executing programs, and
managing system tasks.

The shell is both an interface and a scripting environment, making it a
critical part of Linux/Unix systems. It acts as a layer between the user
and the kernel, translating user inputs into actions performed by the
operating system.

## **13.1. Types of Shells**

- **Bourne Shell (sh)**:

  - The original Unix shell developed by Stephen Bourne.

  - Simple, lightweight, and foundational for scripting.

- **Bash (Bourne Again Shell)**:

  - An improved version of the Bourne shell, offering additional
    features like command history and tab completion.

  - Default shell on most Linux distributions.

- **C Shell (csh)**:

  - Syntax resembles the C programming language.

  - Adds features like aliases and job control.

- **Korn Shell (ksh)**:

  - Combines features of the Bourne and C shells.

  - Known for its scripting capabilities.

- **Z Shell (zsh)**:

  - An advanced shell with powerful features like better autocompletion,
    plugins, and theming.

  - Popular among developers due to its flexibility.

- **Fish (Friendly Interactive Shell)**:

  - A user-friendly and modern shell with interactive features.

  - Includes syntax highlighting and autosuggestions.

## **13.2. Key Features**

- **Command Execution**: Allows users to run programs or scripts
  directly by typing commands.

- **Scripting**: Supports writing and running shell scripts to automate
  repetitive tasks.

- **Input/Output Redirection**: Redirects input/output streams using
  operators like \>, \<, and \|.

- **Environment Management**: Manages environment variables and system
  settings.

- **Job Control**: Allows background/foreground execution and monitoring
  of tasks.

- **History**: Keeps a history of previously executed commands for easy
  reuse.

- **Customizability**: Users can configure shells with aliases,
  functions, and startup scripts (e.g., .bashrc or .zshrc).

## **13.3. How a Shell Works**

- **User Input**: The user enters a command.

- **Parsing**: The shell parses the command and interprets its meaning.

- **Execution**: The shell executes the command by invoking the
  appropriate program or utility.

- **Output**: Displays the result or output of the command on the
  screen.

## 13.4. Useful Commands

- echo \$0 or echo \$SHELL→ find your current shell

- cat /etc/passwd \| grep username → find your default shell

- cat /etc/shells → list available shells

## 13.5. Shell Scripting

**Shell scripting** is the process of writing and executing a series of
commands in a script file to automate tasks on a Linux/Unix-based
system. The file, typically written in a shell language (like Bash or
Zsh), is executed by the shell. Shell scripting is widely used for
system administration, task automation, and application deployment.

### **13.5.1. Why Use Shell Scripting?**

- **Task Automation**: Automates repetitive tasks like backups, file
  management, and monitoring.

- **Efficiency**: Reduces manual errors and speeds up execution.

- **Flexibility**: Supports conditional logic, loops, and external tool
  integration.

- **System Administration**: Essential for managing Linux systems,
  creating cron jobs, and monitoring services.

### **13.5.2. Basic Structure of a Shell Script**

- Shebang(#!):

  - Indicates which shell to use for interpreting the script

  - Example for Bash: \#!/bin/bash

- Commands

  - A sequence of shell commands executed in order

- Comments

  - Begin with \# and are not executed

- Variables

  - Store data for reuse in the script

### 13.5.3. Key Concepts

- Variables

- num=10

> echo "The number is \$num"

- Input/Output

- read name

> echo "Welcome, \$name!"

- if/then/else

- if \[ \$num -gt 5 \]; then

- echo "Greater than 5"

- else

- echo "Less or equal to 5"

> fi

- for loop

  - iterating over a fixed range

  - for i in {1..5}; do

  - echo "Iteration: \$i"

> done

- iterating over a list

- for fruit in Apple Banana Cherry; do

- echo "I like \$fruit"

> done

- using a command’s output

- \#!/bin/bash

- for file in \$(ls \*.txt); do

- echo "Processing \$file"

> done

- iterating over an array

- fruits=("Apple" "Banana" "Cherry")

- for fruit in "\${fruits\[@\]}"; do

- echo "I like \$fruit"

> done

- loop through files in a directory

- for file in \*.txt; do

- echo "Found file: \$file"

> done

- loop using C-style syntax

- for ((i = 1; i \<= 5; i++)); do

- echo "C-style Loop: \$i"

> done

- while loop

  - simple counter

  - count=1

  - while \[ \$count -le 5 \]; do

  - echo "Count: \$count"

  - ((count++)) \# Increment the counter

> done

- reading a file line by line

- while read -r line; do

- echo "Line: \$line"

> done \< myfile.txt

- until loop

  - increment until a condition is met

  - count=1

  - until \[ \$count -gt 5 \]; do

  - echo "Count: \$count"

  - ((count++)) \# Increment the counter

> done

- functions

- greet() {

- echo "Hello, \$1!"

- }

> greet "Alice"

- command substitution

- current_date=\$(date)

> echo "Today is \$current_date"

- error handling

  - set -e command enables a behavior where the script will **exit
    immediately if any command returns a non-zero exit status**
    (indicating failure), unless that command is part of a condition.
    This can be particularly useful to prevent the script from
    continuing execution after encountering an error, which might lead
    to unintended or harmful actions.

  - \#!/bin/bash

  -

  - set -e

  -

  - echo "Step 1: Success"

  - ls /nonexistent-directory \# This command fails and stops the script

> echo "Step 2: This will not run"

- positional parameters

  - \$1,\$2, etc., represent script arguments

  - \$#: Number of arguments

- echo "First argument: \$1"

> echo "Total arguments: \$#"

- exit status:

  - \$?: captures the exit status of the last command

  - 0: Success, non-zero: Failure.

- Environment Variables:

  - Access system variables like \$PATH, \$HOME, and \$USER

- Arrays

  - Store multiple values in a single variable

- fruits=("Apple" "Banana" "Cherry")

> echo "\${fruits\[1\]}" \# Banana

- Case Statements

  - multi-branch decision making

- case \$day in

- Mon) echo "Start of the week" ;;

- Fri) echo "Weekend is near" ;;

- \*) echo "Midweek" ;;

> esac

## 13.6. Aliases

An **alias** is a shortcut to a command or a series of commands in
Linux. Aliases allow you to simplify and customize frequently used
commands, making them shorter or easier to remember.

### 13.6.1. Types of Aliases

- Temporary Aliases:

  - These aliases exist only for the duration of the current shell
    session.

  - alias ll='ls -la --color=auto'

  - alias update='sudo apt update && sudo apt upgrade -y'

- Permanent Aliases:

  - These aliases persist across sessions

  - Defined in shell configuration files like ~/.bashrc, ~/.zshrc, or
    /etc/bash.bashrc.

### 13.6.2. Useful Commands

- alias → lists the currently defined aliases

- source ~/.bashrc → reload the file to activate changes in bash

- source ~/.zshrc → reload the file to activate changes in zsh

## 13.7. Managing Jobs in a Shell

**Ctrl+Z, bg, fg, jobs, nohup, disown**

The Ctrl+Z, bg, and fg commands in Linux are used for managing jobs in
the shell. They allow you to pause, background, or bring jobs to the
foreground during a terminal session.

### **13.7.1. Ctlr+Z**

Suspends (pauses) the currently running process in the terminal and
places it in the background in a **stopped** state. Press Ctrl+Z while a
command is running interactively in the foreground.

- long_running_command and press Ctrl+Z will suspend the task and bring
  back the terminal

### **13.7.2. jobs**

- jobs → see all jobs managed by the current shell

- **Job States:**

  - **Running**: The job is executing in the background.

  - **Stopped**: The job is paused (e.g., by Ctrl+Z).

- **Job IDs**

  - Each job has a unique **job ID**, displayed as \[n\].

  - Use the job ID with bg or fg to manipulate specific jobs.

- kill %\<ID\> → use the job id to terminate a job by the job id

### **13.7.3. bg (Background)**

Resumes a suspended process and runs it in the background, allowing you
to continue using the terminal for other tasks.

- bg sends the job to the background.

- bg %\<ID\> → background a job by job id

- long_running_command 100 & → run a command directly in the background
  by appending & in the end

### **13.7.4. fg (Foreground)**

Brings a background job to the foreground, allowing you to interact with
it directly. If no job ID is specified, the most recent job is brought
to the foreground.

- fg %\<ID\> bring the specified job to the foreground.

### **13.7.5. nohup**

If you simply send a job to the background using bg or start it with &,
the job is **terminated** when the shell is closed. This is because the
job is tied to the shell session, and closing the shell sends a **SIGHUP
(Hangup)** signal to all child processes. If a background job is
disassociated from the shell using tools like nohup, it will continue
running even after the shell is closed. The nohup command prevents the
**SIGHUP** signal from being sent to the process.

- nohup long_running_command & → process is not terminated when you log
  out or close the terminal.

- nohup long_running_command \> output.log 2\>&1 & → Standard output and
  standard error are redirected to a file (nohup.out) by default, unless
  explicitly redirected by the user.

- TIps: For more interactive control, use tmux or screen

### **13.7.6. disown**

The disown command in Linux is used to remove a job from the shell’s job
table, effectively disassociating it from the shell. This means that the
job will no longer be tied to the shell, and it won’t be terminated when
the shell is closed or the user logs out.

- disown %\<ID\> → The job will continue running after the shell is
  closed

- disown -a → disown all background jobs; removes all jobs from the
  shell’s job table.

- disown -h %\<ID\> → protects a job from SIGHUP without removing it;
  the job remains in the job table but will not terminate when the shell
  exits

- disown -r → disown only the running jobs (not stopped jobs)

### **13.7.7. nohup vs. disown**

- nohup:

  - Used at the time of starting a process.

  - Prevents a process from receiving SIGHUP by default.

  - Automatically redirects output to a file (nohup.out).

- disown:

  - Used after a job is already running.

  - Removes the process from the shell’s job table, optionally marking
    it immune to SIGHUP.

# 14. Terminal

The **terminal** is the **interface** that provides a way for users to
interact with the system. Historically, it referred to **physical
devices** (like teletypewriters), but now it generally means
**software-based terminal emulators**.

## **14.1. tty vs pts**

In Linux, tty and pts refer to types of terminal devices. These
represent interfaces through which a user interacts with the system.
Understanding the difference between the two is crucial in comprehending
how Linux handles terminals and sessions.

- tty:

  - tty stands for **Teletypewriter**. It originally referred to
    physical terminal devices connected to a computer. In modern
    systems, tty typically refers to **virtual consoles** or **directly
    connected terminals**.

  - Associated with physical or virtual console terminals.

  - You can switch between virtual consoles using Ctrl + Alt + F1 **to**
    Ctrl + Alt + F6 (on most systems).

  - Each virtual console corresponds to a tty **device**, such as
    /dev/tty1, /dev/tty2, etc.

- pts

  - pts stands for **Pseudo-Terminal Slave**. It refers to **virtual
    terminals** created by terminal emulators (e.g., GNOME Terminal,
    xterm, SSH sessions). A pseudo-terminal consists of two parts:

    - **Master**: Controls the terminal session.

    - **Slave**: Interacts with the user’s shell or process.

  - Created dynamically when a user opens a terminal emulator or remote
    session

  - Found in /dev/pts/ (e.g., /dev/pts/0, /dev/pts/1).

  - Commonly used for:

    - Graphical terminal emulators.

    - SSH or telnet sessions.

    - Screen or tmux sessions.

**Commands**

- tty → command to identify the current terminal

  - “tty1” is for a virtual console.

  - “pts/0” for a terminal emulator or SSH session.

- ls /dev/tty\* → List active tty connections

- ls /dev/pts/\* → List active pts connections

# 15. File System

A **file system** is a method and data structure that an operating
system uses to manage, organize, store, and retrieve data on a storage
device such as a hard disk, SSD, or USB drive. It provides a way to
manage files, directories, and their metadata (permissions, timestamps,
etc.).

File systems define how data is stored on the storage medium and how it
is retrieved. Without a file system, data would be stored in a
continuous block, making it nearly impossible to differentiate one piece
of data from another.

## **15.1. Native File Systems**

These are file systems developed specifically for Linux.

### 15.1.1. Ext2

- Second Extended File System - One of the earliest Linux file systems.

- Does not support journaling.

- Faster for small devices or environments where journaling is
  unnecessary.

### 15.1.2. Ext3

- Third Extended File System - Adds journaling to Ext2, making it more
  reliable.

- Journaling reduces the risk of file system corruption during crashes
  or power failures.

- Fully backward-compatible with Ext2.

### 15.1.3. Ext4

- Fourth Extended File System - Improved version of Ext3.

- Supports larger file sizes (up to 16 TB) and volumes.

- Faster performance with features like delayed allocation and extents.

### 15.1.4. XFS

- High-performance journaling file system.

- Excellent for large-scale storage and large files.

- Designed for parallel I/O operations.

### 15.1.5. Btrfs

- B-Tree File System - A modern file system focusing on fault tolerance,
  repair, and scalability.

- Features include snapshots, compression, and subvolumes.

- Still under development but increasingly used.

### 15.1.6. ReiserFS

- Designed for smaller files and faster access times.

- Journaling support.

- Declined in popularity due to limited updates.

### 15.1.7. swap

- Swap provides extra memory when the RAM is full.

- Swap is used to store the contents of RAM when a system goes into
  hibernation.

- Prevents applications from crashing when the system runs out of RAM.

## 15.2. Virtual File Systems

### 15.2.1. tmpfs

- Files in tmpfs are stored in volatile memory (RAM), making it much
  faster than disk storage.

- It can also use swap space if memory is full.

- The size of a tmpfs filesystem can dynamically grow or shrink based on
  the files stored in it.

- It has an upper limit, typically set as a percentage of available RAM.

- Data is non-persistent and disappears when the system is rebooted or
  the filesystem is unmounted.

- Used for temporary files such as /tmp, /run, or /var/lock.

- Often used to improve performance by avoiding slow disk I/O for
  temporary data.

### 15.2.2. devtmpfs

- special filesystem used to manage device nodes in the /dev directory.

- provides a dynamic and efficient way to populate /dev with device
  files (special files) automatically during system boot or when new
  devices are added.

- devtmpfs is entirely managed by the kernel and does not require
  user-space tools like udev to create device nodes.

- It works in tandem with udev, which can further manage permissions and
  symbolic links.

### 15.2.3. efivarfs

- efivarfs (EFI Variable Filesystem) is a special filesystem used to
  expose UEFI (Unified Extensible Firmware Interface) variables to user
  space.

- It is mounted at /sys/firmware/efi/efivars and provides a standardized
  way to interact with UEFI firmware settings.

- Provides a way to list, read, and write UEFI variables such as boot
  order, Secure Boot configuration, and hardware information.

- Each UEFI variable is represented as a file within this filesystem.

- UEFI variables can be manipulated using standard file operations,
  provided the kernel and hardware support it.

- Often used to manage Secure Boot settings, such as enrolling new keys
  or modifying boot configurations.

## **15.3. Network File Systems**

Used to access files over a network.

### 15.3.1. NFS

- Network File System - Allows remote file sharing between systems over
  a network.

- Common in server environments.

### 15.3.2. Samba (CIFS/SMB)

- Provides file sharing between Linux and Windows systems.

- Based on the SMB protocol.

## **15.4. Non-Native File Systems (Foreign File Systems)**

Linux supports file systems from other operating systems

### 15.4.1. FAT32 (vfat):

- Common on USB drives, SD cards, and older Windows systems.

- Limitation: File size up to 4 GB and volume size up to 8 TB.

- Linux Driver: vfat.

### 15.4.2. exFAT:

- Designed for flash storage with no 4 GB file size limit.

- Widely used on SDXC cards and modern USB drives.

- Linux Driver: exfat or kernel-native exfat module (since Linux 5.4).

### 15.4.3. HFS (Hierarchical File System):

- Legacy macOS file system.

- Linux Driver: hfs.

### 15.4.4. HFS+ (HFS Plus):

- Main file system for macOS before APFS.

- Linux Driver: hfsplus.

### 15.4.5. APFS (Apple File System):

- Current macOS file system, designed for SSDs.

- Linux Support: Experimental read-only support via third-party tools
  (e.g., apfs-fuse or apfsprogs).

# 16. Disk Management

## **16.1. du Command**

The du command in Linux is used to estimate and display the disk space
usage of files and directories. Unlike the df command, which reports
usage at the file system level, du provides detailed information about
individual files and directories.

Running du without any options displays the disk usage of all
directories and subdirectories starting from the current directory.

**Options**

- du -h → display sizes in a human-readable format (eg: KB, MB, GB, TB)

- du -s → show the total size of a directory or file, suppressing
  detailed output.

- du -c → display a grand total at the end

- du -a → show sizes for all, not just directories

- du -d N or du —max-depth=N → limit the output to N levels of
  subdirectories

- du --exclude=PATTERN → exclude files matching a specific pattern

**Common Use Cases**

- du -h --max-depth=1 --exclude="./Library" \| sort -h → identify large
  directories

- du -sh -- .\[^.\]\* \* \| sort -rh → sort by size \* (TBC)

- du -sh /var/log → analysing specific directory

- du -h --exclude='/tmp/\*' → exclude temp files like cache

## **16.2. df Command**

The df command in Linux is used to report the amount of disk space
available on file systems. It displays information about the total
space, used space, and available space for each mounted file system.

**Key Columns in the Output**

| Column     | Description                                                |
|------------|------------------------------------------------------------|
| Filesystem | The name of the mounted file system                        |
| 1K-blocks  | Total size of the file system in 1KB blocks (default unit) |
| Used       | Disk space currently in use                                |
| Available  | Disk spaec available for use                               |
| Use %      | Percentage of disk space used                              |
| Mounted on | Mount point of the file system                             |

Options

- df -h → display sizes in a human-readable format (eg: KB, MB, GB, TB)

- df -T → show the file system type (eg: ext4, xfs)

- df -i → display inode usage instead of block usage

- df -l show only local file systems (exclude network file systems)

- df --total → display a total line summarising all file systems

- df -x → exclude specific file system types (eg: eg; tmpfs, nfs)

- df -t → show only specific file system types

Useful Commands

- df -hTl --total -xtmpfs -xfuse.prl_fsd -xdevtmpfs -xefivarfs → exclude
  in memory filesystems

## **16.3. fdisk Command**

The fdisk command is a powerful disk partitioning tool in Linux. It is
used to create, modify, delete, and manage disk partitions on a system.
It supports a variety of partition table formats, including the MBR
(Master Boot Record) and GPT (GUID Partition Table).

> **⚠️ DANGER WARNING:**
> - Modifying partitions can result in complete data loss
> - ALWAYS backup data before using fdisk
> - Writing changes (w command) is permanent and immediate
> - Wrong partition changes can make your system unbootable
> - Verify device names with `lsblk` before proceeding

**Common Uses**

- Viewing the partition table of a disk.

- Creating new partitions.

- Deleting existing partitions.

- Changing partition types.

- Writing changes to the disk.

**Basic Commands within fdisk Interactive Mode**

Once you enter the interactive mode by running fdisk /dev/sdX (where
/dev/sdX is your disk), you can use the following commands:

- m → Display help menu.

- p → Print the current partition table.

- n → Create a new partition.

- d → Delete a partition.

- t → Change the partition type (e.g., Linux, swap).

- w → Write changes to disk and exit.

- q → Quit without saving changes.

**Precautions**

- Always back up your data before making changes to disk partitions.

- fdisk primarily supports MBR partition tables. For GPT partitioned
  disks, use tools like gdisk or parted.

- Modifications with fdisk are destructive if done incorrectly, as they
  can result in data loss.

## **16.4. mkfs Command**

The mkfs (Make File System) command is used to create a new file system
on a storage device or partition in Linux. A file system is essential
for organizing and storing data on a disk. The mkfs command allows you
to specify the type of file system you want to create (e.g., ext4, xfs,
btrfs). syntax: mkfs \[options\] \<device\> . Alternatively, mkfs can
act as a frontend to specific file system creation commands: mkfs.ext4,
mkfs.xfs , mkfs.vfat, etc.

> **⚠️ DANGER WARNING:**
> - `mkfs` ERASES ALL DATA on the target device
> - This operation is irreversible - destroyed data cannot be recovered
> - ALWAYS verify the device name with `lsblk` before running
> - Creating a filesystem on the wrong device can destroy your OS
> - Never run mkfs on a mounted filesystem

**Examples:**

- mkfs.ext4 /dev/sdX1 → create an ext4 file system on /dev/sdX1

- mkfs.xfs /dev/sdX1 → create an xfs file system

- mkfs.vfat -F 32 /dev/sdX1 → format a USB drive with FAT32

- mkswap /dev/sdX2 → format and setup swap space

**Options**:

- t \<type\> → Specify the type of file system to create.

- -c → Check the device for bad blocks before formatting.

- -L \<label\> → Set a volume label for the file system.

- -n \<name\> → Set the file system name (for certain types).

- -b \<block-size\> → Specify block size for the file system.

**Key Points**

- mkfs command effectively formats the partition as part of the process
  of creating a file system.

- mkfs is executed, it:

  - Erases the existing file system metadata,

  - Writes the new file system’s data structures (e.g., superblocks,
    inodes, directories).

  - Prepares the storage device for storing files in the specified file
    system format.

- Data Erasure:

  - The command doesn’t explicitly wipe all data but overwrites the
    metadata structures of the existing file system.

  - The actual file data may still exist on the disk until overwritten
    but becomes inaccessible unless recovered with specialized tools.

- Explicit Formatting Tools:

  - While mkfs creates the file system, commands like wipefs or dd can
    be used to erase data completely before running mkfs, ensuring no
    residual data remains.

- Partitioning vs. Formatting:

  - Partitioning: Performed using tools like fdisk, parted, or gparted
    to define storage layout.

  - Formatting: Involves creating a file system on a partition using
    mkfs.

## 16.5. lsblk Command

list information about block devices on your system. Block devices are
storage devices like hard drives, SSDs, optical drives, and USB drives.
This command displays details such as device names, mount points, sizes,
and file system types.

- Displays information about block devices in a tree-like format.

- Shows mount points, file systems, and device hierarchy.

- Excludes non-storage devices like loop devices by default.

- Helps identify storage layouts and attached drives.

Examples

- lsblk → Displays a tree of block devices and partitions.

- lsblk -f → Displays file system information like UUID, type, and mount
  points.

- lsblk -a → Shows all devices, including empty devices.

- lsblk -p → Displays full paths to devices (e.g., /dev/sda).

- lsblk -o NAME,SIZE,TYPE → Displays only the device name, size, and
  type.

- lsblk -J → Displays block device details in JSON format.

- lsblk -x SIZE → Sorts the output by device size.

## 16.6. blkid Command

used to locate and display attributes of block devices on the system. It
is particularly useful for identifying file systems, UUIDs (Universally
Unique Identifiers), and labels of partitions or storage devices.

- Identifies file system types of block devices.

- Retrieves UUIDs and labels of partitions.

- Useful for tasks like editing /etc/fstab or troubleshooting storage
  issues.

- Supports reading and caching of device metadata.

Examples:

- blkid → Displays all block devices along with their attributes.

- blkid /dev/sda1 → Retrieves details about the partition /dev/sda1.

- blkid -U "123e4567-e89b-12d3-a456-426614174000" → Locates the device
  with the specified UUID.

- blkid -L "mydata" → Locates the device with the label mydata.

- blkid -s TYPE → Outputs the file system type of each device.

- blkid -o json → Displays block device details in JSON format.

- blkid -p /dev/sda1 → Probes the device /dev/sda1 for information
  without using the cache.

- blkid -t TYPE=ext4 → Lists all devices with the file system type ext4.

Use Cases:

- Editing /etc/fstab: Use blkid to retrieve UUIDs or labels to create
  persistent mount entries in /etc/fstab.

- Disk Management: Identify file systems on attached devices during
  troubleshooting or configuration.

- Script Automation: Automate device detection based on file system
  types, UUIDs, or labels.

## 16.7. fsck Command

The fsck (File System Consistency Check) command is a tool used in Linux
and other Unix-like operating systems to check and repair file system
integrity. It ensures that the file system on a storage device (such as
a hard disk or SSD) is consistent and free of errors.

- Detects File System Issues: Finds corrupted file system structures,
  missing inodes, or orphaned blocks.

- Repairs File System Errors: Attempts to fix inconsistencies, such as
  misplaced metadata or broken links.

- Works with Various File Systems: Supports ext2, ext3, ext4, and others
  via specific file system check utilities.

- Automated Checks: Automatically runs during system boot if the system
  detects file system issues

Common Options

- -A: Check all file systems listed in /etc/fstab.

- -C: Show progress of the check.

- -N: Show what fsck would do without making changes.

- -P: Check file systems in parallel (with -A).

- -R: Skip the root file system (used with -A).

- -V: Display verbose output.

- -y: Automatically answer “yes” to prompts.

- -n: Automatically answer “no” to prompts (read-only mode).

Examples:

- sudo fsck /dev/sdXn → Check and repair a specific partition

- sudo fsck -A → check all file systems

- sudo fsck -n /dev/sdXn → non-intrusive check

- sudo fsck -f -y /dev/sdXn → force check and repair

When to Use fsck

- Unclean Shutdown: If the system was powered off abruptly or a drive
  was improperly unmounted.

- Boot Failures: If the system fails to boot due to file system
  corruption.

- Performance Issues: If access to files or directories becomes
  unusually slow.

- Manual Checks: For periodic maintenance or after errors are reported
  in logs.

Important Notes

- Unmount File Systems: Always unmount a file system before running fsck
  to prevent further corruption.

- Check Root File System: You can’t unmount the root file system while
  the system is running. Instead:

  - Boot into single-user mode or a live CD/USB.

  - Run fsck on the unmounted root file system.

- Automatic Boot-Time Check: fsck runs automatically during boot if:

  - A file system is marked as dirty.

  - A certain number of mounts have occurred (configurable via tune2fs).

**Force fsck at boot time**

- sudo tune2fs -C 100 /dev/sdXn → -C 100: Sets the mount count to a
  value exceeding the maximum allowed mount count, forcing a check.

- sudo tune2fs -E force_fsck /dev/sdXn → -E force_fsck: Explicitly sets
  the file system to require a check.

- sudo shutdown -rF now → -F: Forces an fsck check on all file systems
  during reboot.

- sudo touch /forcefsck → The presence of /forcefsck triggers fsck for
  all file systems during the next reboot.

- Interrupt the bootloader (usually by pressing Esc or Shift during
  boot) and edit the boot command line to append fsck.mode=force and
  fsck.repair=yes to the kernel parameters.

- sudo dmesg \| grep fsck → After the reboot, check the logs to confirm
  fsck was run.

Note: For non-ext file systems like XFS or Btrfs, fsck doesn’t work as
expected. Use their respective tools:

- XFS: Use xfs_repair.

- Btrfs: Use btrfs check.

## **16.8. dd Command**

The dd command in Linux is a powerful and versatile tool for copying and
converting data at the block level. It is commonly used for tasks like
creating disk images, making backups, cloning disks or partitions, and
manipulating raw data.

> **⚠️ EXTREME DANGER WARNING:**
> - `dd` is nicknamed "disk destroyer" for a reason
> - Swapping `if` and `of` parameters can wipe your entire disk
> - There is NO confirmation prompt - it executes immediately
> - ALWAYS verify device names with `lsblk` before running
> - One typo can destroy all your data irreversibly
> - NEVER run `dd` commands without understanding them completely

**Basic Syntax**

- dd if=\<input_file\> of=\<output_file\> \[options\]

- if= Specifies the input file or device (e.g., a disk, partition, or
  file).

- of= Specifies the output file or device.

**Common Use Cases**

- sudo dd if=/dev/sda of=/path/to/disk_image.img bs=4M status=progress →
  Create an exact copy (image) of a disk

  - /dev/sda: Input device (e.g., a disk).

  - /path/to/disk_image.img: Output file (disk image).

  - bs=BLOCK_SIZE: Specifies the block size (e.g., bs=1M for 1 megabyte
    blocks). Larger block sizes improve performance but may require more
    memory.

  - status=progress: Shows progress during the operation.

- sudo dd if=/path/to/disk_image.img of=/dev/sda bs=4M status=progress →
  Restore a disk image to a disk or partition:

- sudo dd if=/dev/sda of=/dev/sdb bs=4M status=progress →

  - /dev/sda: Source disk/partition.

  - /dev/sdb: Destination disk/partition.

- sudo dd if=/path/to/iso_image.iso of=/dev/sdX bs=4M status=progress →
  Copy an ISO image to a USB drive (e.g., for creating a bootable
  installation media):

  - /path/to/iso_image.iso: Path to the ISO file.

  - /dev/sdX: USB drive (replace X with the correct letter).

- sudo dd if=/dev/zero of=/dev/sdX bs=1M status=progress → Write zeros
  to an entire disk to wipe data:

  - /dev/zero: A special device that produces zeroes.

- sudo dd if=/dev/zero of=/dev/sda bs=1M count=1000 oflag=direct →
  Perform a speed test on a disk

  - count=1000: Specifies the number of blocks to write.

  - oflag=direct: Uses direct I/O for better performance.

- sudo dd if=/dev/sda1 of=/dev/sdb1 bs=64K status=progress → copy data
  from one partition to another

- sudo dd if=/dev/sda \| gzip \> /path/to/disk_image.gz → make a disk
  image and compress it

- dd if=/dev/zero of=zeroed_file.txt bs=1M count=100 → create a zeroed
  file

**Caution**

- dd can overwrite data if misused. Be very careful when specifying if
  and of options, especially with devices (/dev/sda vs /dev/sdb).

- Without the status=progress option, dd doesn’t provide feedback, so it
  may seem like the command isn’t doing anything.

- For large files or disk operations, dd may take a long time,
  especially with smaller block sizes.

## 16.9. wipefs

clear or display file system signatures (magic strings) from devices.
This command does not erase the actual data on the device but removes
the metadata that identifies a file system, making it appear as though
no file system is present.

- View existing file system signatures on a device.

- Clear specific or all file system signatures from a device.

- Prevents accidental overwriting of important file systems by enabling
  signature management.

**Examples:**

- wipefs /dev/sda1 → Lists all existing file system signatures on
  /dev/sda1.

- wipefs -a /dev/sda1 → Erases all file system signatures on /dev/sda1.

- wipefs -o 0x438 /dev/sda1 → Removes the file system signature at
  offset 0x438 on /dev/sda1.

- wipefs -a -n /dev/sda1 → Displays what would be removed but does not
  perform any operation.

- wipefs -a -f /dev/sda1 → Removes all file system signatures, even if
  the device is in use or mounted (use cautiously).

**Use Cases**

- Remove old file system signatures to prepare a device for new
  partitions or file systems.

- Clear conflicting file system metadata when creating new partitions.

- Make a device appear as though it has no file system for testing or
  reinitialization.

**Notes**

- Removing file system signatures with wipefs does not delete the actual
  data on the disk. However, access to the data may become difficult or
  impossible without the file system metadata.

- Always use caution when running wipefs -a or -f on important devices.

- Superuser privileges are required to run wipefs. Use sudo if
  necessary.

## 16.10. mount Command

used to attach (mount) a file system to a directory in the system’s
directory tree. A mounted file system allows the operating system and
users to access its files. The opposite action, detaching the file
system, is called unmounting (done with the umount command).

- Mount local storage devices, such as hard drives, SSDs, and USBs.

- Mount remote file systems, such as NFS or Samba shares.

- Attach specific file systems like ISO images or network drives.

- View currently mounted file systems.

**Useful Commands**

- mount → Displays all currently mounted file systems.

- cat /proc/mounts → Another way to display all currently mounted file
  systems.

- sudo mount /dev/sda1 /mnt → Mounts the device /dev/sda1 to the /mnt
  directory.

- sudo mount -t ext4 /dev/sda1 /mnt → specify a file sytem type

- sudo mount -o loop file.iso /mnt → mount an ISO image

- sudo mount -o ro /dev/sda1 /mnt → read-only mount

- sudo mount -t nfs 192.168.1.100:/shared /mnt → mount a remote file
  system (NFS)

- sudo umount /mnt → to detach a file system, use the umount command

- lsof +D /mnt → if the device is busy, find the blocking process

## 16.11. fstab

“File System Table” /etc/fstab is a configuration file in Linux that
contains information about file systems and how they should be mounted.
It is consulted during boot to automatically mount file systems.

- Specifies file systems to mount at boot.

- Simplifies the use of mount for manual mounts by predefining file
  system details.

- Ensures consistent mounting behavior across reboots.

**Structure and Format**

- File System: Device or remote file system to mount (e.g., /dev/sda1,
  UUID, LABEL, or network path).

- Mount Point: Directory where the file system will be mounted (e.g., /,
  /mnt/data).

- File System Type: Type of file system (e.g., ext4, xfs, vfat, nfs,
  swap).

- Options: Mount options (e.g., defaults, ro, noexec). Multiple options
  are comma-separated.

- Dump: Used by the dump utility. 1 enables backup; 0 disables it.

- Pass: Determines the order in which fsck checks the file system. 0
  disables checking; 1 is for root; 2 is for others.

Example /etc/fstab

\# \<file system\> \<mount point\> \<type\> \<options\> \<dump\>
\<pass\>

UUID=12345-6789 / ext4 defaults 1 1

/dev/sda2 /home ext4 defaults,noatime 1 2

/dev/sdb1 /mnt/data xfs defaults 0 0

/dev/sr0 /media/cdrom iso9660 ro,noauto 0 0

tmpfs /tmp tmpfs defaults,noexec 0 0

# 17. System Information

## **17.1. dmesg Command**

The dmesg command in Linux is used to display system messages and kernel
ring buffer information. These messages include hardware-related events,
kernel warnings, driver updates, and other low-level system activities,
making it a critical tool for troubleshooting hardware and
kernel-related issues.

- dmesg -HT → outputs the current kernel message buffer in a
  human-readable paginated format

- dmesg --level=LEVEL → Filters messages by severity level (eg: emerg,
  alert, info)

- dmesg --fascility=FACILITY → Filters messages by facility (eg: kernel,
  user, daemon)

**Common Use Cases**

- dmesg \| grep -i usb → check hardware detection after plugging a usb
  device

- dmesg \| less → review system messages from the boot sequence

- dmesg \| grep -i network → check kernel messages for network-related
  issues

- dmesg -w → run continuously to monitor activity in real time

**dmesg vs Log Files**

- dmesg shows only kernel messages and recent activity in the kernel
  ring buffer.

- For a comprehensive log of system activity (including user-space
  processes), check:

  - /var/log/messages

  - /var/log/syslog

  - /var/log/dmesg

## 17.2. iostat Command

The iostat command in Linux is part of the sysstat package and is used
to monitor system input/output (I/O) statistics for devices, partitions,
and the CPU. It provides valuable insights into how the system’s storage
devices and processors are being utilized, helping diagnose performance
bottlenecks related to disk or CPU usage.

**Default Behaviour**

- When run without options, iostat displays CPU statistics and I/O
  statistics for all devices.

- It shows data since the system was last booted, not for the current
  moment unless you specify an interval.

**Common Use Cases**

- iostat → show cput statistics and I/O statistics for all devices since
  boot

- iostat 2 → updates statistics every 2 seconds

- iostat -c → display only cpu statistics

- iostat -x → show extended device statistics

- iostat -d sda → show statistics for specific device

- iostat -m 2 → display statistics in megabytes and updates every 2
  seconds

- iostat -t → include timestmp

## 17.3. vmstat Command

The vmstat (Virtual Memory Statistics) command in Linux provides a
snapshot of system performance, specifically focusing on memory,
processes, paging, block I/O, traps, and CPU activity. It’s a useful
tool for understanding the overall health of your system and diagnosing
performance issues.

**Comparison: vmstat vs iostat**

- vmstat: Focuses on virtual memory, CPU, and system performance.

- iostat: Primarily tracks disk I/O and CPU performance.

## 17.4. free Command

information about the system’s memory usage. It provides details about
the total, used, free, shared, buffer/cache, and available memory on the
system, both for physical memory (RAM) and swap space.

**Common Use Cases:**

- free → basic memory usage

- free -h → display memory in human-readable format

- free -s 5 → monitor memory usage continuously (every 5 seconds)

- free -m → show memory in megabytes

- free -t → show memory including swap

## 17.5. lsof Command

(List Open Files) command lists information about files that are
currently open by processes. In Linux, almost everything is treated as a
file, including regular files, directories, sockets, pipes, and devices.
This makes lsof an incredibly powerful utility for monitoring and
debugging system processes and file usage.

- Identify which process is using a file or directory.

- Monitor network activity (open ports and connections).

- Troubleshoot file system issues (e.g., files preventing unmounting).

- Debug locked files or processes.

- Identify resource leaks in applications.

**Examples**

- lsof → list all open files

- lsof /path/to/file → find processes using a specific file

- lsof -u username → find processes running as a specific user

- lsof -p 1234 → find processes with a specific PID

- lsof -c ssh → list files opened by a specific command

- lsof -i → List network connections

- lsof -i :22 → show proceses using a specific port

- lsof +D /path/to/directory → list open files in a directory

- lsof +L1 → list deleted files still open by processes

- lsof -u ^root → exclude a specific user

- lsof -r 5 → monitor changes to open files in real-time

## 17.6. Other sysinfo Commands

- cat /proc/cpuinfo → The /proc/cpuinfo file in Linux contains detailed
  information about the CPU(s) on your system. Each processor or core is
  represented by a section in this virtual file

- cat /proc/meminfo → The /proc/meminfo file in Linux provides detailed
  information about the system’s memory usage. It is a virtual file that
  displays real-time memory statistics, including physical memory, swap
  space, and buffer/cache memory. The information is represented in
  kilobytes (kB).

- lsmem → The lsmem command in Linux is used to display information
  about the system’s memory blocks. It provides details about the memory
  layout, including physical memory blocks that are online, offline, or
  reserved.

- pmap → display the memory map of a running process. It provides
  detailed information about the memory usage of a specific process,
  including virtual memory areas and the size of different segments like
  code, data, and stack.

- lscpu → detailed information about the CPU architecture and
  capabilities of your system. It extracts data from the /proc/cpuinfo
  file and other sources to provide an organized overview of the
  processor(s).

- dmidecode → provides information about the system’s hardware as
  described by the system BIOS (or UEFI). It fetches data using the
  Desktop Management Interface (DMI) table and outputs details about
  components like the processor, memory, cache, motherboard, and system
  firmware.

- uptime → display how long the system has been running, along with
  information about the number of users currently logged in and the
  system’s load averages.

- hostname

  - hostnamectl → command for managing the system’s hostname and related
    system information.

  - /etc/hostname → view or change the system’s static hostname.

- OS

  - uname -a → Displays kernel-related information, including the kernel
    version, architecture, and system hostname.

  - lsb_release -a → Provides distribution-specific information on
    systems supporting LSB (Linux Standard Base).

  - /etc/os-release → standardized file providing distribution-specific
    information.

  - /etc/redhat-release → This file contains the distribution-specific
    version information for Red Hat-based distributions (e.g., Red Hat
    Enterprise Linux, CentOS, AlmaLinux, or Rocky Linux).

# 18. Networking

## **18.1. netstat Command**

(used in Mac but outdated on Linux in favour of ss Command)

The netstat (network statistics) command is a powerful utility in Linux
used to display network-related information. It provides information
about network connections, routing tables, interface statistics, and
more. It is particularly useful for troubleshooting networking issues,
monitoring network performance, and identifying open ports or active
connections on a system.

**Common Use Cases**

- netstat -a → Displays all active network connections, including TCP
  and UDP, in all states (LISTEN, ESTABLISHED, etc.).

- netstat -t → Displays only TCP network connections.

- netstat -l → shows all the ports on which the system in currently
  listening for incoming connections

- netstat -tulnp → display TCP and UDP connections that are listening,
  along with the associated program names and processID

- netstat -r → display the systems routing table, showing how packets
  are routed through the network

- netstat -i → Displays network interface statistics like packet counts
  and errors for each interface (eth0, wlan0, etc.).

- netstat -c → Continuously refreshes the output every second.

- netstat -s → Displays detailed protocol statistics (e.g., TCP, UDP,
  ICMP).

## **18.2. ss Command**

The ss (Socket Statictics) command is a utility in Linux used to display
network connections, listening ports, and various socket-related
statistics. It is faster and more efficient than the older netstat
command and is the recommended tool for inspecting network connections
in modern Linux systems. It is part of the iproute2 package, which is
standard on most Linux distributions.

**Key Features of ss**

- ss is faster than netstat, as it directly retrieves data from the
  kernel, making it more efficient.

- It provides more detailed information about network connections,
  including the states of TCP connections.

- ss can display a wide range of information, including both active and
  listening ports, socket statistics, and even detailed per-protocol
  information.

**Common Use Cases:**

- ss -tuln → display TCP and UDP connections that are listening, along
  with the associated program names and processID

- ss -t -a → show both LISTEN (waiting for connections) and ESTAB
  (connections that are established) states.

- ss -tulnp → display the PID and name of the program that is using each
  socket

## **18.3. ip Command**

The ip command is a powerful and versatile networking tool used in Linux
to manage network interfaces, routing tables, IP addresses, tunnels, and
more. It is part of the iproute2 package, which has replaced older tools
like ifconfig, route, netstat, and arp for network configuration and
management.

The ip command provides a unified syntax for network configuration and
allows you to control and monitor network resources in a consistent
manner.

Common Objects and Commands

- ip addr show → view ip addresses assigned to interfaces

- ip addr add 192.168.1.100/24 dev eth0 → add a new IP address on an
  interface

- ip addr del 192.168.1.100/24 dev eth0 → remove an IP address from an
  interface

- ip link show → show network interfaces

- ip route show → view routing table

## **18.4. ping Command**

The ping **command** is a network utility used to test the connectivity
between your device and another device or server on a network. It sends
**ICMP (Internet Control Message Protocol)** Echo Request messages to
the target and waits for Echo Reply messages, measuring the time it
takes for the packets to travel there and back.

The ping command is commonly used for:

- Checking network connectivity.

- Measuring network latency (round-trip time).

- Diagnosing network issues.

Common Use Cases:

- ping 8.8.8.8 → checks if your device can connect to google’s public
  DNS server

- ping -c 5 google.com → send 5 packets to measure avg response time

- ping -s 1000 google.com → test large packet transmission

- ping -6 google.com → ping in IPv6.

Tips:

- some devices or firewalls block ICMP traffic making the ping command
  fail even if the destination is reachable

## **18.5. ifconfig Command**

(Note: outdated on modern Linux systems; still in use on macOS)

The ifconfig **(interface configuration)** command is a network
management tool in Linux used to configure, manage, and view network
interfaces.

- Display current network interface configurations.

- Assign IP addresses to network interfaces.

- Enable or disable interfaces.

- Manage network settings such as netmask, broadcast, and more.

Common Use Cases

- ifconfig → display all active interfaces

eth0 Link encap:Ethernet HWaddr 00:1A:2B:3C:4D:5E

inet addr:192.168.1.100 Bcast:192.168.1.255 Mask:255.255.255.0

UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1

RX packets:1200 errors:0 dropped:0 overruns:0 frame:0

TX packets:900 errors:0 dropped:0 overruns:0 carrier:0

collisions:0 txqueuelen:1000

RX bytes:1024000 (1.0 MB) TX bytes:512000 (512.0 KB)

- output information: displays

  - IP Address: inet addr

  - Broadcast Address: Bcast

  - Subnet Mask: Mask

  - Mac Address: HWaddr

- ifconfig eth0 up → activates eth0 network interface

- ifconfig eth0 down → disables the eth0 network interface

- ifconfig eth0 192.168.1.10 netmask 255.255.255.0 → assigns an IP
  address 192.168.1.10 and subnet mask 255.255.255.0 to eth0

## **18.6. tcpDump**

tcpdump is a powerful command-line tool for network packet analysis and
debugging. It allows users to capture and analyze network traffic in
real time. It is widely used by system administrators, network
engineers, and security professionals to diagnose network issues,
monitor traffic, and inspect data packets.

Basic Examples:

- sudo tcpdump → captures traffic on the default interface (eg: eth0)

- sudo tcpdump -i eth0 → captures traffic only on the eth0 interface

- sudo tcpdump host 192.168.1.1 → captures packets to or from the IP
  192.168.1.1

- sudo tcpdump port 80 → captures http traffic (port 80)

- sudo tcpdump tcp → captures only TCP packets

- sudo tcpdump -w capture.pcap → saves packets to a file (capture.pcap)
  for later analysis with tools like Wireshark

## **18.7. nslookup**

The nslookup command is a network administration tool used to query the
Domain Name System (DNS) for information about domain names, IP
addresses, and other DNS records. It is a powerful diagnostic tool that
helps troubleshoot DNS-related issues.

Common Use Cases

- nslookup example.com → look up the address of a domain

- nslookup 192.0.2.1 → look up the domain name of an IP Address (reverse
  look up)

- nslookup -query=type example.com → query specific DNS Record Types

- nslookup -query=type example.com → query specific DNS Record Types

  - A for IPv4 addresses

  - AAAA for IPv6 addresses

  - MX for mail servers

  - NS for name servers

  - TXT for text records

- nslookup example.com 8.8.8.8 → queries the DNS server at 8.8.8.8
  (Google Public DNS)

## **18.8. dig**

The dig command (short for **Domain Information Groper**) is a powerful
and flexible command-line tool used to query the Domain Name System
(DNS). It provides detailed information about DNS records, making it a
preferred tool for network administrators and developers for diagnosing
DNS-related issues.

Features and Usage

- dig example.com → Returns the IPv4 address (A record)

- dig example.com MX → query specific record types

- dig @8.8.8.8 example.com → query a specific DNS server

- dig -x 192.0.2.1 → perform reverse DNS lookup

- dig +trace example.com → traces the query path from root DNS servers
  to the authoritative server

## **18.9. traceroute**

The traceroute command is a network diagnostic tool used to track the
path that packets take from your computer to a target host on the
internet. It provides a detailed report of the route and the time taken
for each hop along the way, helping diagnose network connectivity issues
and identify bottlenecks.

How It Works

- By default, traceroute sends **UDP packets** to the destination.

- Each packet has a Time-to-Live (TTL) value, starting at 1 and
  incrementing with each hop.

- Each router along the path decrements the TTL by 1. When TTL reaches
  0, the router sends an ICMP “Time Exceeded” message back to the
  source.

- The response time from each router (hop) is recorded, and the process
  continues until the destination is reached or the maximum hop count is
  exceeded.

- When the target host responds, traceroute displays the path and
  response times.

Common Usage

- traceroute example.com → displays the route taken

- traceroute -m 20 example.com → specify the maximum number of hope

- traceroute -p 80 example.com → sends packets to port 80 (useful for
  troubleshooting HTTP connections)

- traceroute -I example.com → uses ICMP packets instead of UDP

- traceroute -s 56 example.com → sends packets of 56 bytes

- traceroute -v example.com → verbose output

## 18.10. nmap

powerful **network scanning and security auditing tool**. It is widely
used to discover hosts, services, and open ports on a network.
Additionally, it can help identify the operating system and other
details of remote devices.

- nmap example.com → scan a single host

- nmap 192.168.1.1-100 → scan a range of IP addresses

- nmap 192.168.1.0/24 → scan an entire subnet

- nmap -p- 192.168.1.1 → scan for all open ports

- for more advance use cases read manual

**Use Cases**

- Discover active devices in a network.

- Identify open ports on a server.

- Detect vulnerable services and software versions.

- Perform network troubleshooting.

- Audit firewall rules.

**Tips**

- Always use nmap on networks and systems you own or have explicit
  permission to scan.

- nmap scans can trigger alerts in Intrusion Detection Systems (IDS).

- Use stealth scans (-sS) to minimise detection when scanning targets.

## 18.11. Other Network Commands

- iftop-\> real-time network bandwidth monitoring tool that shows a list
  of network connections and their data usage. It provides detailed
  information about the traffic to and from the system, helping identify
  bandwidth bottlenecks or unusual network activity

- ifup/ifdown eth0 → activates/deactivates the eth0 interface using the
  configuration file specified in the /etc/network/interfaces

- nmcli → ?

- nmtui → ?

# **19. Log Monitoring**

Logs in Linux are typically stored in the /var/log/ directory, though
some applications may store logs in custom locations.

- /var/log/syslog or /var/log/messages: These are general system logs,
  storing messages from the kernel and various system services. In some
  distributions, syslog is used while others use messages.

- /var/log/auth.log: This log file contains authentication-related
  events, including login attempts, sudo usage, and other
  security-related activities.

- /var/log/dmesg: Contains kernel ring buffer messages, which capture
  information about hardware, boot processes, and drivers.

- /var/log/boot.log: Stores boot messages, including system startup and
  service initialization information.

- /var/log/kern.log: Contains kernel-related logs. It captures
  information about the kernel, including hardware detection and driver
  messages.

- /var/log/cron: Contains logs related to cron jobs, i.e., scheduled
  tasks.

- /var/log/httpd/ or /var/log/nginx/: These directories contain logs
  related to the Apache (httpd) or Nginx web servers, respectively. The
  logs include access and error logs.

- /var/log/mysql/: Logs related to the MySQL database server, including
  queries and error messages.

- /var/log/maillog: Stores logs related to email services (e.g.,
  Postfix, Sendmail).

- /var/log/user.log: Stores user-related log messages and events.

- /var/log/faillog: Records failed login attempts on the system.

- /var/log/sudo.log: Contains logs of sudo commands, including details
  about the user running the commands.

- /var/log/Xorg.0.log: Stores logs related to the X11 server, including
  display driver issues.

# **20. Environment Variables**

Environment variables are dynamic values that the operating system and
applications use to store system-wide or session-specific settings.
These variables influence the behavior of processes running on a system
by providing configuration details, such as paths to directories,
usernames, system settings, or application-specific parameters.

Common Environment Variables:

- PATH: Defines directories where executable programs are located.

- HOME: Indicates the user’s home directory.

- USER: Stores the username of the current user.

- SHELL: Specifies the default shell for the user (e.g., /bin/bash).

- LANG: Sets the language and locale for the system.

- PWD: Contains the current working directory.

- OLDPWD: Stores the previous working directory.

- TERM: Defines the terminal type (e.g., xterm, linux).

- EDITOR: Specifies the default text editor (e.g., vim, nano).

- LOGNAME: Stores the user’s login name.

- HOSTNAME: Contains the system’s hostname.

Common Use Cases:

- printenv or env → list all variables

- echo \$VARIABLE_NAME → view a specific variable

- temporary definition and export a variable for a shell

  - VARIABLE_NAME=value && export VARIABLE_NAME

- persistent definition (for all sessions)

  - Add the variable to one of the following files:

  - User-Specific: ~/.bashrc, ~/.bash_profile, or ~/.zshrc.

  - System-wide: /etc/environment, /etc/profile, or /etc/bash.bashrc.

- export PATH=\$PATH:/new/directory→ Append to a variable

- export PATH=/new/directory:\$PATH → prepend to a variable

- unset VARIABLE_NAME → unsetting variable; removing from the current
  session

# **21. ssh**

A protocol and tool used to securely access and manage remote systems
over an encrypted connection. It replaces older, insecure protocols like
Telnet by ensuring confidentiality and integrity of the data transferred
between the client and the server.

- Uses encryption to protect data from eavesdropping.

- Supports password-based and key-based authentication.

- Can be used to copy files using **SCP** or **SFTP**.

- Supports secure port forwarding and tunneling.

- Enables running commands on remote systems.

## 21.1. Common Use Cases

- ssh user@example.com → connects to server

- ssh -p 2222 user@example.com → connects on a custom port

- ssh -i ~/.ssh/private_key user@example.com → connects to the server
  using the specified private key

- ssh user@example.com 'uptime' → runs the uptime command on the remote
  server and displays the output locally

- scp file.txt user@example.com:/remote/path/ → transferring files
  securely

- sftp user@example.com → then use commands like put, get, or ls

- ssh -L 8080:localhost:80 user@example.com → forwards local port 8080
  to the remote server’s port 80

- ssh -R 9090:localhost:22 user@example.com → forwards remote port 9090
  to the local machine’s SSH port 22.

## 21.2. ssh config

SSH connections can be simplified using the ~/.ssh/config file.

Host myserver

HostName example.com

User user

Port 2222

IdentityFile ~/.ssh/private_key

Now, you can connect using

ssh myserver

## 21.3. Generating SSH Keys

- ssh-keygen -t rsa -b 4096 → Generate a key pair; note that **rsa is an
  old algorithm** and could practically become breakable in the
  foreseeable future.

- ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519_SiliconSorcerer
  -C "vibinbobyjoseph Generated for SiliconSorcerer"

  - -t type of encryption algorithm; ed25519 is highly secure, faster
    and more efficient

  - -f specifies the file name

  - -c is for comment

  - -a higher numbers result in slower passphrase verification and
    increased resistance to brute-force password cracking should the
    keys be stolen. default is 16.

- ssh-copy-id user@example.com → copy the public key to the server.
  Alternatively, append the public key manually to
  ~/.ssh/authorized_keys on the server

## 21.4. SSH Tunnels and Proxies

ssh -D 8080 user@example.com → applications can use localhost:8080 as a
proxy

## 21.5. Security Tips

- Use Key-Based Authentication: More secure than password-based access.

- Disable Root Login: Edit /etc/ssh/sshd_config and set PermitRootLogin
  no.

- Change Default Port: Change Port in /etc/ssh/sshd_config to something
  other than 22.

- Enable Firewall Rules: Restrict access to the SSH port using firewalls
  like ufw or iptables.

# 22. Terminal Multiplexers

## **22.1. screen**

(Note: tmux is a modern alternative)

The screen command is a terminal multiplexer that allows you to run
multiple terminal sessions simultaneously within a single terminal
window. It provides the ability to detach sessions and reattach them
later, making it particularly useful for long-running processes, remote
sessions, or multitasking in a terminal environment.

- Run multiple terminal sessions within a single screen instance.

- Detach a screen session and reconnect to it later, even after logging
  out or losing a connection.

- Share a session between multiple users for collaboration.

- Provides a scrollback buffer to view previous terminal output.

- Configurable key bindings, screen titles, and session behaviors.

**Common Commands**

- screen → open a new screen session

- screen -S session_name → starts a screen session with a specific name

- screen -ls → lists all active screen sessions

- screen -r → reattaches to the most recent detached session

- screen -r session_name → reattaches to a specific session by name

- Ctrl+A then D → detaches the current session

- exit → exits a screen session

- ~/.screenrc customize → configure default behaviours

## **22.2. tmux**

tmux (Terminal Multiplexer) is a modern alternative to screen that
allows you to create, manage, and navigate between multiple terminal
sessions (panes, windows, and sessions) within a single terminal window.
It is an advanced alternative to the screen command, offering better
customization, scripting support, and a more modern feature set.

- Detach and reattach sessions, preserving your work even after
  disconnecting from SSH or closing the terminal.

- Split windows into multiple panes for multitasking within a single
  session.

- Customize shortcuts and commands through a configuration file.

- Share a session with another user for collaborative work.

- Easy navigation between panes, windows, and sessions.

Common Commands

- tmux → starts a new tmux session

- tmux new -s session_name → starts a new session with custom name

- tmux ls → list all active tmux sessions

- tmux attach -t session_name → reattaches to a specific tmux session

- Ctrl +b, then d → detaches the current session

- tmux kill-session -t session_name → terminates a specific session

Navigating within tmux

- Ctrl + b, then d → Detaches from the current session.

- Ctrl + b, then % → Splits the current window into two horizontal
  panes.

- Ctrl + b, then " → Splits the current window into two vertical panes.

- Ctrl + b, then Arrow Key → Navigates between panes using arrow keys.

- Ctrl + b, then c → Creates a new window in the current session.

- Ctrl + b, then n → Moves to the next window.

- Ctrl + b, then x → Closes the current pane.

- Ctrl + b, then : → Enter command mode, then type resize-pane.

- Ctrl + b, then \[ → Enters copy mode to scroll through the terminal
  history.

- Ctrl + b, then , → Prompts for a new name for the current window.

# 23. File Transfer And Download

## **23.1. wget Command**

The wget command is a non-interactive command-line utility used to
download files from the web. It supports downloading via protocols like
HTTP, HTTPS, and FTP. wget is designed to handle slow or unstable
network connections by retrying downloads and resuming incomplete ones.

- wget https://example.com/file.zip → download file.zip from the
  specified URL

- wget -O custom_name.zip https://example.com/file.zip → save the file
  with a different name

- wget -c https://example.com/file.zip → resume a partially downloaded
  file

- wget -i urls.txt → download multiple files

- wget --limit-rate=100k https://example.com/largefile.zip → limits the
  download speed to 100 KB/s

- wget -r https://example.com → downloads the entire website (follows
  links and save the directory structure)

- wget --user=username --password=password
  https://example.com/protected-file.zip → download files using basic
  authentication

- wget --header="Authorization: Bearer \<token\>"
  https://example.com/api/resource → download files using bearer token
  authentication

- wget --tries=5 https://example.com/file.zip → specify number of
  retries

- wget -e use_proxy=yes -e http_proxy=proxy_server:port
  https://example.com/file.zip → specify a proxy

- wget -q https://example.com/file.zip → suppresses output during
  download

- wget -m https://example.com → creates a complete local copy of the
  website

- wget -r -A "\*.jpg" https://example.com/images/ → recrusvely download
  all .jpg files from a specific directory

- wget -b https://example.com/largefile.zip → download a file in the
  background

## **23.2. curl Command**

For transferring data to or from a server using various protocols, such
as HTTP, HTTPS, FTP, and more. It is widely used to interact with APIs,
download files, and troubleshoot network issues. Unlike wget, which
focuses primarily on downloading files, curl excels at interacting with
web services and making API requests.

- Protocol Support: HTTP, HTTPS, FTP, FTPS, SCP, SFTP, LDAP, POP3, SMTP,
  and more.

- API Interaction: Perform GET, POST, PUT, DELETE, and other HTTP
  methods.

- Data Upload/Download: Send or receive data using different protocols.

- Authentication: Supports basic, token-based, and other types of
  authentication.

- Proxy Support: Works through proxy servers.

- SSL/TLS: Handles secure connections and certificates.

Common Examples:

- curl https://example.com → fetches the content of a specific URL and
  displays it in the terminal

- curl -o file.html https://example.com → saves the output to file.html
  instead of displaying it in the terminal

- curl -L https://example.com → follow HTTP redirectors to the final URL

- curl -O https://example.com/file.zip → saves the file using its
  original name (file.zip)

- curl -X POST -d "key=value" https://example.com/api → sends a post
  request with JSON data and the appropriate header

- curl -X POST -H "Content-Type: application/json" -d '{"key":"value"}'
  https://example.com/api → sends a POST request with JSON data and the
  appropriate header

- curl -H "Authorization: Bearer token" https://example.com/api → Adds
  an authorization header to the request.

- curl -u username:password https://example.com/protected → basic
  authentication

- curl -H "Authorization: Bearer \<token\>"
  https://example.com/protected → token authentication

- curl -I https://example.com → view http HTTP headers

- curl -X PUT -d '{"update":"true"}' -H "Content-Type: application/json"
  https://example.com/api/resource → Test API Endpoint

- curl -O https://example.com/file1.zip -O https://example.com/file2.zip
  → Download multiple files

- curl -C - -O https://example.com/largefile.zip → resume an interrupted
  download

- curl -b "name=value" https://example.com → send a cookie with the
  request

- curl -T file.txt https://example.com/upload → upload file.txt to the
  server

- curl -c cookies.txt https://example.com → saves cookies to cookies.txt

## **23.3. aria2c Command**

The aria2 command is a lightweight, fast, and versatile multi-protocol
download utility. It supports HTTP, HTTPS, FTP, BitTorrent, and Metalink
protocols. Designed for advanced downloading, aria2 can split files into
multiple segments and download them concurrently to maximize download
speed. It is particularly useful for downloading large files, batch
downloads, and BitTorrent seeding.

**Key Features**

- **Multi-Protocol Support**: HTTP, HTTPS, FTP, BitTorrent, and
  Metalink.

- **Multi-Source Downloading**: Fetches segments of a file from multiple
  sources.

- **Concurrent Connections**: Downloads files in parallel to improve
  speed.

- **Lightweight**: Minimal resource usage compared to GUI-based download
  managers.

- **Customizable**: Supports a wide range of options for fine-tuning
  downloads.

- **Resume Support**: Resumes interrupted downloads.

- **BitTorrent Client**: Downloads or seeds torrents.

- **Metalink Support**: Handles Metalink files for better redundancy and
  error recovery.

Common Examples

- aria2c https://example.com/file.zip → basic file download

- aria2c -x 16 https://example.com/file.zip → uses 16 connections to
  download the file, increases speed

- aria2c -c https://example.com/file.zip → resumes a partially
  downloaded file

- aria2c https://example.com/file1.zip https://example.com/file2.zip →
  downloads multiple files concurrently

- aria2c -i urls.txt → download files listed in a text file

- aria2c file.torrent → starts download files from a .torrent file

- aria2c --http-user=username --http-passwd=password
  https://example.com/protected.zip → basic authentication

- aria2c --ftp-user=username --ftp-passwd=password
  ftp://example.com/protected.zip → ftp authentication

- aria2c file.metalink → downloads files described in a Metalink file,
  automatically handling multiple mirrors

- aria2c -d /path/to/directory https://example.com/file.zip → saves the
  downloaded file in the specific directory

- aria2c --max-download-limit=1M https://example.com/file.zip → limit
  the download speed

- aria2c -x 8 -s 16 https://example.com/file.zip → uses 8 connections
  per server and splits the file into 16 segments

- aria2c https://mirror1.com/file.zip https://mirror2.com/file.zip →
  fetches file from multiple mirrors simultaneously

## **23.4. scp Command**

The scp (Secure Copy Protocol) command is used to securely transfer
files and directories between a local and remote host, or between two
remote hosts. It uses the SSH (Secure Shell) protocol to encrypt the
data, ensuring secure file transfer.

- Secure Transfer: Uses SSH for encryption.

- Cross-Platform: Works across Linux, macOS, and Windows (with tools
  like PuTTY or OpenSSH).

- Recursive Copy: Can transfer entire directories with the -r option.

- Authentication: Uses SSH keys or passwords for authentication.

- Port Specification: Allows specifying non-default SSH ports.

Common Examples:

- scp file.txt user@remote_host:/remote/directory/ → Transfers file.txt
  to the specified directory on the remote host.

- scp user@remote_host:/remote/file.txt /local/directory/ → Downloads
  file.txt from the remote host to the local directory.

- scp -r /local/directory user@remote_host:/remote/directory/ → Copies
  the entire directory and its contents to the remote host.

- scp user1@remote_host1:/path/file.txt user2@remote_host2:/path/ →
  Copies a file directly between two remote hosts.

- scp -P 2222 file.txt user@remote_host:/remote/directory/ → Uses port
  2222 instead of the default SSH port (22).

- scp -i ~/.ssh/id_rsa file.txt user@remote_host:/remote/directory/ →
  Uses the specified private SSH key for authentication.

- scp -C largefile.zip user@remote_host:/remote/directory/ → transfer
  large files efficiently with compression

## **23.5. rsync Command**

Synchronize files and directories between local and remote systems. It
is often used for backups, mirroring, and incremental file transfers.
Unlike scp, rsync uses delta encoding to transfer only the differences
between source and destination files, making it more efficient for
repeated operations.

- Incremental Transfer: Transfers only the changed parts of files.

- Compression: Reduces data transfer size by compressing files during
  transfer.

- Preserves File Attributes: Retains permissions, ownership, timestamps,
  and symbolic links.

- Synchronization: Keeps source and destination in sync, including
  deletion of files.

- Local and Remote Support: Works for both local-to-local and
  local-to-remote transfers.

- Resumable Transfers: Can resume interrupted transfers.

Common Examples:

- rsync file.txt user@remote_host:/remote/directory/ → Transfers
  file.txt to the specified directory on the remote host.

- rsync -av /local/directory/ user@remote_host:/remote/directory/ →
  Synchronizes the contents of /local/directory/ with
  /remote/directory/.

- rsync -r /local/directory/ /remote/directory/ → Transfers a directory
  and its contents recursively.

- rsync -az /local/directory/ user@remote_host:/remote/directory/ → Adds
  compression (-z) for faster transfers.

- rsync -av --delete /source/directory/ /destination/directory/ →
  Deletes files in the destination that are no longer present in the
  source directory.

- rsync -av -e "ssh -p 2222" /local/directory/
  user@remote_host:/remote/directory/ → Copy files over a specific SSH
  port

- rsync -av --dry-run /source/directory/ /destination/directory/ → dry
  run to preview changes

- rsync -av --exclude="\*.log" --exclude="temp/" /source/ /destination/
  → excludes files matching the \*.log and the directory /temp

# **24. Package Managers**

A **package manager** is a tool that simplifies the process of
installing, upgrading, configuring, and managing software packages on a
system. It is an essential part of modern operating systems, especially
Linux distributions, providing a centralized and consistent way to
handle software.

**Key Functions of Package Managers**

- **Install Software**: Downloads and installs software from
  repositories.

- **Upgrade Software**: Updates packages to the latest version.

- **Remove Software**: Uninstalls software cleanly.

- **Resolve Dependencies**: Automatically identifies and installs
  required dependencies for a package.

- **Search for Packages**: Allows users to search for available
  software.

- **Manage Repositories**: Configures sources from where packages are
  downloaded.

- **Verify Integrity**: Ensures the authenticity and integrity of
  downloaded packages.

| Package Manager | Distro          | Command Example                  |
|-----------------|-----------------|----------------------------------|
| APT             | Debian/Ubuntu   | sudo apt install package_name    |
| YUM/DNF         | CentOS/Fedora   | sudo dnf install package_name    |
| Pacman          | Arch Linux      | sudo pacman -S package_name      |
| Zypper          | openSUSE        | sudo zypper install package_name |
| RPM             | Red Hat, CentOS | sudo rpm -ivh package_name.rpm   |

## **24.1. Ubuntu/Debian**

**APT (Advanced Package Tool)** is a package management system used
primarily on Debian-based Linux distributions, including **Ubuntu**,
**Linux Mint**, and others. It simplifies the process of managing
software by automating package installation, upgrades, dependency
resolution, and removal.

APT operates by interacting with a repository of precompiled packages.
These repositories are configured in the file /etc/apt/sources.list.
Each package contains metadata about its dependencies and version,
allowing APT to automate installation and updates.

Common Commands

- sudo apt update → It fetches the latest information about available
  packages and their versions from the repositories defined in
  /etc/apt/sources.list and /etc/apt/sources.list.d/. It does **not**
  upgrade or install any packages. Instead, it ensures that your system
  is aware of the latest versions of the packages available in the
  repositories.

- sudo apt upgrade → Upgrades all installed packages to their latest
  versions by comparing the versions of installed packages against the
  metadata fetched by apt update.

- sudo apt install \<package\> → Installs the specified package and its
  dependencies.

- sudo apt remove \<package\> → Removes a package without deleting
  configuration files.

- sudo apt purge \<package\> → Removes a package and its configuration
  files.

- sudo apt autoremove → Removes unused dependencies installed with other
  packages.

- sudo apt search \<term\> → Searches for packages matching the given
  term.

- sudo apt show \<package\> → Displays information about a package.

- sudo apt list --installed → Lists all installed packages.

- sudo add-apt-repository ppa:repository_name && sudo apt update → add a
  new repository

Tips

- apt vs apt-get: both tools are part of the same system, apt is a
  newer, user-friendly command-line tool introduced in Ubuntu 16.04 to
  replace apt-get for common tasks.

- /etc/apt/sources.list.d/ contains files that supplement the primary
  software sources defined in /etc/apt/sources.list (this has now moved
  to /etc/apt/sources.list.d/ubuntu.sources).

- Note\* : Investigate installed packages; resilio sync

## **24.2. Fedora/RHEL/CentOS**

DNF (Dandified Yum) is the next-generation package manager for RPM-based
Linux distributions, such as Fedora, RHEL (Red Hat Enterprise Linux),
and CentOS. It replaces the older YUM (Yellowdog Updater Modified)
package manager with enhanced performance, better dependency resolution,
and improved user experience. DNF uses repository configurations located
in /etc/yum.repos.d/.

Common Commands

- dnf search \<package\> Searches for a package.

- dnf install \<package\> Installs a package and its dependencies.

- dnf remove \<package\> Removes a package and unused dependencies.

- dnf update Updates all installed packages to the latest version.

- dnf check-update Checks if updates are available.

- dnf list installed Lists all installed packages.

- dnf info \<package\> Displays detailed information about a package.

- dnf clean all Clears cached metadata and packages.

- dnf autoremove Removes orphaned packages no longer required.

- dnf downgrade \<package\> Downgrades a package to an earlier version.

- dnf history Displays the history of DNF transactions.

# **25. Other Important Commands and Utils**

## **25.1. date Command**

The date **command** in Linux is used to display or set the system date
and time. It is a straightforward tool for working with time-related
information and allows for formatting the output or modifying the system
clock.

- date → display the current date and time

- date "+%Y-%m-%d" → date in custom format

- date "+%H:%M:%S" → time custom format

- date "+%Y-%m-%d %H:%M:%S" → full date and time in custom format

- sudo date "2024-12-28 16:00:00" → set the system date and time

- date -u → display the UTC time

## **25.2. timedatectl Command**

The timedatectl command is a utility in Linux systems that allows you to
manage and configure the system clock, time zone, and NTP (Network Time
Protocol) synchronization. It is part of the **systemd** suite of tools,
and is commonly used on modern Linux distributions that use systemd for
system management.

Common Commands

- timedatectl → display the current date, time, time zone and NTP
  synchronisation status

- sudo timedatectl set-timezone Europe/London → change the system’s time
  zone, use the set-timezone option:

- timedatectl list-timezones → list available time zones

- sudo timedatectl set-ntp true → enable/disable NTP synchronisation

- sudo timedatectl set-time '2024-12-28 15:00:00' → set the system clock
  manually

- sudo timedatectl set-time '2024-12-28' → set only the system date

## **25.3. bc Command**

The bc command in Linux is a command-line calculator and a programming
language for arithmetic operations. It supports basic arithmetic,
advanced mathematical functions, and user-defined variables. It’s
especially useful for precision-based calculations and can handle
operations with floating-point numbers.

- bc → launch bc in interactive mode

- echo "10 + 5" \| bc → perform basic arithmetic

- echo "scale=3; 10/3" \| bc → set precision

- echo "scale=4; sqrt(25)" \| bc -l → load the math library with -l for
  functions like s, c, a (sine, cosine, arctangent), sqrt (square root),
  etc.

- echo "scale=2; s(3.14159/4)" \| bc -l → sine function

- echo "ibase=2; 1010" \| bc → binary to decimal

- echo "obase=16; 255" \| bc → decimal to hexadecimal

- echo "x=5; y=10; x\*y" \| bc → use variables

## 25.4. cal Command

The cal command in Linux is used to display a simple calendar on the
terminal. It’s a lightweight tool that shows the current month, any
specified month or year, and supports features like highlighting the
current day or calculating specific calendar dates.

- cal → display the current month

- cal 2024 → display the specific year

- cal 12 2024 → display the specific month and year

- cal -3 → display three months (pervious, current, next)

- cal -B 2 -A 2 → display months before and after

## 25.5. script Command

Used to record a terminal session. It captures all input and output
displayed in the terminal during the session and saves it to a file.
This can be useful for logging commands, debugging, documenting
processes, or sharing terminal sessions with others.

- script session.log → start recording to a file

- script -a session.log → append to an existing file

- script -c "ls -l" session.log → record the output of a command

- script -f session.log → writes the output to the file immediately,
  rather than buffering it.

- exit or Ctrl+D→ exit script

# **26. tuned service**

**Tuned** is a Linux daemon and a collection of tools designed to
optimize and manage system performance profiles dynamically. It adjusts
system settings based on predefined profiles or user-defined ones to
improve performance, save power, or balance both depending on the use
case.

Tuned is commonly used in enterprise environments to fine-tune the
performance of servers, desktops, and virtual machines by modifying
kernel parameters, disk settings, network configurations, and other
system components.

- **Dynamic Tuning**: Automatically adjusts system settings based on the
  workload and hardware usage.

- **Predefined Profiles**: Comes with a variety of profiles optimized
  for different workloads (e.g., high-performance, power-saving, virtual
  machines).

- **Custom Profiles**: Allows users to create and customize profiles
  tailored to their specific needs.

- **Integration**: Works seamlessly with systemd and other system
  utilities.

- **Monitoring and Adaptive Optimization**: Monitors hardware usage and
  applies adjustments in real-time to match the workload.

**Basic Commands**

- tuned-adm active → Displays the currently active profile.

- tuned-adm list → Lists all available profiles.

- tuned-adm recommend → get a profile recommendation from tuned

- tuned-adm profile \<profile\> → Activates a specific profile.

- tuned-adm off → Disables tuning and stops the Tuned daemon.

- systemctl start tuned → Starts the Tuned daemon.

- systemctl enable tuned → Enables the Tuned service to start at boot.

- Create custom profile in sudo vi /etc/tuned/my-profile/tuned.conf and
  activate it using tuned-adm profile my-profile

# **27. System Security**

## **27.1. OS Hardening**

**OS Hardening** refers to the process of securing an operating system
by reducing its attack surface and minimising vulnerabilities. This is
achieved by configuring the system to enhance security, removing
unnecessary components, and implementing best practices to mitigate
potential threats.

- Minimal OS

  - during installation, select only the necessary packages and software

  - avoid installing gui components unless required

  - remove unwanted packages

- Change default credentials

  - replace default usernames/passwords with strong, unique credentials

  - immediately disable or remove default accounts (eg: root ssh login)

- Update the system

  - update the OS and installed packages

  - sudo apt update && sudo apt upgrade -y \# For Debian-based systems

> sudo yum update -y \# For Red Hat-based systems

- enable automatic updates for critical patches, if feasible

- update third party softwares that were installed outside the package
  manager

<!-- -->

- disable unnecessary user accounts sudo usermod -L username

- remove or disable guest accounts

- set strong password policies

- configure a firewall

- consider using an intrusion detection and prevention framework (eg
  fail2ban)

- identify (eg: check on listening ports) and disable unused network
  services

- disable unused remote access protocols (eg: telnet, RSH)

- restrict SSH access to specific IPs.

- sudo nano /etc/hosts.allow

> sshd: 192.168.1.0/24

- Enable SSH hardening

  - use key-based authentication

  - disable direct root login via ssh; use sudo for privilege escalation

  - prevent remote logins from accounts with empty passwords

  - restrict protocol to version 2

  - set idle session timeouts

  - sudo vi /etc/ssh/sshd_config

  -

  - \#set idle session timeouts

  - ClientAliveInterval 300

  - ClientAliveCountMax 2

  -

  - \#disable director root login via ssh

  - PermitRootLogin no

  -

  - \#prevent remote logins from accounts with empty passwords

  - PermitEmptyPasswords no

  -

  - \# Limit SSH logins only to certain users who need remote access

  - AllowUsers user1 user2

  -

  - \#restrict protocol to version 2

> Protocol 2

- File Permissons:

  - Restrict access to critical system files

  - ensure user’s home directories are not globally readable

  - Configure chroot environments for services like FTP or DNS to
    isolate them from the main system.

- Enable service-specific hardening

  - Example: configure nginx or apache securely:

    - restrict file access in webservers

    - disable directory listing

  - Use tools like AppArmor or SELinux for mandatory access control

- Enable automatic security updates

- sudo apt install unattended-upgrades

> sudo dpkg-reconfigure unattended-upgrades

- Perform regular vulnerability scans

  - use tools like Lynis or OpenSCAP to audit the system

- sudo apt install lynis

> sudo lynis audit system

## 27.2. Firewall

A **firewall** is a security system designed to monitor, filter, and
control incoming and outgoing network traffic based on predetermined
security rules. Its primary purpose is to protect computers, servers,
and networks from unauthorized access, cyberattacks, and other security
threats while allowing legitimate communication.

**Types of Firewalls**

- **Network Firewalls**: Protect entire networks by filtering traffic at
  the network perimeter. Typically hardware-based or software running on
  dedicated devices.

- **Host-Based Firewalls**: Protect individual devices (hosts) by
  controlling traffic to and from that specific device. Often
  software-based (e.g., iptables or ufw on Linux, Windows Firewall).

- **Cloud Firewalls**: Offered by cloud providers to secure virtual
  infrastructure in cloud environments.

**How Firewalls Work**

Firewalls act as gatekeepers that enforce a set of rules to determine
whether to **allow** or **block** traffic. These rules are based on
factors such as:

- **IP Address**: Block or allow traffic from specific addresses.

- **Port Numbers**: Control traffic based on specific ports (e.g., port
  80 for HTTP).

- **Protocol**: Filter traffic by protocol (e.g., TCP, UDP, ICMP).

- **Traffic Direction**: Specify rules for inbound or outbound traffic.

**Firewall Techniques**

- **Packet Filtering**: Examines individual packets of data for
  source/destination IPs, ports, and protocols. Basic and efficient but
  lacks deep inspection of data.

- **Stateful Inspection**: Tracks the state of active connections and
  determines whether incoming packets are part of an existing
  connection. More secure than simple packet filtering.

- **Proxy Firewall**: Acts as an intermediary between clients and
  servers. Inspects and filters traffic at the application layer.

- **Next-Generation Firewalls (NGFWs)**: Provide advanced features like
  deep packet inspection, intrusion detection/prevention, and
  application awareness.

**Common Firewall Tools in Linux**

- iptables → a command-line utility for managing Netfliter, a packet
  filtering framework in the Linux kernel.

- nftables - A modern replacement for iptables with better performance
  and simpler syntax.

- ufw (Uncomplicated Firewall) - a user-friendly frontend for iptables

- firewalld: A dynamic firewall management tool for modern linux
  distributions, with D-Bus interface

### **27.2.1. iptables**

iptables is a command-line utility in Linux that allows administrators
to configure the rules for the Netfilter framework within the Linux
kernel. It is primarily used to set up, maintain, and inspect the tables
of IP packet filter rules, enabling the creation of firewalls and
control over network traffic.

- **Netfilter**:

  - The kernel-level packet filtering framework that iptables interacts
    with.

  - Processes packets at different stages (e.g., incoming, outgoing).

- **Tables**:

  - A collection of chains that defines the type of processing applied
    to packets.

  - Common tables:

    - **filter**: Default table for basic packet filtering (e.g., allow
      or block traffic).

    - **nat**: Handles network address translation for packet routing.

    - **mangle**: Alters packet headers (e.g., to set Quality of
      Service).

    - **raw**: Allows raw packet processing and skips connection
      tracking.

- **Chains**:

  - A set of rules applied to packets as they traverse the system.

  - Built-in chains:

    - **INPUT**: For packets destined for the local system.

    - **FORWARD**: For packets being routed through the system.

    - **OUTPUT**: For packets originating from the local system.

- **Rules**:

  - Define the conditions (match criteria) and actions (targets) to take
    for packets.

  - Example conditions: source IP, destination port, protocol.

- **Targets**:

  - Actions to take on packets matching a rule.

  - Common targets:

    - **ACCEPT**: Allow the packet.

    - **DROP**: Silently drop the packet.

    - **REJECT**: Drop the packet and send an error response.

    - **LOG**: Log the packet details.

**Basic Commands**

- sudo iptables -L -v → view current rules

- sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT → allow incoming
  traffic on port 22 (SSH)

- sudo iptables -A INPUT -p tcp --dport 80 -j DROP → block incoming
  traffic on port 80 (HTTP)

- sudo iptables -D INPUT -p tcp --dport 22 -j ACCEPT → delete a rule

- sudo iptables -F → flush all rules

- sudo iptables-save \> /etc/iptables/rules.v4 → save rules persistently

- sudo iptables -A INPUT -s 192.168.1.100 -j DROP → block traffic from a
  specific IP

- sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j REDIRECT
  --to-port 80 → forward traffic from one port to another

### **27.2.2. nftables**

nftables is a modern packet filtering and firewalling framework in
Linux, designed to replace the legacy iptables. It provides a simplified
and unified way to manage firewall rules, network address translation
(NAT), and packet classification.

Introduced in Linux kernel 3.13 (2014), nftables improves performance,
scalability, and usability over iptables, while retaining backward
compatibility through translation layers like iptables-nft.

**Key Features**

- **Unified Framework**:

  - Combines packet filtering, NAT, and traffic classification in a
    single framework.

  - Reduces the complexity of maintaining separate tools (e.g.,
    iptables, ip6tables, arptables, and ebtables).

- **Improved Syntax**:

  - Provides a more concise and readable configuration language compared
    to iptables.

- **Performance Enhancements**:

  - Uses a single ruleset for all protocols (IPv4, IPv6, ARP, etc.).

  - Efficient memory usage and better scalability.

- **Dynamic Rulesets**:

  - Supports atomic updates to rules, avoiding disruptions during
    configuration changes.

- **Stateful Filtering**:

  - Allows tracking and filtering based on the state of connections
    (e.g., NEW, ESTABLISHED, INVALID).

**Basic Structure**

- **Tables**:

  - Logical containers for chains and rules.

  - Example: filter, nat.

- **Chains**:

  - Collections of rules that act on packets.

  - Types:

    - **Input**: For packets destined for the local machine.

    - **Output**: For packets originating from the machine.

    - **Forward**: For packets being routed through the machine.

- **Rules**:

  - Define conditions and actions for packets.

  - Example: Drop packets from a specific IP.

- **Sets and Maps**:

  - Allow grouping of multiple values (e.g., IP addresses, ports) to
    simplify rules.

**Basic Commands**

- sudo nft list ruleset view rules

- sudo nft add table ip my_table → add a table

- sudo nft add chain ip my_table my_chain { type filter hook input
  priority 0\\ } → add a chain

- sudo nft add rule ip my_table my_chain tcp dport 22 accept → add a
  rule

- sudo nft delete rule ip my_table my_chain handle 1 → delete a rule

- sudo nft list ruleset \> /etc/nftables.conf → save rules

- sudo nft -f /etc/nftables.conf → load rules

- iptables-save \| iptables-translate \> rules.nft && nft -f rules.nft →
  convert existing iptables rules to nftables sysntax

**Advantages of nftables over iptables**

- **Simpler Syntax**:

  - Reduces the complexity of managing rules.

  - Example: In iptables, each rule requires a separate command. In
    nftables, multiple rules can be written in a single file.

- **Unified Ruleset**:

  - Handles IPv4, IPv6, NAT, and ARP with a single set of rules.

- **Performance**:

  - Uses just-in-time (JIT) compilation for faster rule matching.

- **Atomic Updates**:

  - Ensures that partial changes to rules don’t disrupt the system.

- **Dynamic Data Structures**:

  - Supports sets and maps, enabling efficient handling of multiple IPs
    or ports in a single rule.

### **27.2.3. firewalld**

firewalld is a dynamic firewall management tool for Linux systems that
provides a higher-level interface for configuring firewall rules. It is
built on top of nftables or iptables, depending on the system, and is
designed to simplify network security management through zones,
services, and a persistent configuration.

Introduced primarily for Red Hat-based distributions, firewalld is now
available on many Linux systems and is commonly used in modern
distributions such as Fedora, CentOS, and RHEL.

- **Zones**:

  - Define different levels of trust for network connections (e.g.,
    home, work, public).

  - Each zone has its own set of rules and configuration.

- **Dynamic Configuration**:

  - Changes to firewall rules are applied immediately without restarting
    the firewall service.

  - Supports temporary and permanent rule changes.

- **Service-Oriented**:

  - Predefined services (e.g., HTTP, SSH) simplify rule creation by
    mapping to specific ports and protocols.

- **Integration with** nftables **and** iptables:

  - Uses the underlying kernel packet filtering frameworks (nftables or
    iptables) for rule implementation.

- **GUI and CLI Tools**:

  - Provides both graphical and command-line interfaces for
    configuration.

- **Rich Language for Rules**:

  - Supports advanced rules like port forwarding, masquerading, and
    custom chains.

**Basic Commands**

- sudo firewall-cmd --get-active-zones → view active zones

- sudo firewall-cmd --zone=public --add-service=http → allow HTTP
  traffic temporarily

- sudo firewall-cmd --zone=public --add-service=http --permanent && sudo
  firewall-cmd --reload → allow HTTP traffic permanently

- sudo firewall-cmd --zone=public --remove-service=http --permanent &&
  sudo firewall-cmd --reload → remove a rule

- sudo firewall-cmd --zone=public --list-all → list rules for a zone

- sudo firewall-cmd --set-default-zone=home → set default zone

- sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent &&
  sudo firewall-cmd --reload → add a custom port

- sudo firewall-cmd --zone=external --add-masquerade --permanent && sudo
  firewall-cmd --reload → enable NAT for outgoing traffic

- sudo firewall-cmd --zone=public
  --add-forward-port=port=8080:proto=tcp:toport=80 --permanent && sudo
  firewall-cmd --reload → forwared traffic from one port to another

- sudo firewall-cmd --permanent --new-zone=myzone && sudo firewall-cmd
  --reload → create a new zone

- sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4"
  source address="192.168.1.100" accept' --permanent && sudo
  firewall-cmd --reload → add a rule to allow traffic from a specific
  IP.

**Configuration Files**

Firewalld stores its configuration files under /etc/firewalld/. Key
directories include:

- **Zones**: Zone configurations are stored in /etc/firewalld/zones/.

- **Services**: Service definitions are located in
  /usr/lib/firewalld/services/.

- **Defaults**: The default configuration file is
  /etc/firewalld/firewalld.conf.

### **27.2.4. fail2ban**

Fail2Ban is a security tool for Linux systems designed to protect
servers from brute force attacks and other types of unauthorized access
attempts. It monitors log files for specific patterns of failed login
attempts or suspicious activity and automatically takes action (e.g.,
banning an IP address) to prevent further malicious behavior.

Fail2Ban works by integrating with the system’s firewall (e.g., iptables
or nftables) to temporarily or permanently block offending IP addresses.
It is highly configurable, lightweight, and can protect various
services, including SSH, web servers, FTP servers, and more.

**How Does Fail2Ban Work?**

- **Monitoring Logs**:

  - Fail2Ban scans log files (e.g., /var/log/auth.log, /var/log/secure)
    for patterns of failed login attempts or other configurable
    triggers.

  - It uses regular expressions (regex) to identify suspicious activity.

- **Triggering an Action**:

  - When a predefined condition is met (e.g., several failed login
    attempts within a short time), Fail2Ban executes a predefined
    action.

  - Common actions include banning an IP using the system’s firewall or
    sending an alert to the administrator.

- **Temporary or Permanent Bans**:

  - Offending IP addresses are banned for a configurable period. Bans
    can also be made permanent if needed.

**Features of Fail2Ban**

- **Automatic Banning**:

  - Protects against brute force attacks by banning IPs after multiple
    failed attempts.

- **Customizable Filters**:

  - Define what constitutes “suspicious” behavior by editing
    configuration files.

- **Jails**:

  - Fail2Ban uses “jails” to define protection rules for specific
    services (e.g., SSH, HTTP).

  - Each jail specifies the log file to monitor, the regex patterns to
    match, and the action to take.

- **Email Alerts**:

  - Can send email notifications to administrators when an IP is banned.

- **Supports Multiple Services**:

  - Protects SSH, Apache/Nginx, FTP, MySQL, and other services.

- **Firewall Integration**:

  - Works seamlessly with iptables, nftables, and other firewalls.

**Basic Configuration**

- Default configuration: /etc/fail2ban/jail.conf

- It’s recommended to create a local copy to override defaults:
  /etc/fail2ban/jail.local

# 28. Swap Space

**Swap space** in Linux is a dedicated area on a storage device (disk or
SSD) that acts as virtual memory. When the system’s physical RAM (Random
Access Memory) is fully utilized, the operating system moves inactive
data from RAM to the swap space to free up RAM for active processes.
This helps maintain system stability and prevents programs from crashing
when memory is insufficient.

**Types of Swap Space**

- **Swap Partition**:

  - A dedicated disk partition reserved for swap.

  - Created and managed during disk partitioning (e.g., using fdisk or
    parted).

- **Swap File**:

  - A regular file on the file system that is used as swap space.

  - Useful for systems where creating a separate partition is not
    feasible.

**Comparison Table**

| **Aspect** | **Swap Partition** | **Swap Space** |
|----|----|----|
| Performance | Slightly faster (dedicated space) | Slightly slower (file system overhead; particularly on heavily fragmented file systems) |
| Flexibility | Fixed size, not easily resized | Easily resized or added dynamically |
| Ease of Management | Harder to manage (requires partitioning tools; and may involve reboot) | Easier to manage (Simple commands; can be added dynamically) |
| File System Dependency | Independent of file system; can be used in environments where the file system is not yet mounted or is corrupted. | Requires a functioning file system |
| Hibernation | more reliable for storing the entire system state during hibernation | Requires additional configuration. |
| Risk of Deletion | Very low | Can be accidentally deleted or moved |
| Disk Space Utilisation | Potentially wastes space | More efficient use of disk space |

**Advantages of Swap Space**

- **Memory Management**: Acts as an overflow for RAM, preventing “out of
  memory” errors.

- **System Stability**: Helps ensure the system remains operational even
  under high memory demand.

- **Hibernate Support**: Swap is used to store the contents of RAM when
  the system is put into hibernation.

**How Much Swap Space Should You Allocate?**

- For systems with **less than 2 GB RAM**: Swap should be at least equal
  to RAM.

- For systems with **2-8 GB RAM**: Swap can be half the size of RAM.

- For systems with **more than 8 GB RAM**: Swap is often minimal (2-4
  GB), unless hibernation is used.

**Configuring Swap Space**

- swapon --show && free -h → check existing swap space

- Swap Partition

  - Use a partitioning tool to create a partition and mark it as swap
    (type 82 in fdisk)

  - mkswap /dev/sdXn → initialise it for swap

  - swapon /dev/sdXn → Enable the swap partition

- Swap File

  - use fallocate or dd

    - fallocate -l 1G /swapfile create a swap file

    - dd if=/dev/zero of=/swapfile bs=1024 count=1048576 → use dd if
      fallocate is not available

  - chmod 600 /swapfile → set the correct permissions

  - mkswap /swapfile → initialise it as swap

  - swapon /swapfile → enable the swap file

- Make Swap Permanent by adding an entry into the /etc/fstab

  - /dev/sdXn none swap sw 0 0 → for swap partition

  - /swapfile none swap sw 0 0 → for swapfile

**Adjusting the Swappiness**

- Swappiness determines how aggressively the kernel swaps. Value ranges
  from 0 (minimum swapping) to 100 (maximum swapping).

  - cat /proc/sys/vm/swappiness → check the current value

  - sysctl vm.swappiness=10 → temporarily changes swappiness

- Priority: You can adjust priority to swap spaces. Higher priority ones
  is used first.

  - When activating swap you set the priority explicitly. e.g,

    - swapon /dev/sdX1 --priority 10

    - swapon /swapfile --priority 5

  - This can be set in the /etc/fstab as follows:

  - /dev/sdX1 none swap sw,pri=10 0 0

> /swapfile none swap sw,pri=5 0 0

- Default Priority: If no priority is specified, the system assigns a
  default priority value based on the order in which the swap spaces are
  activated.

# **29. System States**

## 29.1. Power States

- shutdown: Gracefully shuts down or reboots the system after notifying
  logged-in users and processes.

  - sudo shutdown now → shut down the system immediately

  - sudo shutdown -r now → reboot the system

  - sudo shutdown +10 → reboot after 10 mins

  - sudo shutdown -c → cancel a shutdown

- init: Changes the system’s runlevel (system state). It can be used to
  shut down, reboot, or switch to a different state. init is **largely
  deprecated** in modern Linux systems that use systemd as their init
  system

- reboot

- halt: Stops all processes and brings the system to a halt without
  powering it off. Equivalent to shutdown -H now

- poweroff: Powers off the system, halting all processes and turning off
  the machine.

  - sudo poweroff

- systemctl commands: On systems using systemd, systemctl is the
  preferred way to manage system power states.

  - sudo systemctl poweroff

  - sudo systemctl reboot

  - sudo systemctl halt

## **29.2. Run Levels**

System run levels in Linux (and Unix-like operating systems) are
predefined states that a system can operate in. Each run level
represents a specific configuration of system processes, services, and
the overall operational state of the machine.

Traditionally, run levels are associated with **SysVinit**-based
systems. However, modern Linux systems that use **systemd** have
replaced the concept of “run levels” with **targets**. Despite this, the
term “run level” is still used for historical and conceptual
understanding.

**Traditional Run Levels**

- sudo init 0 → system halt (shutdown)

- sudo init 1 → Single-user mode (for maintenance or rescue tasks)

- sudo init 2 → Multi-user mode without network services (on some
  distributions)

- sudo init 3 → Full multi-user mode with networking (text based
  interface, no gu)

- sudo init 4 → Undefined or user-definable (rarely used)

- sudo init 5 → Full multi-user mode with networking and GUI

- sudo init 6 → reboot

**Run Levels in systemd**

With **systemd**, the concept of run levels is replaced by **targets**,
which are more flexible and descriptive. Targets achieve similar goals
as run levels but are not limited to numerical values.

- poweroff.target → system halt (shutdown)

- rescue.target → single-user mode

- multi-user.target → multi-user mode

- graphical.target → full multi-user mode with networking and gui

- reboot.target → reboot the system

**Commands**

- systemctl get-default → view the current target (run-level)

- sudo systemctl set-default multi-user.target → change the default
  target

- sudo systemctl isolate graphical.target → switch to a target

- systemctl list-units --type=target → list available targets

# **30. Advanced Topics**

## **30.1. NFS**

**Network File System (NFS)** is a distributed file system protocol that
allows users to access files over a network as if they were located on
their local system. It enables seamless file sharing and resource access
between systems in a network.

### **30.1.1. How NFS Works**

- **NFS Server**: Exports directories over the network.

- **NFS Client**: Mounts the exported directories to a local directory,
  making them accessible.

- **Protocol**: NFS operates over **TCP** or **UDP**, with TCP being
  preferred for reliability.

- **RPC (Remote Procedure Call)**: NFS relies on RPC mechanisms to
  manage requests.

### **30.1.2. Setting Up NFS**

- On the server

  - Install NFS

    - sudo apt install nfs-kernel-server → For Debian-based systems

    - sudo yum install nfs-utils → \# For Red Hat-based systems

    - note: may need rpc-bind as well.

  - Edit /etc/exports to define shared directories and client
    permissions

    - /shared/directory client_IP(rw,sync,no_subtree_check)

  - Options:

    - rw: Read-write access.

    - ro: Read-only access.

    - sync: Writes data to disk before acknowledging.

    - no_subtree_check: Avoids subtree checking for better performance.

  - Start NFS Server

    - sudo systemctl start nfs-server && sudo systemctl enable
      nfs-server

  - Export Directories

    - sudo exportfs -a

- On the Client

  - Install NFS Utils

    - sudo apt install nfs-common → Debian-based

    - sudo yum install nfs-utils → Red Hat-based

  - showmount -e \<server_ip_or_hostname\> → view exported directories

  - sudo mount server_IP:/shared/directory /local/mount/point → mount
    the NFS share

  - Add to /etc/fstab for automatic mounting:

    - server_IP:/shared/directory /local/mount/point nfs defaults 0 0

- Securing NFS\* - TBD

## 30.2. Logical Volume Management (LVM)

**Logical Volume Management (LVM)** is a system for managing disk
storage that provides flexibility, scalability, and ease of use compared
to traditional partitioning methods. LVM allows you to create, resize,
and manage logical volumes abstracted from physical storage devices.

## 30.3. SELinux

**SELinux (Security-Enhanced Linux)** is a security architecture
integrated into the Linux kernel that provides **mandatory access
control (MAC)**. It was developed by the NSA (National Security Agency)
to enforce stricter control over processes, users, and applications,
preventing unauthorized access and mitigating the impact of
vulnerabilities.

### **30.3.1. How SELinux Works**

- **Traditional Linux Permissions:**

  - Uses discretionary access control (DAC), where owners of files
    control permissions.

  - Weakness: If a process is compromised, the attacker can inherit the
    permissions.

- **SELinux Mandatory Access Control (MAC):**

  - Applies additional policies that define what processes and users can
    do, regardless of DAC permissions.

  - Policies are enforced system-wide and cannot be overridden by
    regular users.

### **30.3.2. SELinux Modes**

- **Enforcing (default in most distributions):**

  - SELinux policies are enforced.

  - Access is denied if policies are violated.

  - Recommended for production systems.

- **Permissive:**

  - SELinux policies are not enforced, but violations are logged.

  - Useful for debugging and troubleshooting.

- **Disabled:**

  - SELinux is completely turned off.

  - Not recommended as it removes the security benefits of SELinux.

### **30.3.3. SELinux Policy Types**

- **Targeted Policy (default):**

  - Only specific processes (like web servers or databases) are confined
    by SELinux policies.

  - Easier to manage and widely used.

- **Strict Policy:**

  - Every process is confined.

  - Provides the highest level of security but is harder to manage.

### **30.3.4. Key SELinux Concepts**

- **Labels (Contexts):**

  - SELinux assigns labels to files, directories, and processes.

  - Each label has three components:

    - **User:** Role of the entity (e.g., system_u).

    - **Role:** Permissions (e.g., object_r for files).

    - **Type:** Defines the domain (e.g., httpd_t for web server
      processes).

  - Example of a file’s SELinux label:

  - ls -Z

> -rw-r--r--. root root unconfined_u:object_r:httpd_sys_content_t:s0
> index.html

- **Booleans:**

  - Booleans allow you to toggle specific SELinux features dynamically.

  - Example: Allowing Apache to connect to databases.

  - getsebool -a \| grep httpd

> setsebool -P httpd_can_network_connect on

- **Policy Rules:**

  - Define what actions are permitted or denied.

  - Written in SELinux policy language and compiled into binary format.

### **30.3.5. SELinux Tools**

- sestatus → check the status

- getenforce → Get current mode

- setenforce 0 → Set to Permissive

- setenforce 1 → Set to Enforcing

- ls -Z → viewing SELinux labels

- restorecon -Rv /var/www/html → relabeling files

- Troubleshooting

  - SELinux violations are logged in /var/log/audit/audit.log or
    /var/log/messages

  - ausearch -m avc -ts today

  - audit2why \< /var/log/audit/audit.log

- Generate custom policies to fix SELinux issues

- audit2allow -w -a

- audit2allow -a -M my_policy

> semodule -i my_policy.pp

- touch /.autorelabel && reboot → relabeling file system

- getsebool -a → listing SELinux Booleans

## **30.4. systemd-analyze Command**

The systemd-analyze command is a diagnostic and troubleshooting tool
provided by the **systemd** init system. It is primarily used to analyze
and optimize the Linux boot process, but it also provides insights into
system performance related to services and dependencies.

### **30.4.1. Key Features**

- systemd-analyze → Displays the time taken by each stage of the boot
  process, including:

  - **Firmware** initialization (BIOS/UEFI)

  - **Kernel** initialization.

  - **Initrd** (Initial RAM Disk) setup.

  - Startup of **services** and units.

- systemd-analyze plot \> boot-process.svg → Creates a graphical
  visualization of the boot process. Useful for identifying slow
  services or units.

- systemd-analyze critical-chain → Displays a timeline of the most
  time-consuming units during boot, arranged in a critical chain.

- systemd-analyze blame → Lists all services and units that were started
  during boot, sorted by the time they took to start.

- systemd-analyze verify /lib/systemd/system/ssh.service → Checks unit
  files for syntax and configuration errors.

- systemd-analyze dot network.target \| dot -Tsvg \> dependencies.svg →
  Displays the dependency tree of a specific unit.

- systemd-analyze security sshd.service → Analyzes the security
  hardening features of a specific service.

## 30.5. Other Advance Features/Services

- **Stratis**

  - Stratis is a Linux storage management solution designed to simplify
    the creation, management, and monitoring of complex storage setups.
    It provides advanced features like snapshots, thin provisioning, and
    easy volume management without requiring in-depth knowledge of
    traditional storage technologies like Logical Volume Manager (LVM)
    or Btrfs.

- **RAID**

  - RAID (Redundant Array of Independent Disks) is a data storage
    virtualization technology that combines multiple physical disk
    drives into a single logical unit to improve performance, provide
    redundancy, or both. RAID configurations use techniques like
    striping, mirroring, and parity to achieve their goals.

- **Samba**

  - **Samba** is an open-source software suite that enables **file
    sharing**, **print services**, and **authentication** between
    Linux/Unix systems and Windows systems. It implements the **SMB
    (Server Message Block)** and **CIFS (Common Internet File System)**
    protocols, allowing interoperability in mixed environments.

- **NAS Device**

  - **NAS (Network Attached Storage)** is a storage solution that
    provides centralized data storage and file sharing over a network.
    It acts as a dedicated file server, enabling users and devices
    within a network to access, store, and manage data efficiently.

- **SATA and SAS**

- MySql and MariaDB

- **FTP Server**

  - vsftp (server)

  - ftp (client command)

- **NTP (Network Time Protocol)**

  - **NTP (Network Time Protocol)** is a networking protocol used to
    synchronize the clocks of devices (computers, servers, routers,
    etc.) over a network. It ensures that all devices in a network
    maintain accurate and consistent time, which is crucial for various
    applications, including logging, authentication, and data
    consistency.

  - Implementations:

    - ntpd **(Network Time Protocol Daemon)** is a traditional, widely
      used service that implements the **Network Time Protocol (NTP)**
      to synchronize the system clock of a computer or networked device
      with time servers. It adjusts the system’s time and keeps it
      accurate over long periods by querying remote time servers,
      typically over the internet or a local network.

    - **Chronyd** is a versatile and robust implementation of the
      **Network Time Protocol (NTP), a modern alternative to nptd**. It
      is part of the **Chrony** software package and serves as an
      alternative to the traditional ntpd (Network Time Protocol
      daemon). Chronyd is particularly well-suited for systems that are
      often offline, operate in virtualized environments, or require
      fast synchronization.

- The **“Message of the Day” (MOTD)** in Linux is a feature that
  displays a message to users upon logging into the system. It is
  typically used to convey important information, updates, or
  administrative notices to users.

  - Static MOTD: /etc/motd contains the static text that is displayed
    when a user logs in

  - Dynamic MOTD: Scripts in /etc/update-motd.d/ can be added, modified,
    or removed to customize dynamic messages.

    - sudo vi /etc/update-motd.d/10-mydate

    - \#!/bin/bash

> echo "Today is \$(date)"

- sudo chmod +x /etc/update-motd.d/10-mydate

- sudo chmod -x /etc/update-motd.d/\* → disable dynamic MOTD

<!-- -->

- **Mail**

  - Workflow:

    - **Compose**: A user composes an email in an MUA (Mail User Agent,
      eg: Outlook).

    - **Send**: The MUA sends the email to the configured MTA (Mail
      Transfer Agent) using SMTP (Simple Mail Transfer Protocol).

    - **Route**: The MTA routes the email to the recipient’s MTA.

    - **Deliver**: The recipient’s MTA (Mail Transfer Agent) passes the
      email to an MDA, which delivers it to the recipient’s mailbox.

    - **Retrieve**: The MUA (Mail User Agent) connects to the email
      server using POP3 or IMAP.

    - **Read**: The user reads emails stored on the server or downloads
      them to the local system.

  - Common Softwares

    - Postfix (MTA)

    - Dovcot (IMAP/POP3)

    - mail, mutt or Thunderbird (GUI) - (MUA)

- **Web Server**

  - Popular web-servers

    - Apache - httpd

    - nginx

- **Central Logger (rsyslog)**

- **OpenLDAP**

- **Docker**

- **podman**

  - Podman (short for **Pod Manager**) is an open-source container
    management tool for Linux that provides a lightweight and daemonless
    alternative to Docker. It is designed to manage and run containers
    and pods (groups of containers that share networking and storage) on
    Linux systems. Podman is a part of the **libpod** library, which
    provides container lifecycle management functionality.

- **Automating Linux Installation**

  - RHEL-based systems (CentOS, Rocky Linux, Fedora): Kickstart,
    Cobbler.

  - Ubuntu/Debian

    - Preseed: for older versions of Debian or Ubuntu.

    - Autoinstall: for Ubuntu Server 20.04 and later.

    - FAI: fully automated installation and deployment of Debian and
      Ubuntu systems.

  - Cloud Environments: Cloud-init, Terraform, Ansible

  - SUSE: AutoYaST.

- **openVPN**

- **DHCP**

- **Proxy Server (Squid)**

- **Cockpit:** Cockpit is a web-based system management tool for Linux
  servers and desktops. It provides an intuitive graphical interface to
  manage and monitor Linux systems, making tasks like system
  administration and troubleshooting easier for both beginners and
  experienced administrators. Cockpit is lightweight, modular, and
  designed to integrate seamlessly with existing Linux services and
  tools. It supports real-time monitoring and interactive management,
  allowing administrators to perform various tasks without needing to
  rely entirely on the command line.

  - Web-based interface may be a security concern if not properly
    secured.

- **Bootstrap**

  - **BIOS/UEFI** → Firmware initializes hardware and locates
    bootloader.

  - **Bootloader** → Loads the Linux kernel and passes control to it.

  - **Kernel** → Initializes system and mounts the root filesystem.

  - **init/systemd** → Starts user-space processes, services, and
    targets.

  - **User Login** → The system is ready for use.

- **masscan**: masscan is a high-performance port scanner known for its
  speed and ability to scan the entire internet in minutes. It’s often
  compared to nmap but is designed specifically for very fast scans.
  While masscan is extremely efficient, it has limited functionality
  compared to nmap, as it primarily focuses on identifying open ports.

# 31. Further Notes to read

**Other:**

- do the quiz on the udemy course

- split

- export

- env

- umask

**Networking**

- IP

- Subnet Mask

- Gateway

- Static vs DHCP

- Interface

- MacAddress

- Transport Layers

- Other protocols

TODO:

- Tally up the documents with the response from chatGPT on “What are all
  the system utility commands in Linux”

- htop

- iotop

- iptraf

- psacct

- socket vs pipe

- find /path/to/search -type f -exec file {} \\

- Rename files to Title Case: rename 's/(\S+)/\u\L\$1/g' \*

- ClamAV

- file system integrity monitoring

Interface Configuration Files

- /etc/nsswitch.conf

- /etc/hostname

- /etc/sysconfig/network

- /etc/sysconfig/network-scripts/ifcfg-nic

- /etc/resolve.conf

Note: see NIC Information & NIC or Port Bonding sections in the udemy
course

NIC\* (Network Interface Card)

- ifconfig

  - eth0

  - lo

  - vir0

  - other?

- ethtool

NIC Bonding: Configure two NICs to one for a) redundancy b) speed

- modprobe bonding

- modinfo bonding

- /etc/sysconfig/network-scripts/ethernet1

- /etc/sysconfig/network-scripts/ethernet2

Network Utilities

- nmtui - network manager - text user inferface

- nmcli - network manager - command line interface

TODO

- Configure cheat or tldr with commonly used syntaxes on popular
  commands
