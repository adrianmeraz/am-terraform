resource "aws_security_group" "allow_tls" {
  tags = var.tags

  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  cidr_ipv4         = var.cidr_ipv4
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  security_group_id = aws_security_group.allow_tls.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  cidr_ipv6         = var.cidr_ipv6
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  security_group_id = aws_security_group.allow_tls.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
