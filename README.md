# limess does dotfiles

Your dotfiles are how you personalize your system. These are mine.

Realised I should _finally_ have a source controlled set of config files to stop general day to day maintenence being a chore. Tried to get start with Paul Irish's files (https://github.com/paulirish/dotfiles) which looked excellent however I need something a bit more structured to keep me sane.

These files are forked from Zach Holman's original dotfiles - adding antibody as a zsh package manager.

Holman's post on the subject: (http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `script/bootstrap`.

## what's inside

A lot of stuff. Seriously, a lot of stuff. Check them out in the file browser
above and see what components may mesh up with you.
[Fork it](https://github.com/holman/dotfiles/fork), remove what you don't
use, and build on what you do use.

## components

There's a few special files in the hierarchy.

-   **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
    available everywhere.
-   **Brewfile**: This is a list of applications for [Homebrew Cask](http://caskroom.io) to install: things like Chrome and 1Password and Adium and stuff. Might want to edit this file before running any initial setup.
-   **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
    environment.
-   **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
    expected to setup `$PATH` or similar.
-   **topic/completion.zsh**: Any file named `completion.zsh` is loaded
    last and is expected to setup autocomplete.
-   **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
    your `$HOME`. This is so you can keep all of those versioned in your dotfiles
    but still keep those autoloaded files in your home directory. These get
    symlinked in when you run `script/bootstrap`.

## install

First install [Homebrew](https://brew.sh/). This will be used later to install CLI apps and cask applications (`./script/install`).

Run this:

```sh
git clone --recurse-submodules -j8 https://github.com/limess/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
script/install
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`dot` is a simple script that installs some dependencies, sets sane OS X
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.
