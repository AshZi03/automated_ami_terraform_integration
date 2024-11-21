variable "azs" {
  default = ["us-east-1a", "us-east-1b"]  # Replace with the AZs you want
}

resource "aws_instance" "my_instance" {
  for_each      = toset(var.azs)         # Iterate over the AZs
  ami           = "ami-035db85c9fe6d0d95" # Replace with your AMI ID
  instance_type = "t2.micro"             # Adjust to your instance type

  availability_zone = each.value         # Assign each instance to a unique AZ

  tags = {
    Name = "Instance-in-${each.value}"   # Unique name for each instance
  }
}
