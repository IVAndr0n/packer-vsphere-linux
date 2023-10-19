# ------------------------------------------------------------------------------
# Name:           template-linux-ubuntu_vsphere.pkr.hcl
# Description:    Packer Template for VMware vSphere and Linux Ubuntu OS
# Code revision:  Andrey Eremchuk, https://github.com/IVAndr0n/
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
#                                  Packer Block
# ------------------------------------------------------------------------------
packer {
    required_version = ">= 1.9.4"
    required_plugins {
        vsphere = {
            version = ">= v1.2.1"
            source  = "github.com/hashicorp/vsphere"
        }
    }
}

# ------------------------------------------------------------------------------
#                                  Local Variables Block
# ------------------------------------------------------------------------------
locals { 
    built_by                    = "HashiCorp Packer ${packer.version}"
    build_version               = formatdate("YY.MM", timestamp())
    build_date                  = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
    vm_os                       = coalesce(join("-", compact([var.vm_os_family, var.vm_os_short_name, var.vm_os_bit])), "${var.vm_guest_os_type}")
    vm_name                     = "${join("-", compact([local.vm_os, local.build_version]))}"
    vm_description              = <<-EOT
                                    Operating System: ${local.vm_os}
                                    Created: ${local.build_date}
                                    Build Version: ${local.build_version}
                                    Built By: ${local.built_by}
                                    Description: Linux Ubuntu install image for VMware vSphere.
                                EOT
    manifest_path               = "${path.cwd}/manifests"
    manifest_file               = "manifest-${local.vm_os}.json"
}

# ------------------------------------------------------------------------------
#                                  Source Block
# ------------------------------------------------------------------------------
source "vsphere-iso" "setup" {
    # vSphere Configuration
    vcenter_server              = var.vcenter_server
    username                    = var.vcenter_username
    password                    = var.vcenter_password
    insecure_connection         = var.vcenter_insecure
    datacenter                  = var.vcenter_datacenter
    cluster                     = var.vcenter_cluster
    datastore                   = var.vcenter_datastore
    folder                      = var.vcenter_folder

    # vSphere Content Library and Template Configuration
    convert_to_template         = var.vcenter_convert_template
    create_snapshot             = var.vcenter_snapshot
    snapshot_name               = var.vcenter_snapshot_name
    dynamic "content_library_destination" {
        for_each = var.vcenter_content_library != null ? [1] : []
            content {
                library         = var.vcenter_content_library
                name            = "${local.vm_name}"
                description     = local.vm_description
                ovf             = var.vcenter_content_library_ovf
                destroy         = var.vcenter_content_library_destroy
                skip_import     = var.vcenter_content_library_skip
            }
    }

    # Virtual Machine Options
    vm_name                     = local.vm_name
    notes                       = local.vm_description
    vm_version                  = var.vm_hardware_version
    guest_os_type               = var.vm_guest_os_type
    CPUs                        = var.vm_numvCPUs
    cpu_cores                   = var.vm_coresPerSocket
    CPU_hot_plug                = var.vm_cpu_hotadd
    RAM                         = var.vm_mem_size
    RAM_reserve_all             = var.vm_mem_reserve_all
    RAM_hot_plug                = var.vm_mem_hotadd
    storage {
        disk_size               = var.vm_disk_size
        disk_thin_provisioned   = var.vm_disk_thin
    }
    disk_controller_type        = var.vm_disk_controller
    network_adapters {
        network_card            = var.vm_nic_type
        network                 = var.vcenter_network
    }
    cdrom_type                  = var.vm_cdrom_type
    video_ram                   = var.vm_video_ram
    vTPM                        = var.vm_vtpm
    firmware                    = var.vm_firmware
    tools_upgrade_policy        = var.vm_tools_upgrade_policy

    # vSphere Removable media configuration
    iso_paths                   = [ "[${var.os_iso_datastore}] ${var.os_iso_path}/${var.os_iso_file}", "${var.vm_tools}" ]
    floppy_files                = var.floppy_files
    cd_content                  = {
                                    "meta-data" = file("${abspath(path.root)}/boot_config/meta-data")
                                    "user-data" = templatefile("${abspath(path.root)}/boot_config/${var.boot_config}", {
                                        vm_os_short_name             = var.vm_os_short_name
                                        os_language                  = var.os_language
                                        os_keyboard                  = var.os_keyboard
                                        os_timezone                  = var.os_timezone
                                        build_username               = var.build_username
                                        build_password_encrypted     = var.build_password_encrypted
                                    })
                                  }
    cd_files                    = var.cd_files
    cd_label                    = var.cd_label
    remove_cdrom                = var.vm_cdrom_remove

    # Builder Options
    boot_order                  = var.vm_boot_order
    boot_wait                   = var.vm_boot_wait
    boot_command                = [ "c<wait>",
                                    "linux /casper/vmlinuz --- autoinstall",
                                    "<enter><wait>",
                                    "initrd /casper/initrd",
                                    "<enter><wait>",
                                    "boot",
                                    "<enter>" ]
    ip_wait_timeout             = var.vm_ip_timeout
    communicator                = "ssh"
    ssh_username                = var.build_username
    ssh_password                = var.build_password
    ssh_timeout                 = "30m"
    shutdown_command            = "echo '${ var.build_password }' | sudo shutdown -h now"
    shutdown_timeout            = var.vm_shutdown_timeout
}

# ------------------------------------------------------------------------------
#                                  Build Block
# ------------------------------------------------------------------------------
build {
    # Build sources
    name                        = local.vm_os
    sources                     = [ "source.vsphere-iso.setup" ]

    # Shell Provisioner to execute scripts
    provisioner "shell" {
        execute_command         = "echo '${ var.build_password }' | {{.Vars}} sudo -E -S sh -eu '{{.Path}}'"
        scripts                 = var.script_files
        environment_vars        = [ "BUILDUSER=${var.build_username}" ]
    }

    # Creating manifest
    post-processor "manifest" {
        output                  = "${local.manifest_path}/${local.manifest_file}"
        strip_path              = true
        strip_time              = true
        custom_data             = {
          "A. Built By"         = local.built_by
          "B. Created"          = local.build_date
          "C. vCenter Server"   = var.vcenter_server
          "D. Template Folder"  = var.vcenter_folder
          "E. Number of vCPU"   = var.vm_numvCPUs
          "F. Cores Per Socket" = var.vm_coresPerSocket
          "G. Disk"             = var.vm_disk_size
          "H. Memory"           = var.vm_mem_size
        }
    }
}