FROM brightspot/brightspot:1.0

# Restore storage into container. To back up (execute from project root):
# docker-compose exec brightspot tar zcf $PWD/etc/data/storage.tar.gz -C /servers/brightspot/www/storage .
ADD ./etc/data/storage.tar.gz /servers/brightspot/www/storage/

# Restore solr into container. To back up (execute from project root):
# docker-compose exec brightspot tar zcf $PWD/etc/data/solr.tar.gz -C /servers/solr/solr/collection1/data .
ADD ./etc/data/solr.tar.gz /servers/solr/solr/collection1/data/

# Restore mysql into container. To back up (execute from project root):
# docker-compose exec brightspot sh -c "mysqldump -uroot -pbrightspot --compact --hex-blob --single-transaction --add-drop-table brightspot | gzip > $PWD/etc/data/sql.gz"
ADD ./etc/data/sql.gz /servers/brightspot/sql.gz
RUN service mysql start \
    && gunzip -c /servers/brightspot/sql.gz | mysql brightspot \
    && service mysql stop
RUN rm /servers/brightspot/sql.gz

# Add context.xml settings for CountdownUpdateTask
RUN add_context_config countdown/apiToken "api_key_here"
RUN add_context_config countdown/endpointUrl "http://127.0.0.1/countdown-endpoint"