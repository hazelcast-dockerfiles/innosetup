# InnoSetup for Hazelcast

Docker image which build Windows installer for Hazelcast IMDG.

## Usage

```bash
# download Hazelcast
wget --content-disposition https://download.hazelcast.com/download.jsp?version=hazelcast-4.0.3

# create installer
docker run --rm -v `pwd`:/mnt kwart/innosetup-hazelcast hazelcast-installer /mnt/hazelcast-4.0.3.zip
```

## Signing the installer

The [osslsigncode](https://github.com/mtrojnar/osslsigncode) is installed in the image.
You can use it to sign the `Hazelcast_setup` executables:

```bash
# sign the installer
docker run --rm -v `pwd`:/mnt kwart/innosetup-hazelcast \
  osslsigncode sign \
    -n "Hazelcast IMDG" -i http://hazelcast.org/ \
    -certs /mnt/hazelcast.crt -key /mnt/hazelcast.key \
    -in /mnt/Hazelcast_setup_4.0.3.exe \
    -out /mnt/Hazelcast_setup_4.0.3-signed.exe
```
