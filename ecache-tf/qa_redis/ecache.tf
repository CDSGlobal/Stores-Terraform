provider "aws" {
    region = "us-east-1"
}

resource "aws_elasticache_cluster" "qa_stores_cache" {
  cluster_id           = "stores-cluster"
  parameter_group_name = "default.redis5.0"
}
