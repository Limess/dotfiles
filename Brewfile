# AWS CLI https://aws.amazon.com/cli/
brew 'awscli@2'
# zsh plugin manager
brew 'antidote'
# cat alternative https://github.com/sharkdp/bat
brew 'bat'
# better git pager https://github.com/dandavison/delta
brew 'git-delta'
# clojure scripting support https://github.com/babashka/babashka
brew 'borkdude/brew/babashka'
# clojure linter https://github.com/clj-kondo/clj-kondo
brew 'borkdude/brew/clj-kondo'
# graphical process manager
brew 'bottom'
cask 'circleci-public/circleci/circleci@next'
# secrets manager using SSM https://github.com/segmentio/chamber
brew 'chamber'
brew 'coreutils'
brew 'clojure'
# https://cuelang.org/
brew 'cue-lang/tap/cue'
brew "doitlive"
brew 'common-fate/granted/granted'
# better lsh
# better du https://github.com/bootandy/dust
brew 'dust'
brew 'eza'
# better find https://github.com/sharkdp/fd
brew 'fd'
brew 'fzf'
brew 'findutils'
# https://github.com/wagoodman/dive
brew 'dive'
# github CLI https://github.com/cli/cli
brew 'gh'
# source control
brew 'git'
brew 'gnu-sed'
brew 'gnupg'
brew 'hadolint'
brew 'helm'
brew 'httpstat'
brew 'imagemagick'
# kubernetes context switching https://github.com/ahmetb/kubectx
brew 'kubectx'
brew 'kubernetes-cli'
# colorized kubectl output https://github.com/kubecolor/kubecolor
brew 'kubecolor'
# kubectl plugin manager https://github.com/kubernetes-sigs/krew
brew 'krew'
# kubernetes management tool https://github.com/derailed/k9s
brew 'derailed/k9s/k9s'
# JSON utility https://stedolan.github.io/jq/
brew 'jq'
brew 'jp2a'
brew 'libgit2'
# cross-tool version manager https://mise.jdx.dev
brew 'mise'
# Security network tool
brew 'nmap'
brew "pgcli"
# better ps https://github.com/dalance/procs
brew 'procs'
brew 'readline'
# better grep (https://github.com/BurntSushi/ripgrep)
brew 'ripgrep'
# LLM CLI proxy https://github.com/rtk-ai/rtk
brew 'rtk'
brew 'stunnel'
brew 'shellcheck'
# shell prompt https://starship.rs
brew 'starship'
brew 'tree'
brew 'unzip'
brew 'uv'
brew 'vim'
brew 'wget'
brew 'yarn'
brew 'zopfli'
# like httpie https://github.com/ducaale/xh
brew 'xh'
# kubernetes logs
brew 'stern'
# better cd
brew 'zoxide'

if OS.mac?
  cask_args appdir: '/Applications'

  # Start with mas (Mac App Store) and related software so we get XCode
  brew 'mas'

  mas 'dato', id: 1470584107
  mas 'magnet', id: 441258766
  mas 'slack', id: 803453959
  mas 'whatsapp', id: 310633997
  mas 'xcode', id: 497799835
  mas 'yubico-authenticator', id: 1497506650

  brew 'git'
  brew 'reattach-to-user-namespace' # https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
  brew 'tmux'
  brew 'bash'
  brew 'pinentry-mac'
  # driver for postgres for use with MySQL Workbench
  brew 'psqlODBC'
  brew 'zsh'

  cask 'bluesnooze' # disable bluetooth while mac is sleeping to prevent it staying connected to headphones
  cask 'docker-desktop'
  cask 'firefox'
  cask 'flux-app'
  cask 'ghostty'
  # Installed by signal
  # cask 'google-chrome'
  # hyperdock seems to be broken
  # cask 'hyperdock'
  cask 'kap'
  cask 'jetbrains-toolbox'
  # https://lidrun.com - keeps AI/dev jobs running with the lid closed
  cask 'aibrickai/lidrun/lidrun'
  # cask 'minikube'
  cask 'private-internet-access'
  # cask 'podman'
  cask 'raycast'
  cask 'sensiblesidebuttons'
  cask 'sublime-text'
  cask 'spotify'
  cask 'tableplus'
  cask 'visual-studio-code'
  cask 'vlc'

  brew 'boot-clj'
end
