# Lab 1: Creating a Function

At the core of Kubeless is a Function. A Function is representation of the code
to be executed. Along with the code a Function contains metadata about its
runtime dependencies, build instructions etc. In this lab you will learn how to:

* Creating functions with different runtimes
* Invoking functions from the command line
* Upgrading functions
* Getting logs from functions

In this lab you will work with two Functions, `hello-python` and `hello-node`,
and learn to manage them using the kubeless command line tool.

## Tutorial: Creating functions

Functions in Kubeless have the same format regardless of the language of the
function or the event source. In general, every function:

* Receives an object `event` as their first parameter. This parameter includes
  all the information regarding the event source. In particular, the key 'data'
  should contain the body of the function request.
* Receives a second object `context` with general information about the
  function.
* Returns a string/object that will be used as response for the caller.

A simple Hello World function in Python will look something like this:

```python
def handler(event, context):
  print (event)
  return event['data']
```

You can find more details about the function interface
[here](https://kubeless.io/docs/kubeless-functions#functions-interface).

To create, or deploy, functions you will be using `kubeless` commands:

```shell
$ kubeless function deploy hello-python --runtime python2.7 \
                                --from-file hello.py \
                                --handler hello.handler
INFO[0000] Deploying function...
INFO[0000] Function hello submitted for deployment
INFO[0000] Check the deployment status executing 'kubeless function ls hello-python'
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

## Exercise: Creating a Node.js function

In the previous tutorial you crated your first function using the Python
runtime. Now it is your turn to to create a function but this time using Node.js
runtime.

Deploy a new function with the following parameters:

| Name         | Runtime   | From file  | Handler       |
|--------------|-----------|------------|---------------|
| `hello-node` | `nodejs6` | `hello.js` | hello.handler |

## Tutorial: Listing functions

In order to see your function you can use both `kubectl` and `kubeless` command
line utilities. The reason you can use the `kubectl` command is that all
functions are stored as in the Kubernetes API as a custom `function` resource.

```shell
$ kubectl get functions
NAME            AGE
hello-python    5m
hello-node      1m
```

The `kubectl` view does not give us that much information since `kubectl` does
not know that much about what fields a function has and what is relevant to
display. Instead we can use the `kubeles` cli to get a more detailed view.

```shell
$ kubeless function ls
NAME            NAMESPACE   HANDLER       RUNTIME   DEPENDENCIES    STATUS
hello-python    default     hello.handler python2.7                 1/1 READY
hello-node      default     hello.handler node6                     1/1 READY
```

### Hints

You can also use `describe` in order to get more detailed information about a
function.

```
kubeless function describe <function>
```

## Tutorial: Invoking functions

You can invoke, or call, any function directly from the command line using the
`kubeless function call` command:

```shell
$ kubeless function call hello-python --data 'Hello world!'
```

As you can see this command takes in a `--data` parameter which will be sent to
the function and avaialble inside the `envent.data` object.

## Exercise: Invoke the Node.js function

Now it is your turn to invoke the `hello-node` function you created previously.
Try sending it your name in the `--data` flag and see what it returns.

### Quiz

* What happens if the function is invoked with an none or empty data?

## Tutorial: Upgrading functions

Upgrading a function is in fact nearly identical to how you ceate them. But
insted of calling `create` we call `update`; like this:

```shell
$ kubeless function update hello-python --from-file hello-v2.py
```

## Exercise: Upgrade the Node.js function

Now it is your turn to update the `hello-node` function to v2 using the
`hello-v2.js` file as a source.

Try invoking the function and see how the output has changed.

## Tutorial: Logs from functions

As you habe noticed only what is returned from the function when it has finished
executing is being returned to you when you are invoking the function. This is
by design. Anything that is printed to `stdout` or `stderr` is available as logs
form the function.

These can be viewed by using the `logs` subcommand like this:

```shell
kubeless function logs <function>
```

## Clean Up

When you are done you can exit your open shells and run the following command:

```shell
$ kubeless function delete hello-python
$ kubeless function delete hello-node
```

-----

<p align="right"><a href="../2-dependencies#readme">Lab 2: Managing Dependencies ➡️</a></p>
