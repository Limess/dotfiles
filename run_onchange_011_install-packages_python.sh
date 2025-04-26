#!/bin/bash

uv install {{ range .packages.all.crates }}{{ . | quote }} {{ end }}
