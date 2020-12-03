FROM arm64v8/python:3.7-buster

ARG LLVMLITE=0.32.0
ARG JOBS=4

RUN apt-get update && apt-get install -y --no-install-recommends \
    llvm-dev \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN python3 -m pip install -U setuptools pip wheel

RUN git clone --recursive https://github.com/numba/llvmlite.git --branch v$LLVMLITE 

WORKDIR /llvmlite

RUN python3 setup.py build -j${JOBS}
RUN python3 setup.py bdist_wheel
