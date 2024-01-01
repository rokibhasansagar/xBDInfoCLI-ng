FROM mono:5.12

RUN mkdir -p /usr/src/app/source /usr/src/app/build
WORKDIR /usr/src/app/source

COPY . /usr/src/app/source
RUN msbuild BDInfo.sln -t:Restore
RUN msbuild BDInfo.sln -t:Build -p:Configuration=$env:Configuration -p:OutDir=/usr/src/app/build/
# RUN nuget restore -NonInteractive
# RUN xbuild /property:Configuration=Release /property:OutDir=/usr/src/app/build/
WORKDIR /usr/src/app/build

ENTRYPOINT [ "mono",  "./BDInfo.exe" ]
