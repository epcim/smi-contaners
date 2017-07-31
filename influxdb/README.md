

 # cli test

     curl -i -XPOST http://influxdb01:8087/query --data-urlencode q=CREATE DATABASE mydb
     curl -i -XPOST 'http://localhost:8087/write?db=mydb' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64 1434055562000000000'
     curl -G 'http://localhost:8087/query?pretty=true' --data-urlencode db=mydb --data-urlencode q=SELECT "value" FROM "cpu_load_short" WHERE "region"=us-west

