#!/bin/sh
FROM rhel7
ENV HOME /tmp
ENV OS_CLI_VERSION v3.10.0-rc.0
ENV OS_TAG c20e215

RUN yum install curl ca-certificates && \
    curl -s -L https://github.com/openshift/origin/releases/download/${OS_CLI_VERSION}/openshift-origin-client-tools-${OS_CLI_VERSION}-${OS_TAG}-linux-64bit.tar.gz -o /tmp/oc.tar.gz && \
    tar zxvf /tmp/oc.tar.gz -C /tmp/ && \ 
    mv /tmp/openshift-origin-client-tools-${OS_CLI_VERSION}-${OS_TAG}-linux-64bit/oc /usr/bin/ && \
    rm -rf /tmp/oc.tar.gz /tmp/openshift-origin-client-tools-${OS_CLI_VERSION}-${OS_TAG}-linux-64bit/ && \
    rm -rf /root/.cache /var/cache/yum/ && \
    oc version

CMD ["oc"]
COPY script.sh /opt/script.sh
RUN chmod +x /opt/script.sh
CMD sh /opt/script.sh
