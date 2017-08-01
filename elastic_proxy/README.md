# Elasticsearch docker proxy

To ensure *HA* access to *elasticsearch* cluster You have to implement proxy solution.
Proxying is based on *nginx* default container provided in *docker* repository.

___
##### **Important**
*nginx container* have to share network with *elasticsearch* cluster
___

Example configuration:
```yaml
  elastic_proxy:
    image: nginx
    volumes:
      - ${PWD}/elastic_proxy/nginx.conf:/etc/nginx/nginx.conf:ro
    ports:
      - 9200:9200
    deploy:
      replicas: 3
    networks:
      - elastic_grid
      - default_public

```

*nginx* container uses default configuration files mountet as external resource.

Example proxy configuration:
```
events {
    worker_connections  1024;
}

http {

  upstream elasticsearch {
    server elasticsearch_node1:9200;
    server elasticsearch_node2:9200;
    server elasticsearch_node3:9200;

    keepalive 15;
  }

  server {
    listen 9200;

    location / {
      proxy_pass http://elasticsearch;
      proxy_http_version 1.1;
      proxy_set_header Connection "Keep-Alive";
      proxy_set_header Proxy-Connection "Keep-Alive";
    }

  }

}
```
As described in **Elasticsearch docker cluster** section, containers within shared network will be accessible via service names.
