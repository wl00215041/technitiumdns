FROM debian:stretch-slim
ENV ASPNETCORE_URLS=http://+:80 DOTNET_RUNNING_IN_CONTAINER=true
ENV DOTNET_VERSION=3.1.1

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl libc6 \
                                  libgcc1 libgssapi-krb5-2 libicu57 liblttng-ust0 libssl1.0.2 libstdc++6 zlib1g && \ 
                                  rm -rf /var/lib/apt/lists/*
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.blob.core.windows.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-x64.tar.gz && \
    mkdir -p /usr/share/dotnet && \
    tar -zxf dotnet.tar.gz -C /usr/share/dotnet && \
    rm dotnet.tar.gz && \ 
    ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
RUN apt-get -y update && apt-get -y install curl libunwind8 icu-devtools apt-transport-https
RUN curl -O https://download.technitium.com/dns/DnsServerPortable.tar.gz && mkdir /app && tar -zxf DnsServerPortable.tar.gz -C /app
EXPOSE 53/udp
EXPOSE 5380
ENTRYPOINT dotnet /app/DnsServerApp.dll
