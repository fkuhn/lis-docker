FROM ubuntu:14.04

MAINTAINER Florian Kuhn <kuhn@ids-mannheim.de>


RUN apt-get update

# Required package installation
RUN apt-get install -y wget maven mysql-server mysql-client python-setuptools python-dev python-pip libxml2 libxml2-dev
RUN apt-get install -y libxslt1.1 libxslt1-dev git
# need software properties common for the convienent add-apt-repository binary
RUN apt-get install -y software-properties-common

# Install oracle java 8 
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
# suppress graphical EULA confirmation dialogue. -y or --force-yes do not work here 
RUN yes | apt-get install oracle-java8-installer

# install dgd2cmdi python module
WORKDIR /opt
RUN git clone https://github.com/fkuhn/dgd2cmdi.git
WORKDIR /opt/dgd2cmdi
RUN python setup.py install

# schemanon installation
# This is a cmdi validator tool
# https://github.com/TheLanguageArchive/SchemAnon
WORKDIR tmp/
RUN git clone https://github.com/TheLanguageArchive/SchemAnon.git
WORKDIR tmp/SchemAnon
RUN pwd 
RUN mvn install:install-file -Dfile=lib/org/eclipse/wst/org.eclipse.wst.xml.xpath2.processor/1.1.0/org.eclipse.wst.xml.xpath2.processor-1.1.0.jar -DgroupId=org.eclipse.wst -DartifactId=org.eclipse.wst.xml.xpath2.processor -Dversion=1.1.0 -Dpackaging=jar
RUN mvn install:install-file -Dfile=lib/xerces/xercesImpl/2.11.0-xml-schema-1.1-beta/xercesImpl-2.11.0-xml-schema-1.1-beta.jar -DpomFile=lib/xerces/xercesImpl/2.11.0-xml-schema-1.1-beta/xercesImpl-2.11.0-xml-schema-1.1-beta.pom -DgroupId=xerces -DartifactId=xercesImpl -Dversion=2.11.0-xml-schema-1.1-beta -Dpackaging=jar
RUN mvn clean install 
RUN rm -rf tmp/SchemAnon
