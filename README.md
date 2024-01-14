# tunNgrok
This repository serves to automate The installation of NGROK in Termux - 2024

<img src="Images/tcp.jpg" width="600px" heigth="600px">

<h3>PLATFORMS</h3>
- Termux

<h3>INSTALATION</h3>
<pre>
  git clone https://github.com/JsonSecurity/tunNgrok
  chmod +x ./install.sh
  ./install.sh
</pre>


<h3>Config (PATH)</h3>
<pre>
  ./ngrok.sh
</pre>
Restart your terminal

<h3>Help</h3>
<pre>
  tun
</pre>

<h3>Tunel TCP</h3>

<pre>
  tun -s tcp -p 443
</pre>

<h3>Tunel HTTP</h3>

<pre>
 tun -s http -p 8080
</pre>

