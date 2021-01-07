FROM arm64v8/python:3.7-buster

ARG CYTHON=0.29.6
ARG JOBS=4

RUN python3 -m pip install -U setuptools pip wheel

RUN git clone --recursive https://github.com/cython/cython.git --branch $CYTHON 

WORKDIR /cython

RUN python3 setup.py build -j${JOBS}
RUN python3 setup.py bdist_wheel
