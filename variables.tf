variable "participant_count" {
  description = "Number of workshop participants"
  default     = 1  # Change based on your need
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "AWS Key Pair name"
  default     = "workshop-key"  # Change this to your key
}

variable "ami_id" {
  description = "The AMI ID for a Linux distribution (e.g., Ubuntu) with Docker installed"
  default     = "ami-0866a3c8686eaeeba"  # Example Ubuntu AMI, change according to your region
}
