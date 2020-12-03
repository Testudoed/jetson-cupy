FROM arm64v8/python:3.7-buster

ARG SCIKITLEARN=0.23.2
ARG JOBS=4

RUN python3 -m pip install -U setuptools pip wheel
RUN python3 -m pip install Cython numpy scipy

RUN git clone --recursive https://github.com/scikit-learn/scikit-learn.git --branch $SCIKITLEARN 

WORKDIR /scikit-learn

RUN python3 setup.py build -j${JOBS}
RUN python3 setup.py bdist_wheel
