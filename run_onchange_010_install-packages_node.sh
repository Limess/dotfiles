#!/bin/bash

npm install -g {{ range .packages.all.npm }}{{ . | quote }} {{ end }}
