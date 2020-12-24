##### `postgreSQL`集成了`timescaedb `和 `plv8`扩展

##### 构建镜像常见的两种方式，推荐方式2

###### 1.在已经安装的docker机器上执行`docker build`命令

```console
docker build -t timescaledb_plv8 .
```
###### 2.注册 `Docker Hub`账号自动化构建

- 将该所有文件推送到`github`上
- 在`https://hub.docker.com/`上注册账号，并创建仓库
- 将`github`仓库和`github`仓库连接
- 设置自动化构建触发器

##### 版本信息

| 名称          | 版本     |
| ------------- | -------- |
| `postgreSQL`  | `12`     |
| `timescaledb` | `1.7.3`  |
| `plv8`        | `2.3.14` |

##### 运行容器

```
# 拉取镜像，离线安装可以先把镜像保存下来
docker pull huanglg/timescaledb_plv8
# 创建容器卷
docker volume create postgres 
# 启动
docker run -d --name postgres \
-p 5432:5432 \
-e POSTGRES_PASSWORD=your_passwd \
--restart=always  \
--privileged=true \
-v postgres:/var/lib/postgresql/data \
huanglg/timescaledb_plv8
```


