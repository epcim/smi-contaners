# Elasticsearch docker cluster

### Services structure
Each *elasticsearch* node have to be **separated service** in _docker compose file_, eg:
```yaml
  elasticsearch_node1:
    image: docker.elastic.co/elasticsearch/elasticsearch:5.5.0
    environment:
      [...]
      - discovery.zen.ping.unicast.hosts=elasticsearch_node1,elasticsearch_node2,elasticsearch_node3
    [...]
    networks:
       - elastic_grid
  elasticsearch_node2:
    image: docker.elastic.co/elasticsearch/elasticsearch:5.5.0
    environment:
      [...]
      - discovery.zen.ping.unicast.hosts=elasticsearch_node1,elasticsearch_node2,elasticsearch_node3
    [...]
    networks:
       - elastic_grid
  elasticsearch_node3:
    image: docker.elastic.co/elasticsearch/elasticsearch:5.5.0
    environment:
      [...]
      - discovery.zen.ping.unicast.hosts=elasticsearch_node1,elasticsearch_node2,elasticsearch_node3
    [...]
    networks:
       - elastic_grid
```

Services has to be connected with the same network (if you use **swarm** it's good to use _overlay_ network), eg:
```yaml
networks:
  elastic_grid:
    driver: overlay
```
### Nodes communication

Within shared network nodes will be accessible via name of a service eg: *elasticsearch_node1*.
That name will be translated into IP and it can be used in *elasticsearch* configuration files as well.
