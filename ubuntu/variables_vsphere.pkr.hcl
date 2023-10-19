# ------------------------------------------------------------------------------
# Name:           variables_vsphere.pkr.hcl
# Description:    Definition of Packer variables for VMware vSphere
# Code revision:  Andrey Eremchuk, https://github.com/IVAndr0n/
# ------------------------------------------------------------------------------

# vSphere Configuration
variable "vcenter_server" {
  type        = string
  description = "FQDN of vCenter Server for build creation"
}
variable "vcenter_username" {
  type        = string
  description = "Packer username for vCenter connection"
  sensitive   = true
}
variable "vcenter_password" {
  type        = string
  description = "Packer password for vCenter connection"
  sensitive   = true
}
variable "vcenter_insecure" {
  type        = bool
  description = "Disable vCenter Server TLS certificate validation"
  default     = true
}
variable "vcenter_datacenter" {
  type        = string
  description = "Name of vSphere datacenter for build creation"
}
variable "vcenter_cluster" {
  type        = string
  description = "Name of vSphere cluster for build creation"
}
variable "vcenter_datastore" {
  type        = string
  description = "Name of vSphere datastore for build creation"
}
variable "vcenter_network" {
  type        = string
  description = "Name of vSphere network for build creation"
}
variable "vcenter_folder" {
  type        = string
  description = "Folder path in vCenter for build creation"
}

# vSphere Content Library and Template Configuration
variable "vcenter_convert_template" {
  type        = bool
  description = "Convert created VM to template"
  default     = true
}
variable "vcenter_snapshot" {
  type        = bool
  description = "Should a snapshot of the virtual machine be created"
  default     = false
}
variable "vcenter_snapshot_name" {
  type        = string
  description = "Snapshot name for the virtual machine"
  default     = "Created by Packer"
}
variable "vcenter_content_library" {
  type        = string
  description = "Content Library name to export virtual machine to"
  default     = null
}
variable "vcenter_content_library_ovf" {
  type        = bool
  description = "Export virtual machine to content library as an OVF template"
  default     = false
}
variable "vcenter_content_library_destroy" {
  type        = bool
  description = "Delete the virtual machine after successful export to a Content Library"
  default     = true
}
variable "vcenter_content_library_skip" {
  type        = bool
  description = "Skip adding VM to Content Library"
  default     = true
}

# Virtual Machine Options
variable "vm_hardware_version" {
  type        = number
  description = "VMs use latest compatible hardware version with vCenter Server. Refer to VMware KB 1003746 for supported hardware versions"
  default     = null
}
variable "vm_guest_os_type" {
  type        = string
  description = "Guest operating system type (or guest ID) in vSphere"
}
variable "vm_numvCPUs" {
  type        = number
  description = "Number of CPU cores"
  default     = 2
}
variable "vm_coresPerSocket" {
  type        = number
  description = "Number of CPU cores per socket"
  default     = 1
}
variable "vm_cpu_hotadd" {
  type        = bool
  description = "Enable CPU hot-add for VM"
  default     = false
}
variable "vm_mem_size" {
  type        = number
  description = "Virtual machine memory size in MB"
  default     = 2048
}
variable "vm_mem_reserve_all" {
  type        = bool
  description = "Reserve all allocated memory for VM"
  default     = false
}
variable "vm_mem_hotadd" {
  type        = bool
  description = "Enable memory hot-add for VM"
  default     = false
}
variable "vm_disk_size" {
  type        = number
  description = "Virtual machine disk size in MB"
  default     = 40960
}
variable "vm_disk_thin" {
  type        = bool
  description = "Set system disk thin provisioning to 'true' for dynamic storage allocation or 'false' for full allocation"
  default     = true
}
variable "vm_disk_controller" {
  type        = list(string)
  description = "Ordered list of disk controller types to add to VM (e.g. one or more of 'pvscsi', 'scsi', etc.)"
  default     = ["pvscsi"]
}
variable "vm_nic_type" {
  type        = string
  description = "Virtual machine network card type (e.g. 'e1000e' or 'vmxnet3')"
  default     = "vmxnet3"
}
variable "vm_cdrom_type" {
  type        = string
  description = "Type of CD-ROM drive to add to VM (e.g. 'sata' or 'ide')"
  default     = "sata"
}
variable "vm_video_ram" {
  type        = number
  description = "Virtual machine video memory size in KB"
  default     = 4096
}
variable "vm_vtpm" {
  type        = bool
  description = "Add virtual Trusted Platform Module (vTPM) device to VM"
  default     = false
}
variable "vm_firmware" {
  type        = string
  description = "Virtual machine firmware type: 'efi', 'efi-secure', or 'bios'"
  default     = "efi-secure"
}
variable "vm_tools_upgrade_policy" {
  type        = bool
  description = "vSphere automatically checks and upgrades VMware Tools during a system power cycle"
  default     = false
}

