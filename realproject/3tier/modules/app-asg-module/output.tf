output "web_scaling_groupe" {
  value = aws_autoscaling_group.web_scaling_group.id
}
output "web_template" {
    value = aws_launch_template.web_template.id
}