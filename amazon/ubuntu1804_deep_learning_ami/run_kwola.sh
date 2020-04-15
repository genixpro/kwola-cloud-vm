#!/usr/bin/env bash


cd /home/ubuntu
s3fs `cat .s3-bucket` kwola_s3_mount
source venv/bin/activate
cd kwola_s3_mount
kwola
