# Go K8S CICD

This is an example of using CodeBuild and Codepipeline for Application Deployment in EKS.

This is to be used together with Terraform EKS Automation [https://github.com/shawnxlw/terraform-eks-automation]

## Components

### Dockerfile

Instead of base on `golang:latest` which is almost 800mb in size, the image is built `FROM scratch` (literally 0kb!) and only add in the binary compiled outside.

The binary is complied with statcially linked libraries in CodeBuild build stage with `golang:alpine` image:

```
docker run --rm -v "$(PWD)":/usr/src/myapp -w /usr/src/myapp -e CGO_ENABLED=0 -e GOOS=linux golang:alpine go build -a -installsuffix cgo -o main -v .
```

### Makefile
`Makefile` automates the binary build, image build and clean up tasks.

### Build Specs

`buildspec/build.yml` is the build spec for building and pushing image to ECR repo.

`buildspec/deploy.yml` is the build spec for deploying application to EKS with kubectl apply

### Kube Specs

`kubespec/deployment.yml` contains two deployments each per AZ with nodeAffinity to balance pods across AZs. This is a workaround. There is an open PR on this issue: [https://github.com/kubernetes/kubernetes/issues/68981]

`kubespec/service.yml` contains LoadBalancer type Service for exposing the application to the internet. This is fine if the cluster only runs this one app, consider Nginx Ingress otherwise.

## How to use

### With CI/CD

Apply Terraform EKS Automation to create the CI/CD pipeline and CodeCommit git repo. Commit code to the repo and application will be built and deployed automatically.

### Manual

To build the binary, build the image and clean up, run
```
make
```

To just build the binary, run
```
make go_build
```