Here's a quick rundown of the scripts here:

* sad
  
  Run with an argument of a process you want to kill, such as `sad chrome`. 
  It'll show you a list of processes that match your search and you can then select which one to kill.
  It's essentially just a fancier way of saying `ps -a | grep [name]` followed by `kill [proc]`.
  I find it really useful and have this script in my path on all of my systems.
  
* Mastodon_to_text

  This does what it says. If you plug in all of the variables, it will pull down mastodon statuses and save them in a text file. 
  I'm using this to copy my Mastodon statuses to a folder on my gopher server. 

* Bots

  This is a game I wrote sometime in the mid 2000s. I'm in my thirties now, so I was likely in my early teenage years when I wrote that. I found an old IDE hard drive packed away and this was among the files I recovered from it (after finding an IDE-USB adapter that _didn't_ look like it would burn my house down). While it still looks _functional_, it's likely NOT a demonstration of perl's best practices nor effecint code writing, and it just included here as a fun part of my personal history. 