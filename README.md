# Docker environment for 4.3BSD on VAX

```
docker build -t ye-olde-bsd .
docker run -itp 127.0.0.1:25:25 -p 127.0.0.1:79:79 ye-olde-bsd
```

https://github.com/rapid7/metasploit-framework/pull/10700
