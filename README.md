# openeew-download

This reposistory builds the source image for [download.openeew.com](https://download.openeew.com) which is used as a secure download server to deliver firmware to OpenEEW sensors.

The [OpenEEW Firmware](https://github.com/openeew/openeew-firmware) that runs on the ESP32 based [OpenEEW Sensor](https://github.com/openeew/openeew-sensor) will activate itself via the OpenEEW Devicement Management orchestration process. The sensor firmware knows what version it is running and sends this information to the OpenEEW Device Management service endpoint.  The endpoint responds with the latest version number of the firmware and the https URL where the latest version of the firmware can be downloaded.  The ESP32 then determines if the firmware it is running is downlevel and, if necessary, will initiate an ESP32 over the air (OTA) upgrade using the [esp_https_ota()](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/system/esp_https_ota.html) API.  That API downloads the new firmware binary from a https URL download server.

This repository contains the source image of that download server.
- the smallest, simplest Express https server
- the firmware binaries (typically sourced from [OpenEEW Firmware Releases](https://github.com/openeew/openeew-firmware/releases))
- the Dockerfile to build a container from this express server and firmware binaries
- the yaml file to deploy it to a IBM Cloud Container Service (IKS) kubernetes cluster that hosts the core components of openeew.com

## Express Server

This `static-server.js` module creates an HTTP web server and serves static content
from a specified directory on a specified port.

This express server is constructed from examples located at:
- https://expressjs.com/en/starter/static-files.html


To execute this express server, git clone this repo.  Review the package.json
To start the local server.

```sh
npm install
node static-server.js
```

## Build a container

The `Dockerfile` in this repo creates container which runs the express server to serve the firmware binaries.

```sh
docker build -t openeew/openeew-download:v1 .
```

```
echo SERVER_PORT=8443>./env.list
docker rm openeew-download
docker run -it -p 8443:8443 --env-file env.list --name openeew-download openeew/openeew-download:v1
```

## Kubernetes yaml file

Use the `download-v1.yaml` file to deploy this container to IKS

To create the secret, you may need to add the base64 encoded SERVER_PORT to the `Secret` section of the yaml file

```sh
$ echo -n 8443 | base64
ODQ0Mw==
```

```
ibmcloud login --sso
ibmcloud cr login
ibmcloud cr region-set us-south
ibmcloud target -g OpenEEW-Infra
ibmcloud ks cluster config --cluster <cluster-config>
ibmcloud cr namespace-add openeew-download
docker push us.icr.io/openeew-download/openeew-download:v1
kubectl apply -f download-v1.yaml --namespace default
```

### Contributors

<a href="https://github.com/openeew/openeew-download/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=openeew/openeew-download" />
</a>
___

Enjoy! Give us [feedback](https://github.com/openeew/openeew-download/issues) if you have suggestions on how to improve this information.

## Contributing and Developer information

The community welcomes your involvement and contributions to this project. Please read the OpenEEW [contributing](https://github.com/openeew/openeew/blob/master/CONTRIBUTING.md) document for details on our code of conduct, and the process for submitting pull requests to the community.

## License

The OpenEEW sensor is licensed under the Apache Software License, Version 2. Separate third party code objects invoked within this code pattern are licensed by their respective providers pursuant to their own separate licenses. Contributions are subject to the [Developer Certificate of Origin, Version 1.1 (DCO)](https://developercertificate.org/) and the [Apache Software License, Version 2](http://www.apache.org/licenses/LICENSE-2.0.txt).
