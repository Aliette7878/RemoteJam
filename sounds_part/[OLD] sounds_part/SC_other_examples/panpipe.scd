/*
* A test on creating a sampler for some beautiful pan pipe sound files
* recorded by timohanes (@ https://freesound.org/people/timohanes/packs/4159/ )
* and released under CC0.
*/

// first of all start the server
s.boot;

// the following dictionary will contain all information
// related to the instruments like:
// * sample buffers
// * corresponding MIDI notes
// * lowest MIDI of the recoded samples
~panflute_sampler = Dictionary.new();

// the path where the samples are stored
~sample_path = "C:/Users/andri/Desktop/POLIMI/[Polimi]IIIsemester/[Polimi]CPC/[CPC]Project/RemoteJam/RemoteJam/sounds_part/SC_other_examples/pan-pipe";
// following global contains a string which is contained in all the samples names
~file_name_body = "__timohanes__pan-pipe-";


// fill the dictionary with ordered data from the samples
(
var tmp_buffers;
var tmp_array;
var path;

// 1. load samples from a folder extracting only one channel from the stereo files
path = PathName(~sample_path);
path.entries.do{
	|item|
	tmp_buffers = tmp_buffers.add( Buffer.readChannel(s, item.fullPath, channels:1));

};


// 2. create an array of dictionaries
tmp_array = Array.newClear();

tmp_buffers.do{
	|item, index|
	var d = Dictionary.new;
	var string = PathName(item.path).fileNameWithoutExtension;
	var output = string.findRegexp("[abcdefgABCDEFG]#?[0123456789]");
	if( output.isEmpty.not, {
		var noteNameAll = output[0][1];
		var octNumber = noteNameAll.rotate(1)[0].asString.asInteger;
		var noteName = noteNameAll[0].asString;
		var isSharp = noteNameAll.contains("#"); // boolean
		//[noteNameAll, noteName, octNumber, isSharp].postln;
		var midiNumber = (octNumber +1) * 12;
		switch( noteName,
			"c", { midiNumber = midiNumber+0; },
			"d", { midiNumber = midiNumber+2; },
			"e", { midiNumber = midiNumber+4; },
			"f", { midiNumber = midiNumber+5; },
			"g", { midiNumber = midiNumber+7; },
			"a", { midiNumber = midiNumber+9; },
			"b", { midiNumber = midiNumber+11; },
		);
		if(isSharp, {midiNumber = midiNumber + 1;});
		[noteNameAll, noteName, isSharp, octNumber, midiNumber].postln;
		d.add(\midi -> midiNumber.asInteger);
		d.add(\note -> noteNameAll);
		d.add(\buffer -> item);
		tmp_array = tmp_array.add(d);
	},
	{
		output.postln;
	});
};

tmp_array.sortBy(\midi);

~panflute_sampler.put( "lowest_note", tmp_array[0][\midi] );
~panflute_sampler.put(   "buffers", Array.newClear() );
~panflute_sampler.put( "midinotes", Array.newClear() );

tmp_array.do{
	|item, index|
	[index, item.values].postln;
	~panflute_sampler.put( "buffers",   ~panflute_sampler.at("buffers").add(item[\buffer]) );
	~panflute_sampler.put( "midinotes", ~panflute_sampler.at("midinotes").add(item[\midi]) );
};
)

// print something to check if the dictionary has been
// succesfully created and filled with data
~panflute_sampler.at("lowest_note");
~panflute_sampler.at("buffers").do({|item| item.postln});
~panflute_sampler.at("midinotes").do({|item| item.postln});


// define some synth to play the samples

// SIMPLE PLAYER
// A synth to play the sample as it is.
(
SynthDef(\simple_player, {
	|
	out=0, amp=0.5, gate=1, buf, rate=1.0, pan=0.0,
	atk=0.01, dcy=0.2, sus=0.7, rel=0.1
	|
	var sig, env;
	env = EnvGen.ar(Env.adsr(atk, dcy, sus, rel), gate, doneAction:2);
	sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf)*rate, 1, doneAction:0);
	sig = sig * amp * env;
	sig = HPF.ar(sig, 400);
	sig = LeakDC.ar(sig);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)


