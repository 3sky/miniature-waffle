# Setup EKS
Step-by-step guide about setting Kubernetes app with EKS, DNS and container registry.

## Terraform

### Init

``` sh
terraform init
```

### Plan

``` sh
terraform plan | less
# take a look on plan, if it's correct go ahead
```

### Apply

This step will take some time to finish. (9:33.03 total)
``` sh
terraform apply 
# if correct enter yes or terraform apply -auto-approve
```

## Kubectl auth

``` sh
aws eks update-kubeconfig \
    --region $(terraform output -raw region) \
    --name $(terraform output -raw cluster_name)
```

## Pushing images

### Auth

``` sh
aws ecr get-login-password \
    --region $(terraform output -raw region) \
    | docker login --username AWS \
    --password-stdin $(terraform output -raw ecr_url | cut -d'/' -f1)
```

### Tag and push

``` sh
docker tag nginx:latest $(terraform output -raw ecr_url):1.0.0
docker push $(terraform output -raw ecr_url):1.0.0
```

## Helming

### Set register into helm config file 
### Dry run

``` sh
helm template <app name> -f <file with values> --dry-run <chart name>
# for example
# helm template example-app -f example-app.yaml --dry-run ./example-app
```

### Install chart

``` sh
helm install <app name> -f <file with values> --namespace <namespace> <chart name>
# for example
# helm install example-app -f example-app.yaml --namespace example ./example-app
```

### Upgrade app

``` sh
helm upgrade <app name> <chart> --set.image=<tag>
# for example
# helm upgrade example-app ./example-app --set=image.tag=2.0.0
```

## CloudFlare DNS

### ADD CNAME record

``` sh
TOKEN=
curl -X POST "https://api.cloudflare.com/client/v4/zones/544f19c701032840977281095d4aad8e/dns_records" \
     -H "Authorization: Bearer $TOKEN" \
     -H "Content-Type: application/json" \
     --data '{"type":"CNAME","name":"app","content":"'"$ELB"'","ttl":1,"proxied":true}' | jq .
```

### Digging

``` sh
dig CNAME +short app.3sky.dev
```
