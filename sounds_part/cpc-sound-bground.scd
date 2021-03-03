s.boot

//Players: 1, 2, 3
//Patterns: A, B, C
//Levels: 1, 2

(
s.waitForBoot({

	//**************** INITIALIZATION *******************

	s.plotTree;


	//************** EXT FILES & BUFFERS ****************

	//File.getcwd  //to check what is the current working directory

	//Importing background sounds
	//~bg_wind = Buffer.read(s, "background/bg-soft-wind.wav", 0, -1);
	//~bg_lotar= Buffer.read(s, "background/bg-lotar.wav", 0, -1);
	//~bg_crickets = Buffer.read(s, "background/bg-crickets.wav", 0, -1);
	~bg_crickets_birds = Buffer.read(s, "background/bg-crickets_birds.wav", 0, s.sampleRate*25);

	//Importing birds sounds
	~birds = Buffer.read(s, "birds/birds.wav", 0, s.sampleRate*6);

	//Importing other nature/instruments sounds
	~lemur = Buffer.read(s, "background/bg-lemur.wav", 0, -1);
	~elephant = Buffer.read(s, "background/bg-elephant.wav", 0, -1);
	~didgeridoo = Buffer.read(s, "instruments/didgeridoo-a.wav", 0, -1);
	~flute_rnd = Buffer.read(s, "instruments/flute-glissando.wav", 0, -1);


	//Importing people sounds
	~tawny_1 = Buffer.read(s, "people/tawny-1.wav", 0, -1);
	~tawny_2 = Buffer.read(s, "people/tawny-2.wav", 0, -1);
	~tawny_3 = Buffer.read(s, "people/tawny-3.wav", 0, -1);
	~owl = Buffer.read(s, "people/owl discrete.wav", 0, -1);
	~scream = Buffer.read(s, "people/scream_high.wav", 0, -1);


	//Importing shakers sounds
	~rain = Buffer.read(s, "shakers/rain-maker.wav", 0, s.sampleRate*4);
	~rattle = Buffer.read(s, "shakers/sandyrb.wav", 0, s.sampleRate*4);
	~nut = Buffer.read(s, "shakers/nut-shaker.wav", 0, s.sampleRate*4);

	//Importing kalimba sounds
	~k_c0 = Buffer.read(s, "kalimba/k-c-low.wav", 0, -1);
	~k_f0 = Buffer.read(s, "kalimba/k-f0.wav", 0, -1);
	~k_c1 = Buffer.read(s, "kalimba/k-c.wav", 0, -1);
	~k_f1 = Buffer.read(s, "kalimba/k-f1.wav", 0, -1);
	~k_c2 = Buffer.read(s, "kalimba/k-c-high.wav", 0, -1);
	~k_short_a = Buffer.read(s, "kalimba/k-short-a.wav", 0, -1);
	~k_short_c = Buffer.read(s, "kalimba/k-short-c.wav", 0, -1);
	~k_short_d = Buffer.read(s, "kalimba/k-short-d.wav", 0, -1);

	//Just to hear the sounds

	//~lemur_buf = Synth.new(\playbuf, [\buf, ~bg_lemur.bufnum, \rel, 5, \amp, 0.3]);


	//******************** SYNTHDEFS *************************

	//*********************** WIND *************************

	SynthDef(\wind, {
		arg amp = 0.002, freq_mul = 1000, freq_add = 1100;
		var w1, w2;		//two identical functions, one left, one right
		w1=RLPF.ar(
			WhiteNoise.ar(1), 	//normal level, out level comes later
			LFNoise1.kr(0.1, freq_mul, freq_add),//filter controlled by global envelope.
			//Beware of low cutoff when using RLPF
			LFNoise1.kr(0.2, 0.45, 0.46),  // 0.55 to 1 varying reciprocal Q
			amp  //low level, controlled by global envelope
		);
		w2=RLPF.ar(
			WhiteNoise.ar(1),
			LFNoise1.kr(0.1, freq_mul, freq_add),
			LFNoise1.kr(0.2, 0.45, 0.46),
			amp
		);
		Out.ar(0,[w1, w2] )
	}).add;

	//**************** SYNTHDEF FOR BUFFER SOUNDS ***************

	SynthDef(\playbuf, {
		arg amp = 1, out = 0, buf, rate = 1, t_trig = 1, start=0, rel = 2, done_act = 2, rev_mix = 0.25, rev_room = 0.15;
		var sig, env;
		sig = PlayBuf.ar(2, buf, rate * BufRateScale.kr(buf), t_trig, start, doneAction:done_act);
		env = EnvGen.kr(Env.new([0,1,0], [0.4, rel], [3, -1]), t_trig, doneAction:done_act);
		sig = sig*env;
		sig = FreeVerb.ar(sig, mix: rev_mix, room: rev_room)*amp;

		Out.ar(out, sig);
	}).add;


	SynthDef(\playbuf_loop, {
		arg amp = 1, out = 0, buf, rate = 1, t_trig = 1, start=0, rel = 2, loop = 0, done_act = 0, rev_mix = 0.5, rev_room = 0.5;
		var sig, env;
		sig = PlayBuf.ar(2, buf, rate * BufRateScale.kr(buf), t_trig, start, loop, doneAction:done_act);
		env = EnvGen.kr(Env.new([0,1], [0.5]), t_trig, doneAction:done_act);
		sig = sig*env*LFNoise1.kr(0.3, 0.2, 0.46);
		sig = FreeVerb.ar(sig, mix: rev_mix, room: rev_room)*amp;
		Out.ar(out, sig);
	}).add;

	SynthDef(\playbuf_kal, {
		arg amp = 1.5, out = 0, buf, rate = 1, t_trig = 1, start=0, atk=2, rel = 2, done_act = 2, rev_mix = 0.25, rev_room = 0.4;
		var sig, env;
		sig = PlayBuf.ar(2, buf, rate * BufRateScale.kr(buf), t_trig, start, doneAction:done_act);
		env = EnvGen.kr(Env.new([0.1,1,0], [atk, rel], [1, -1]), t_trig, doneAction:done_act);
		sig = sig*env;
		sig = FreeVerb.ar(sig, mix: rev_mix, room: rev_room)*amp;

		Out.ar(out, sig);
	}).add;

	//synthdef for the drum sounds
	SynthDef(\playbuf_drum, {
		arg amp = 1, out = 0, buf, rate = 1, t_trig, start=0, rel = 1, da = 2;
		var sig, env;
		sig = PlayBuf.ar(2, buf, rate * BufRateScale.kr(buf), t_trig, start, doneAction: da);
		env = EnvGen.kr(Env.new([0,1,0], [0, rel], [1,-1]), doneAction:2);
		sig = sig*env;
		sig = FreeVerb.ar(sig, mix:0.5, room:0.7)*amp;
		Out.ar(out, sig);
	}).add;

	//******************* SYNTHDEF: BASS *********************

	SynthDef.new(\bass, {
		arg freq=440, amp = 1;
		var sig, env, oscfreq;
		env = SinOsc.kr([0.1,1,1,0]).range(0.05,0.2);
		//env = LFNoise2.kr(500);
		oscfreq = {freq * LFNoise2.kr(0.5).range(0.99, 1.01)};
		sig = SinOsc.ar([oscfreq, 0, 10, 100]);
		sig = sig * env * amp;
		sig = FreeVerb.ar(sig, room:0.7);
		Out.ar(0, Mix.new(sig)*0.5);
	}).add;


	//******************** DRUMS **************************


	//Imported drum files

	~tom = Buffer.read(s, "drums/tom.wav", 0, s.sampleRate*1);
	~low = Buffer.read(s, "drums/b-low.wav", 0, s.sampleRate*1);
	~high = Buffer.read(s, "drums/high-hit.wav", 0, s.sampleRate*1);
	~mid = Buffer.read(s, "drums/mid-kenkeni.wav", 0, s.sampleRate*1);
	~snap = Buffer.read(s, "drums/b-snap.wav", 0, s.sampleRate*1);


	//************* SEQUENCING: RHYTHM ********************


	~drum_A = Pdef(
		\rhythmA,
		Pbind(
			\instrument, \playbuf_drum,
			\dur, Pseq([1/4], inf),
			\stretch, 60/120 * 4,
			\buf, Pseq(
				[
					~low,
					Pwrand([~low, ~tom], [0.6, 0.4], 2),
					~high,
				], inf
			),
			\rate, Pexprand(1, 1.05, inf),
			\amp, Pseq([0.8, Pexprand(0.005,0.6,2), 0.6], inf),
		);
	).play(quant: 1.875);

	~drum_B = Pdef(
		\rhythmB,
		Pbind(
			\instrument, \playbuf_drum,
			\dur, Pseq([1/8], inf),
			\stretch, 60/120 * 4,
			//\buf, Pwrand([~low, ~high, ~mid],[0.25, 0.6, 0.15], inf),
			\buf, Pseq(
				[
					~tom,
					Pwrand([~low, ~mid, ~high], [0.25,0.6,0.15], 7),
					~high,
					Pwrand([~tom, ~mid, ~high], [0.25,0.25,0.5], 7),
				], inf
			),
			\rate, Pexprand(1, 1.05, inf),
			\amp, Pseq([0.9, Pexprand(0.1,0.5,7)], inf),
		);
	).stop;


	~drum_C = Pdef(
		\rhythmC,
		Pbind(
			\instrument, \playbuf_drum,
			\dur, Pseq([1/8], inf),
			\stretch, 60/120 * 4,
			\buf, Pwrand([~low, ~mid],[0.6, 0.4], inf),
			\rate, Pexprand(0.7, 1.05, inf),
			\amp, Pexprand(0.2,0.5, inf),
		);
	).stop;

	//************* SEQUENCING: KALIMBA ********************

	~kalimba_A = Pbind(
		\instrument, \playbuf_kal,
		\dur, Pwrand([0.5, 0.25], [0.3, 0.7], inf),
		\stretch, 60/120 * 2,
		//\buf, Pwrand([~low, ~high, ~mid],[0.25, 0.6, 0.15], inf),
		\buf, Pseq(
			[
				Pwrand([~k_c1, ~k_f0], [0.7, 0.3], inf),
				Pwrand([~k_short_a, ~k_short_c], [0.6,0.4], inf),
				Pwrand([~k_f1, ~k_c1], [0.6, 0.4], inf),
			], inf
		),
		\amp, Pseq([1.5, Pexprand(0.2,1,2), 1.5], inf),
		\rate, Prand([1, 2/3, 3/2, 4/3, 5/4], inf);

	).play(quant: 1.875);

	~kalimba_B = Pbind(
		\instrument, \playbuf_kal,
		\dur, Pseq([0.125*3/2, 0.125*3/2, 0.625], inf),
		\stretch, 60/120 * 2,
		//\buf, Pwrand([~low, ~high, ~mid],[0.25, 0.6, 0.15], inf),
		\buf, Pseq(
			[
				Pwrand([~k_c1, ~k_f0], [0.7, 0.3], inf),
				Pwrand([~k_short_a, ~k_short_c], [0.6,0.4], inf),
				Pwrand([~k_f1, ~k_c1], [0.6, 0.4], inf),
			], inf
		),
		\amp, Pseq([1.5, Pexprand(0.2,1,2), 1.5], inf),
		\rate, Pseq(
			[
				Prand([1, 2/3], inf),
				Prand([1, 4/3], inf),
				1,
			], inf
		),
	).play(quant: 1.875);

	~kalimba_C = Pbind(
		\instrument, \playbuf_kal,
		\dur, Pseq([0.1875, 0.1875, 0.1875, 0.1875, 0.125, 0.125], inf),
		\stretch, 60/120 * 4,
		//\buf, Pwrand([~low, ~high, ~mid],[0.25, 0.6, 0.15], inf),
		\buf, Pseq(
			[
				Pwrand([~k_f0, ~k_c0], [0.4, 0.6], 4),
				Pseq([~k_short_c], 2),
			], inf
		),
		\amp, Pseq([1.5, Pexprand(0.2,1,2), 1.5], inf),
		\rate, Pseq(
			[
				Prand([1, 8/7], 4),
				Prand([1, 8/7], 2),
			], inf
		),
	).play(quant: 1.875);

	~toneA1 = Pdef(
		\sinetone1,
		Pbind(
			\instrument, \sine,
			\dur, Pseq([0.5, 0.25, 0.25], inf),
			//\freq, Prand([330, 247, 277, 370, 220], inf).trace,
			\freq, Prand([57, 59, 62, 64, 67].midicps, inf),
			\atk, Pwhite(0.0, 0.005, inf),
			\rel, Pwhite(0.2, 0.4, inf),
			\harmonic, Pexprand(1, 20, inf).round,
			\amp, Pexprand(0.2, 0.5, inf),
			);
	).stop;

	//******************* OSC ************************

	n = NetAddr.new("127.0.0.1", 57120);

	// OSC START

	~osc_start = OSCdef("start",
		{
			arg msg, time, addr, port;
			("OSC start:" + msg[1]).postln;
			if(msg[1]==1,{
				~wind = Synth.new(\wind);
				~crick_birds_buf = Synth.new(\playbuf_loop, [\buf, ~bg_crickets_birds.bufnum, \loop, 1, \amp, 0.05]);
				~eleph_buf = Synth.new(\playbuf, [\buf, ~elephant.bufnum, \rel, 2, \amp, 0.3]);
				~bass1 = Synth(\bass, [\freq, 174, \amp, 0.3]);
				~bass2 = Synth(\bass, [\freq, 260, \amp, 0.3]);

				~drum_A.play(quant: 1.875)

				//~lotar_buf = Synth.new(\playbuf_loop, [\buf, ~bg_lotar.bufnum, \loop, 1, \amp, 0.5]);

			});

		},
		'/OSCstart'
	);


	// OSC EVENTS: DISCRETE EVENTS

	~osc_events = OSCdef("Discrete events",
		{
			arg msg, time, addr, port;
			("Discrete event:" + msg[0]).postln;
			if(msg[1]==1,{
				~birds_buf = Synth.new(\playbuf, [\buf, ~birds.bufnum, \rate, 1.3, \rel, 4, \done_act, 2, \amp, 0.8]);
				~scream_buf = Synth.new(\playbuf, [\buf, ~scream.bufnum, \rate, 1.1, \rel, 3, \done_act, 2, \amp, 0.4]);
				~didg_buf = Synth.new(\playbuf, [\buf, ~didgeridoo.bufnum, \rate, 1.3, \rel, 3, \done_act, 2, \amp, 0.8]);

				~flute_rnd_buf = Synth.new(\playbuf, [\buf, ~flute_rnd.bufnum, \rate, 1.2, \rel, 4, \done_act, 2, \amp, 6]);

				~eleph_buf.set(\t_trig, 1, \start, [0,2].choose*s.sampleRate, \amp, 0.3);

			});

		},
		'/IP1/shaken'
	);

	~osc_stickmen = OSCdef("Stickmen",
		{
			arg msg, time, addr, port;
			("Stickmen:" + msg[0]).postln;
			if(msg[1]==1,{
				~scream_buf = Synth.new(\playbuf, [\buf, ~scream.bufnum, \rate, 0.8, \rel, 3, \done_act, 2, \amp, 0.3]);
			});

		},
		'/stickmen/jumped'
	);

	//FOR LATER: MAP THE LIGHT TO VOLUME
	~osc_light = OSCdef("IP1 light",
		{
			arg msg, time, addr, port;
			("IP1 light:" + msg[1]).postln;
			if(msg[1]<0.05, {
				Synth(\playbuf_drum).set(\amp, 0);
				~patternA.resume;
				"The sound stops".postln},
			{//wobble.set(\gain, 1)
			});
		},
		'/light'
	);

	~osc_pattern_1 = OSCdef("Pattern 1",
		{
			arg msg, time, addr, port;
			//("pattern 1:" + msg[1]).postln;
			if(msg[1]== 'Pattern A',{
				~drum_A.play(quant: 1.875);
				~drum_B.stop;
				~drum_C.stop;
			});
			if(msg[1]=='Pattern B', {
				~drum_B.play(quant: 1.875);
				~drum_A.stop;
				~drum_C.stop;
			});
			if(msg[1]=='Pattern C', {
				~drum_C.play(quant: 1.875);
				~drum_A.stop;
				~drum_B.stop;
			});
		},
		'/IP1/pattern'
	);



	// OSC EVENTS: SHAKERS

	~osc_shaker1 = OSCdef("IP1 shaker",
		{
			arg msg, time, addr, port;
			("IP1 shaken:" + msg[0]).postln;
			if(msg[1]==1,{
				~rain_buf = Synth.new(\playbuf, [\buf, ~rain.bufnum, \rate, 1.2, \rel, 2, \done_act, 2, \amp, 3]);
			});

		},
		'/IP1/shaken'
	);


	~osc_shaker2 = OSCdef("IP2 shaker",
		{
			arg msg, time, addr, port;
			("IP2 shaken:" + msg[1]).postln;
			if(msg[1]==1,{
				~rattle_buf = Synth.new(\playbuf, [\buf, ~rattle.bufnum, \rate, 1.5, \rel, 2, \done_act, 2]);
			});

		},
		'/IP2/shaken'
	);

	~osc_shaker3 = OSCdef("IP3 shaker",
		{
			arg msg, time, addr, port;
			("IP3 shaken:" + msg[1]).postln;
			if(msg[1]==1,{
				~nut_buf = Synth.new(\playbuf, [\buf, ~nut.bufnum, \rate, 1, \rel, 2, \done_act, 2]);
			});

		},
		'/IP3/shaken'
	);


}))




//OSCdef.freeAll
//s.freeAll