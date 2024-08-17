Can I have multiple readme files in github? 
I have no idea.


------------------------------------------------------------
Here's a quick rundown of the scripts here:

* sync-cf-ips

  This script will download the current IPv4 addresses used by cloudflare and create/update NGINX's "real_ip" configuration so that the source IPs are recorded correctly in the log. It assumes you're using NGINX's config.d, and creates or replaces a "real_ips.conf" file into that directory. 
  This is obviously only useful if you're using Cloudflare's proxy service on your domain. 

* sad
  
  Run with an argument of a process you want to kill, such as `sad chrome`. 
  It'll show you a list of processes that match your search and you can then select which one to kill.
  It's essentially just a fancier way of saying `ps -a | grep [name]` followed by `kill [proc]`.
  I find it really useful and have this script in my path on all of my systems.
  

* rpcoutlets

  It controls my RPC2 PDU. If you happen to own an RPC2, maybe this is _slightly_ useful. 
  Run with the state you want for the outlet and the outlet number; e.g. `rpcoutlets on 3`
  It's written to be run in the background, too, without any arguments. 
  In this case, it watches the cpu package temp of my main server and will flip outlet 5 (an extra fan) on and off in response to that reading.
  

* Mastodon_to_text

  This does what it says. If you plug in all of the variables, it will pull down mastodon statuses and save them in a text file. 
  I'm using this to copy my Mastodon statuses to a folder on my gopher server. 
