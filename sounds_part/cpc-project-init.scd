//s.boot
//TO DO:
//HANDLE MASTER VOLUME (clipping problem)
//MAP LIGHT TO THE VOLUME
//MAP THE CONTINUOUS VALUE
//SHAKER HARDER

//Players: 1, 2, 3
//Patterns: A, B, C

(
s.waitForBoot({

	//**************** INITIALIZATION *******************

	s.plotTree;

	//************** EXT FILES & BUFFERS ****************

	//File.getcwd  //to check what is the current working directory
	//thisProcess.nowExecutingPath.dirname //also

	//Imported drum files
	~low = Buffer.read(s, "drums/drum-sample-8.wav", 0, s.sampleRate*1);
	~high = Buffer.read(s, "drums/drum-sample-9.wav", 0, s.sampleRate*1);
	~mid = Buffer.read(s, "drums/kenkeni-drum.wav", 0, s.sampleRate*0.25);

	//Imported "rain sand" file
	~shake1 = Buffer.read(s, "shakers/rain-maker.wav", 0, s.sampleRate*3);
	~shake2 = Buffer.read(s, "shakers/sandyrb.wav", 0, s.sampleRate*3);
	~shake3 = Buffer.read(s, "shakers/nut-shaker.wav", 0, s.sampleRate*3);


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

	//~playbuf = Synth.new(\playbuf, [\buf, ~mid.bufnum]);

	~playbuf = Synth.new(\playbuf, [\buf, ~shake1.bufnum, \rate, 1.5, \rel, 2]);
	~playbuf = Synth.new(\playbuf, [\buf, ~shake2.bufnum, \rate, 1.5, \rel, 2, \amp, 1]);
	~playbuf = Synth.new(\playbuf, [\buf, ~shake3.bufnum, \rate, 1.5, \rel, 2]);



//******************* SOUND DEF *********************

	SynthDef.new(\sine, {
		arg freq=440, atk = 0.005, rel=0.3, amp = 1, pan = 0;
		var sig, env;
		sig = SinOsc.ar(freq);
		env = EnvGen.kr(Env.new([0,1,0], [atk, rel], [1,-1]), doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		sig = sig * env;
		sig = FreeVerb.ar(sig);
		Out.ar(0, sig);
	}).add;

	SynthDef(\ks_string, {
		arg note, rand, delayTime;
		var x, y, env;
		env = Env.new(#[1, 1, 0],#[2, 0.001]);
		// A simple exciter x, with some randomness.
		x = Decay.ar(Impulse.ar(0, 0, rand), 0.1+rand, WhiteNoise.ar);
		x = CombL.ar(x, 0.05, note.reciprocal, delayTime, EnvGen.ar(env, doneAction:2));
		x = x*0.5;
		Out.ar(0, LeakDC.ar(x));
	}).add;

	//************* SEQUENCING: TONE ********************

	//Pbind: sequencing note events. Pdef: to manipulate real-time

	~toneA1 = Pdef(
		\sinetone1,
		Pbind(
			\instrument, \sine,
			\dur, Pseq([0.5, 0.25, 0.25], inf),
			//\freq, Prand([330, 247, 277, 370, 220], inf).trace,
			\freq, Prand([57, 59, 62, 64, 67].midicps, inf),
			\atk, Pwhite(0.0, 0.02, inf),
			\rel, Pwhite(0.2, 0.4, inf),
			\harmonic, Pexprand(1, 20, inf).round,
			\amp, Pexprand(0.2, 0.5, inf),
			);
	).play(quant: 1.875);

	~toneA2 = Pdef(
		\sinetone2,
		Pbind(
			\instrument, \sine,
			\dur, Pseq([0.375, 0.375, 0.25], inf),
			//\freq, Prand([123, 110], inf).trace,
			\freq, Prand([45, 43].midicps, inf),
			\atk, Pwhite(0.0, 0.02, inf),
			\rel, Pwhite(0.2, 0.4, inf),
			\harmonic, Pexprand(1, 20, inf).round,
			\amp, Prand([0.1,0.2,0.3], inf),
			);
	).play(quant: 1.875);

	~toneB1 = Pdef(
		\tone3,
		Pbind(
			\instrument, \ks_string,
			\dur, Pseq([0.25, 0.125, 0.125, 0.25], inf),
			//\note, Prand([[79, 84], [81, 86], [81, 76]].midicps, inf),
			\note, Prand([48, 50, 55, 57].midicps, inf),
			\rand, 0.1+0.1.rand,
			\delayTime, 1+1.0.rand,
			\amp, Pexprand(0.02, 0.05, inf),
		);
	).play(quant: 1.25);

	~toneB2 = Pdef(
		\sinetone4,
		Pbind(
			\instrument, \sine,
			\dur, Pseq([0.25, 0.25, 0.25, 0.25], inf),
			\freq, Prand([48, 50, 43, 45].midicps, inf),
			\atk, Pwhite(0.0, 0.05, inf),
			\rel, Pwhite(0.1, 0.4, inf),
			\harmonic, Pexprand(1, 20, inf).round,
			\amp, Pexprand(0.2, 0.4, inf),
			);
	).play(quant: 1.875);

	~toneC1 = Pdef(
		\sinetone5,
		Pbind(
			\instrument, \ks_string,
			\dur, Pseq([0.125, 0.125, 0.125, 0.25, 0.125, 0.125], inf),
			\note, Prand([88, 86, 84, 79, 93, 83, 64, 69, 71].midicps, inf),
			\rand, 0.1+0.1.rand,
			\delayTime, 2+1.0.rand,
			\amp, Pexprand(0.01, 0.1, inf),
			);
	).play(quant: 1.875);

	~toneC2 = Pdef(
		\sinetone6,
		Pbind(
			\instrument, \sine,
			\dur, Pseq([0.375, 0.625], inf),
			\freq, Prand([40,45,43].midicps, inf),
			\atk, Pwhite(0.0, 0.05, inf),
			\rel, Pwhite(0.1, 0.5, inf),
			\harmonic, Pexprand(1, 20, inf).round,
			\amp, Pexprand(0.2, 0.5, inf),
			);
	).play(quant: 1.875);


	~toneA1.stop;
	~toneA2.stop;
	~toneB1.stop;
	~toneB2.stop;
	~toneC1.stop;
	~toneC2.stop;


	//************* SEQUENCING: RHYTHM ********************

	~patternA = Pdef(
		\rhythmA,
		Pbind(
			\instrument, \playbuf,
			\dur, Pseq([1/4], inf),
			\stretch, 60/120 * 4,
			//\buf, Pwrand([~low, ~high, ~mid],[0.25, 0.6, 0.15], inf),
			\buf, Pseq(
				[
					~low,
					Pwrand([~low, ~mid, ~high], [0.25,0.6,0.15], 2),
					~high,
				], inf
			),
			\rate, Pexprand(1, 1.05, inf),
			\amp, Pseq([0.8, Pexprand(0.005,0.4,2), 0.6], inf),
		);
	).play(quant: 1.875);

	~patternB = Pdef(
		\rhythmB,
		Pbind(
			\instrument, \playbuf,
			\dur, Pseq([1/16], inf),
			\stretch, 60/120 * 4,
			//\buf, Pwrand([~low, ~high, ~mid],[0.25, 0.6, 0.15], inf),
			\buf, Pseq(
				[
					~low,
					Pwrand([~low, ~mid, ~high], [0.25,0.6,0.15], 7),
					~high,
					Pwrand([~low, ~mid, ~high], [0.25,0.25,0.5], 7),
				], inf
			),
			\rate, Pexprand(1, 1.05, inf),
			\amp, Pseq([0.9, Pexprand(0.1,0.5,7)], inf),
		);
	).play(quant: 1.875);

	~patternC = Pdef(
		\rhythmC,
		Pbind(
			\instrument, \playbuf,
			\dur, Pseq([1/8], inf),
			\stretch, 60/120 * 4,
			\buf, Pwrand([~low, ~mid],[0.6, 0.4], inf),
			\rate, Pexprand(0.7, 1.05, inf),
			\amp, Pexprand(0.2,0.5, inf),
		);
	).play(quant: 1.875);


	//******************* OSC ************************

	n = NetAddr.new("127.0.0.1", 57120);

	//FOR LATER: MAP THE LIGHT TO VOLUME
	/*~osc_light = OSCdef("Light",
		{
			arg msg, time, addr, port;
			("light:" + msg[1]).postln;

			if(msg[1]<0.05, {
				//wobble.set(\gain, 0); "The sound stops".postln}, {wobble.set(\gain, 1)
			});
		},
		'/light'
	);*/


	// DISCRETE EVENTS: SHAKERS

	~osc_shaker1 = OSCdef("IP1 shaker",
		{
			arg msg, time, addr, port;
			("IP1 shaken:" + msg[1]).postln;
			if(msg[1]==1,{
				~playbuf = Synth.new(\playbuf, [\buf, ~shake1.bufnum, \rate, 1.2, \rel, 2, \amp, 3]);
			});

		},
		'/IP1/shaken'
	);

	~osc_shaker2 = OSCdef("IP2 shaker",
		{
			arg msg, time, addr, port;
			("IP2 shaken:" + msg[1]).postln;
			if(msg[1]==1,{
				~playbuf = Synth.new(\playbuf, [\buf, ~shake2.bufnum, \rate, 1.5, \rel, 2, \amp, 1]);
			});

		},
		'/IP2/shaken'
	);

	~osc_shaker3 = OSCdef("IP3 shaker",
		{
			arg msg, time, addr, port;
			("IP3 shaken:" + msg[1]).postln;
			if(msg[1]==1,{
				~playbuf = Synth.new(\playbuf, [\buf, ~shake3.bufnum, \rate, 1.5, \rel, 2, \amp, 1]);
			});

		},
		'/IP3/shaken'
	);


	// OSC PATTERNS


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

	~osc_timbre_2 = OSCdef("Timbre 2",
		{
			arg msg, time, addr, port;
			//("timbre 2:" + msg[1]).postln;
			if(msg[1]== 'timbre A',{
				~toneA1.play(quant: 1.875);
				~toneA2.play(quant: 1.875);
				~toneB1.stop;
				~toneB2.stop;
				~toneC1.stop;
				~toneC2.stop;
			});
			if(msg[1]=='timbre B', {
				~toneB1.play(quant: 1.875);
				~toneB2.play(quant: 1.875);
				~toneA1.stop;
				~toneA2.stop;
				~toneC1.stop;
				~toneC2.stop;
			});
			if(msg[1]=='timbre C', {
				~toneC1.play(quant: 1.875);
				~toneC2.play(quant: 1.875);
				~toneB1.stop;
				~toneB2.stop;
				~toneA1.stop;
				~toneA2.stop;
			});
		},
		'/IP2/timbre'
	);

}))




//OSCdef.freeAll
//s.freeAll


//s.plotTree
//s.meter


//manupulating more than one file in a folder

	/*~folder = PathName.new("/sounds");
	~folder.entries.do({
		arg path;
		~sounds = ~sounds.add(Buffer.read(s, path.fullPath);
	});*/


//wobble bass

/*SynthDef(\wobble, {
		arg note = 22, gate = 1, dur = 2, gain = 1;

		var sig = Mix.ar(LFSaw.ar(note.midicps));

		var env = EnvGen.kr(Env.asr(0.05,dur, 0.5, -4.5));
		var out = env * sig * gain;

		Out.ar(0, out);
	}).add;


	~wobble = Synth(\wobble);
	//wobble.set(\gain, 0)
*/

//var sinx, siny, sinz;
	//var wobble;
	//var osc_light, osc_linx, osc_liny, osc_linz;





//~b0.free; //free the buffer. also Buffer.freeAll;
/*
if(File.exists("sounds/rain-maker.wav"),
	{
		//reading the file. index of the first and the last frames taken
		~b0 = Buffer.read(s, "sounds/rain-maker.wav", 0, s.sampleRate*5);
		//~b0.query; //summary: 2 channels because stereo file; sample rate
		//~b0.duration; //duration in seconds
	})

*/

//~playbuf = Synth.new(\playbuf, [\buf, ~b0.bufnum, \rate, 0.5]);
	//different rate: playing slower and faster. rate=-1 is backwards
	//to transpose the sound by semitones, use rate=*.midiratio where * is (1,2,3..)
/*
//creating a group of buffers: can create chaotic randomized sounds
	g = Group.new;

	(
		~playbuf1 = Synth.new(\playbuf, [\buf, ~mid.bufnum, \rate, 2, \loop, 1], g);
		~playbuf2 = Synth.new(\playbuf, [\buf, ~high.bufnum, \rate, 0.5, \loop, 1], g);
	)


	SynthDef(\bufrd_noise, {
		arg amp = 1, out = 0, buf, freq = 1, start, end;
		var sig, ptr;
		// random sections ofthe sound at random speed
		ptr = LFDNoise1.ar(freq).range(start, end);
		sig = BufRd.ar(2, buf, ptr);
		sig = sig * amp;
		Out.ar(out, sig);
	}).add;

	~playbuf = Synth.new(\bufrd_noise, [\buf, ~low.bufnum, \start, 0, \end, ~low.numFrames-1, \freq, 1]);
*/

/*
	SynthDef.new(\pulseSine , { arg out = 0, amp = 0.25, kfreq = 5 ;
		Out.ar(
			bus:out,
			channelsArray: SinOsc.ar(
				freq: kfreq*50, mul: LFPulse.kr( freq:
					kfreq, width: 0.25 )
			)
			*amp); }
	).add;

	v = Synth(\kick);
	v.set(\kfreq, 5);

*/


