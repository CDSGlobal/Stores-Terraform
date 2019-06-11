provider "aws" {
    region = "us-east-1"
}

resource "aws_elasticache_cluster" "qa_storescache" {
  engine               = "redis"
  node_type            = "cache.m5.large"
  num_cache_nodes      = "1"
  cluster_id           = "qa-stores-cluster"
  parameter_group_name = "default.redis5.0"
  subnet_group_name    = "sg-elastic-cache" 
}

resource "aws_elasticache_replication_group" "example" {
  automatic_failover_enabled    = true
  replication_group_id          = "tf-rep-group-1"
  replication_group_description = "test description"
  node_type                     = "cache.m5.large"
  number_cache_clusters         = 2
  parameter_group_name          = "default.redis5.0"
  port                          = 6379
  subnet_group_name             = "sg-elastic-cache"

  lifecycle {
    ignore_changes = ["number_cache_clusters"]
  }
}

resource "aws_elasticache_cluster" "replica" {
  count = 2

  cluster_id           = "tf-rep-group-1-${count.index}"
  replication_group_id = "${aws_elasticache_replication_group.example.id}"
}
