# ========================================== #
# Variables
# ========================================== #
variable "profile" {
  description = "AWS Profile"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "project" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

# ========================================== #
# VPC
# ========================================== #
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

# ========================================== #
# Subnet
# ========================================== #
variable "public_subnets" {
  description = "Public Subnets"
  type        = map(string)
}

variable "private_subnets" {
  description = "Private Subnets"
  type        = map(string)
}

# ========================================== #
# Availability Zone
# ========================================== #
variable "availability_zones" {
  description = "Availability Zones"
  type        = map(string)
}