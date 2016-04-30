set val(chan)	Channel/WirelessChannel
set val(prop)	Propogation/TwoRayGround
set val(netif)	Phy/WirelessPhy
set val(mac)	Mac/802_11
set val(ifq)	Queue/DropTail/PriQueue
set val(ll)		LL
set val(ant)	Antenna/OmniAntenna
set val(ifqlen) 50
set val(nn)		10
set val(rp)		DumbAgent
set val(x)		600
set val(y)		600


Mac/802_11 set dataRate_ 11Mb

# Global Variables
set ns_ 	[new Simulator]
set tracefd	[open wifi.tr w]
$ns_ trace-all $tracefd

set namtrace [open wifi.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)

# Set up topography object
set topo 	[new Topography]
$topo load_flatgrid $val(x) $val(y)

# Create God
create-god $val(nn)

# Create channel
set chan_1_ [new $val(chan)]

$ns_ node-config -adhocRouting $val(rp) \
				-llType $val(ll) \
				-macType $val(mac) \
				-ifqType $val(ifq) \
				-ifqLen $val(ifqLen) \
				-antType $val(ant) \
				-propType $val(prop) \
				-phyType $val(netif) \
				-topoInstance $topo \
				-agentTrace OFF \
				-routerTrace OFF \
				-macTrace ON \
				-movementTrace ON \
				-channel $chan_1_

		
	for {set i 0} {$i < [expr $val(nn)]} {incr i} {
		set node_($i) [$ns_ node]
		$node_($i) random-motion 0	;
		set mac_($i) [$node_($i) getMac 0]
		$mac_($i) set RTSThreshold_ 3000
	}


$node_(0) set X_ 200.0
$node_(0) set Y_ 360.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 100.0
$node_(1) set Y_ 100.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 400.0
$node_(2) set Y_ 400.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 280.0
$node_(3) set Y_ 140.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 100.0
$node_(4) set Y_ 320.0
$node_(4) set Z_ 0.0

$node_(5) set X_ 70.0
$node_(5) set Y_ 210.0
$node_(5) set Z_ 0.0

$node_(6) set X_ 440.0
$node_(6) set Y_ 310.0
$node_(6) set Z_ 0.0

$node_(7) set X_ 490.0
$node_(7) set Y_ 320.0
$node_(7) set Z_ 0.0

$node_(8) set X_ 520.0
$node_(8) set Y_ 280.0
$node_(8) set Z_ 0.0

$node_(9) set X_ 560.0
$node_(9) set Y_ 360.0
$node_(9) set Z_ 0.0

$ns_ at 0.0 "$node_(0) label AP1"
$ns_ at 0.0 "$node_(1) label N1"
$ns_ at 0.0 "$node_(2) label MN1"
$ns_ at 0.0 "$node_(3) label MN2"
$ns_ at 0.0 "$node_(4) label MN3"
$ns_ at 0.0 "$node_(5) label MN4"
$ns_ at 0.0 "$node_(6) label MN5"
$ns_ at 0.0 "$node_(7) label MN6"
$ns_ at 0.0 "$node_(8) label MN7"
$ns_ at 0.0 "$node_(9) label AP2"

$ns_ at 0.0 "$node_(0) add-mark m1 green circle"
$ns_ at 0.0 "$node_(1) add-mark m1 red circle"
$ns_ at 0.0 "$node_(2) add-mark m1 yellow circle"
$ns_ at 0.0 "$node_(3) add-mark m1 blue circle"
$ns_ at 0.0 "$node_(4) add-mark m1 purple circle"
$ns_ at 0.0 "$node_(5) add-mark m1 pink circle"
$ns_ at 0.0 "$node_(6) add-mark m1 red circle"
$ns_ at 0.0 "$node_(7) add-mark m1 plum circle"
$ns_ at 0.0 "$node_(8) add-mark m1 yellow circle"
$ns_ at 0.0 "$node_(9) add-mark m1 grey circle"


set AP_ADDR1 [$mac_(0) id]
$mac_(0) ap $AP_ADDR1
set AP_ADDR2 [$mac_([expr $val(nn) - 1]) id]
$mac_([expr $val(nn) - 1]) ap $AP_ADDR2

$mac_(1) ScanType Active

for {set i 3} {$i < [expr $val(nn) - 1]} {incr i} {
	$mac_($i) ScanType Passive;
}

$ns_ at 1.0 "$mac(2) ScanType ACTIVE"
Application/Traffic/CBR set packetsize_ 1023
Application/Traffic/CBR set rate_ 256Kb

for {set i 1} {$i < [expr $val(nn) - 1]} {incr i}{
	set udp1($i) [new Agent/UDP]

	$ns_ attach-agent $node_($i) $udp1($i)
	set cbr1($i) [new Application/Traffic/CBR]
	$cbr1($i) attach-agent $udp1($i)
}

set null0 [new Agent/Null]
$ns_ attach-agent $node_(1) $null0
$ns_ connect $udp1(2) $null0

set null1 [new Agent/Null]
$ns_ attach-agent $node_(1) $null1
