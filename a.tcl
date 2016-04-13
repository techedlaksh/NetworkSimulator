global s nam_trace all_trace
set s [new Simulator]


########### TESTING NS2 ############################
# proc p {x} {
# 	global s
# 	puts "[$s now] $x"
# 	$s after 1 "p [expr 2*$x]"
# }

# $s at 0 "p 1"
# $s at 30 "exit"
#####################################################



########### SINGLE NODE NAM ##########################
# Creating a file 
set nam_trace [open a.nam w]
set all_trace [open a.trace w]
# Trace everything and put it in a.trace
$s trace-all $all_trace
# Trace everything related to nam and put it in a.nam
$s namtrace-all $nam_trace

proc finish {} {
	global s nam_trace all_trace
	$s flush-trace
	close $nam_trace
	close $all_trace
	exit
}

set src [$s node]
set dst [$s node]

# link b/w src and dst is 2 way link (duplex-link)
# 1Mb bandwidth || 100ms delay || DropTail queue management protocol
$s duplex-link $src $dst 1Mb 100ms DropTail

# TCP/Reno ==> protocol for $src
# TCPSink ==> packets receiver
set tcp [$s create-connection TCP/Reno $src TCPSink $dst 0]
set ftp [$tcp attach-source FTP]

$s at 0 "$ftp start"
$s at 10 "finish "
##########################################################

$s run