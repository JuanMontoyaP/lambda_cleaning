variable "aws_region" {
  description = "Main region to create the resources"
  type        = string
  default     = "us-west-1"
}

variable "alert_email" {
  description = "Email to send alerts to"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}", var.alert_email))
    error_message = "The alert_email variable must be a valid email address."
  }
}

variable "lambda_zip_path" {
  description = "Path to the zipped Lambda function code"
  type        = string
  default     = "lambda_function_payload.zip"
}