# vSphere Removable media configuration
variable "vm_tools" {
  type        = string
  description = "Path to VMware Tools ISO in the datastore (e.g. '[]/vmimages/tools-isoimages/linux.iso')"
}
variable "os_iso_datastore" {
  type        = string
  description = "Name of vSphere datastore containing the source OS media"
}
variable "os_iso_path" {
  type        = string
  description = "Source vSphere datastore path for ISO images"
}
variable "os_iso_file" {
  type        = string
  description = "Vendor ISO file name"
}
variable "floppy_files" {
  type        = list(string)
  description = "Files for VM boot floppy"
  default     = []
}
variable "cd_files" {
  type        = list(string)
  description = "List of files for CD attached on VM boot"
  default     = []
}
variable "cd_content" {
  type        = map(string)
  description = "Can be used with cd_files to add large files without loading them into memory (cd_content takes priority)"
  default = {}
}
variable "cd_label" {
  type        = string
  description = "CD/DVD label for virtual machine's CD-ROM drive"
  default     = "cidata"
}
variable "vm_cdrom_remove" {
  type        = bool
  description = "Should CD-ROM drives be removed after provisioning"
  default     = true
}

# Guest OS Options
variable "os_image_name" {
  type        = string
  description = "Windows image name to build"
}
variable "os_product_key" {
  type        = string
  description = "Windows activation product key"
}
variable "os_language" {
  type        = string
  description = "Guest operating system language"
}
variable "os_keyboard" {
  type        = string
  description = "Keyboard input language of the guest operating system"
}
variable "os_timezone" {
  type        = string
  description = "Guest operating system timezone"
  default     = "UTC"
}
variable "os_built-in_admin_password" {
  type        = string
  description = "Built-in Administrator Password"
  sensitive   = true
}
variable "os_built-in_admin_username" {
  type        = string
  description = "Built-in Administrator Username, e.g. 'root' for Linux or 'Administrator' for en-us Windows"
  sensitive   = true
  default     = null
}

# Builder Options
variable "vm_os_family" {
  type        = string
  description = "Operating system family (windows, linux, etc.)"
  default     = null
}
variable "vm_os_short_name" {
  type        = string
  description = "Abbreviated OS name (e.g. '11-pro', 'server-2022-std-core', 'ubuntu-22-04-2-lts', 'centos-8-stream', etc.)"
  default     = null
}
variable "vm_os_bit" {
  type        = string
  description = "Operating system bit depth ('x86', 'x64')"
  default     = null
}
variable "vm_boot_order" {
  type        = string
  description = "Virtual machine boot order in comma-separated format (e.g. 'disk,cdrom')"
  default     = "disk,cdrom"
}
variable "vm_boot_wait" {
  type        = string
  description = "Time for virtual machine to wait after booting before sending boot command (e.g. '1h5m2s' or '2s')"
  default     = "2s"
}
variable "boot_config" {
  type        = string
  description = "Name of the unattended installation file (e.g. 'Autounattend.pkrtpl.hcl', 'ks.pkrtpl.hcl', 'user-data.pkrtpl.hcl')"
}
variable "vm_ip_timeout" {
  type        = string
  description = "Virtual machine timeout for obtaining an IP address (e.g. '1h5m2s' or '2s')"
  default     = "45m"
}
variable "vm_shutdown_timeout" {
  type        = string
  description = "Virtual machine timeout for shutting down after issuing the shutdown command (e.g. '1h5m2s' or '2s')"
  default     = "1h55m"
}
variable "build_username" {
  type        = string
  description = "Guest operating system login username"
  sensitive   = true
}
variable "build_password" {
  type        = string
  description = "Guest operating system login password"
  sensitive   = true
}
variable "build_password_encrypted" {
    type        = string
    description = "Encrypted password for the 'build_username'"
    sensitive   = true
    default     = null
}
variable "build_ansible_user" {
    type        = string
    description = "Name of the user to be used by Ansible"
    sensitive   = true
    default     = null
}
variable "build_ansible_key" {
    type        = string
    description = "SSH key for the Ansible user"
    sensitive   = true
    default     = null
}
variable "rhsm_user" {
    type        = string
    description = "RedHat Subscription Manager username"
    sensitive   = true
    default     = null
}
variable "rhsm_pass" {
    type        = string
    description = "RedHat Subscription Manager password"
    sensitive   = true
    default     = null
}

# Provisioner actions
variable "script_files" {
  type        = list(string)
  description = "List of OS scripts to execute"
  default     = []
}
variable "inline_cmds" {
  type        = list(string)
  description = "List of OS commands to execute"
  default     = []
}