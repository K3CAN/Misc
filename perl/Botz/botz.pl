#!/usr/bin/perl
$boticon = "O";
$deadboticon = "%";
$humanicon = "@";
$deadhumanicon = "X";
$blastscore = 0;
$roundscore = 0;
$control = 0;
$classic = "0";
$name = "botz";
open INFO, "botz.inf";
print STDOUT "[2J";
print STDOUT <INFO>;
close INFO;
$level = <STDIN>;
$level = 1 if $level<1;
$level = 10 if $level>10;
$round = 1;

getcontrols();
PLAY: $human{state}=0; while ($human{state} == 0) {setup(); check();}
printit();
while () 	{
move();
botmove();
check();
printit();
if ($deadbots == $numbots) {
	print "[2;1HWinner!\nNext round\n";
	$round++;
	$totalscore = ($roundscore - $blastscore);
	last}
if ($human{state} == 0) {print "[2;1HYou lose!\nTry again\n"; last;}
		}
pressenter();
goto PLAY;


#subs start:

sub setup {
$deadbots = 0;
$numbots = (($level * $round) * 10) + $more;
$more = 0;
$btu = $blast = $round;
for ($i=0; $i<$numbots; $i++) {
	$bot[$i]{x}=int(rand(81));
	$bot[$i]{y}=int(rand(21));
	$bot[$i]{state}=1;
}
%human = (
"x" => int(rand(81)),
"y" => int(rand(21)),
"state" => 1);
}

sub check {
$deadbots = 0;
$score = 0;
for ($i=0; $i<$numbots; $i++) {
if ($bot[$i]{state} == 0) {$deadbots++; $roundscore += 5}
for ($n=($i+1); $n<$numbots; $n++) {
	if ($bot[$i]{x}==$bot[$n]{x} && $bot[$i]{y}==$bot[$n]{y}) {
		$bot[$i]{state} = $bot[$n]{state} = 0;
	}
	}
}
for ($n=0; $n<$numbots; $n++) {
	if ($human{x}==$bot[$n]{x} && $human{y}==$bot[$n]{y}) {
		$human{state} = $bot[$n]{state} = 0;
	}

if ($bot[$n]{y} > 20) {$bot[$n]{y} = 20}
if ($bot[$n]{y} < 2) {$bot[$n]{y} = 2}
if ($bot[$n]{x} > 80) {$bot[$n]{x} = 80}
if ($bot[$n]{x} < 1) {$bot[$n]{x} = 1}
if ($human{x} > 80) {$human{x} = 80}
if ($human{x} < 1) {$human{x} = 1}
if ($human{y} > 20) {$human{y} = 20}
if ($human{y} < 2) {$human{y} = 2}
}
}

sub botmove {
for ($i=0; $i<$numbots; $i++) {
	unless ($bot[$i]{state} == 0) {
		if ($bot[$i]{x} < $human{x}) {$bot[$i]{x}++
		} elsif ($bot[$i]{x} > $human{x}) {$bot[$i]{x}-- }
		if ($bot[$i]{y} < $human{y}) {$bot[$i]{y}++
		} elsif ($bot[$i]{y} > $human{y}) {$bot[$i]{y}-- }
		} else { }
	}
}

sub move {

if ($control == 0) {
	system "stty cbreak </dev/tty >/dev/tty 2>&1";	#----------------------
	$key = getc;					#This part gets the key
	system "stty -cbreak </dev/tty >/dev/tty 2>&1";	#----------------------
} else {
	$key = getc;					#more key stuff
}
if ($key eq $controls{up})    	 {$human{y}--}
elsif ($key eq $controls{down})	 {$human{y}++}
elsif ($key eq $controls{left}) {$human{x}--}
elsif ($key eq $controls{right}) {$human{x}++}
elsif ($key eq $controls{leftup}) {$human{x}--; $human{y}--}
elsif ($key eq $controls{rightup}) {$human{x}++; $human{y}--}
elsif ($key eq $controls{rightdown}) {$human{x}++; $human{y}++}
elsif ($key eq $controls{leftdown}) {$human{x}--; $human{y}++}
elsif ($key eq $controls{wait} ||$key eq "w") {} #doesn't move 
#'+' Key = Teleport
elsif ($key eq $controls{teleport}) {$human{y}=int(rand(20)); $human{x}=int(rand(80))}
#'*' Key = 'Bullet-time'
elsif ($key eq $controls{BT} && $classic eq "0") {bullettime();}
#'-' key = '-- blast'
elsif ($key eq $controls{hblast} && $classic eq "0") {hblast()}
#'/' key = '| blast'
elsif ($key eq $controls{vblast} && $classic eq "0") {vblast()}
#'.' key = Skip Five Moves
elsif ($key eq $controls{skipfive}) {skipfive();}
#';' key = command
elsif ($key eq ";") {command();}
#'r' key = Restart
elsif ($key eq "r") {goto PLAY;}
#'q' key = Quit
elsif ($key eq "q") {die "[2J"."Game terminated"}

else {move()}
}

