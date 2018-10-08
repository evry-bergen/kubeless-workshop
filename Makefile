ARCH := amd64

HELM_VARS := --install --wait --timeout 600 --force
HELM_CHARTS := helm nats minio promethues grafana kubeless

MINIKUBE_RAM := 4096
MINIKUBE_DISK := 40g
MINIKUBE_VERSION := v1.11.3

ifeq ($(OS),Windows_NT)
		CLIENT_OS := windows

    ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
				CLIENT_ARCH := amd64
    else
        ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
						CLIENT_ARCH := amd64
        endif
        ifeq ($(PROCESSOR_ARCHITECTURE),x86)
						CLIENT_ARCH := ia32
        endif
    endif
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
				CLIENT_OS := linux
    endif
    ifeq ($(UNAME_S),Darwin)
				CLIENT_OS := darwin
    endif
    UNAME_M := $(shell uname -m)
    ifeq ($(UNAME_M),x86_64)
				CLIENT_ARCH := amd64
    endif
    ifneq ($(filter %86,$(UNAME_M)),)
				CLIENT_ARCH := ia32
    endif
    ifneq ($(filter arm%,$(UNAME_M)),)
				CLIENT_ARCH := arm64
    endif
endif

MINIO_BIN 			:= mc
MINIO_BASE_URL 	:= https://dl.minio.io/client/mc/release
MINIO_FULL_URL 	:= $(MINIO_BASE_URL)/$(CLIENT_OS)-$(CLIENT_ARCH)/$(MINIO_BIN)
MINIO_KEY_ID	 	:= AKIAIOSFODNN7EXAMPLE
MINIO_SECRET	 	:= wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY \

all-install: $(addprefix install-, $(HELM_CHARTS))

add-etc-hosts:
	$(eval MINIKUBE_IP := $(shell minikube ip))
	@sudo sh -c "echo \"\n\" >> /etc/hosts"
	@sudo sh -c "echo \"$(MINIKUBE_IP)  minio.minikube\" >> /etc/hosts"
	@sudo sh -c "echo \"$(MINIKUBE_IP)  nats.minikube\" >> /etc/hosts"
	@sudo sh -c "echo \"$(MINIKUBE_IP)  kubeless.minikube\" >> /etc/hosts"
	@sudo sh -c "echo \"$(MINIKUBE_IP)  prometheus.minikube\" >> /etc/hosts"
	@sudo sh -c "echo \"$(MINIKUBE_IP)  grafana.minikube\" >> /etc/hosts"
	@sudo sh -c "echo \"$(MINIKUBE_IP)  function-python.minikube\" >> /etc/hosts"
	@sudo sh -c "echo \"$(MINIKUBE_IP)  function-node.minikube\" >> /etc/hosts"

start-minikube:
	@minikube start \
		--memory $(MINIKUBE_RAM) \
		--disk-size $(MINIKUBE_DISK) \
		--kubernetes-version $(MINIKUBE_VERSION) \
		-v 4
	@minikube addons enable ingress

install-helm:
	@helm init \
		--upgrade \
		--wait

verify-helm:
	@helm version

install-nats:
	@helm repo update
	@helm upgrade nats stable/nats \
		--namespace nats-io \
		--values config/nats.yaml \
		$(HELM_VARS)

remove-nats:
	@helm delete --purge nats

install-minio-client:
	curl -vOL $(MINIO_FULL_URL)
	chmod +x $(MINIO_BIN)
	sudo mv $(MINIO_BIN) /usr/local/bin/$(MINIO_BIN)

configure-minio-client:
	$(eval MINIKUBE_IP := $(shell minikube ip))
	@mc config host add local \
		http://$(MINIKUBE_IP):30900 \
		$(MINIO_KEY_ID) \
		$(MINIO_SECRET) \
		--api "S3v4" \
		--lookup "path"
	@mc mb local/uploads
	@mc mb local/thumbnails

verify-minio-client:
	@mc mb local/client-test
	@mc cp LICENSE local/client-test
	@mc ls local/client-test
	@mc rm local/client-test/LICENSE
	@mc rm local/client-test

install-minio:
	@helm repo update
	@helm upgrade minio stable/minio \
		--namespace minio \
		--values config/minio.yaml \
		$(HELM_VARS)

remove-minio:
	@helm delete --purge minio

install-kubeless:
	@helm repo update
	@helm upgrade kubeless ./charts/kubeless \
		--namespace kubeless \
		--values config/kubeless.yaml \
		$(HELM_VARS)

remove-kubeless:
	@helm delete --purge kubeless

install-prometheus:
	$(eval MINIKUBE_IP := $(shell minikube ip))
	@helm repo update
	@helm upgrade prometheus stable/prometheus \
		--version 7.2.0 \
		--namespace monitoring \
		--values config/prometheus.yaml \
		--set server.ingress.hosts[1]=prometheus.$(MINIKUBE_IP).nip.io \
		$(HELM_VARS)

remove-promethues:
	@helm delete --purge grafana

install-grafana:
	$(eval MINIKUBE_IP := $(shell minikube ip))
	@helm repo update
	@helm upgrade grafana stable/grafana \
		--version 1.16.0 \
		--namespace monitoring \
		--values config/grafana.yaml \
		--set ingress.hosts[1]=grafana.$(MINIKUBE_IP).nip.io \
		$(HELM_VARS)

open-grafana:
	$(eval MINIKUBE_IP := $(shell minikube ip))
	@open http://grafana.$(MINIKUBE_IP).nip.io

remove-grafana:
	@helm delete --purge grafana
