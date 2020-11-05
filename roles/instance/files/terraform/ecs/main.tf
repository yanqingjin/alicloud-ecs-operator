data "alicloud_instance_types" "types_ds" {
  cpu_core_count = 1
  memory_size    = 2
  availability_zone = var.availability_zone
}

data "alicloud_vswitches" "default" {
  zone_id = var.availability_zone
  vpc_id = var.vpc_id
}

resource "alicloud_security_group" "group" {
  name        = "tf_test_foo"
  description = "foo"
  vpc_id      = var.vpc_id
}

resource "alicloud_instance" "instance" {
  security_groups   = alicloud_security_group.group.*.id

  instance_type              = "ecs.n4.large"
  system_disk_category       = "cloud_efficiency"
  system_disk_name           = "test_foo_system_disk_name"
  system_disk_description    = "test_foo_system_disk_description"
  image_id                   = "ubuntu_18_04_64_20G_alibase_20190624.vhd"
  instance_name              = var.name
  vswitch_id                 = data.alicloud_vswitches.default.vswitches.0.id
}