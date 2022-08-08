# prevent bash completion from correcting serverless
alias serverless="nocorrect serverless"
alias npmu="npx npm-check -u"
alias tsc="nocorrect tsc"

# prevent spotlight/alfred indexing node_modules
# https://twitter.com/Herschel_R/status/1113095592559984641
function npm_install {
    mkdir -p node_modules
    touch ./node_modules/.metadata_never_index
    if [ -f yarn.lock ]; then
        yarn install $@
    else
        npm install $@
    fi
}
alias ni=npm_install
alias nvm=fnm
alias jest="nocorrect jest"
