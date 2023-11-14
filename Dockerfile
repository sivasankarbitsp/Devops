# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

ARG HTTP_PROXY='http://sau2cob:Kaniyanaishu@9292@rb-proxy-unix-apac.bosch.com:8080'
# ARG HTTP_PROXY='http://crm3kor:##bosch@bang@P98@rb-proxy-unix-apac.bosch.com:8080'
ARG HTTPS_PROXY=${HTTP_PROXY}

# Install dependent packages
RUN export http_proxy=${HTTP_PROXY} \
&& export https_proxy=${HTTPS_PROXY}\
&& apt-get update \
    && apt-get install -y --no-install-recommends \
        dialog \
        mosquitto \
        mosquitto-clients \
        openssh-server \
        wget \
        unzip \
        net-tools \
        iputils-ping \
        nano \
        python3 \
        python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir /run/sshd
	
# Create an SSH user for accessing the terminal of the microservice
# user name is admin and password is admin
RUN useradd -ms /bin/bash admin \
    && echo 'admin:admin' |chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose ports MQTT on 1883 and ssh on 22 
EXPOSE 1883 22

# Create a directory for Python files in the user's home directory
RUN mkdir -p /home/admin/

# Copy your Python files for publishing MQTT message
#COPY publish.py /home/admin/

# Start SSH server and Mosquitto
CMD ["/usr/sbin/sshd", "-D"]