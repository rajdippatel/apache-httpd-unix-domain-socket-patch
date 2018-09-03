HTTPD_VERSION='2.4.34'
APR_VERSION='1.6.3'
APR_UTIL_VERSION='1.6.1'

# Install Build Dependencies
sudo apt-get -y install autoconf libtool libtool-bin python3
sudo ln -s /usr/bin/python3 /usr/bin/python

# Download and Extract APR
rm -f -r apr-$APR_VERSION
wget http://www-us.apache.org/dist//apr/apr-$APR_VERSION.tar.gz
tar -xf apr-$APR_VERSION.tar.gz
rm apr-$APR_VERSION.tar.gz

# Download and Extract APR-Util
rm -f -r apr-util-$APR_UTIL_VERSION
wget http://www-us.apache.org/dist//apr/apr-util-$APR_UTIL_VERSION.tar.gz
tar -xf apr-util-$APR_UTIL_VERSION.tar.gz
rm apr-util-$APR_UTIL_VERSION.tar.gz

# Download, Extract, Configure Httpd
rm httpd-$HTTPD_VERSION
wget http://www-us.apache.org/dist//httpd/httpd-$HTTPD_VERSION.tar.gz
tar -xf httpd-$HTTPD_VERSION.tar.gz
rm httpd-$HTTPD_VERSION.tar.gz

mv apr-$APR_VERSION httpd-$HTTPD_VERSION/srclib/apr
mv apr-util-$APR_UTIL_VERSION httpd-$HTTPD_VERSION/srclib/apr-util

cd httpd-$HTTPD_VERSION
CWD=$(pwd)
./configure --prefix=$CWD/build --with-included-apr --with-included-apr-util --enable-so --enable-ssl

cp ../listen.c server/

make
make install

# Configure Server with Unix Domain Socket
# Edit build/conf/httpd.conf file to listen on domain socket (/var/run/httpd.sock)

# Start Server with following instructions
# build/bin/httpd -DFOREGROUND

# Test Server using curl
curl --unix-socket /var/run/httpd.sock http://localhost
# In case apache server and client are running under different user, adjust file permission on /var/run/httpd.sock file

