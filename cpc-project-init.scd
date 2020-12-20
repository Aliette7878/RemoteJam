
(
s.waitForBoot({

	//****************** OSC **************************

	s.boot
	s.addr
	n = NetAddr.new("192.168.1.50", 7400);
	NetAddr.localAddr


	OSCdef('Accelerometer',{
		arg msg;

		postln(msg);

		try{
			if(msg.size > 2) {
			}  {postln("Error: Empty msg")};
		}

	},'/accelerometer/raw/x');

	OSCdef.new(
		\x,
		{
			arg msg, time, addr, port;
			msg[1].postln;
		},
		'/accelerometer/raw/x'
	);

	o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/accelerometer/raw/x', n);

	o = OSCFunc({arg msg, time, address, receivedPort;
		"received trigger!".postln;
		msg.postln;
	}, "/accelerometer/raw/x", n);


	OSCresponder(n, "/accelerometer/raw/x", {arg time, responder, msg;
		"received trigger!".postln;
		msg.postln;
	}).add;

	OSCFunc.trace(false);

	o.free;

}))





