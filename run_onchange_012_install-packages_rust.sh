#!/bin/bash

cargo install {{ range .packages.all.crates }}{{ . | quote }} {{ end }}
