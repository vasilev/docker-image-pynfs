FROM iron/python:2-dev AS builder

RUN apk add --no-cache krb5-dev swig \
    && pip install ply gssapi \
    && git clone --branch=master git://github.com/ffilz/pynfs.git --shallow-since=2018-03-20T00:00:00 /app/pynfs \
    && cd /app/pynfs \
    && git reset --hard 145f4abec678b26a0b4ede417ab7cc788a3f4405 \
    && ./setup.py build \
    && rm -rf .git \
    && pip uninstall -y ply setuptools wheel \
    && pip uninstall -y pip


FROM iron/python:2
RUN apk add --no-cache krb5
COPY --from=builder /app /app
COPY --from=builder /usr/lib/python2.7/site-packages /usr/lib/python2.7/site-packages


EXPOSE 2049

ENTRYPOINT ["python", "/app/pynfs/nfs4.0/nfs4server.py"]
