FROM arm64v8/ubuntu:18.04 as base

ARG CUDA=10.2
ARG RELEASE=r32.4
ARG CUPY=8.2.0
ARG JOBS=4

RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 ca-certificates

COPY jetson-ota-public.key /etc/jetson-ota-public.key
RUN apt-key add /etc/jetson-ota-public.key

RUN echo "deb https://repo.download.nvidia.com/jetson/common $RELEASE main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
RUN echo "deb https://repo.download.nvidia.com/jetson/t194 $RELEASE main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list

ENV CUDA_VERSION $CUDA

RUN CUDAPKG=$(echo $CUDA_VERSION | sed 's/\./-/'); \
    apt-get update && apt-get install -y --no-install-recommends \
    cuda-toolkit-$CUDAPKG \
    git \
    build-essential \
    python3.7 \
    python3.7-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN ln -s cuda-$CUDA_VERSION /usr/local/cuda 

RUN rm /usr/bin/python3 && \
    ln -s python3.7 /usr/bin/python3

RUN python3 -m pip install -U setuptools pip wheel
RUN python3 -m pip install Cython
RUN git clone --recursive https://github.com/cupy/cupy.git --branch v$CUPY 

WORKDIR /cupy

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

RUN python3 setup.py build -j${JOBS}
RUN python3 setup.py bdist_wheel 