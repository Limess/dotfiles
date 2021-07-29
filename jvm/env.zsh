export PATH="$HOME/.jenv/bin:$HOME/.jetbrains:$PATH"
export SCALA_HOME="/usr/local/opt/scala/idea"
export JAVA_OPTS="${JAVA_OPTS} -Djava.net.useSystemProxies=true"

eval "$(jenv init -)"

if [ -f /usr/libexec/java_home ]; then
	JENV_VERSION_NAME=$(jenv version-name)
	export JAVA_HOME="$(/usr/libexec/java_home -v $JENV_VERSION_NAME)"
fi

