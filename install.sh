if [[ "$(whoami)" != "root" ]]
then
	echo "use sudo"
	exit
fi 
apt-get update > /dev/null
dpkg -i *.deb > /dev/null
apt install -f
dpkg -i *.deb > /dev/null 
rm /etc/squid/squid.conf
cp squid.conf /etc/squid/squid.conf
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout /etc/squid/squid.pem -out /etc/squid/squid.pem
chown proxy:proxy /etc/squid/squid.pem
chmod 640 /etc/squid/squid.pem
openssl x509 -outform der -in /etc/squid/squid.pem -out /etc/squid/squid.crt
/usr/lib/squid/security_file_certgen -c -s /var/lib/ssl_db -M 4MB
chown proxy:proxy -R /var/lib/ssl_db
squid -k reconfigure
systemctl restart squid




