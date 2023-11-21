terraform {
  cloud {
    organization = "Sammyvirtual-solution"

    workspaces {
      name = "wordpress"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
