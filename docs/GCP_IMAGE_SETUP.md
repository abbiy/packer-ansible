# Setup to build GCP Images

1. Perform initial GCP CLI setup tasks
1. Get default GCP credentials

## Perform initial GCP CLI setup tasks

:thinking: Before creating a GCP image, you need to perform some intial setup tasks to configure the GCP CLI tool.
It will set things like your default project and also require you to provide authorization to the tool.

To kickstart the setup process, run the following command:

```console
gcloud init
```

## Get default GCP credentials

:thinking: When creating a GCP image, the GCP credentials file is required by Packer to access the GCP Compute VM instance that is used
to create the image.

To get the default credentials, run the following command:

```console
gcloud auth application-default login
```
