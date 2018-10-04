# Kubeless Workshop

Serverless Kubernetes Workshop with Kubeless

## Prerequsite

| Tool                                                         | Version        |
|--------------------------------------------------------------|----------------|
| [Virtualbox](https://www.virtualbox.org/wiki/Downloads)      | v5.2.18        |
| [Minikube](https://github.com/kubernetes/minikube/releases)  | v0.29.0        |
| [kubectl](https://github.com/kubernetes/kubernetes/releases) | v1.11.3        |
| [Helm](https://github.com/helm/helm/releases)                | v2.11.0        |
| [Kubeless](https://github.com/kubeless/kubeless/releases)    | v1.0.0-alpha.8 |

## Setting up Minikube

Download the Minikube utility:

| Architecture | Download                                                                                |
|--------------|-----------------------------------------------------------------------------------------|
| Mac          | https://github.com/kubernetes/minikube/releases/download/v0.29.0/minikube-darwin-amd64  |
| Linux        | https://github.com/kubernetes/minikube/releases/download/v0.29.0/minikube-linux-amd64   |
| Windows      | https://github.com/kubernetes/minikube/releases/download/v0.29.0/minikube-windows-amd64 |

```shell
$ minikube start --memory 4096 --disk-size 40g --kubernetes-version v1.11.3 -v 4
$ minikube addons enable ingress
```

Verify the setup by running the following commands:

```shell
$ minikube status
$ kubectl version
$ kubectl cluster-info
$ kubectl get nodes
```

Set up the required ingress hostnames for this workshop:

```shell
$ export MINIKUBE_IP=$(minikube ip)
$ sudo sh -c "echo \"\n\" >> /etc/hosts"
$ sudo sh -c "echo \"$MINIKUBE_IP  minio.minikube\" >> /etc/hosts"
$ sudo sh -c "echo \"$MINIKUBE_IP  nats.minikube\" >> /etc/hosts"
$ sudo sh -c "echo \"$MINIKUBE_IP  kubeless.minikube\" >> /etc/hosts"
$ sudo sh -c "echo \"$MINIKUBE_IP  function-python.minikube\" >> /etc/hosts"
$ sudo sh -c "echo \"$MINIKUBE_IP  function-node.minikube\" >> /etc/hosts"
```

## Setting up Helm

Download the Helm client CLI:

| Architecture | Download                                                                        |
|--------------|---------------------------------------------------------------------------------|
| Mac          | https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-darwin-amd64.tar.gz |
| Linux        | https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz  |
| Windows      | https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-windows-amd64.zip   |

```shell
$ helm init
```

Verify helm setup

```shell
$ helm version
```

## Installing Kubeless

Download the Kubeless client CLI:

| Architecture | Download                                                                                         |
|--------------|--------------------------------------------------------------------------------------------------|
| Mac          | https://github.com/kubeless/kubeless/releases/download/v1.0.0-alpha.8/kubeless_darwin-amd64.zip  |
| Linux        | https://github.com/kubeless/kubeless/releases/download/v1.0.0-alpha.8/kubeless_linux-amd64.zip   |
| Windows      | https://github.com/kubeless/kubeless/releases/download/v1.0.0-alpha.8/kubeless_windows-amd64.zip |

```shell
$ helm upgrade kubeless ./charts/kubeless --namespace kubeless \
  --install --wait --timeout 600 --force  --values assets/kubeless.yaml
```

Verify Kubeless installation

```shell
$ kubeless get-server-config
```

### Install NATS

[NATS](https://nats.io) is a simple, high performance open source messaging
system for cloud native applications, IoT messaging, and microservices
architectures. Kubeless has native support for NATS in addition to Kafka.

```shell
$ helm upgrade nats stable/nats --namespace nats-io \
  --install --wait --timeout 600 --force  --values assets/nats.yaml
```

## Open Kubeless UI

Set up local port forwarding

```shell
$ kubectl get pods -n kubeless | grep kubeless-ui | awk '{ print $1 }'
$ kubectl port-forward <pod-name> -n kubeless 3000 -n kubeless
```

Open `http://localhost:3000` to access the Kubeless UI.
