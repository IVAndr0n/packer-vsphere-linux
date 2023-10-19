# ------------------------------------------------------------------------------
# Name:           linux-ubuntu2204-x64_vsphere.pkrvar.hcl
# Description:    Required Packer Variables for VMware vSphere and Linux OS
# Code revision:  Andrey Eremchuk, https://github.com/IVAndr0n/
# ------------------------------------------------------------------------------

# Virtual Machine Options
vm_guest_os_type            = "ubuntu64Guest"
vm_numvCPUs                 = 1
vm_coresPerSocket           = 1
vm_mem_size                 = 2048
vm_disk_size                = 32768
vm_disk_controller          = ["pvscsi"]
vm_video_ram                = null
vm_vtpm                     = false
vm_firmware                 = "efi-secure"

# Images
vm_tools                    = "[] /vmimages/tools-isoimages/linux.iso"
os_iso_path                 = "ISO/Linux"
os_iso_file                 = "ubuntu-22.04.2-live-server-amd64.iso"

# Guest OS Options
os_image_name               = ""
os_product_key              = ""
os_language                 = "en_US.UTF-8"
os_keyboard                 = "us"
os_timezone                 = "Europe/Minsk"

# Builder Options
vm_os_family                = "linux"
vm_os_short_name            = "ubuntu-22-04-2-lts"
vm_os_bit                   = "x64"
boot_config                 = "user-data.pkrtpl.hcl"
floppy_files                = []
cd_files                    = []
script_files                = ["scripts/config.sh"]
inline_cmds                 = []