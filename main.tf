resource "aws_key_pair" "eks" {
  key_name   = "eks"
  #you can paste the public key directly like this
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCh+L6J1cw+r9UFsSXljbUKpvf6sMAhJsbHoyYcFZ1WpFtKnDGLgnn2I3T6Zc3lOKlMFV5tKW0PjknPyu1ImsK3BP697gqN8dTXhhTiKzanXoT1m047ecoN54S9jl8QVSKl7RU9Ph1PdFUI/AeEyQc6NcLXI7Anaq5lk6NTEdXG6Y6yPGMkLZXoUyG8H4l4X6fjv6CjxGxoafoylV7ug3jfFI/kmLmjz7O34/fxVs2m0Y90RqRbpRXANhMlQf1Jy1wrOkdRhtn0c3+qlCgHgubutmjPEan7iWd6HmNzO1SRlohLzKrFM1i5BOfwLsk8UUo/n6LoYOEUYhRqB3c13weYskI1oMrbj6oNv6+dQFww0QDMXYfWG5PnkudemZWKgh7h1t15nEq5gKOmv7xSj2z6wDZyUFells9ephlDxpgNA6xny/U/PRaf7e3sc6VD2nPOGzFQExrkqHzFm+57xQukxowYqN0qAqhq61EKLvsY0JrUacJ1LUktJJT8M5CcgreXocmLl42Lqj/PBkqqLU6edzA573V86A0ZAd7+wSqGQvezrPjdRGMO6ATOv/6ejjeNQ154QXia9OtUQRvc6Slq2yhUdF8MewWyPGzKskGZPDiBmD+2hwEXgKeHtKgeCJY40WWVG/FQfDzrkrCT7YEMZ/dq4inG78xaoGmez8kzsQ== Tejaswini A@LAPTOP-UT494P6R"
#   public_key = file("~/.ssh/eks.pub")

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"


  cluster_name    = "${var.project_name}-${var.environment}"
  cluster_version = "1.31"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = "vpc-056cc33b9ab2530c6"
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  create_cluster_security_group = false
  cluster_security_group_id     = "sg-00acd1a6a04d124ca"

  create_node_security_group = false
  node_security_group_id     = "sg-08e841782ad95ae5c"

 
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    blue = {
      min_size      = 2
      max_size      = 10
      desired_size  = 2
      #capacity_type = "SPOT"
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
      
      key_name = aws_key_pair.eks.key_name
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  tags = var.common_tags
}