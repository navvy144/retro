FROM phusion/baseimage:0.9.15
MAINTAINER Lee Oliver "navvy144@gmail.com"
ENV REFRESHED_AT 2015-04-04
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# chfn workaround - Known issue within Dockers
RUN ln -s -f /bin/true /usr/bin/chfn

#install dependancies
RUN apt-get update && apt-get install -y wget

#map array
VOLUME /mnt
#VOLUME /var/log

#get retrospect
RUN wget http://download.retrospect.com/software/linux/v1000/Linux_Client_x64_10_0_0_114.tar \
 && tar xvf Linux_Client_x64_10_0_0_114.tar

#get modified install script
ADD Retroinstall.sh /tmp/Retroinstall.sh
RUN chmod 755 /tmp/Retroinstall.sh

#install retrospect
RUN /tmp/Retroinstall.sh

#Add default retro password
ADD retroclient.state /var/log/retroclient.state

#start retrospect
ENTRYPOINT /usr/local/retrospect/client/retroclient

#open ports
EXPOSE 497

