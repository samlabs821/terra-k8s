.RECIPEPREFIX = >
init:
> terraform init

plan:
> terraform plan -out=tf.plan

apply:
> terraform apply tf.plan

destroy:
> terraform destroy

print:
> jq -c '.outputs.ipv4.value' terraform.tfstate

clean:
> rm -rf terraform.tfstate.backup terraform.tfstate tf.plan
