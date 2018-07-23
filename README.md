## Add Go to OpenShift catalog

Apply `go.yaml` template to your OpenShift cluster, Then you will have Go in your catalog.

```
oc apply -f go.yaml -n openshift
```

It should looks like this:

![openshift_catalog_go](./files/openshift_catalog_go.png)


## Create Docker Registry Secret

```bash
$ oc create secret docker-registry my-docker-registry --docker-server=<server> --docker-username=<username> --docker-password=<password> --docker-email=<email>
```

## Create Source Clone Secret

```bash
$ oc -n myproject create secret generic my-github-clone-secret --from-file=ssh-privatekey=<path/to/ssh/private/key> --type=kubernetes.io/ssh-auth
```

## Create Config Map

By command line

```bash
$ oc create configmap <name> --from-env-file=<path/to/bar.env> -n myproject
```

Later when the env variables needs to change, you can do this to update them:

```bash
$ oc delete configmap <name> -n myproject
$ oc create configmap <name> --from-env-file=<path/to/bar.env> -n myproject
```

## Create New App

Click the Go icon that created by us before, you will see:

![new_app](./files/new_app.png)

And fill in the secrets and config maps created above. then you will be able to deploy your first app


## How you should write your Build.Dockerfile

For OpenShift be able to build your Go app correctly, You have to provide a Build.Dockerfile in your source repository. See [Build.Dockerfile](./app1/Build.Dockerfile) for example.

And for many type of apps, I think manage a dependency container image is a good idea to increase the speed of your build time. Because you manually build the dependency image and push it to registry, and OpenShift will cache that image in it's docker and reused them every time without have to fetch dependencies. See [Dep.Dockerfile](./app1/Dep.Dockerfile) for example

## Two Stage Build

This OpenShift template contains two BuildConfig

First stage called `{name}-compile` which will git clone your source code, and run your `Build.Dockerfile` to build the binary and other assets that you want include in `/app/` folder.

Second stage use a very small base image like alpine and the files in `/app/` to create a minimum image, It will execute `/app/entry` as docker cmd.

## Trigger OpenShift to build and deploy after tests on CI passed

We can integrate OpenShift with Semaphore CI with it's general trigger on BuildConfig, navigate OpenShift Console to the BuildConfig for `{name}-compile`:

![general_web_hook](./files/general_web_hook.png)

Copy that value, and put this curl to call it into your Semaphore CI build after test succeed.

```bash
curl -k -X POST -H "Content-Type: application/json" https://192.168.99.100:8443/oapi/v1/namespaces/myproject/buildconfigs/goapp-hello-compile/webhooks/fluuRF2rFY5RcIBeipj3/generic
```
