#cloud-config
autoinstall:
  version: 1
  apt:
    geoip: true
    preserve_sources_list: false
    primary:
      - arches: [amd64, i386]
        uri: http://archive.ubuntu.com/ubuntu
      - arches: [default]
        uri: http://ports.ubuntu.com/ubuntu-ports
  early-commands:
    - sudo systemctl stop ssh # otherwise packer tries to connect and exceed max attempts
  locale: ${os_language}
  keyboard:
    layout: ${os_keyboard}
  storage:
    layout:
      name: lvm
  identity:
    hostname: ${vm_os_short_name}
    username: ${build_username}
    password: ${build_password_encrypted}
  ssh:
    install-server: true
    allow-pw: true
  packages:
    - cloud-init
    - curl
    - net-tools
    - open-vm-tools
    - openssh-server
  user-data:
    package_update: true
    package_upgrade: true
    package_reboot_if_required: true
    disable_root: false
    timezone: ${os_timezone}
  late-commands:
    - sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config
    - echo '${build_username} ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/${build_username}
    - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/${build_username}