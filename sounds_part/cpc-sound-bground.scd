s.boot

//Players: 1, 2, 3
//Patterns: A, B, C
//Levels: 1, 2

(
s.waitForBoot({

	//**************** INITIALIZATION *******************

	s.plotTree;

	//************** EXT FILES & BUFFERS ****************

	File.getcwd  //to check what is the current working directory
	//thisProcess.nowExecutingPath.dirname //also


	//Imported bg sounds
	~bg_wind = Buffer.read(s, "background/bg-soft-wind.wav", 0, -1);
	~bg_crickets = Buffer.read(s, "background/bg-crickets.wav", 0, -1);
	~bg_crickets_birds = Buffer.read(s, "background/bg-crickets_birds.wav", 0, -1);
	~bg_lemur = Buffer.read(s, "background/bg-lemur.wav", 0, -1);
	~bg_lotar = Buffer.read(s, "background/bg-lotar.wav", 0, -1);


	//Imported shakers sounds
	~rain = Buffer.read(s, "shakers/rain-maker.wav", 0, s.sampleRate*3);
	~rattle = Buffer.read(s, "shakers/sandyrb.wav", 0, s.sampleRate*3);


	//synthdef for the buffer sounds
	SynthDef(\playbuf, {
		arg amp = 2, out = 0, buf, rate = 1, t_trig, start=0, rel = 0.5, loop = 0, da = 2;
		var sig, env;
		sig = PlayBuf.ar(2, buf, rate * BufRateScale.kr(buf), t_trig, start, loop, doneAction: da);
		env = EnvGen.kr(Env.new([0,1,0], [0, rel], [1,-1]), doneAction:2);
		sig = sig*env;
		sig = FreeVerb.ar(sig, mix:0.5)*amp;

		Out.ar(out, sig);
	}).add;


	//Just to hear the sounds
	~playbuf = Synth.new(\playbuf, [\buf, ~bg_wind.bufnum, \rate, 1, \rel, 25]);
	~playbuf = Synth.new(\playbuf, [\buf, ~bg_crickets.bufnum, \rate, 1, \rel, 25, \amp, 4]);
	~playbuf = Synth.new(\playbuf, [\buf, ~bg_crickets_birds.bufnum, \rate, 1, \rel, 25]);
	~playbuf = Synth.new(\playbuf, [\buf, ~bg_lemur.bufnum, \rate, 1, \rel, 25]);
	~playbuf = Synth.new(\playbuf, [\buf, ~bg_lotar.bufnum, \rate, 1, \rel, 25]);


	~playbuf = Synth.new(\playbuf, [\buf, ~rain.bufnum, \rate, 1.5, \rel, 2]);
	~playbuf = Synth.new(\playbuf, [\buf, ~rattle.bufnum, \rate, 1.5, \rel, 2, \amp, 1]);




//******************* SOUND DEF *********************



	//******************* OSC ************************

	n = NetAddr.new("127.0.0.1", 57120);



	// DISCRETE EVENTS: SHAKERS

	~osc_shaker1 = OSCdef("IP1 shaker",
		{
			arg msg, time, addr, port;
			("IP1 shaken:" + msg[1]).postln;
			if(msg[1]==1,{
				~playbuf = Synth.new(\playbuf, [\buf, ~rain.bufnum, \rate, 1.2, \rel, 2, \amp, 3]);
			});

		},
		'/IP1/shaken'
	);



	~osc_pattern_1 = OSCdef("Pattern 1",
		{
			arg msg, time, addr, port;
			//("pattern 1:" + msg[1]).postln;
			if(msg[1]== 'Pattern A',{
				~patternA.play(quant: 1.875);
				~patternB.stop;
				~patternC.stop;
			});
			if(msg[1]=='Pattern B', {
				~patternB.play(quant: 1.875);
				~patternA.stop;
				~patternC.stop;
			});
			if(msg[1]=='Pattern C', {
				~patternC.play(quant: 1.875);
				~patternA.stop;
				~patternB.stop;
			});
		},
		'/IP1/pattern'
	);


}))




//OSCdef.freeAll
//s.freeAll