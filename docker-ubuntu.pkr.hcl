packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "nginx" {
  image  = "nginx:latest"
  commit = true
}

build {
  name    = "learn-packer"
  sources = ["source.docker.nginx"]

  provisioner "file" {

    source      = "./webpage"
    destination = "/webpage"
  }

  provisioner "shell" {

    inline = [
      "cd /webpage",
      "cp -r . /usr/share/nginx/html",
    ]
  }
  post-processor "docker-tag" {
    repository = "nginx-webpage"
    tag        = ["latest"]
  }
}
