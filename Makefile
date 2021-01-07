CUPY_VERSION?=8.2.0
SCIKITLEARN_VERSION?=0.23.2
STATSMODELS_VERSION?=0.12.1
LLVMLITE_VERSION?=0.32.0
MATPLOTLIB_VERSION?=3.3.3
CYTHON_VERSION?=0.29.6

MAKE_PID := $(shell echo $$PPID)
JOB_FLAG := $(filter -j%, $(subst -j ,-j,$(shell ps T | grep "^\s*$(MAKE_PID).*$(MAKE)")))
JOBS     := $(subst -j,,$(JOB_FLAG))
SOURCE_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BINARY_DIR:=$(SOURCE_DIR)

ifndef JOBS
JOBS:=1
endif

all: cupy scikitlearn statsmodels llvmlite matplotlib cython

cupy:
	docker build -t aarch64-cupy:$(CUPY_VERSION) \
		--build-arg "CUPY=$(CUPY_VERSION)" --build-arg "JOBS=$(JOBS)" \
		- < cupy.Dockerfile
	docker create --name cupy-build aarch64-cupy:$(CUPY_VERSION) /bin/bash
	docker cp cupy-build:/cupy/dist/ $(BINARY_DIR)
	docker rm -f cupy-build

scikitlearn:
	docker build -t aarch64-scikit:$(SCIKITLEARN_VERSION) \
		--build-arg "SCIKITLEARN=$(SCIKITLEARN_VERSION)" --build-arg "JOBS=$(JOBS)" \
		- < scikitlearn.Dockerfile
	docker create --name scikitlearn-build aarch64-scikit:$(SCIKITLEARN_VERSION)
	docker cp scikitlearn-build:/scikit-learn/dist/ $(BINARY_DIR)
	docker rm -f scikitlearn-build

statsmodels:
	docker build -t aarch64-statsmodels:$(STATSMODELS_VERSION) \
		--build-arg "STATSMODELS=$(STATSMODELS_VERSION)" --build-arg "JOBS=$(JOBS)" \
		- < statsmodels.Dockerfile
	docker create --name statsmodels-build aarch64-statsmodels:$(STATSMODELS_VERSION)
	docker cp statsmodels-build:/statsmodels/dist/ $(BINARY_DIR)
	docker rm -f statsmodels-build

llvmlite:
	docker build -t aarch64-llvmlite:$(LLVMLITE_VERSION) \
		--build-arg "LLVMLITE=$(LLVMLITE_VERSION)" --build-arg "JOBS=$(JOBS)" \
		- < llvmlite.Dockerfile
	docker create --name llvmlite-build aarch64-llvmlite:$(LLVMLITE_VERSION)
	docker cp llvmlite-build:/llvmlite/dist/ $(BINARY_DIR)
	docker rm -f llvmlite-build

matplotlib:
	docker build -t aarch64-matplotlib:$(MATPLOTLIB_VERSION) \
		--build-arg "MATPLOTLIB=$(MATPLOTLIB_VERSION)" --build-arg "JOBS=$(JOBS)" \
		- < matplotlib.Dockerfile
	docker create --name matplotlib-build aarch64-matplotlib:$(MATPLOTLIB_VERSION)
	docker cp matplotlib-build:/matplotlib/dist/ $(BINARY_DIR)
	docker rm -f matplotlib-build

cython:
	docker build -t aarch64-cython:$(CYTHON_VERSION) \
		--build-arg "CYTHON=$(CYTHON_VERSION)" --build-arg "JOBS=$(JOBS)" \
		- < cython.Dockerfile
	docker create --name cython-build aarch64-cython:$(CYTHON_VERSION)
	docker cp cython-build:/cython/dist/ $(BINARY_DIR)
	docker rm -f cython-build

clean:
	rm -rf $(BINARY_DIR)/dist

