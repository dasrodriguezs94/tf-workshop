output "instance_public_ips" {
  value = aws_instance.workshop_instance.*.public_ip
}

output "workshop_user_access_keys" {
  value = aws_iam_access_key.workshop_user_key.*.id
  sensitive = true
}

output "workshop_user_secret_keys" {
  value = aws_iam_access_key.workshop_user_key.*.secret
  sensitive = true
}
