packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "nginx_python"
  sources = [

    "sources.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "echo Installing nginx,python3.6",
      "sudo apt update -y",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository -y ppa:deadsnakes/ppa",
      "sudo apt update -y",
      "sudo apt install -y nginx  docker.io",
      "sudo apt-get -y install python3.6",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "python3.6 --version || echo 'Python 3.6 installation failed!'"
      ]
  }
}
