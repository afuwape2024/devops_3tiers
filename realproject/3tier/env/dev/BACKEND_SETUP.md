# Backend Setup (S3 + DynamoDB)

This environment uses:
- S3 bucket for Terraform state
- DynamoDB table for state locking

Configuration is defined directly in `backend.tf`.

## Prerequisites
- S3 bucket exists: `oluwagbenro.afuwape.realproject`
- DynamoDB table exists: `terraform-state-lock` (partition key: `LockID`, type `S`)

Create bucket (one time):
```bash
aws s3api create-bucket \
	--bucket oluwagbenro.afuwape.realproject \
	--region us-east-2 \
	--create-bucket-configuration LocationConstraint=us-east-2
```

Enable bucket versioning:
```bash
aws s3api put-bucket-versioning \
	--bucket oluwagbenro.afuwape.realproject \
	--versioning-configuration Status=Enabled
```

Create DynamoDB lock table (one time):
```bash
aws dynamodb create-table \
	--table-name terraform-state-lock \
	--attribute-definitions AttributeName=LockID,AttributeType=S \
	--key-schema AttributeName=LockID,KeyType=HASH \
	--billing-mode PAY_PER_REQUEST \
	--region us-east-2
```

## Initialize
```bash
cd /workspaces/devops_3tiers/realproject/3tier/env/dev
terraform init -reconfigure
```

## Verify
```bash
terraform state list
```
