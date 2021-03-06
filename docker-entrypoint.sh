#!/bin/bash

# modify php.ini
cat >> /usr/local/etc/php/php.ini << EOF
post_max_size = 1024M
memory_limit = 1024M
upload_max_filesize = 1024M
EOF

# enable apache rewrite
ln -s /etc/apache2/mods-available/rewrite.load  /etc/apache2/mods-enabled/

# init edusoho files
if [ ! -d /var/www/html/edusoho ];then
    tar xzf /tmp/edusoho.tar.gz -C  /var/www/html/
    chown www-data:www-data /var/www/html/ -R 
fi


# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