// GRAIN PLAYER
// a synth to play buffers in a granular fashion
(
SynthDef(\grain_player, {
	|
	out=0, gate=1, amp=0.9, buf, rate=1, pan=0.0,
	atk=5, dcy=0.2, sus=0.7, rel=5
	|
    var sig, env;

	var density = LFNoise0.kr(25).range(1, 5);
	var trigger = Impulse.kr( density );
	var pos = 0.5 + TRand.kr(trigger, -0.35, 0.35);
	var length = 1 + TRand.kr(trigger, 0.25, 0.35);

	env = EnvGen.kr(Env.adsr(atk, dcy, sus, rel), gate, doneAction:2);

    sig = GrainBuf.ar(2,
		trigger,
		length,
		buf,
		rate,
		pos,
		2,
		pan: pan);

	sig = sig * amp * env;
	sig = HPF.ar(sig, 400);
	sig = LeakDC.ar(sig);
	Out.ar(out, sig);
}).add;
)


// HYBRID PLAYER
// A synth which make use of the initial section of the sample in order to get a sharper attack,
// then it moves automatically to the sustain section (made with a granular Ugen)
// to make the tail of the sound indipendent from the sample duration.
(
SynthDef(\hybrid_player, {
	|
	out=0, gate=1, amp=0.9, buf, rate=1, pan=0.0,
	atk=5, dcy=0.1, sus=0.7, rel=5
	|
    var sig, sig1, sig2, env;

	var density = LFNoise0.kr(25).range(1, 5);
	var trigger = Impulse.kr( density );
	var pos = 0.5 + TRand.kr(trigger, -0.35, 0.35);
	var length = 1 + TRand.kr(trigger, 0.25, 0.35);

	env = EnvGen.kr(Env.adsr(atk, dcy, sus, rel), gate, doneAction:2);

	sig1 = PlayBuf.ar(1, buf, BufRateScale.ir(buf)*rate, 1, doneAction:0);

    sig2 = GrainBuf.ar(2,
		trigger,
		length,
		buf,
		rate,
		pos,
		2,
		pan: 0);

	sig = SelectX.ar(Line.kr(0.0, 1.0, 0.2), [sig1, sig2]);

	sig = sig * amp * env;
	//sig = HPF.ar(sig, 400);
	sig = LeakDC.ar(sig);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)



// Play with these synths and samples using some Pbind.

(
Pbindef(\panflute_pattern,
	\index, Pfunc { |e| ((e.use{ ~midinote.()} - ~panflute_sampler.at("lowest_note")-1)/3).floor },
	\buf, Pindex(~panflute_sampler.at("buffers"), Pkey(\index)),
	\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~panflute_sampler.at("midinotes"), Pkey(\index))).midiratio,
	\instrument, Prand([\simple_player, \grain_player], inf),
	\scale, Scale.major,
	\octave, 4,
	\degree, Pseq([1,2,3,4,5,6,7,8]-1, inf),
	\amp, Pwhite(0.3, 0.5, inf),
	\dur, 1,
	\atk, 0.01,
	\rel, 0.1,
	\legato, 1,
	\out, 0,
	\pan, Pwhite(-0.2, 0.2, inf)
);
)

(
Pbindef(\panflute_pattern,
	\index, Pfunc { |e| ((e.use{ ~midinote.()} - ~panflute_sampler.at("lowest_note")-1)/3).floor },
	\buf, Pindex(~panflute_sampler.at("buffers"), Pkey(\index)),
	\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~panflute_sampler.at("midinotes"), Pkey(\index))).midiratio,
	\instrument, \hybrid_player,
	\scale, Scale.minor,
	\octave, 4,
	\degree, Pseq([0,1,2,3,4,5,6,7], inf),
	\amp, 0.3, //Pwhite(0.3, 0.5, inf),
	\dur, 10,
	\atk, 0.1,
	\dcy, 0.2,
	\sus, 0.7,
	\rel, 0.2,
	\legato, 1,
	\out, 0,
	\pan, Pwhite(-0.2, 0.2, inf)
);
)

(
Pbindef(\panflute_pattern,
	\index, Pfunc { |e| ((e.use{ ~midinote.()} - ~panflute_sampler.at("lowest_note")-1)/3).floor },
	\buf, Pindex(~panflute_sampler.at("buffers"), Pkey(\index)),
	\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~panflute_sampler.at("midinotes"), Pkey(\index))).midiratio,
	\instrument, \hybrid_player,
	\scale, Scale.minorPentatonic,
	\octave, Pwrand([2,3,4], [0.5,1,3].normalizeSum, inf),
	\degree, Prand([0,1,2,3,4,5,6,7], inf),
	\amp, Pwhite(0.3, 0.5, inf),
	\dur, Prand([0.25, 0.5, 1], inf),
	\atk, 0.1,
	\dcy, 0.2,
	\sus, 0.7,
	\rel, 0.2,
	\legato, 1,
	\out, 0,
	\pan, Pwhite(-0.2, 0.2, inf)
);
)

Pbindef(\panflute_pattern).play;
Pbindef(\panflute_pattern).stop;