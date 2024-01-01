FROM mono:5.18 as builder

RUN mkdir -p /usr/src/app/source /usr/src/app/build
WORKDIR /usr/src/app/source

COPY . /usr/src/app/source
RUN nuget restore -NonInteractive && msbuild BDInfo.sln -t:Build -p:Configuration=Release -p:OutDir=/usr/src/app/build/
# RUN xbuild /property:Configuration=Release /property:OutDir=/usr/src/app/build/

FROM mono:5.18
COPY --from=builder /usr/src/app/build/*.exe /usr/src/app/build/*.config /usr/src/app/build/*.dll /app/bdinfo_cli/

WORKDIR /app/bdinfo_cli

RUN printf '#!/bin/bash\nmono /app/bdinfo_cli/BDInfo.exe "$@"' >/usr/bin/bdinfo_cli \
  && chmod +x /usr/bin/bdinfo_cli

ENTRYPOINT [ "/usr/bin/bdinfo_cli" ]
