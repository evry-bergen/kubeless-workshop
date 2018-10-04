# Kubeless Workshop

Serverless Kubernetes Workshop with [Kubeless](kubeless), [NATS](nats), and
[Minio](minio). In this workshop you will learn how to:

* Set up a [Kubeless][kubeless]
* Creating functions using the `kubeless` CLI
* Creating triggers for invoking functions

[kubeless]: https://kubeless.io
[nats]: https://nats.io
[minio]: https://minio.io

## 0. Prerequsite

| Tool                        | Version        |
|-----------------------------|----------------|
| [Virtualbox](virtualbox-dl) | v5.2.18        |
| [Minikube](minikube-dl)     | v0.29.0        |
| [kubectl](kubectl-dl)       | v1.11.3        |
| [Helm](helm-dl)             | v2.11.0        |
| [Kubeless](kubeless-dl)     | v1.0.0-alpha.8 |

[virtualbox-dl]: https://www.virtualbox.org/wiki/Downloads
[minikube-dl]: https://github.com/kubernetes/minikube/releases
[kubectl-dl]: https://github.com/kubernetes/kubernetes/releases
[helm-dl]: https://github.com/helm/helm/releases
[kubeless-dl]: https://github.com/kubeless/kubeless/releases

## 1. Installing Dependencies

### 1.1. Setting up Minikube

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

### 1.2. Setting up Helm

Download the Helm client CLI:

| Architecture | Download                                                                        |
|--------------|---------------------------------------------------------------------------------|
| Mac          | https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-darwin-amd64.tar.gz |
| Linux        | https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz  |
| Windows      | https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-windows-amd64.zip   |

Insstall the Helm server component:

```shell
$ helm init --upgrade
```

Verify that Helm is set up correctly:

```shell
$ helm version
```

### 1.3. Installing Kubeless

Download the Kubeless client CLI:

| Architecture | Download                                                                                         |
|--------------|--------------------------------------------------------------------------------------------------|
| Mac          | https://github.com/kubeless/kubeless/releases/download/v1.0.0-alpha.8/kubeless_darwin-amd64.zip  |
| Linux        | https://github.com/kubeless/kubeless/releases/download/v1.0.0-alpha.8/kubeless_linux-amd64.zip   |
| Windows      | https://github.com/kubeless/kubeless/releases/download/v1.0.0-alpha.8/kubeless_windows-amd64.zip |

Install the Kubeless control pane using Helm:

```shell
$ helm upgrade kubeless ./charts/kubeless --namespace kubeless \
  --install --wait --timeout 600 --force  --values config/kubeless.yaml
```

Verify the Kubeless installation:

```shell
$ kubeless get-server-config
```

### 1.4. Install NATS

[NATS](https://nats.io) is a simple, high performance open source messaging
system for cloud native applications, IoT messaging, and microservices
architectures. Kubeless has native support for NATS in addition to Kafka.

Install the NATS server using Helm:

```shell
$ helm upgrade nats stable/nats --namespace nats-io \
  --install --wait --timeout 600 --force  --values config/nats.yaml
```

### 1.5. Install Minio

[Minio](https://minio.io) is a high performance distributed object storage
server, designed for large-scale private cloud infrastructure.

Download the Minio client CLI:

| Architecture | Download                                                   |
|--------------|------------------------------------------------------------|
| Mac          | https://dl.minio.io/client/mc/release/darwin-amd64/mc      |
| Linux        | https://dl.minio.io/client/mc/release/linux-amd64/mc       |
| Windows      | https://dl.minio.io/client/mc/release/windows-amd64/mc.exe |

Install the Minio server using Helm:

```shell
$ helm upgrade minio stable/minio --namespace minio \
  --install --wait --timeout 600 --force --values config/minio.yaml
```

Set up the `mc` client command line utility to communicate with the Minio
installation.

```shell
$ export MINIKUBE_IP=$(minikube ip)
$ mc config host add local \
  http://${MINIKUBE_IP}:30900 \
  AKIAIOSFODNN7EXAMPLE \
  wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY \
  --api "S3v4" \
  --lookup "path"
```

Verify the setup by running:

```shell
$ mc ls --recursive local
```

## 2. Labs

1. [Creating Functions](./labs/1-functions)

## 3. Tips and Tricks

### Kubeless UI

You can view the Kubless UI by going to [kubeless.minikube](kubeless-minikube)
in your browser.

[kubeless-minikube]: http://kubeless.minikube
