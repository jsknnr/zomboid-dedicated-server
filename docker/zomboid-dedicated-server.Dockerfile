#   Project Zomboid Dedicated Server using SteamCMD Docker Image.
#   Copyright (C) 2021-2022 Renegade-Master [renegade.master.dev@protonmail.com]
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

#######################################################################
#   Author: Renegade-Master
#   Description: Base image for running a Dedicated Project Zomboid
#       server.
#   License: GNU General Public License v3.0 (see LICENSE)
#######################################################################
# Updated by: sknnr

# Images
ARG BASE_IMAGE="docker.io/cm2network/steamcmd:latest"
ARG RCON_IMAGE="docker.io/outdead/rcon:latest"

FROM ${RCON_IMAGE} as rcon

FROM ${BASE_IMAGE}

# Add metadata labels
LABEL com.renegademaster.zomboid-dedicated-server.authors="Renegade-Master" \
    com.renegademaster.zomboid-dedicated-server.contributors="JohnEarle, ramielrowe, sknnr" \
    com.renegademaster.zomboid-dedicated-server.source-repository="https://github.com/jsknnr/zomboid-dedicated-server" \
    com.renegademaster.zomboid-dedicated-server.image-repository="https://hub.docker.com/sknnr/project-zomboid-server"

# Copy rcon files
COPY --from=rcon /rcon /usr/bin/rcon

# Copy the source files
COPY --chown=steam:steam src /home/steam/

USER root

# Install Python, and take ownership of rcon binary
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-minimal iputils-ping tzdata musl vim \
    && apt-get remove --purge --auto-remove -y \
    && rm -rf /var/lib/apt/lists/*

USER steam

# Run the setup script
ENTRYPOINT ["/bin/bash", "/home/steam/run_server.sh"]
