# tunNgrok
This repository serves to automate The installation of NGROK in Termux - 2024

<img src="https://github.com/JsonSecurity/Images/blob/main/scripts/tcp.jpg" width="600px" heigth="600px">

<h3>PLATFORMS</h3>
- Termux

<h3>INSTALATION</h3>

```
git clone https://github.com/JsonSecurity/tunNgrok
```

```
cd tunNgrok

chmod +x install.sh
chmod +x tun.sh
```

```
./install.sh
```

- Restart your terminal

<h3>Help</h3>

```
tun
```

```
[ ! ] Script tun ngrok 3.2 by [ Json Security ]
 
   [+] Execution:
	    tun -e
				
   [+] Config:
	    tun -s \<protocolo\> -p \<puerto\>
```

<h3>Tunel TCP</h3>

```
tun -s tcp -p 443
```

<h3>Tunel HTTP</h3>

```
tun -s http -p 8080
```

