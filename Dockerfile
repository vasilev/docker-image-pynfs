FROM iron/python:2-dev
COPY . /app
RUN apk add --update krb5-dev swig \
    && pip install ply gssapi \
    && cd /app && ./setup.py build

EXPOSE 2049

ENTRYPOINT ["python", "/app/nfs4.0/nfs4server.py"]
