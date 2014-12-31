exports.server = "irc.freenode.net";
exports.nick = "ProtonElectron";
//exports.nick = "Hydrogen_Debug";
exports.debug = true;
exports.options = {
    userName: "jsbot",
    realName: "jsbot",
    port: 6667,
    debug: false,
    showErrors: true,
    autoRejoin: true,
    autoConnect: true,
    channels: ["#linuxba"],
    secure: false,
    selfSigned: false,
    certExpired: false,
    floodProtection: true,
    floodProtectionDelay: 1000,
    sasl: false,
    stripColors: false,
    channelPrefixes: "&#",
    messageSplit: 512
}
exports.command = {
    prefix:'@',
    ping:"ping",
    help:"help",
    eval_js:"js",
    eval_bf:"bf",
    opencc:"opencc"
};
exports.console = {
    lines_limit: 3,
    max_limit: 10
};
exports.extra = {
    'opencc':{
	"enabled":true,
	"configs":['s2t',
		   't2s',
		   's2tw',
		   'tw2s',
		   's2hk',
		   'hk2s',
		   's2twp',
		   'tw2sp'
		  ]
    }
};

