#!/bin/bash
docker build -t image_hosts -f DockerHosts .
docker build -t image_ansible -f DockerAnsible .
