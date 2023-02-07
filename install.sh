if [[ "$(whoami)" != "root" ]]
then
	echo "use sudo"
	exit
fi 
apt-get update > /dev/null
dpkg -i *.deb > /dev/null
apt install -f > /dev/null
dpkg -i *.deb > /dev/null 
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout /etc/squid/squid.key.pem -out /etc/squid/squid.pem
chown proxy:proxy squidca.pem
chmod 640 squidca.pem
openssl x509 -outform der -in /etc/squid/squid.pem -out /etc/squid/squid.crt
/usr/lib/squid/security_file_certgen -c -s /var/lib/ssl_db -M 4MB
chown proxy:proxy -R /var/lib/ssl_db
squid -k reconfigure
systemctl restart squid




