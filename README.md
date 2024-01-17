# Tomcat 8.5 for Developers

This is a modified `tomcat:8.5` image with some minor adjustments to make it easier to deploy a local application to.

* Common jars are baked into lib
* Easy to add more files (like configuration) to the classpath through a mount point

## Building

`./build-image.sh` builds the image. It currently doesn't push it up anywhere.

The Tomcat version can be changed in the .env file, which will change both the base image and the tag for the produced image.

## Rootless Docker recommended

Standard Docker install runs as root, which means all your containers have root privileges, and can accidentally write files owned by root to your mounted directories. For development containers this is almost never what we want, so it's recommended to set up [rootless Docker][rootless].

## Usage

Your app should be able to build a `ROOT.war`. On a Gradle project, this should be under `build/libs` - other build systems will vary.

Files placed under `/app/classpath` will become part of the classpath, so this is a good place to mount configuration files.

You may want to mount a replacement `/usr/local/tomcat/conf/context.xml` if you want to define Tomcat-managed DataSources.

This should run a one-shot Tomcat that deploys your Gradle-built application (If you are using rootless Docker, leave out the `--user ...` option`)

```
docker run --rm --name tomcat --user $(id -u) --network host \
 -v ./build/libs:/usr/local/tomcat/webapps \
 -v ./config:/app/classpath \
 universityofwarwick/dev-tomcat
```

[rootless]: https://docs.docker.com/engine/security/rootless/#install