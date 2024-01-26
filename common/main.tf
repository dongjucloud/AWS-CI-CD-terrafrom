module "network" {
  source = "../modules/network"
  vpc-id = module.network.vpc_id
  pub-sub1-id = module.network.pub_sub1_id
  pub-sub2-id = module.network.pub_sub2_id
  pri-sub1-id = module.network.pri_sub1_id
  pri-sub2-id = module.network.pri_sub2_id
  pub-rt-id = module.network.pub_rt_id
  pri-rt-id = module.network.pri_rt_id
  myeip-id = module.network.eip_id
  myigw-id = module.network.igw_id
  mynat-id = module.network.nat_id
}

module "cluster" {
  source = "../modules/cluster"
  ecr-url = module.cluster.ecr_url
  pri-sub1-id = module.network.pri_sub1_id
  pri-sub2-id = module.network.pri_sub2_id
  pub-sub1-id = module.network.pub_sub1_id
  pub-sub2-id = module.network.pub_sub2_id
  vpc-id = module.network.vpc_id
  log-group = module.monitoring.cloudwatch-log-name
  log-stream = module.monitoring.cloudwatch-log-stream-name

}
module "cicd" {
  source = "../modules/cicd"
  vpc-id = module.network.vpc_id
  s3-id = module.cicd.s3_id
  s3-bucket = module.cicd.s3_bucket
  pri-sub1-id = module.network.pri_sub1_id
  pri-sub2-id = module.network.pri_sub2_id
  code-repo-url = module.cicd.code_repo_url
}
module "monitoring" {
  source = "../modules/monitoring"
  ecs-service-name = module.cluster.ecs-service-name
  ecs-cluster-name = module.cluster.ecs-cluster-name
  sns-topic-arn = module.monitoring.sns-topic-arn
}