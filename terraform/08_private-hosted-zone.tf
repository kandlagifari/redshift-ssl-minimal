resource "aws_route53_zone" "redshift-r53" {
  name = "kafuuchino.com"

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "redshift-ns" {
  zone_id = aws_route53_zone.redshift-r53.zone_id
  name    = "redshift-ssl.kafuuchino.com"
  type    = "CNAME"
  ttl     = 300
  records = [module.redshift-ssl-cluster.cluster_dns_name]
}
