FROM python:3-alpine
COPY . /app
RUN apk add --update krb5-dev swig build-base curl git linux-headers \
    && curl -sS https://bootstrap.pypa.io/get-pip.py | python3 \
    && pip install ply gssapi \
    && git clone --depth 1 https://github.com/ffilz/pynfs.git /app/pynfs \
    && cd /app/pynfs && rm -rf ./.git \
    && ./setup.py build

EXPOSE 2049

ENTRYPOINT ["python", "/app/pynfs/nfs4.0/nfs4server.py"]
