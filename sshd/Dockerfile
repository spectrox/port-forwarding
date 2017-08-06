FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

#RUN echo 'root:screencast' | chpasswd
RUN useradd client -s /bin/bash /client -m
#RUN echo 'client:ssh' | chpasswd

# SSH restrict root login
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# SSH allow publish ports through tunnel
RUN echo "Match User client" >> /etc/ssh/sshd_config
RUN echo "    GatewayPorts clientspecified" >> /etc/ssh/sshd_config

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

CMD ["/usr/sbin/sshd", "-D"]
