FROM ubuntu:14.04

MAINTAINER Raymond Wen "rx.wen218@gmail.com"

# Install java8
RUN apt-get update && apt-get install -y software-properties-common expect && add-apt-repository -y ppa:webupd8team/java && apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer bsdtar

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl make

# Install Android SDK
RUN curl -L https://dl.google.com/android/repository/tools_r25.2.3-linux.zip | bsdtar -xf- -C /opt/

# Setup environment
ENV ANDROID_HOME /opt/tools
ENV PATH ${PATH}:${ANDROID_HOME}/tools
RUN curl -L https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip | bsdtar -xf- -C /opt/
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo
RUN chmod a+x /usr/bin/repo
# make sure applications executable
RUN chmod +x -R /opt/

# Install sdk components
COPY tools/android-accept-licenses.sh /opt/tools/android-accept-licenses.sh
RUN ["/opt/tools/android-accept-licenses.sh", "android update sdk --all --force"]

# Cleaning
RUN apt-get clean
