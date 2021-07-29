# Windows

Running on Windows presents some interesting challenges to running on OSX/Linux.

I've now nearly entirely using [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/faq) after finding other solutions (git bash, cygwin, running an Ubuntu VM, dual booting, docker, vagrant) unpalletable for a variety of reasons, normally speed and context switching.

This document is intended to serve as a guide for re-configuring WSL with these dotfiles/generally.

## Tweaks

Disable windows defender for the WSL folder. This makes a **huge** difference to performance. See this [gist](https://gist.github.com/noelbundick/9c804a710eb76e1d6a234b14abf42a52) for a powershell script to run.

This has slight security implications, but it's a 5x increase in most IO operations so totally worth it if you're going to be relying on this as a productivity tool.

## Terminal

After trying a few terminals (conemu/cmder, git bash, the default terminal) and reading very negative things about others (hyper) I've currently settled on:

-   [Terminus](https://eugeny.github.io/terminus/) - Nice interface, slightly buggy settings, seems to have input lag, no native terminal splitting
-   [wsltty](https://github.com/mintty/wsltty) - Fast, lightweight, customisable, doesn't take over other terminals and lead to long startup times (I'm looking at you conemu)

For the moment I'm trying both, but may settle one one (more likely wsltty with tmux for splitting if I want full productivity).

## Git

Ah git on WSL. Such pain. For now, see [wslgit](https://github.com/andy-5/wslgit) although this has a number of issues and generally has to trade off working with docker with working at all with VSCode.

## Editor

VSCode in Windows. Open editors using `code $path` in WSL. Git integration is broken/finnecky and tools (go/python etc) need installing on the host windows installation (i.e. installing twice and having 2x the dependencies).

## Docker

See [Setting Up Docker for Windows and WSL to Work Flawlessly](https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly). Note it's not flawless, as using custom mountpoints seems to break git at the time of writing. Pretty good though.

If for some reason exposing the Docker daemon without TLS doesn't work in WSL despite being ticked, make sure Windows has not [reserved port 2375](https://github.com/docker/for-win/issues/3546#issuecomment-483311479).

## ssh-agent

Use [ssh-agent-wsl](https://github.com/rupor-github/ssh-agent-wsl). Start the agent on startup and add keys in Windows. This is actually a lovely experience. May need to set the Windows OpenSSH service to run automatically and occasionally kick it to ensure it's running.

## Package manager

I'm currently using [brew](https://brew.sh/). Linuxbrew is now part of brewcore and vaguely works with non-terrible performance. This is a means of convenience to dual-run OSX and Windows setups, if I was a linux user at work I'd no-doubt use `apt` rather than brew but right now finding packages for both is a pain. Early days of WSL this had horrible perf issues but it seems to have improved.
