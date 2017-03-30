package heartbeat;

use strict;
use warnings;
use Plugins;
use IO::Socket;
use IO::Select;
use Log qw(message error warning);

Plugins::register('heartbeat', 'idRO heartbeat', \&Unload, \&Unload);

my $hooks = Plugins::addHooks(
	['idROheartbeat',		\&onLoad, undef]
);

# onUnload
sub Unload {
	Plugins::delHooks($hooks);
}

sub onLoad ($aDestIp, $aDestPort) {
	#If change map, do new ping-pong request, else just send the ping
	if ($aDestIp ne $dest_serverIp) {
		my $dest_serverIp = '202.93.25.76';
		my $dest_port = 17000;
		
		my $local_port = 52000 + int(rand(63999 - 52000));
		
		my $sock = IO::Socket::INET->new(
			PeerAddr => $dest_serverIp,
			PeerPort => $dest_port,
			LocalPort => $local_port,
			Proto => 'udp', 
			Timeout => 1) or die('Error opening socket.');
		
		my $data = "hello";	
		
		while (<>){
			$sock->send();		
			sleep .2; # Wait for response...
			
			message "[Heartbeat Receive] \n", "system";
			print   "RCV:" . read_socket($send_socket, $datagram) . "\n";
			
			#do data process here
			#end data process
	   }		
	} else {
	
	}
   exit;
}

sub read_socket{
    my $h = shift;  # Socket Handle

    my ($datagram,$flags);

    my $Sender_Info = $h->recv($datagram, $MAX_TO_READ, $flags) or return 0;
	
    my ($Sender_port, $Sender_iaddr_binary) = sockaddr_in($Sender_Info);
	
    my $Sender_addr = inet_ntoa($Sender_iaddr_binary);
	
    return $Sender_addr, $Sender_port, $datagram;
}