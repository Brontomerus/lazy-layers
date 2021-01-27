FROM amazonlinux:latest

RUN yum update -y \
    && yum install -y gzip tar wget gcc openssl-devel bzip2-devel libffi-devel zip make \
    && cd opt \
    && wget https://www.python.org/ftp/python/3.8.7/Python-3.8.7.tgz \ 
    && tar xzf Python-3.8.7.tgz \
    && cd Python-3.8.7 \
    && ./configure --enable-optimizations \
    && make altinstall \
    && cd .. \
    && mkdir -p layer/python/lib/python3.8/site-packages

# Create Lambda Layer
# pip3.8 install -t ./layer/python/lib/python3.8/site-packages/ ___ENTER_PACKAGES_HERE___ \
RUN pip3.8 install -t ./layer/python/lib/python3.8/site-packages/ pandas pyarrow \
    && cd layer \
    && zip -r pandas-pyarrow.zip ./python/ \
    && pip3.8 install awscli


# enter into container -> run 
# aws configure -> enter creds in prompt
# cd layer
# aws s3 ls -> lists the s3 buckets out
# aws s3 cp [local-file-name].zip s3://mybucket1/ -> grab the zip and put file in s3
