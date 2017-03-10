# S2I Builder for Angular Apps
OpenShift S2I builder image for Angular apps using Angular CLI and Apache httpd 2.4.

Builder image contains a NodeJS / NPM environment to be able to build your Angular application using the angular cli (ng build --prod).

Additionally the apache httpd web container is used during runtime to statically serve the files generated during build phase.

## S2I - Source 2 Image
You can directly invoke S2I builds from command line using the [S2I](https://github.com/openshift/source-to-image) binary.

This repository contains an angular app (*ng new test-app*) in the directory test/test-app that can be used for demo purpose. To build this demo app with S2i simply execute:

```
s2i build https://github.com/MrGoro/s2i-angular-container.git --context-dir=test/test-app/ schuermann/s2i-angular-container angular-sample-app
docker run -p 8080:8080 angular-sample-app
```

### Incremental Builds
You can trigger incremental builds by specifying *--incremental=true* when building an image. Incremental builds provide the already installed node_modules directory of a previous build within a following build.
```
s2i build https://github.com/MrGoro/s2i-angular-container.git --incremental=true --context-dir=test/test-app/ schuermann/s2i-angular-container angular-sample-app
docker run -p 8080:8080 angular-sample-app
```

### Use a different runtime image
For dynamic languages like PHP, Python, or Ruby, the build-time and run-time environments are the same. In this case using the builder as a base image for a resulting application image is natural.

For compiled languages like C, C++, Go, or Java, the dependencies necessary for compilation might dramatically outweigh the size of the actual runtime artifacts, or provide attack surface areas that are undesirable in an application image. See [S2I Docs - How to use a non-builder image for the final application image](https://github.com/openshift/source-to-image/blob/master/docs/runtime_image.md).
 
The same applies to Angular Apps that are compiled using a full NodeJS / NPM environment and a lot of dependencies (node_modules). During runtime they are served as static web pages from a web container with no need for NodeJS, the application source and all dependencies.

To use a different image for runtime, you can do the following with S2I:
```
s2i build https://github.com/MrGoro/s2i-angular-container.git --context-dir=test/test-app/ schuermann/s2i-angular-container angular-sample-app --runtime-image <runtime-image> --runtime-artifact </path/to/artifact>
```

For example to run the built app using nginx you could use the following:
```
s2i build https://github.com/MrGoro/s2i-angular-container.git --context-dir=test/test-app/ schuermann/s2i-angular-container angular-sample-app --runtime-image nginx --runtime-artifact /opt/app-root/src:/usr/share/nginx/html
```

## OpenShift
To use the builder image in your OpenShift environment you can import this simple image stream by creating the objects inside angular-s2i-httpd.json using the [OC](https://github.com/openshift/origin) binary:
```
oc create -f angular-s2i-httpd.json
```

To make the image stream globally availiable use the namespace *openshift*
```
oc create -f angular-s2i-httpd.json -n openshift
```
