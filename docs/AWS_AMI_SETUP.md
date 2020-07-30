# Setup to build AWS AMI

1. Create AWS access keys
1. Create AWS EC2 Key Pair
1. (Optional) Set AWS Multi-factor authentication (MFA) credentials

## Create AWS access keys

:thinking When creating an AWS AMI, an AWS access key is needed by Packer to access the account.
This information is usually kept in `~/.aws/credentials` and is accessed by the Packer `amazon-ebs` builder.

1. Create [Access keys for CLI, SDK, & API access](https://console.aws.amazon.com/iam/home?#/security_credentials).

1. **Method #1:** Use the `aws` command line interface to create `~/.aws/credentials`.
   Supply the information when prompted.
   Example:

    ```console
    $ aws configure

    AWS Access Key ID:
    AWS Secret Access Key:
    Default region name [us-east-1]:
    Default output format [json]:
    ```

1. **Method #2:** :pencil2: Manually create a `~/.aws/credentials` file.
   Example:

    ```console
    mkdir ~/.aws

    cat <<EOT > ~/.aws/credentials
    [default]
    aws_access_key_id = AAAAAAAAAAAAAAAAAAAA
    aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    EOT

    chmod 770 ~/.aws
    chmod 750 ~/.aws/credentials
    ```

1. References:
    1. Packer [using AWS authentication](https://www.packer.io/docs/builders/amazon/#authentication)

## Create AWS EC2 Key Pair

:thinking When creating an AWS AMI, a EC2 key pair is required by Packer to access the EC2 instance that is used
to create the AMI. With access, Packer is able to run provisioners such as Ansible on the EC2 instance

1. Create [EC2 key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#prepare-key-pair)

1. Add key pair to custom-var.json

```json
{
  "aws_ssh_keypair_name": "packer-key",
  "aws_ssh_private_key_file": "~/packer-key.pem",
}
```

## (Optional) Set AWS Multi-factor authentication (MFA) credentials

:thinking If the AWS account is setup with multi-factor authentication, a new set of access key id, key and session token
has to generated ephemerally for packer to build the AMI.

Do follow the [AWS MFA guide](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/set-aws-mfa-credentials.md) to setup the credentials required to build AMI.
