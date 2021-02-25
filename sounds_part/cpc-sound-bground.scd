//s.boot

//Players: 1, 2, 3
//Patterns: A, B, C
//Levels: 1, 2

(
s.waitForBoot({

	//**************** INITIALIZATION *******************

	s.plotTree;

	//******************** WIND *************************


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

	~wind = Synth.new(\wind);

	//************** EXT FILES & BUFFERS ****************

	//File.getcwd  //to check what is the current working directory

	//Importing background sounds
	//~bg_wind = Buffer.read(s, "background/bg-soft-wind.wav", 0, -1);
	~bg_lotar= Buffer.read(s, "background/bg-lotar.wav", 0, -1);
	~bg_crickets = Buffer.read(s, "background/bg-crickets.wav", 0, -1);
	~bg_crickets_birds = Buffer.read(s, "background/bg-crickets_birds.wav", 0, s.sampleRate*25);

	//Importing other nature sounds
	~bg_lemur = Buffer.read(s, "background/bg-lemur.wav", 0, -1);
	~bg_elephant = Buffer.read(s, "background/bg-elephant.wav", 0, -1);


	//Importing people sounds
	~tawny_1 = Buffer.read(s, "people/tawny-1.wav", 0, -1);
	~tawny_2 = Buffer.read(s, "people/tawny-2.wav", 0, -1);
	~tawny_3 = Buffer.read(s, "people/tawny-3.wav", 0, -1);
	~owl = Buffer.read(s, "people/owl discrete.wav", 0, -1);
	~scream = Buffer.read(s, "people/scream_high.wav", 0, -1);

	//Importing birds sounds
	~birds = Buffer.read(s, "birds/birds.wav", 0, -1);
	~parrot = Buffer.read(s, "birds/grey-parrot.wav", 0, -1);


	//Importing shakers sounds
	~rain = Buffer.read(s, "shakers/rain-maker.wav", 0, s.sampleRate*4);
	~rattle = Buffer.read(s, "shakers/sandyrb.wav", 0, s.sampleRate*4);
	~nut = Buffer.read(s, "shakers/nut-shaker.wav", 0, s.sampleRate*4);


	//synthdef for the buffer sounds

	SynthDef(\playbuf, {
		arg amp = 1, out = 0, buf, rate = 1, t_trig = 1, start=0, rel = 2, done_act = 0, rev_mix = 0.25, rev_room = 0.15;
		var sig, env;
		sig = PlayBuf.ar(2, buf, rate * BufRateScale.kr(buf), t_trig, start, doneAction:done_act);
		env = EnvGen.kr(Env.new([0,1,0], [0.5, rel], [3, -1]), t_trig, doneAction:done_act);
		sig = sig*env;
		sig = FreeVerb.ar(sig, mix: rev_mix, room: rev_room)*amp;

		Out.ar(out, sig);
	}).add;


	//TO DO: INSERT RANDOM AMPLITUDE
	SynthDef(\playbuf_loop, {
		arg amp = 1, out = 0, buf, rate = 1, t_trig = 1, start=0, rel = 2, loop = 0, done_act = 0, rev_mix = 0.5, rev_room = 0.5;
		var sig, env;
		sig = PlayBuf.ar(2, buf, rate * BufRateScale.kr(buf), t_trig, start, loop, doneAction:done_act);
		env = EnvGen.kr(Env.new([0,1], [0.5]), t_trig, doneAction:done_act);
		sig = sig*env;
		sig = FreeVerb.ar(sig, mix: rev_mix, room: rev_room)*amp;
		Out.ar(out, sig);
	}).add;


	//Just to hear the sounds
	//~playbuf = Synth.new(\playbuf, [\buf, ~bg_wind.bufnum, \rate, 1, \rel, 25]);
	~crick_buf = Synth.new(\playbuf, [\buf, ~bg_crickets.bufnum, \rate, 1, \amp, 1, \rel, 25]);
	~crick_buf.set(\t_trig, 1, \start, ~bg_crickets.numFrames.rand);

	~crick_birds_buf = Synth.new(\playbuf_loop, [\buf, ~bg_crickets_birds.bufnum, \loop, 1, \amp, 0.05]);

	~lotar_buf = Synth.new(\playbuf_loop, [\buf, ~bg_lotar.bufnum, \loop, 1, \amp, 0.5]);


	~lemur_buf = Synth.new(\playbuf, [\buf, ~bg_lemur.bufnum, \rel, 5, \amp, 0.3]);
	~eleph_buf = Synth.new(\playbuf, [\buf, ~bg_elephant.bufnum, \rel, 2, \amp, 0.2]);
	~eleph_buf.set(\t_trig, 1, \start, [0,2].choose*s.sampleRate);


	~rain_buf = Synth.new(\playbuf, [\buf, ~rain.bufnum, \rate, 1.2, \rel, 2, \done_act, 2, \amp, 4]);
	~rattle_buf = Synth.new(\playbuf, [\buf, ~rattle.bufnum, \rate, 1.5, \rel, 2, \done_act, 2]);
	~nut_buf = Synth.new(\playbuf, [\buf, ~nut.bufnum, \rate, 1, \rel, 2, \done_act, 2]);


	//******************* SOUND DEF *********************


	//BASS
	SynthDef.new(\bass, {
		arg freq=440, amp = 1;
		var sig, env, oscfreq;
		env = SinOsc.kr([0.1,1,1,0]).range(0.05,0.2);
		//env = LFNoise2.kr(500);
		oscfreq = {freq * LFNoise2.kr(0.5).range(0.98, 1.02)};
		sig = SinOsc.ar([oscfreq, 0, 10, 100]);
		sig = sig * env * amp;
		sig = FreeVerb.ar(sig, room:0.7);
		Out.ar(0, Mix.new(sig)*0.5);
	}).add;

	~bass = Synth(\bass, [\freq, 200, \amp, 0.1]);


	//******************** DRUMS ************************

	//Imported drum files
	~low = Buffer.read(s, "drums/drum-sample-8.wav", 0, s.sampleRate*1);
	~high = Buffer.read(s, "drums/drum-sample-9.wav", 0, s.sampleRate*1);
	~mid = Buffer.read(s, "drums/kenkeni-drum.wav", 0, s.sampleRate*0.25);

	//synthdef for the drum sounds
	SynthDef(\playbuf_drum, {
		arg amp = 2, out = 0, buf, rate = 1, t_trig, start=0, rel = 0.5, loop = 0, da = 2;
		var sig, env;
		sig = PlayBuf.ar(2, buf, rate * BufRateScale.kr(buf), t_trig, start, loop, doneAction: da);
		env = EnvGen.kr(Env.new([0,1,0], [0, rel], [1,-1]), doneAction:2);
		sig = sig*env;
		sig = FreeVerb.ar(sig, mix:0.5)*amp;

		Out.ar(out, sig);
	}).add;


	//************* SEQUENCING: RHYTHM ********************

	~patternA = Pdef(
		\rhythmA,
		Pbind(
			\instrument, \playbuf_drum,
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
			\instrument, \playbuf_drum,
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
			\instrument, \playbuf_drum,
			\dur, Pseq([1/8], inf),
			\stretch, 60/120 * 4,
			\buf, Pwrand([~low, ~mid],[0.6, 0.4], inf),
			\rate, Pexprand(0.7, 1.05, inf),
			\amp, Pexprand(0.2,0.5, inf),
		);
	).play(quant: 1.875);


	//******************* OSC ************************

	n = NetAddr.new("127.0.0.1", 57120);



	// DISCRETE EVENTS: SHAKERS

	~osc_shaker1 = OSCdef("IP1 shaker",
		{
			arg msg, time, addr, port;
			("IP1 shaken:" + msg[1]).postln;
			if(msg[1]==1,{
				~rain_buf = Synth.new(\playbuf, [\buf, ~rain.bufnum, \rate, 1.2, \rel, 2.5, \done_act, 2, \amp, 4]);
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




//COOL THING: JURASSIC PARK THUMP
(
{ var nse, env, kic;
	kic = tanh(Ringz.ar(LPF.ar(Trig.ar(Impulse.ar(1.0),SampleDur.ir),1000),30,0.25,7).sin*2);
	env = Env.perc(0.05, 1, 1, -4);
	nse = BrownNoise.ar(2) + PinkNoise.ar(0.5)  * EnvGen.kr(env,Impulse.kr(1), doneAction: 2);

	nse = Mix.ar(BPF.ar(nse,[100,1200,80,40,20],MouseX.kr(0,1),[1,0.2,1,1,1]));
	nse = LPF.ar(nse + kic, MouseY.kr(100,1000))! 2

}.play
)


//OSCdef.freeAll
//s.freeAll