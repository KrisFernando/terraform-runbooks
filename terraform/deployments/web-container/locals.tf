locals {
  environment             = terraform.workspace
  vpc_id                  = try(data.terraform_remote_state.ecs_cluster.outputs.vpc_id, null)     
  public_subnet_ids       = try(data.terraform_remote_state.ecs_cluster.outputs.public_subnet_ids, null)     
  private_subnet_ids      = try(data.terraform_remote_state.ecs_cluster.outputs.private_subnet_ids, null)     
  ecs_cluster_id          = try(data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster_id, null)
  ecs_cluster_name        = try(data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster_name, null)     
  alb_security_group_id   = try(data.terraform_remote_state.ecs_cluster.outputs.alb_security_group_id, null)     
  app_security_group_id   = try(data.terraform_remote_state.ecs_cluster.outputs.ecs_task_security_group_id, null)
}