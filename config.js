exports.server = "irc.freenode.net";
exports.nick = "ProtonElectron";
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
    eval:"js",
    help:"help"
};
exports.console = {
    lines_limit: 3,
    max_limit: 10
};
