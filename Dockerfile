# syntax=docker/dockerfile:1

# This image sets up a Linux build environment for Flutter.
#
# Build image as `docker build -t <name> .`
# Use this image as `docker run --mount type=bind,src=.,target=/app <name>`

# Sets up Flutter
#
# This is setup as a seperate stage to reduce size of the final image
#
# Resuing `debian:stable` here as it is also used as the base of the main image
FROM debian:latest AS flutter_setup

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y
RUN apt-get install -y xz-utils
# Setting up checksum here to allow Docker to cache this step
# Without this checksum, Docker runs this download on every build
ADD --checksum=sha256:87493b72916f12054176c2a8bbf9547fe63cb5754bdddfe300219d9b57e626af https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.35.6-stable.tar.xz /flutter.tar.xz
RUN mkdir /flutter
RUN tar -xf /flutter.tar.xz -C /flutter

# Builds app
#
# Assumes that the code is located at `/app`.
# Can be done using `docker run --mount type=bind,src=.,target=/app class_demo:latest` or similar
#
# Binding the source folder here is reccomended as it ensures that the build output is also available on the host.
# This has the unfortunate side-effect of installing linux dependencies on a potentially non-linux host.
# To get the project into a working state on the host, run `flutter pub get`.
# Note that one should *not* run `flutter pub clean`, as it will delete the generated linux bundle.
FROM debian:latest

# Setup

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y
# Flutter base dependencies
RUN apt-get install -y clang cmake git ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev
# `audioplayers` package dependencies
# From https://pub.dev/packages/audioplayers_linux
RUN apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

COPY --from=flutter_setup /flutter /flutter

# Add to path for convenience
ENV PATH="$PATH:/flutter/flutter/bin"

# Mark as safe to allow commands like `flutter --version` to function
RUN git config --global --add safe.directory /flutter/flutter

# Arbritary
RUN flutter --disable-analytics

# Precache only linux dependencies in the image as this image is expected to be used mostly for linux builds
# Others will be downloaded as needed
RUN flutter precache --linux

# Set `WORKDIR` to avoid unexpected surpries when running commands like `flutter build`
WORKDIR /app

# Set up appropiate entrypoints
#
# Note that this builds the app by default as that is the main purpose of this container.
#
# This is set up in this manner to allow users to customize the build command if needed.
# For example, one may run `docker run class_demo:latest --version` to get the version of Flutter that the app would be built against.
ENTRYPOINT [ "flutter" ]
CMD [ "build" , "linux" ]
