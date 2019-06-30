FROM google/cloud-sdk:latest

ADD forward_exec.sh /forward_exec.sh

RUN chmod 0644 /forward_exec.sh

ENTRYPOINT ["/bin/bash", "/forward_exec.sh"]
