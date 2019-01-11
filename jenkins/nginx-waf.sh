export OPENSSL_VERSION="openssl-1.1.1"
export NGINX_VERSION="nginx-1.15.4-1.el7_4"
export MORE_HEADERS_VERSION="0.33"
export COOKIE_FLAG_BRANCH="master"
export NAXSI_VERSION=0.56

sudo yum -y upgrade
sudo yum -y groupinstall 'Development Tools'
sudo yum -y install wget redhat-lsb-core openssl-devel libxml2-devel libxslt-devel gd-devel perl-ExtUtils-Embed GeoIP-devel pcre-devel unzip which

wget https://www.openssl.org/source/${OPENSSL_VERSION}.tar.gz -O /tmp/${OPENSSL_VERSION}.tar.gz
tar -xvzf /tmp/${OPENSSL_VERSION}.tar.gz -C /tmp/
wget https://github.com/AirisX/nginx_cookie_flag_module/archive/${COOKIE_FLAG_BRANCH}.zip -O /tmp/nginx_cookie_flag_module.zip
unzip -u /tmp/nginx_cookie_flag_module.zip -d /tmp/
wget https://github.com/openresty/headers-more-nginx-module/archive/v${MORE_HEADERS_VERSION}.tar.gz -O /tmp/more_headers-v${MORE_HEADERS_VERSION}.tar.gz
tar -xvzf /tmp/more_headers-v${MORE_HEADERS_VERSION}.tar.gz -C /tmp/
wget https://github.com/nbs-system/naxsi/archive/${NAXSI_VERSION}.tar.gz -O /tmp/naxsi-v${NAXSI_VERSION}.tar.gz
tar -xvzf /tmp/naxsi-v${NAXSI_VERSION}.tar.gz -C /tmp/

rpm -ivh http://nginx.org/packages/mainline/centos/7/SRPMS/${NGINX_VERSION}.ngx.src.rpm

sed -i "s|--with-http_ssl_module|--with-http_ssl_module --with-openssl=/tmp/$OPENSSL_VERSION|g" /var/lib/jenkins/rpmbuild/SPECS/nginx.spec
sed -i "s|--with-http_ssl_module|--with-http_ssl_module --add-dynamic-module=/tmp/naxsi-${NAXSI_VERSION}/naxsi_src/|g" /var/lib/jenkins/rpmbuild/SPECS/nginx.spec
sed -i "s|--with-http_ssl_module|--with-http_ssl_module --add-dynamic-module=/tmp/headers-more-nginx-module-${MORE_HEADERS_VERSION}|g" /var/lib/jenkins/rpmbuild/SPECS/nginx.spec
sed -i "s|--with-http_ssl_module|--with-http_ssl_module --add-dynamic-module=/tmp/nginx_cookie_flag_module-${COOKIE_FLAG_BRANCH}|g" /var/lib/jenkins/rpmbuild/SPECS/nginx.spec
sed -i "s|%files|%files\n%{_libdir}/nginx/modules/ngx_http_naxsi_module.so|g" /var/lib/jenkins/rpmbuild/SPECS/nginx.spec
sed -i "s|%files|%files\n%{_libdir}/nginx/modules/ngx_http_headers_more_filter_module.so|g" /var/lib/jenkins/rpmbuild/SPECS/nginx.spec
sed -i "s|%files|%files\n%{_libdir}/nginx/modules/ngx_http_cookie_flag_filter_module.so|g" /var/lib/jenkins/rpmbuild/SPECS/nginx.spec

rpmbuild -ba --verbose --define "debug_package %{nil}" /var/lib/jenkins/rpmbuild/SPECS/nginx.spec
