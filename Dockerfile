FROM iron/python:2-dev

RUN apk add --update krb5-dev swig \
    && pip install ply gssapi \
    && git clone git://github.com/ffilz/pynfs.git --shallow-since=2018-03-20T00:00:00 /app/pynfs \
    && cd /app/pynfs \
    && git reset --hard 145f4abec678b26a0b4ede417ab7cc788a3f4405 \
    && ./setup.py build

EXPOSE 2049

ENTRYPOINT ["python", "/app/pynfs/nfs4.0/nfs4server.py"]
