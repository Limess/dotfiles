#!/usr/bin/env bash

# serena MCP server
claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context claude-code --mode interactive --mode editing --mode no-memories --project-from-cwd
