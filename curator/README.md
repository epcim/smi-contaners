# Elasticsearch docker curator

Implementation uses community based *curator* image - [visity/elasticsearch-curator](https://github.com/visity/docker-elasticsearch-curator)

___
##### **Important**
*curator container* have to share network with *elasticsearch* cluster
___

Example configuration:
```yaml
  curator:
    image: visity/elasticsearch-curator
    environment:
      - INTERVAL_IN_HOURS=24
      - OLDER_THAN_IN_DAYS="20"
      - ELASTICSEARCH_HOST=elastic_proxy
    deploy:
      replicas: 1
    networks:
       - elastic_grid
```

*curator* should access *elasticsearch* proxy.
