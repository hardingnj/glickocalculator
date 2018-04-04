FROM rocker/shiny:latest

MAINTAINER "Nicholas Harding" nicholas.harding@bdi.ox.ac.uk

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    python3 \
    libpython3-dev
 
RUN python3 --version
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py
RUN pip install pandas
RUN ln -s /usr/bin/python3 /usr/bin/python

ENV CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt
RUN curl -OL https://github.com/sublee/glicko2/archive/master.zip
RUN unzip master.zip 
RUN cd glicko2-master && python setup.py install

COPY glickoweb /srv/shiny-server/glickoweb

RUN ls /srv/shiny-server/
RUN which shiny-server

RUN R -e 'install.packages("reticulate")'

RUN which python3
RUN which python
RUN ls /usr/lib/
RUN ls /usr/local/lib 
RUN python3 --version
ENV LD_LIBRARY_PATH /usr/lib/python3.6/config-3.6m-x86_64-linux-gnu

EXPOSE 3838
CMD ["/usr/bin/shiny-server.sh"]
