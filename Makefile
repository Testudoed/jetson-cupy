CUPY_VERSION?=8.2.0
SCIKITLEARN_VERSION?=0.23.2
STATSMODELS_VERSION?=0.12.1
LLVMLITE_VERSION?=0.32.0

MAKE_PID := $(shell echo $$PPID)
JOB_FLAG := $(filter -j%, $(subst -j ,-j,$(shell ps T | grep "^\s*$(MAKE_PID).*$(MAKE)")))
JOBS     := $(subst -j,,$(JOB_FLAG))

all: cupy scikitlearn statsmodels

cupy:
	docker build -t aarch64-cupy:$(CUPY_VERSION) \
		--build-arg "CUPY=$(CUPY_VERSION)" --build-arg "JOBS=$(JOBS)" \
		-f cupy.Dockerfile .
	docker create -ti --name cupy-build aarch64-cupy:$(CUPY_VERSION) /bin/bash
	docker cp cupy-build:/cupy/dist/ ./
	docker rm -f cupy-build

scikitlearn:
		docker build -t aarch64-scikit:$(SCIKITLEARN_VERSION) \
		--build-arg "SCIKITLEARN=$(SCIKITLEARN_VERSION)" --build-arg "JOBS=$(JOBS)" \
		-f scikitlearn.Dockerfile .
	docker create -ti --name scikitlearn-build aarch64-scikit:$(SCIKITLEARN_VERSION)
	docker cp scikitlearn-build:/scikit-learn/dist/ ./
	docker rm -f scikitlearn-build

statsmodels:
		docker build -t aarch64-statsmodels:$(STATSMODELS_VERSION) \
		--build-arg "STATSMODELS=$(STATSMODELS_VERSION)" --build-arg "JOBS=$(JOBS)" \
		-f statsmodels.Dockerfile .
	docker create -ti --name statsmodels-build aarch64-statsmodels:$(STATSMODELS_VERSION)
	docker cp statsmodels-build:/statsmodels/dist/ ./
	docker rm -f statsmodels-build

llvmlite:
		docker build -t aarch64-llvmlite:$(LLVMLITE_VERSION) \
		--build-arg "LLVMLITE=$(LLVMLITE_VERSION)" --build-arg "JOBS=$(JOBS)" \
		-f llvmlite.Dockerfile .
	docker create -ti --name llvmlite-build aarch64-llvmlite:$(LLVMLITE_VERSION)
	docker cp llvmlite-build:/llvmlite/dist/ ./
	docker rm -f llvmlite-build