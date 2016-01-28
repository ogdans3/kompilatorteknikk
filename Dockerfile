FROM nachinius/c-dev:latest

RUN mkdir -p ~/kompilatorteknikk
WORKDIR ~/kompilatorteknikk

COPY ./* ~/kompilatorteknikk/

