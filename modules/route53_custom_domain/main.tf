locals {
  fqdn = "${var.subdomain_name}.${var.domain_name}"
}

resource "aws_acm_certificate" "main" {
  # Added second us-east-1 provider per: https://github.com/hashicorp/terraform/issues/10957#issuecomment-269653276
  # provider = aws.acm

  domain_name       = lower(local.fqdn)
  validation_method = "DNS"

  tags = var.tags
}

data "aws_route53_zone" "public" {
  name         = var.domain_name
  private_zone = false
}

### Record added for DNS Validation

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public.zone_id

  lifecycle {
    ignore_changes = [zone_id]
  }
}

resource "aws_acm_certificate_validation" "main" {
  # Added second us-east-1 provider per: https://github.com/hashicorp/terraform/issues/10957#issuecomment-269653276
  # provider = aws.acm

  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : lower(record.fqdn)]
}

### Create Route 53 Records

resource "aws_api_gateway_domain_name" "main" {
  # Changed to regional per: https://stackoverflow.com/a/57681383
  domain_name = lower(local.fqdn)
  regional_certificate_arn = aws_acm_certificate.main.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  depends_on = [aws_acm_certificate_validation.main]

  tags = var.tags
}

resource "aws_route53_record" "main" {
  name    = aws_api_gateway_domain_name.main.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.public.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.main.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.main.regional_zone_id
  }

  lifecycle {
    ignore_changes = [zone_id]
  }
}

resource "aws_api_gateway_base_path_mapping" "main" {
  api_id = var.api_gateway_id
  domain_name = aws_api_gateway_domain_name.main.id
  stage_name = var.stage_name
}