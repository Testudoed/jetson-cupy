CUPY_VERSION?=8.2.0

MAKE_PID := $(shell echo $$PPID)
JOB_FLAG := $(filter -j%, $(subst -j ,-j,$(shell ps T | grep "^\s*$(MAKE_PID).*$(MAKE)")))
JOBS     := $(subst -j,,$(JOB_FLAG))

cupy:
	docker build -t aarch64-cupy:$(CUPY_VERSION) \
		--build-arg "CUPY=$(CUPY_VERSION)" --build-arg "JOBS=$(JOBS)" \
		-f cupy.Dockerfile .
	docker create -ti --name cupy-build aarch64-cupy:$(CUPY_VERSION) /bin/bash
	docker cp cupy-build:/cupy/dist/ ./
	docker rm -f cupy-build