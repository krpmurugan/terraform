### Container Registry and Container Instances

Azure Container Registry (ACR) is an Azure-based, private registry, for Docker container images.

#### Docker:

Docker is an open-source platform based on Linux containers for developing and running applications inside containers. Docker is used to deploying many containers simultaneously on a given host. Containers are very fast and lightweight because they don’t need the extra load of a hypervisor as they run directly within the host machine’s kernel.

There are five major components in the Docker architecture:

- Docker Daemon listens to Docker API requests and manages Docker objects such as images, containers, networks and volumes.
- Docker Clients: With the help of Docker Clients, users can interact with Docker. Docker client provides a command-line interface (CLI) that allows users to run, and stop application commands to a Docker daemon.
- Docker Host provides a complete environment to execute and run applications. It comprises of the Docker daemon, Images, Containers, Networks, and Storage.
- Docker Registry stores Docker images. Docker Hub is a public registry that anyone can use, and Docker is configured to use images on Docker Hub by default. You can run your own registry on it.
- Docker Images are read-only templates that you build from a set of instructions written in Dockerfile. Images define both what you want your packaged application and its dependencies to look like what processes to run when it’s launched.

#### What Is Container (Docker)?

Containers are a software package into a logical box with everything that the application needs to run. That includes a thin layer of blog operating system, application code, runtime, system tools, system libraries, and etc. Docker containers are built off Docker images. Since images are read-only, Docker adds a read-write file system over the read-only file system of the image to create a container.

Containers are compared with virtual machines (VMs). VMs are the guest operating system such as Linux or Windows runs on top of a host operating system with virtualized access to the underlying hardware. Containers allow you to package your application together with libraries and other dependencies, providing isolated environments for running your software services.

##### Different Container Providers:

1. Docker
2. Microsoft Azure
3. Amazon Web Services (AWS)
4. Google Cloud Platform
5. Linux Containers

#### Azure Container Registry (ACR):

Azure Container Registry permits you to create, store, and manage container images in a private registry for all types of container deployments. You can use Azure container registries with your existing container development and deployment pipelines.

#### Azure Container Instances (ACI)

Azure Container Instances (ACI) is Microsoft PaaS (Platform as service) solution that offers the fastest and simplest way to run a container in Azure, without having to manage any underlying infrastructure. For container orchestration in Azure (build, manage, and deploy multiple containers) use Azure Kubernetes Service (AKS). You can deploy Azure Container Instances using Azure Portal, Azure CLI, Powershell, or ARM Template.

![image](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jr1mb912yznjlzojealm.png)

***Create Azure Container Registry (ACR) in Azure Portal:***

![image](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/drn9llx4v1h6xr1q9ov5.png)

The above screen adds the registry name, SKU, etc to create the azure registry and then add the repository.

***Create Azure Container Registry (ACR) using terraform:***

Create the project structure like below in registry directory

![image](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/avxlhxxdlsrozr87kxm5.png)
 

1.Create a file called variable.tf and write the following code

```
variable "subscription_id" {
  default = "*******-******"
}

variable "resource_group_name" {
  default = "******"
}

variable "registry_name" {
  default = "mrcontainerregistry01"
}

variable "resource_group_location" {
  default = "West Europe"
} 
```

2.Create a file called main.tf and write the following code

```
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  skip_provider_registration = true
}

resource "azurerm_container_registry" "acr" {
  name                     = var.registry_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  sku                      = "Standard"
  admin_enabled            = true
} 
```

3.Create the makefile in the registry directory

```
.PHONY: init
init:
	terraform init

.PHONY: plan
plan:
	terraform plan

.PHONY: apply
apply: validate
	terraform apply --auto-approve

.PHONY: format
format:
	terraform fmt

.PHONY: validate
validate:
	terraform validate

.PHONY: destroy
destroy:
	terraform destroy --auto-approve

.PHONY: refresh
refresh:
	terraform refresh

.PHONY: checkov
checkov:
	checkov --directory .

.PHONY: az-login-registry
az-login-registry: ## login into the Azure using the username and password

ifeq ($(REGISTRY_NAME),)
	@echo "[Error] Please specify a REGISTRY_NAME"
	@exit 1;
endif

	az acr login --name $(REGISTRY_NAME)

.PHONY: build-push-docker-image
build-push-docker-image: az-login-registry
	cd ./../my-project && docker build -t $(REGISTRY_NAME).azurecr.io/sampleapi .
	docker tag $(REGISTRY_NAME).azurecr.io/sampleapi:latest $(REGISTRY_NAME).azurecr.io/sampleapi:v1
	docker push $(REGISTRY_NAME).azurecr.io/sampleapi:v1 
```
and then run the ***make apply*** command to create the ***mrcontainerregistry01*** registry. once created then we need to run the below commands to push our images to the azure registry in order to do that we need to create a couple of files like main.go, Dockerfile in the **my-project** directory. I've created a simple go HTTP request example like below

