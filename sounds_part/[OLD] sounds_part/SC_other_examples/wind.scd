
(
Ndef(\noise2).set(\mFreq, [0.1, 8, \lin]);
Ndef(\noise2).set(\fFreq, [100, 4000, \exp]);
Ndef(\noise).set(\fRq, [0.01, 2, \lin]);

Ndef(\noise).fadeTime = 10;

Ndef(\noise2, {|mFreq = 0.1, fFreq = 1048, fRq = 0.5|

	var src, mod;

	mod = {LFNoise2.ar(mFreq).range(0, 1)}!6;

	src = WhiteNoise.ar(mod.lagud(1, 4));

	src = RLPF.ar(src, fFreq.lag(1), fRq);

	Splay.ar(src);

}).play;


)
