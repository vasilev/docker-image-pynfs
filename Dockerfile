FROM iron/python:2-dev AS builder

RUN apk add --no-cache krb5-dev swig \
    && pip install ply gssapi \
    && git clone --branch=master git://github.com/ffilz/pynfs.git --shallow-since=2018-03-20T00:00:00 /app/pynfs \
    && cd /app/pynfs \
    && git reset --hard 145f4abec678b26a0b4ede417ab7cc788a3f4405 \
    && ./setup.py build \
    && cd nfs4.0 && python -c 'import sys; sys.path.insert(1, "/app/pynfs/nfs4.0/lib"); import nfs4server' \
    && rm -rf .git \
    && pip uninstall -y ply setuptools wheel \
    && pip uninstall -y pip \
    && export SPPATH=`python -c 'import site; print(site.getsitepackages()[0])'`


FROM iron/python:2
RUN apk add --no-cache krb5
COPY --from=builder /app /app
COPY --from=builder ${SPPATH} ${SPPATH}

EXPOSE 2049

ENTRYPOINT ["python", "/app/pynfs/nfs4.0/nfs4server.py"]
