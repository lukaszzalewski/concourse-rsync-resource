FROM python:3-slim-buster

RUN apt-get update && apt install -y bash rsync openssh-server findutils
RUN pip install paramiko

COPY ./assets/* /opt/resource/
