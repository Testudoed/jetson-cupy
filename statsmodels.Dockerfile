FROM arm64v8/python:3.7-buster

ARG STATSMODELS=0.12.1
ARG JOBS=4

RUN python3 -m pip install -U setuptools pip wheel
RUN python3 -m pip install Cython numpy scipy pandas patsy

RUN git clone --recursive https://github.com/statsmodels/statsmodels.git --branch v$STATSMODELS 

WORKDIR /statsmodels

RUN python3 setup.py build -j${JOBS}
RUN python3 setup.py bdist_wheel
