if [[ "$(whoami)" != "root" ]]
then
	echo "use sudo"
	exit
fi 
apt-get udate > /dev/null
read -p  "Enter whitelist site: " white
read -p  "Enter blacklist site: " black
dpkg -i *.deb ; apt install -f && dpkg -i *.deb \
&& cp /etc/squid/squid.conf /etc/squid/squid.conf.save \
&& rm /etc/squid/squid.conf \
&& cp squid.conf /etc/squid \
&& mkdir /etc/squid/lists \
&& touch /etc/squid/lists/blacklist \
&& echo "$black" > /etc/squid/lists/blacklist \
&& touch /etc/squid/lists/whitelist \
&& echo "$white" > /etc/squid/lists/whitelist \
&& openssl req -new -newkey rsa:2048 -sha256 -days 3650 -nodes -x509 -extensions v3_ca -keyout /etc/squid/proxyCA.pem  -out /etc/squid/proxyCA.pem \
&& openssl x509 -in /etc/squid/proxyCA.pem -outform DER -out /etc/squid/squid.der \
&& openssl dhparam -outform PEM -out /etc/squid/bump_dhparam.pem 2048 \
&& sudo chown proxy:proxy /etc/squid/bump_dhparam.pem \
&& sudo chmod 400 /etc/squid/bump_dhparam.pem \
&& sudo chown proxy:proxy /etc/squid/proxyCA.pem \
&& sudo chmod 400 /etc/squid/proxyCA.pem \
&& sudo chown proxy:proxy -R /var/spool/squid \
&& sudo chown proxy:proxy -R /var/log/squid/ \
&& sudo mkdir -p /var/lib/squid \
&& sudo rm -rf /var/lib/squid/ssl_db \
&& sudo /usr/lib/squid/security_file_certgen -c -s /var/lib/squid/ssl_db -M 4MB \
&& sudo chown -R proxy:proxy /var/lib/squid \
&& sudo echo 1 >> /proc/sys/net/ipv4/ip_forward \
&& sudo squid -k reconfigure \
&& sudo systemctl restart squid \
&& sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 3129 \
&& sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 3130




