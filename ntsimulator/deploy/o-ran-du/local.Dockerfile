#
# Copyright 2020 highstreet technologies GmbH and others
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

################
#### DEVICE ####
################

FROM localhost:5000/nts-ng-base:latest
LABEL maintainer="alexandru.stancu@highstreet-technologies.com / adrian.lita@highstreet-technologies.com"

# ntsim-ng configuration and deployment
COPY ./yang /opt/dev/deploy/yang
COPY ./data /opt/dev/deploy/data
COPY ./config.json /opt/dev/ntsim-ng/config/config.json
COPY ./ves_template.json /opt/dev/ntsim-ng/config/ves_template.json

# ntsim-ng init docker
RUN /opt/dev/ntsim-ng/ntsim-ng --container-init -w /opt/dev/ntsim-ng

# finishing container build
ARG BUILD_DATE
LABEL build-date=$BUILD_DATE

# add exposed ports
EXPOSE 830-929
EXPOSE 21-22

ENV NTS_FUNCTION_TYPE=NTS_FUNCTION_TYPE_O_RAN_O_DU

# address of ran simulator
ENV RANSIM_SERVICE_ADDRESS=ran-simulator.riab:5150

# add path to onos-cli script
ENV ONOS_CLI_PATH=/usr/local/bin/onos-cli-wrapper.sh

# run
WORKDIR /opt/dev/workspace
# Uncomment those when you need gdb in a pod/container
# RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y gdb
# RUN ulimit -c unlimited
CMD ["/opt/dev/ntsim-ng/ntsim-ng", "-w/opt/dev/ntsim-ng", "--supervisor"]
