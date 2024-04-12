# Google Docker

## Start Repository 

`gcloud artifacts repositories create vep-vcf2maf --repository-format=docker     --location=us-east1 --description="vep_vcf2maf"`

## List Repositories

`gcloud artifacts repositories list`

## Build 

```
gcloud builds submit --region=us-east1 --tag us-east1-docker.pkg.dev/bhoom-lab-01/vep-vcf2maf/vep:102
```

## Provision GCE
0. [Check the artifact registry page](https://console.cloud.google.com/artifacts?referrer=search&project=bhoom-lab-01), and follow the deploy to GCE instruction.

1. Need to authenticate artifact registry
```
gcloud auth configure-docker us-east1-docker.pkg.dev
```

2. Pull the docker image
```
docker pull \
    us-east1-docker.pkg.dev/bhoom-lab-01/vep-vcf2maf/vep:102
```

3. 