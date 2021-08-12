FROM ubuntu:20.10 as builder
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget
# RUN useradd -ms /bin/bash user
# USER user
RUN mkdir /src
WORKDIR /src

#Installing Android SDK
RUN mkdir -p android/sdk
ENV ANDROID_SDK_ROOT /src/android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools android/sdk/tools
RUN cd android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:/src/android/sdk/platform-tools"

#Installing Flutter SDK
RUN echo "Installing Flutter"
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/src/flutter/bin"
# RUN flutter channel dev
RUN flutter upgrade
RUN flutter doctor
COPY . .
RUN flutter build web --release

FROM nginx:alpine as final
COPY --from=builder /src/build/web /usr/share/nginx/html
