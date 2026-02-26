output "load_balancer_security_group" {
    value = aws_security_group.load_balancer_security_group.id
}
output "web_target_group" {
    value = aws_lb_target_group.web_target_group.arn
}
output "application_lb"{
    value = aws_lb.application_lb.id
}
output "app_listener" {
    value = aws_lb_listener.app_listener.id
}
