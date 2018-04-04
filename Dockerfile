FROM rocker/shiny:latest

MAINTAINER "Nicholas Harding" nicholas.harding@bdi.ox.ac.uk

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates
 
# install anaconda
RUN curl -L http://repo.continuum.io/archive/Anaconda3-4.0.0-Linux-x86_64.sh > \
  anaconda_setup.sh
RUN bash anaconda_setup.sh -b -p /anaconda
ENV PATH /anaconda/bin:$PATH

RUN conda update -y conda

# conda with python 3.5.2
RUN conda create --name shinyenv --yes python=3.5.2
RUN conda config --add channels conda-forge

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN source activate shinyenv && conda install -y pandas matplotlib seaborn numpy

ENV CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt
RUN curl -OL https://github.com/sublee/glicko2/archive/master.zip
RUN unzip master.zip 
RUN source activate shinyenv && cd glicko2-master && python setup.py install

COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY glickoweb /srv/shiny-server/glickoweb
RUN ls /srv/shiny-server/

EXPOSE 3838
CMD ["/usr/bin/shiny-server.sh"]
