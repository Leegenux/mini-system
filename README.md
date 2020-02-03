# Introduction

This project is my customization of Linux running on a ramdisk called **mini-system**.

Automation scripts are provided and you can find out how my project works by looking into those scripts.

# Targets

All the targets are only tested on my TM1701 Laptop and VMWare Workstation.

Features tested on my laptop only:

- [x] Intel Wireless Card
- ...

Tested on both:

- [x] systemd
- [x] NTFS, FAT, EXT4 ,BTRFS and XFS support
- [x] fdisk
- [x] ssh, scp
- [x] vim
- [x] ip, dhclient, wpa_cli ...
- ...

# Directory Structure

```
.
├── installation
│   ├── boot_part
│   ├── efi_part
│   ├── install.sh
│   ├── mount_point
│   └── README.md
└── README.md
```

# Users

You should login as `root` to use all the utilities provided, whose password is `123456`.
