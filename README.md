# S2I Builder for Angular Apps
OpenShift S2I builder image for Angular apps using Angular CLI and Apache httpd 2.4.

Builder image contains a NodeJS / NPM environment to be able to build your Angular application using the angular cli (ng build --prod).

Additionally the apache httpd web container is used during runtime to statically serve the files generated during build phase.

## S2I - Source 2 Image
You can directly invoke S2I builds from command line using the [S2I](https://github.com/openshift/source-to-image) binary.

This repository contains an angular app (ng new test-app) in the directory test/test-app that can be used for demo purpose. To build this demo app with S2i simply execute:

```
s2i build https://github.com/MrGoro/s2i-angular-container.git --context-dir=test/test-app/ schuermann/s2i-angular-container angular-sample-app
docker run -p 8080:8080 angular-sample-app
```

## OpenShift
To use the builder image in your OpenShift environment you can import this simple image stream by creating the objects inside angular-s2i-httpd.json using the [OC](https://github.com/openshift/origin) binary:
```
oc create -f angular-s2i-httpd.json
```

To make the image stream globally availiable use the namespace openshift
```
oc create -f angular-s2i-httpd.json -n openshift
```