sub bullettime {
	if ($btu > 0) {
		$btu--;
		for ($bt=0; $bt<=5; $bt++) {
			print "[25;1HBULLET TIME!!";
			move();
			check();
			printit();
		}
	}
}

sub skipfive {
for ($sf=0; $sf<=3; $sf++) {
	botmove();
	check();
}
printit();
}

sub printit {
print "[2J";
for ($i=0; $i<$numbots; $i++) {
if ($bot[$i]{state} == 1) {print "[$bot[$i]{y};$bot[$i]{x}H$boticon";}
else {print "[$bot[$i]{y};$bot[$i]{x}H$deadboticon";}
if ($human{state} == 1) {print "[$human{y};$human{x}H$humanicon";}
else {print "[$human{y};$human{x}H$deadhumanicon";}
}
print "[1;1H" . "-"x80; #Print lines at the top and bottom of screen
print "[21;1H" . "-"x80 . "\nScore: $totalscore\t\t"; print "Bullet-time power-ups: $btu\tBlast Power: $blast" if $classic eq "0"; print"\nRound: $round\t\tState: $human{state}\t\t\tPos: $human{y}, $human{x} \nLevel: $level";
print "[0;0H";
}

#Blast subs//
sub hblast {
if ($blast>0) {
for ($n=0; $n<$numbots; $n++) {
	if ($human{y}==$bot[$n]{y}) {
		$bot[$n]{state} = 0;
	}
} $blast--;
$blastscore += 50;}
}
sub vblast {
if ($blast>0) {
for ($n=0; $n<$numbots; $n++) {
	if ($human{x}==$bot[$n]{x}) {
		$bot[$n]{state} = 0;
	}
} $blast--;
$blastscore += 50;}
}
#\\Blast subs

#//Command Controls
sub command {
	pressenter();
	chomp $temp;

	if ($temp =~ /^kill/) {
		($a, $kill) = split / /, $temp;
		if ($kill eq "all") {
			for ($n=0; $n<$numbots; $n++) {$bot[$n]{state} = 0;}
		} else {$bot[$kill]{state} = 0;}
		printit();
	} elsif ($temp =~ /^changelevel/) {
		($a, $level, $round) = split / /, $temp;
		$level = 1 if $level<1;
		$round = 1 if $round<1;
		goto PLAY;

	} elsif ($temp eq "die") {$human{state}=0;
		check();

	} elsif ($temp =~ /^moveto/) {
		($a, $human{y}, $human{x}) = split / /, $temp;
		check();
	} elsif ($temp =~ /^addbots/) {
		($a, $more) = split / /, $temp;
		goto PLAY;
	} elsif ($temp =~ /^control/) {
		($a, $control) = split / /, $temp;
	} elsif ($temp =~ /^bind/) {
		($a, $bindkey, $func) = split / /, $temp;
		$controls{$func} = $bindkey;
		savekeys();
	} elsif ($temp eq "viewkeys") {
		print %controls; pressenter();
	} elsif ($temp =~ /^classic/) {
	($a, $classic) = split / /, $temp;
	} else {}
	printit(); move();
}
#\\Command Controls
# # # # # # # # # # # # # # # # # # # #
sub pressenter {
print "[25;1HPress enter to continue; ";
$temp = <STDIN>;
}



#Get key stuff ->
# # # # # # # # # # # # # # # # # # # #

sub getcontrols {
open CONTROLS, "<botz.con" or die;
(
$controls{up}, $controls{down}, $controls{right}, $controls{left}, $controls{leftup}, $controls{leftdown}, $controls{rightup}, $controls{rightdown}, $controls{teleport}, $controls{vblast}, $controls{hblast}, $controls{BT}, $controls{skipfive}, $controls{wait}
) = split /:/, <CONTROLS>;
close CONTROLS or die;
}
# # # # # # # # # # # # # # # # # # # #
sub savekeys {
open CONTROLS, ">botz.con" or die "ERROR OPENING FILE $name.con!";
print CONTROLS "$controls{up}:$controls{down}:$controls{right}:$controls{left}:$controls{leftup}:$controls{leftdown}:$controls{rightup}:$controls{rightdown}:$controls{teleport}:$controls{vblast}:$controls{hblast}:$controls{BT}:$controls{skipfive}:$controls{wait}:";
close CONTROLS;
}
