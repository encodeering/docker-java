# this generated image bundles a java distribution from oracle, which means, that any derivation must require an explicit agreement
# from any consumer on the terms and conditions of oracle
# any derivation is further hold responsible to implement a proper mechanism to obtain the required agreement
# e.g.: the entrypoint is by docker's definition a good candidate, but it doesn't support inheritance
FROM       buildpack-deps:dynamic

MAINTAINER Michael Clausen <encodeering@gmail.com>

ARG        VERSION
ARG        VERSIONSHA
ARG        DOWNLOAD
ARG        LEGAL

LABEL      agreement "an agreement on the java terms and conditions of oracle is required"

RUN        mkdir -p "/opt/java/$VERSION" \
 &&        wget --header "Cookie: oraclelicense=accept-securebackup-cookie" $DOWNLOAD -P /opt/java \
 &&        echo "$VERSIONSHA `find /opt/java/*.tar.gz`" | sha256sum -c -                           \
 &&        tar -xzf /opt/java/*.tar.gz -C "/opt/java/$VERSION" --strip-components=1                \
 &&        rm       /opt/java/*.tar.gz                                                             \
 &&        test -d  /opt/java/$VERSION

RUN {                                        \
           echo "#!/bin/bash";               \
           echo "set -e";                    \
           echo;                             \
           echo "exec docker-eula -k java -u $LEGAL \"\$@\""; \
} >          /usr/local/bin/docker-eula-java \
 && chmod +x /usr/local/bin/docker-eula-java

ENV              JAVA_HOME /opt/java/$VERSION
ENV        PATH $JAVA_HOME/bin:$PATH

ENTRYPOINT ["docker-eula-java"]

CMD        ["bash"]
