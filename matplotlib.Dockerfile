FROM arm64v8/python:3.7-buster

ARG MATPLOTLIB=3.3.3
ARG JOBS=4

RUN python3 -m pip install -U setuptools pip wheel

RUN git clone --recursive https://github.com/matplotlib/matplotlib.git --branch v$MATPLOTLIB 

WORKDIR /matplotlib

RUN python3 setup.py build -j${JOBS}
RUN python3 setup.py bdist_wheel
