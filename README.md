# Test PR31 at https://github.com/projg2/gemato (WIP)

The PR:

[https://github.com/projg2/gemato/pull/31](https://github.com/projg2/gemato/pull/31)

All GnuPG version provided by the Gentoo repo are tested:

[https://packages.gentoo.org/packages/app-crypt/gnupg](https://packages.gentoo.org/packages/app-crypt/gnupg)

1. Build images:

```bash
docker build --build-arg GNUPG_VERSION=2.2.40 -t pr31:2.2.40 -f Dockerfile .
docker build --build-arg GNUPG_VERSION=2.2.41 -t pr31:2.2.41 -f Dockerfile .
docker build --build-arg GNUPG_VERSION=2.3.8  -t pr31:2.3.8  -f Dockerfile .
docker build --build-arg GNUPG_VERSION=2.4.0  -t pr31:2.4.0  -f Dockerfile .
docker build --build-arg GNUPG_VERSION=2.2.40 --build-arg PATCH_GEMATO=true -t pr31:2.2.40_patched -f Dockerfile .
docker build --build-arg GNUPG_VERSION=2.2.41 --build-arg PATCH_GEMATO=true -t pr31:2.2.41_patched -f Dockerfile .
docker build --build-arg GNUPG_VERSION=2.3.8  --build-arg PATCH_GEMATO=true -t pr31:2.3.8_patched  -f Dockerfile .
docker build --build-arg GNUPG_VERSION=2.4.0  --build-arg PATCH_GEMATO=true -t pr31:2.4.0_patched  -f Dockerfile .
```

2. Prohibit access to public DNS servers for containers:

For this purpose and given that IPv6 isn't used, I execute following simple commands on the host:

```bash
iptables -I FORWARD -p tcp --dport 53 -j REJECT
iptables -I FORWARD -p udp --dport 53 -j REJECT
iptables -I FORWARD -d 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16 -p tcp --dport 53 -j ACCEPT
iptables -I FORWARD -d 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16 -p udp --dport 53 -j ACCEPT
```

3. Test the patch:

```bash
docker run --rm pr31:2.2.40 -- emerge --sync
docker run --rm pr31:2.2.41 -- emerge --sync
docker run --rm pr31:2.3.8  -- emerge --sync
docker run --rm pr31:2.4.0  -- emerge --sync
docker run --rm pr31:2.2.40_patched -- emerge --sync
docker run --rm pr31:2.2.41_patched -- emerge --sync
docker run --rm pr31:2.3.8_patched  -- emerge --sync
docker run --rm pr31:2.4.0_patched  -- emerge --sync
```
