# Lab 4: Monitoring Functions

Kubeless monitoring relies on Prometheus. Each supported language runtimes are
instrumented in such a way that they are automatically collecting metrics for
each function invocation.

## Grafana

You could also use Grafana to visualize the prometheus metrics exposed by
Kubeless. Example of a Grafana dashboard for Kubeless showing function call
rate, function failure rate and execution duration:

![Kubeless Grafana dashboard](https://kubeless.io/docs/img/kubeless-grafana-dashboard.png)

## Expercise: Deploy a flakey function

Lets deploy a function that can generate some metrics. This function will fail
on avegare 20% of the time – lets check if that holds true.

```shell
$ kubeless function deploy flakey-node \
  --runtime nodejs6 \
  --handler flakey.handler \
  --from-file flakey.js
```

Now lets generate some traffic for this function to populate the dashboard:

```shell
$ while :
> do
>   kubeless function call flakey-node --data 'test'
> done
```

## Tutorial: View Metrcis

You can now go to Grafana and navigate to the `Kubeless` dashboard:

```
make open-grafana
```

### Hint

Some time the built in dashboard does not load, try refreshing and if not create
a new dashboard and upload the `dashboard.json` file inside this directory as
the source.

## Clean Up

When you are done you can exit your open shells and run the following command:

```shell
$ kubeless function delete flakey-node
```

-----
