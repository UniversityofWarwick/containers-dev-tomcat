# Tomcat 9 for Developers [![Build and Publish Docker Image](https://github.com/UniversityofWarwick/containers-dev-tomcat/actions/workflows/docker.yml/badge.svg)](https://github.com/UniversityofWarwick/containers-dev-tomcat/actions/workflows/docker.yml)

This is a modified Tomcat 9 image with some minor adjustments to make it easier to deploy a local application to.

* Common jars are baked into lib
* Enable JRebel and XRebel with a simple environment variable
* Easy to add more files (like configuration) to the classpath through a mount point

Images are pushed to Docker Hub at https://hub.docker.com/r/universityofwarwick/dev-tomcat/tags

## Building

`./build-image.sh` builds a version of the image, based on what's in `.env` and what other build args you pass it. The default should be to generate the most modern version. The GitHub workflow should handle pushing new versions up. There are a few alternative tags to select the JDK that your app requires.

The Tomcat version can be changed in the .env file, which will change both the base image and the tag for the produced image.

## Rootless Docker recommended

Standard Docker install runs as root, which means all your containers have root privileges, and can accidentally write files owned by root to your mounted directories. For development containers this is almost never what we want, so it's recommended to set up [rootless Docker][rootless].

## Usage

Your app should be able to build a `ROOT.war`. On a Gradle project, this should be under `build/libs` - other build systems will vary.

Files placed under `/app/classpath` will become part of the classpath, so this is a good place to mount configuration files.

You may want to mount a replacement `/usr/local/tomcat/conf/context.xml` if you want to define Tomcat-managed DataSources.

This should run a one-shot Tomcat that deploys your Gradle-built application

```
docker run -it --rm --name tomcat --network host \
 -v ./build/libs:/usr/local/tomcat/webapps \
 -v ./config:/app/classpath \
 -v xrebel_config:/root/.xrebel \
 universityofwarwick/dev-tomcat:9-jdk17
```

## Options

* `-e ENABLE_JREBEL=1` - Enable JRebel agent.
* `-e ENABLE_XREBEL=1` - Enable XRebel agent.
* `-e DISABLE_DEBUG=1` - Disable debug port 8000
* `-e XREBEL_EMAIL=your.email@warwick.ac.uk` - your email as registered with license (file or server)
* `-e XREBEL_URL=xyz` - URL to your team license, if you have a hotseat.
* `-e XREBEL_FILE=/path/to/xrebel.lic` - Path to a license file if you have one. You'll need to mount this inside the container.

## Using JRebel

Install the [IntelliJ JRebel Plugin][jrebel-install].

Follow the [Setup instructions][jrebel-setup]. Skip step 1 as this is handled by this container. In step 2 you will add a remote server pointing at `http://localhost:8080` - it will warn you that this is silly, but it's actually not.

You should set up your project's `.gitignore` to ignore `rebel.xml` and `rebel-remote.xml` as they will be specific to you.

Deploy your app. Make a change to your code and compile it - it should reload!

## Using XRebel

Pass the `XREBEL_EMAIL` and `XREBEL_URL` environment variables containing your email address and your team license URL. When you first run the app and open a page, it will trigger an activation email to your inbox. Click that to activate the license. You will then need to restart the container for it to pick up the new status. Once that's done, it should be ready to use and you shouldn't need to do these steps again.

This process relies on the ~/.xrebel directory being persistent between runs so make sure you are mounting it as a volume (as is done in the Usage section above)

Some people have an individual license file instead - if that's you, mount the file into the container and point to it using the `XREBEL_FILE` environment variable instead of using `XREBEL_URL`.


[rootless]: https://docs.docker.com/engine/security/rootless/#install
[jrebel-install]: https://www.jrebel.com/products/jrebel/quickstart/intellij/
[jrebel-setup]: https://manuals.jrebel.com/jrebel/remoteserver/intellij.html#intellijremoteserver
