# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

## Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

## Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

## Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

## Instructions

### Create Azure App Registration

*Note: A Service principal will be used within Terraform that has permissions to create/modify/delete resources within the subscription. The following steps will create the service principal that will be used by terraform.*

1. Log into the Azure portal by going to https://portal.azure.com
1. While logged into the portal, go to the Azure Active Directory blade.
1.  Click on App registrations
1. Click on "New Registration"
    * Enter in a friendly name of the app registration.
    * Select "Account in this organizational directory only (Default Directory only - Single tenant)
    * Click on Register
1. A new app registration blade will be show with the friendly name of the app registration that was just created.
1. Copy and store both the "**Application (client) ID**" and the "**Directory (tenant) ID**" as they will be needed in future steps.
1. Click on "Certificates & Secrets".
1. Click on "+ New client secret".
    * Provide a description for the cleint secret.
    * Select Expires - In 1 year
1. Copy the **Value** of the secret and store it in a safe place as it will be used in the future.
1. Click on Home. 

### Grant the App Registration Owner Rights In The Subscription

*Note: The app registration created will need to be given permissions in order to create/modify/delete Azure resources within the subscription.*

1. Click on Subscriptions.
1. Click on the subscription that you will be working on.
1. Copy and store the "Subscription ID" as it will be used in future steps.
1. Click on Access Control.
1. Click on Role Assignments.
1. Click on "+ Add".
1. Select add role assignment.
1. On the right side of the screen the "Add role assignment" blade will open.
    * Select the Owner role
    * Select "User, group, or service principal"
    * Enter in the name of the App Registration created above.
    * Select the app registration and click on Save.

### Setting Up Environment Variables for Packer

1. In order for packer to run successfully, environment variables must be configured so that packer can run under the context of the app registration created above.
1. Open Terminal and execute the following command:
*Note: Replace the identifiers specified between the quotes with the actual values that were captured in the above steps.*

    ```dotnetcli
    export ARM_CLIENT_ID="<Application (client) ID>"
    export ARM_CLIENT_SECRET="<Application ID Secret>"
    export ARM_SUBSCRIPTION_ID="<Azure Subscription ID>"
    ```

### Creating Packer Resource Group

1. While in the Azure portal click on resource groups.
1. Click on "+ Add"
1. Create a new resource group called **packer-rg** in the (US) East US region.
1. Click on "Next: Tag".
1. Add a tag named **Project** with a value of **Udacity**.
1. Click on Review + Create
1. Click on Create

### Create Packer Image

1. Open Terminal and navigate to the "C1 - Azure Infrastructure Operations/project/starter_files/Packer" directory.
1. At the terminal prompt execute the following command:

    ```dotnetcli
    packer build server.json
    ```

1. Packer will start to build the image.
1. After packer completes the build task, a new packer built OS image called "UbuntuWebServer_Packer" will exist in the packer-rg resource group.

### Configure Terraform
1. Navigate to the "C1 - Azure Infrastructure Operations/project/starter_files/IaC" directory.
1. Create a new file called **terraform.tfvars** in the directory.
1. Open the **terraform.tfvars** file with a text editor and add the following to file. Replace all identifiers between the quotes with the actual values. You can set the instance_count to the number of instance that you would like to run behind the loadbalancer.

    ```dotnetcli
    clientid = "<Application (client) ID>"
    subscriptionid = "<Azure Subscription ID>"
    clientsecret = "<<Application ID Secret value>"
    tenantid = "<tenant ID>"
    admin_username = "<admin username"
    admin_password = "<admin password>"
    instance_count = 1
    ```

### Create Azure Web Server Solution Using Terraform

1. Open Terminal and navigate to the "C1 - Azure Infrastructure Operations/project/starter_files/IaC"
1. At the terminal prompt, execute the following command to create the Azure Web Server Solution:

    ```dotnetcli
    terraform init
    terraform plan
    terraform apply
    ```

1. When the terraform has completed it will output the public IP of the load balancer. Copy and save the public IP for future use.

### Output

1. After the Terraform completes successfully, open a web browser on your local machine and go to http://<Public IP Provided By Terraform>/index.html
1. The browser should return a page that states "Hello World!!".
1. The terraform builds out the following:
    * 2 Public IPs that are used by the load balancer for both Inbound requests from the internet and outbound requests to the internet.
    * An internal VNET
    * Network Security Group
    * Standard Load Balancer with Health Probes
    * Virtual Machine Scale Set - I chose to use a virtual machine scale set because a scale set is an implicit availibility set with 5 fault domains. A virtual machine scale set allows one to control the number of nodes that are in the scale set but it also provides some advanced capabilities for scaling the instances up/down based on environmental factors (e.g. CPU, Memory, Queues, etc..). A virtual machines scale set also allows for rolling out an update while keeping the service available.
    * Bastion Host - I decided to implement the Azure Bastion service as it provides a security way to SSH and RDP onto systems without the need to build a bastion host or jump box.
    * Tagging Policy Definition and Assignment - Through Terraform, I was able to create the tagging policy definition and assignment thus it is included in the terraform.

## References
* https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
* https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer
* https://microsoft.github.io/AzureTipsAndTricks/blog/tip201.html
* https://medium.com/awesome-azure/difference-between-scale-set-and-availability-set-in-azure-9b2da03b891c
* http://manpages.ubuntu.com/manpages/trusty/man1/busybox.1.html
* https://docs.microsoft.com/en-us/azure/developer/terraform/create-vm-scaleset-network-disks-using-packer-hcl




