# Intro
timescaedb + plv8
# Build image
```console
docker build -t timescaledb_plv8 .
```
## Supported args

| Arg                 | default |
| ------------------- | ------- |
| postgres_version    | 12      |
| timescaledb_version |         |
| plv8_version        | 2.3.14  |

# Run image
```
mkdir -p /opt/postgres/data
docker pull huanglg/timescaledb_plv8
docker run -d --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=your_passwd --restart=always -v  /opt/postgres/data:/var/lib/postgresql/data huanglg/timescaledb_plv8
```

tmore info on [PostgreSQL docs](https://www.postgresql.org/docs/10/sql-importforeignschema.html).
