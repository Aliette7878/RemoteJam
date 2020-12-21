(
s.waitForBoot({

	//**************** INITIALIZATION *******************

	var sinx, siny, sinz;
	var wobble;
	var osc_light, osc_linx, osc_liny, osc_linz;

	s.plotTree;

	//******************* SOUND DEF *********************

	SynthDef(\wobble, {
		arg note = 22, gate = 1, dur = 2, gain = 1;

		var sig = Mix.ar(LFSaw.ar(note.midicps));

		var env = EnvGen.kr(Env.asr(0.05,dur, 0.5, -4.5));
		var out = env * sig * gain;

		Out.ar(0, out);
	}).add;


	wobble = Synth(\wobble);
	//wobble.set(\gain, 0)

	//******************* OSC ************************

	n = NetAddr.new("127.0.0.1", 57120);

	osc_light = OSCdef("Light",
		{
			arg msg, time, addr, port;
			("light:" + msg[1]).postln;

			// if the light is less than 0.1, the sound stops. I know, not optimal, but for the moment it is like that
			if(msg[1]<0.05, {
				wobble.set(\gain, 0); "The sound stops".postln}, {wobble.set(\gain, 1)
			});
		},
		'/light'
	);


	osc_linx = OSCdef("Accelerometer-x",
		{
			arg msg, time, addr, port;
			("acc linear x:" + msg[1]).postln;

		},
		'/accelerometer/linear/x'
	);

	osc_liny = OSCdef("Accelerometer-y",
		{
			arg msg, time, addr, port;
			("acc linear y:" + msg[1]).postln;
		},
		'/accelerometer/linear/y'
	);

	osc_linz = OSCdef( "Accelerometer-z",
		{
			arg msg, time, addr, port;
			("acc linear z:" + msg[1]).postln;
		},
		'/accelerometer/linear/z'
	);

}))

//OSCdef.freeAll
//o.free


//s.plotTree
//s.meter
