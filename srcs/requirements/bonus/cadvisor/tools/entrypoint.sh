#!/bin/bash

exec /usr/local/bin/cadvisor -logtostderr -port=${CADVISOR_PORT}