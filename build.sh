#!/bin/sh -ex

docker build -t ye-olde-bsd .
docker run -itp 127.0.0.1:25:25 -p 127.0.0.1:79:79 ye-olde-bsd
