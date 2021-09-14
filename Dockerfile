FROM alpine

LABEL container="genomescope2" \ 
  about.summary="Reference-free profiling of polyploid genomes " \ 
  about.home="https://github.com/tbenavi1/genomescope2.0" 

#PREAMBLE
WORKDIR /home/genomics
COPY . /home/genomics
RUN cd /home/genomics
RUN mkdir -p ~/R_libs/

RUN apk update \
	&& apk upgrade \
	&& apk add curl

#MAIN
ENV R_LIB=/usr/local/lib/R
ENV R_LIBS_USER=/usr/local/lib/R

RUN mkdir -p /usr/local/lib/R

# Some of these packages will be removed when Genomescope 2 supports R.X.X 
RUN apk add --no-cache --upgrade cairo make bash curl libressl-dev curl-dev libxml2-dev gcc g++ git coreutils ncurses linux-headers libgit2-dev fontconfig-dev harfbuzz-dev fribidi-dev tiff tiff-dev libxt-dev cairo-dev
RUN apk add --no-cache --upgrade openjdk11 perl gfortran

# Because genomescope requires the X11 to run, we have to find a way to build a headless install, we use xvfb for that. 
RUN apk add --no-cache --upgrade xorg-server-dev xorg-server libpng libpng-dev xvfb xvfb-run 
RUN apk add --no-cache --upgrade libxfont-dev libxfont libfontenc font-xfree86-type1
RUN apk add --no-cache --upgrade font-adobe-source-code-pro font-adobe-utopia-type1 font-adobe-100dpi font-adobe-75dpi font-adobe-utopia-100dpi font-adobe-utopia-75dpi
RUN apk add --no-cache --upgrade msttcorefonts-installer fontconfig
RUN update-ms-fonts

# Note R is installed here, but will is reintalled down to R 3.6.3, this is a cludgey solution
RUN apk add --no-cache --upgrade R R-dev R-doc

# This section will not be required when Genomescope 2 supports R 4.X.X
RUN curl -O https://cran.rstudio.com/src/base/R-3/R-3.6.3.tar.gz \
  && tar -xvf R-3.6.3.tar.gz \
  && cd R-3.6.3/ \
  && ./configure --enable-memory-profiling --enable-R-shlib --with-blas --with-lapack --with-x --with-cairo --with-readline=no \
  && make \
  && make install \ 
  && cd ..

RUN Rscript -e 'install.packages("argparse", repos="https://cloud.r-project.org")' \
  && Rscript -e 'install.packages("minpack.lm", repos="https://cloud.r-project.org")'  

RUN git clone https://github.com/tbenavi1/genomescope2.0.git \
	&& cd genomescope2.0/ \
  && cp genomescope.R /usr/bin \
	&& Rscript -e 'install.packages(".", repos=NULL, type="source", lib="/usr/local/lib/R")'\
	&& cd .. 

#CLEANUP

# Don't need git, a choice needs to be made about weather to keep gcc/g++ which may concievably be used 
RUN apk del git

RUN apk cache clean

RUN rm -rf *.tgz *.tar *.zip \
	&& rm -rf /var/cache/apk/* \
	&& rm -rf /tmp/*
