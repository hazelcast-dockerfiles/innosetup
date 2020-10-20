# InnoSetup for Hazelcast

Docker image which build Windows installer for Hazelcast IMDG.

## Usage

```bash
# download Hazelcast
wget --content-disposition https://download.hazelcast.com/download.jsp?version=hazelcast-4.0.3

# create installer
docker run --rm -v `pwd`:/mnt kwart/innosetup-hazelcast hazelcast-installer /mnt/hazelcast-4.0.3.zip
```
