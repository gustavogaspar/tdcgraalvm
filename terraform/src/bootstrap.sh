#!/bin/sh
sudo dnf install java-11-openjdk -y
yum install java-11-openjdk-devel.x86_64  -y
sudo wget https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.1.0/graalvm-ce-java11-linux-amd64-22.1.0.tar.gz -O /home/opc/graal.tar.gz
sudo tar -xzf /home/opc/graal.tar.gz -C /home/opc/