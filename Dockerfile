FROM registry.pivotbio.me/pipeline/sequencing-quality-control

# Update the repository sources list
RUN apt-get update

# Install compiler and perl stuff
RUN apt-get install --yes \
 build-essential \
 gcc-multilib \
 apt-utils \
 perl \
 expat \
 libexpat-dev  \
 wget

# Install perl modules 
RUN apt-get install -y cpanminus

RUN cpanm \
 --notest \
 --no-man-pages \
 CPAN::Meta \
 readline \ 
 Term::ReadKey \
 YAML \
 Digest::SHA \
 Module::Build \
 ExtUtils::MakeMaker \
 Test::More \
 Data::Stag \
 Config::Simple \
 Statistics::Lite \
 Statistics::Descriptive 

RUN apt-get install --yes \
 libarchive-zip-perl

# Install related DB modules
RUN apt-get install --yes \
 libdbd-mysql \
 libdbd-mysql-perl \
 libdbd-pgsql

# Install GD
RUN apt-get remove --yes libgd-gd2-perl

RUN apt-get install --yes \
 libgd2-noxpm-dev

RUN cpanm \
 --notest \
 --no-man-pages \
 GD \
 GD::Graph \
 GD::Graph::smoothlines 


# Install BioPerl dependancies, mostly from cpan
RUN apt-get install --yes \
 libpixman-1-0 \
 libpixman-1-dev \
 graphviz \
 libxml-parser-perl \
 libsoap-lite-perl 

RUN cpanm \
 --notest \
 --no-man-pages \
 Test::Most \
 Algorithm::Munkres \
 Array::Compare Clone \
 PostScript::TextBlock \
 SVG \
 SVG::Graph \
 Set::Scalar \
 Sort::Naturally \
 Graph \
 GraphViz \
 HTML::TableExtract \
 Convert::Binary::C \
 Math::Random \
 Error \
 Spreadsheet::ParseExcel \
 XML::Parser::PerlSAX \
 XML::SAX::Writer \
 XML::Twig XML::Writer

RUN apt-get install -y \
 libxml-libxml-perl \
 libxml-dom-xpath-perl \
 libxml-libxml-simple-perl \
 libxml-dom-perl

# Install BioPerl last built
RUN cpanm -v  \
 --notest \
 --no-man-pages \
 CJFIELDS/BioPerl-1.6.924.tar.gz

WORKDIR /work
ADD . /work

ENTRYPOINT ["./entrypoint.sh"]
