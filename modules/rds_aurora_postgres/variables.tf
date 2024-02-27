variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "db_name" {
  description = "The database name"
  type        = string
}

variable "deletion_protection" {
  description = "If the DB cluster should have deletion protection enabled."
  type        = bool
  default     = false
}

variable "identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
}

variable "master_password" {
  description = "Password for the master DB user"
  type        = string
}

variable "private_subnet_ids" {
  description = "DB private subnet IDs"
  type        = list(string)
}

variable "preferred_backup_window" {
  description = "Daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter"
  type        = string
  default     = "03:00-05:00"
}

variable "serverless_capacity" {
  description = "Serverless scaling range in ACUs (increments of 0.5)"
  type        = map(number)
  default = {
    min = 2,
    max = 4
  }
}

variable "master_username" {
  description = "Username for the master DB user."
  type        = string
}

variable "vpc_id" {
  description = "Id of VPC"
  type        = string
}

variable "vpc_security_group_ids" {
  description = ""
  type        = list(string)
}
