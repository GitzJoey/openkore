package heartbeat;

use strict;
use Plugins;
use IO::Socket::INET;
use Log qw(message error warning);

Plugins::register('heartbeat', 'idRO heartbeat', \&Unload, \&Unload);

my $hooks = Plugins::addHooks(
	['request_heartbeat',		\&onRequest, undef],
	['receive_heartbeat',		\&onReceive, undef],
	['send_heartbeat',			\&onSend, undef]
);

# onUnload
sub Unload {
	Plugins::delHooks($hooks);
}

sub onRequest () {
	message "[Heartbeat Request] \n", "system"; 

	my $dest_serverIp = '202.93.25.76';
	my $dest_port = 17000;
	
	my $local_port = 52000 + int(rand(63999 - 52000));
	
	my $sock = new IO::Socket::INET(
		PeerAddr => $dest_serverIp,
        PeerPort => 3671,
		LocalPort => $local_port,
        Proto => 'udp', 
		Timeout => 1) or die('Error opening socket.');
	my $data = "hello";
	print $sock $data;
}

sub onReceive () {
	
}

sub onSend() {

}

sub process_packet {
	my($user_data, $header, $packet) = @_;
	my $len = length $packet;
	
	my $i=0;

	do {
		my $lg = substr $packet, $i, 16;
		printf "%.8X : ", $i;
		$i+=16;
		print unpack ('H2'x16, $lg), '  'x(16-length $lg);
		$lg =~ s/[x00-x1FxFF]/./g;
		print " $lgn";
	} until $i>=$len;
  
	print "n";
}