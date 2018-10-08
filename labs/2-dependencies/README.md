# Lab 2: Function Dependencies

In this exerciese we will deploy a function that has some external library
dependencies and see how Kubeless handles dependencies.

Kubeless has support for a number of different programming lanaguages and their
prefered package managers:

| Language  | Package manger  | Package file      |
|-----------|-----------------|-------------------|
| Java      | Maven           | pom.xml           |
| Node.js   | npm             | package.json      |
| Python    | pip             | requirements.txt  |
| Ruby      | gem             | Gemfile           |
| Go        | dep             | Gopkg.toml        |
| .Net Core | NuGet           | .csproj           |

### Tip

You can use `kubelctl get pods -w` in a seperate terminal window in order to
"see" how dependencies are installed using the init contianer method. Do this
before running any `kubless function deploy`.

## Exercise: Deploy the Weather forcast function

In this exercise we are going to deploy a simple function that uses
query.yahooapis.com to retrieve the weather forcast for a specific location.

Deploy the function using the `kubeless function deploy` command with the
following parameter:

* name: weather
* runtime: nodejs8
* file: index.js
* dependencies: package.json
* handler: index.weather

Use `kubeless function deploy -h` to get the name of the command line options.

### Tip

You can view a functions dependencies by lising all functions using `kubless
function list` or by inspecting the function using `kubeless function describe
<name>` where `<name>` is the name of the function you have deployed.

### Quiz

* Using the `kubeless` CLI what are the dependencies of this function?

## Exerciese: Get the Weather forcast

Now that the function has been deployed you can invoke the weather function by
using the `kubeless function call` command.

This function expect a data input of the following format:

```json
{"location": "<location>"}
```

Example:

```
{"location": "Oslo, Norway"}
```

### Tip

Use `kubeless function call --help` if you are usure about the arguments
required to invoke functions.

### Quiz

* What is the weather forcast for `Bergen, Norway`?
* What is the weather forcast for `Trollvik, Troms Fylke, Norway`?

## Clean Up

When you are done you can exit your open shells and run the following command:

```shell
$ kubeless function delete weather
```

-----

<p align="right"><a href="../3-http-triggers#readme">Lab 3: HTTP Triggers ➡️</a></p>
