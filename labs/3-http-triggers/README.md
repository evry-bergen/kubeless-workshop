# Lab 3: HTTP Triggers

Kubeless leverages Kubernetes ingress to provide routing for functions. By
default, a deployed function will be matched to a Kubernetes service using
ClusterIP as the service. That means that the function is not exposed publicly.
Because of that, we provide the kubeless trigger http command that can make a
function publicly available. This guide provides a quick sample on how to do it.

## Ingress controller

In order to create routes for functions in Kubeless, you must have an Ingress
controller running. There are several options to deploy it. In this document we
point to several different solutions that you can choose:

### Minikube Ingress addon

If your cluster is running in Minikube you can enable the Ingress controller
just executing:

```shell
$ minikube addons enable ingress
```

## Deploy function with Kubeless CLI

Once you have a Ingress Controller running you should be able to start deploying
functions and expose them publicly. First deploy a function:

```shell
$ kubeless function deploy name-python \
                    --runtime python3.4 \
                    --handler name.handler \
                    --from-file name.py
```

```shell
$ kubectl get pods
NAME                          READY     STATUS    RESTARTS   AGE
name-python-1796153810-krrf3   1/1       Running   0          2s
```

```shell
$ kubectl get services
NAME         CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
name-python  10.0.0.26    <none>        8080/TCP   44s
```

## Creatre HTTP trigger

We will create a http trigger to the `name-python` function:

```shell
$ kubeless trigger http create name-python --function-name name-python
```

This command will create an ingress object that we can explore using `kubectl`:

```shell
$ kubectl get ingress
NAME           HOSTS                              ADDRESS          PORTS     AGE
name-python    name-python.192.168.99.100.nip.io  192.168.99.100   80        59s
```

By default Kubeless creates a default hostname in form of `.MINIKUBE_IP.nip.io`.
Alternatively, you can provide a real hostname with `--hostname` flag. You can
also set the path by using the `--path` flag.

Lets send some JSON data `{"name": "Batman"}` to this address and see what we get
in return:

```shell
$ curl --data '{"name": "Batman"}' \
       --header "Content-Type: application/json" \
        name-python.$(minikube ip).nip.io
```

## Clean Up

When you are done you can exit your open shells and run the following command:

```shell
$ kubeless function delete hello-python
$ kubeless function delete hello-node
```

-----

<p align="right"><a href="../4-monitoring#readme">Lab 4: Monitoring Functions ➡️</a></p>
