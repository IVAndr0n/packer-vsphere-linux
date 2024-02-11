---
layout: post
title: Automatically create Linux virtual machine images using Packer
date: 2023-10-21
categories:
  - hashicorp
---

<!-- # Project: packer-vsphere-linux -->

The project contains a directory of files for automatically creating images of virtual machines based on Linux operating systems using Packer, including configuration files, configuration scripts, and image build scripts

## Repository structure

```sh
$ tree --dirsfirst -F
.
├── ubuntu/
│   ├── boot_config/
│   │   ├── meta-data
│   │   └── user-data.pkrtpl.hcl
│   ├── manifests/
│   ├── scripts/
│   │   └── config.sh
│   ├── build_all_linux-ubuntu_with_duration_record_parallel.ps1   
│   ├── build_all_linux-ubuntu_with_duration_record_sequential.ps1 
│   ├── build_all_linux_ubuntu_without_duration_record_parallel.cmd
│   ├── linux-ubuntu2004-x64_vsphere.pkrvar.hcl
│   ├── linux-ubuntu2204-x64_vsphere.pkrvar.hcl
│   ├── template-linux-ubuntu_vsphere.pkr.hcl
│   └── variables_vsphere.pkr.hcl
└── README.md

4 directories, 11 files
```

## Tested build of the following versions of Linux with Packer

* Ubuntu 20.04 x64
* Ubuntu 22.04 x64

## Additional information

[**mkpasswd**](https://gist.github.com/noraj/3b05c0efa57e045afb60e7016662342f)

Note: mkpasswd binary is installed via the package whois on Debian / Ubuntu only. On other Linux distribution such as ArchLinux, Fedora, CentOS, openSUSE, etc. mkpasswd is provided by the expect package but is an totally different utility which is available as expect_mkpasswd on Debian / Ubuntu.

```sh
apt update
apt install whois
mkpasswd --method=SHA-512 --rounds=4096 '<password>'
```
