# Use an official Node.js runtime as a parent image
# Switched to Node 8 as 'printer' package has V8 compilation errors with Node 18 and Node 12.
# Electron 1.8.2 (from package.json) used Node 8.x.
FROM node:8-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# For older Debian releases like Stretch (which Node 12 slim is based on),
# the repositories are moved to the archive.
# Update sources.list to point to the archive.
RUN sed -i \
    -e 's/deb.debian.org/archive.debian.org/g' \
    -e 's/security.debian.org/archive.debian.org/g' \
    -e '/stretch-updates/d' \
    /etc/apt/sources.list \
    && apt-get update -o Acquire::Check-Valid-Until=false && apt-get install -y --allow-unauthenticated \
    libgtk-3-dev \
    libgtk2.0-0 \
    libgconf-2-4 \
    libasound2 \
    libxtst-dev \
    libxss1 \
    libnss3 \
    libcups2-dev \
    nodejs-dev \
    build-essential \
    node-gyp\
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Create a symlink for python -> python3
# node-gyp often looks for 'python' and might not find 'python3' by default.
# RUN ln -sf /usr/bin/python3 /usr/bin/python


# Install project dependencies
# Using --legacy-peer-deps for compatibility if there are peer dependency issues
# RUN npm config set python /usr/bin/python && npm cache clean --force && npm install --legacy-peer-deps --unsafe-perm

# Copy the rest of the application code
COPY . .

RUN npm install
# Command to run the application
CMD ["npm", "start"]
