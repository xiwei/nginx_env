#!/bin/sh
SRC_PATH=$(pwd)
LUAJIT=LuaJIT-2.0.4
LUAJIT_TAR="$SRC_PATH/lua/$LUAJIT.tar.gz"
cd $SRC_PATH/lua/
tar xzvf $LUAJIT_TAR
cd $LUAJIT
make clean && make 
LUAJIT_LIB="$SRC_PATH/lua/$LUAJIT/src"
LUAJIT_INC="$SRC_PATH/lua/$LUAJIT/src"
export LUAJIT_LIB
export LUAJIT_INC
cd     $SRC_PATH 
NGX_HOME="/home/work/nginx"
NGX_SBIN_PATH="$NGX_HOME/bin/nginx"
NGX_CONF_PATH="$NGX_HOME/conf/nginx.conf"
NGX_ERROR_LOG_PATH="$NGX_HOME/logs/error_log"
NGX_HTTP_ACCESS_LOG_PATH="$NGX_HOME/logs/access_log"
NGX_PIDFILE_PATH="$NGX_HOME/run/nginx.pid"
MOD_SRC_PATH=$SRC_PATH/tmp
mkdir tmp
cp $SRC_PATH/nginx/*.tar.gz ./tmp/
cd tmp
tar -xvzf ./nginx-1.10.2.tar.gz
tar -xvzf ./pcre-8.39.tar.gz 
tar -xvzf ./openssl-1.0.2j.tar.gz
tar -xvzf ./echo-nginx-module-0.60.tar.gz 
tar -xvzf ./headers-more-nginx-module-0.32.tar.gz 
tar -xvzf ./lua-nginx-module-0.10.7.tar.gz
tar -xvzf ./ngx_devel_kit-0.3.0.tar.gz

PCRE_SRC=$SRC_PATH/tmp/pcre-8.39
OPENSSL_SRC=$SRC_PATH/tmp/openssl-1.0.2j
OPTS_WITH="--with-ipv6 \
        --with-http_ssl_module \
	--with-http_v2_module   \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --with-pcre=$PCRE_SRC \
        --with-pcre-jit \
        --with-openssl=$OPENSSL_SRC \
        --with-cc-opt=-Wno-error \
        --with-ld-opt=-lstdc++"
 #for options of --http-*-temp-path of configuration script
OPTS_TEMP_PATH="--http-client-body-temp-path=$NGX_HOME/run/cache/client_body \
        --http-proxy-temp-path=$NGX_HOME/run/cache/proxy \
        --http-fastcgi-temp-path=$NGX_HOME/run/cache/fastcgi \
        --http-uwsgi-temp-path=$NGX_HOME/run/cache/uwsgi \
        --http-scgi-temp-path=$NGX_HOME/run/cache/scgi"
#for options of --without-* of configuration script
OPTS_WITHOUT="--without-http_userid_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module"

HEADERS_MORE_MOD_SRC="$MOD_SRC_PATH/headers-more-nginx-module-0.32"
NDK_MOD_SRC="$MOD_SRC_PATH/ngx_devel_kit-0.3.0"
NGX_LUA_MOD_SRC="$MOD_SRC_PATH/lua-nginx-module-0.10.7"
ECHO_MOD_SRC="$MOD_SRC_PATH/echo-nginx-module-0.60"

OPTS_ADD_MODULE="--add-module=$HEADERS_MORE_MOD_SRC \
        --add-module=$NDK_MOD_SRC \
        --add-module=$NGX_LUA_MOD_SRC \
        --add-module=$ECHO_MOD_SRC"

config_opts="--prefix=$NGX_HOME\
        $OPTS_WITH \
        $OPTS_WITHOUT \
        $OPTS_TEMP_PATH \
        $OPTS_ADD_MODULE" 

cd $SRC_PATH/tmp
cd  nginx-1.10.2/
echo "./configure $config_opts"
./configure $config_opts
make
exit 0