Create the project structure like below in my-project directory to add main.go, .Dockerfile over there

![image](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vre0gtr28s5k55maiuid.png)
1.In the main.go file add the below code
```
package main

import (
	"fmt"
	"html"
	"log"
	"net/http"
)

func main() {

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
	})

	http.HandleFunc("/hi", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hi")
	})

	log.Fatal(http.ListenAndServe(":80", nil))

}
```
2.In Dockerfile add the below code
```
# We specify the base image we need for our

FROM golang:1.12.0-alpine3.9

RUN mkdir /app

ADD . /app

WORKDIR /app

RUN go build -o main .

CMD ["/app/main"] 
```
Once created the main.go, Dockerfile run the below commands to push the docker images to ***mrcontainerregistry01*** registry.

```
make build-push-docker-image REGISTRY_NAME=mrcontainerregistry01

```
It will push the changes to the repository under the given mrcontainerregistry01 registry.

***Create an Azure Docker Container Instance using Azure Portal:***

![image](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ajum4z7douk6w6w0ibvh.png)

Here add the resource group, container name, Image source etc to create the container instance. Once done this we switched to over view section to copy the FQDN and paste it on your browser and run the URL added image functionality will work as expected.

***Create Azure Container Instance(ACI) using terraform:***

Create the project structure like below in instance dir
![image](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/bfpsfxndg12gouwyele0.png)

1.Create a file called variable.tf and write the following code

```
variable "subscription_id" {
  default = "*******-******"
}

variable "resource_group_name" {
  default = "******"
}

variable "instance_name" {
  default = "mrcontainerinstance01"
}

variable "resource_group_location" {
  default = "West Europe"
}
```

2.Create a file called main.tf and write the following code

```
terraform {
  required_version = ">= 0.12.6"
  required_providers {
    azurerm = {
      version = "~> 2.53.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  skip_provider_registration = true
}

resource "azurerm_container_group" "aci" {
  name                = var.instance_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  ip_address_type     = "public"
  dns_name_label      = "aci-first-container01"
  os_type             = "Linux"

  container {
    name   = "myfirstproject"
    image  = "${data.terraform_remote_state.registry.outputs.container-registry-server-name}/sampleapi:v1"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  image_registry_credential {
        server = data.terraform_remote_state.registry.outputs.container-registry-server-name
        username = data.terraform_remote_state.registry.outputs.container-registry-admin-user-name
        password = data.terraform_remote_state.registry.outputs.container-registry-admin-password // We should use Vault to reterive the password

    }

  tags = {
    environment = "testing"
  }
} 
```
3.Create the makefile under the instance directory
```
.PHONY: init
init:
	terraform init

.PHONY: plan
plan:
	terraform plan

.PHONY: apply
apply: validate
	terraform apply --auto-approve

.PHONY: format
format:
	terraform fmt

.PHONY: validate
validate:
	terraform validate

.PHONY: destroy
destroy:
	terraform destroy --auto-approve

.PHONY: refresh
refresh:
	terraform refresh

.PHONY: checkov
checkov:
	checkov --directory . 
```
run the ***make deploy*** command which will create the container instance for you.

Once done go to the overview section of the container instance and copy the FQDN URL, paste it on your browser and click on search, now you will see the created Docker image work as expected. See the screenshot for your reference
![image](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/w75e3bbcl328ywjbl2pf.png)
 
#### References:

- [Azure Container Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group)
- [Azure Container Registry](https://docs.w3cub.com/terraform/providers/azurerm/r/container_registry)
- [Deploy A Container Instance In Azure Using The Azure Portal](https://k21academy.com/microsoft-azure/case-study-deploy-a-container-instance-in-azure-using-the-azure-portal/)
- [Creating Container Images (ACR) to be used with Azure Container Service](https://medium.com/@adilsonbna/creating-container-images-acr-to-be-used-with-azure-container-service-c61140620968)
