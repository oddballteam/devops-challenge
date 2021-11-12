variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cp`)"
  default     = "helloworld"
}

variable "name" {
  type        = string
  description = "Name of the application"
  default     = "app"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = "dev"
}

variable "nginx-name" {
  type        = string
  description = "Name of the application"
  default     = "nginx"
}

variable "scan_images_on_push" {
  type        = bool
  description = "Whether to scan images after they've been pushed"
  default     = true
}
