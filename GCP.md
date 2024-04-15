# Google Docker

## Start Repository 

`gcloud artifacts repositories create vep-vcf2maf --repository-format=docker     --location=us-east1 --description="vep_vcf2maf"`

## List Repositories

`gcloud artifacts repositories list`

## Build 

```
gcloud builds submit --region=us-east1 --tag us-east1-docker.pkg.dev/bhoom-lab-01/vep-vcf2maf/vep:111-1
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
    us-east1-docker.pkg.dev/bhoom-lab-01/vep-vcf2maf/vep:111-1
```

3. Testing the container
- Testing the container by running "echo 'Hello World'" then remove the container

```
docker run --rm us-east1-docker.pkg.dev/bhoom-lab-01/vep-vcf2maf/vep:111-1 echo "Hello World"
```

- You should see "Hello World" from the above command

4. Running vcf2maf via command line follow this format `perl vcf2maf.pl --input-vcf INPUT.vcf --output-maf OUTPUT.maf --tumor-id TUMOR_ID --normal-id NORMAL_ID`

- We will also mount the current directory contain our data with  `docker run -v $(pwd):/data` and the existing `vep_cache` data directory to `/vep_data/`

- `--cache-version 111` if you did not download this cache version
```
docker run --rm -v $(pwd):/data \
-v /Users/manager/vep_data:/vep_data \
us-east1-docker.pkg.dev/bhoom-lab-01/vep-vcf2maf/vep:111-1 \
perl vcf2maf.pl \
--vep-path /usr/local/bin \
--vep-data /vep_data \
--cache-version 111 \
--species homo_sapiens \
--input-vcf /data/tests/test_b37.vcf \
--ref-fasta /vep_data/homo_sapiens/102_GRCh37/Homo_sapiens.GRCh37.dna.toplevel.fa.gz \
--output-maf /data/tests/test_b37.maf

```

## Running VEP only

- We will bind the current `$(pwd)` folder as `/data` in the container and `/Users/manager/vep_data` containing the vep cache as `/vep_data` within the container
- The vep cache, version 111 -- merged version `homo_sapiens_merged_vep_111_GRCh37.tar.gz`, has been previously downloaded, unarchived. This file has been unarchived to `homosapiens_merged`. However, we do need to move the contents to the folder `homo_sapiens` for `vep` to work.

```
docker run --rm -v $(pwd):/data \
-v /Users/manager/vep_data:/vep_data \
us-east1-docker.pkg.dev/bhoom-lab-01/vep-vcf2maf/vep:111-1 \
vep --dir /vep_data \
-i /data/tests/test_b37.vcf \
-o /data/tests/test_b37_vep.vcf \
--cache \
--fasta /vep_data/homo_sapiens/102_GRCh37/Homo_sapiens.GRCh37.dna.toplevel.fa.gz \
--species homo_sapiens --assembly GRCh37 \
--everything --fork 4 --progress
```