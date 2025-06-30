variable "env_name" {
    description = "Environment name like dev and prod"
    type = string
}
variable "env_bucket_name" {
    description = "Name of the bucket without any prefix"
    type = string
}
variable "force_destroy" {
    description = "Whether to allow deleting non-empty bucket"
    type = bool
    default = false
}