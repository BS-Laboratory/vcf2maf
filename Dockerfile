FROM clearlinux:base AS builder

# Install a minimal versioned OS into /install_root, and bundled tools if any
ENV CLEAR_VERSION=41450
RUN swupd os-install --no-progress --no-boot-update --no-scripts \
    --version ${CLEAR_VERSION} \
    --path /install_root \
    --statedir /swupd-state \
    --bundles os-core-update,which

# Download and install conda into /usr/bin
ENV MINICONDA_VERSION=py37_4.9.2
RUN swupd bundle-add --no-progress curl && \
    curl -sL https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -o /tmp/miniconda.sh && \
    sh /tmp/miniconda.sh -bfp /usr

# Use conda to install remaining tools/dependencies into /usr/local
ENV VEP_VERSION=102.0 \
    HTSLIB_VERSION=1.17 \
    BCFTOOLS_VERSION=1.18 \
    SAMTOOLS_VERSION=1.18 \
    LIFTOVER_VERSION=447
RUN conda create -qy -p /usr/local \
    -c conda-forge \
    -c bioconda \
    -c defaults \
    ensembl-vep \
    htslib \
    bcftools \
    samtools \
    ucsc-liftover

# Deploy the minimal OS and tools into a clean target layer
FROM scratch

LABEL maintainer="Cyriac Kandoth <ckandoth@gmail.com>"

COPY --from=builder /install_root /
COPY --from=builder /usr/local /usr/local
COPY data /opt/data
COPY *.pl /opt/
WORKDIR /opt
