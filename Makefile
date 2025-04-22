init:
	terraform init
apply:
	terraform apply --var-file="terraform.tfvars" --auto-approve
destroy:
	terraform destroy --auto-approve