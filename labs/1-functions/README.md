# Lab 1: Creating a Function

Functions in Kubeless have the same format regardless of the language of the
function or the event source. In general, every function:

* Receives an object `event` as their first parameter. This parameter includes all the information regarding the event source. In particular, the key 'data' should contain the body of the function request.
* Receives a second object `context` with general information about the function.
* Returns a string/object that will be used as response for the caller.

A simple Hello World function in Python will look something like this:

```python
def hello(event, context):
  print event
  return event['data']
```

You can find more details about the function interface
[here](https://kubeless.io/docs/kubeless-functions#functions-interface).

You create the function by using the `kubeless` command line utility:

```shell
$ kubeless function deploy hello-python --runtime python2.7 \
                                --from-file hello.py \
                                --handler hello.handler
INFO[0000] Deploying function...
INFO[0000] Function hello submitted for deployment
INFO[0000] Check the deployment status executing 'kubeless function ls hello'
```

Let's have a closer look at what is going on in this example:

* `hello`: This is the name of the function we want to deploy.
* `--runtime python2.7`: This is the runtime we want to use to run our function.
  Available runtimes are shown in the help information.
* `--from-file test.py`: This is the file containing the function code. It is
  supported to specify a zip file as far as it doesn't exceed the maximum size
  for an etcd entry (1 MB).
* `--handler test.foobar`: This specifies the file and the exposed function that
  will be used when receiving requests. In this example we are using the
  function foobar from the file test.py.

You can find more deployment configuration options available by executing
`kubeless function deploy --help`.

In order to see the newly created function we can use both `kubectl` and
`kubeless` command line utilities.

```shell
$ kubectl get functions
NAME         AGE
hello        1h

$ kubeless function ls
NAME            NAMESPACE   HANDLER       RUNTIME   DEPENDENCIES    STATUS
hello           default     helloget.foo  python2.7                 1/1 READY
```

We can invoke the function directly from the command line using the `kubeless
function call` command:

```shell
$ kubeless function call hello --data 'Hello world!'
Hello world!
```
