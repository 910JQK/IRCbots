/* Modules */
var IRC = require("irc");
var Sandbox = require("sandbox");
var Bf = require("./bf.js");

/* Settings */
var settings = require("./config.js");
const default_limit = settings.console.lines_limit;
const max_limit = settings.console.max_limit;
const filter = new RegExp("[\\x00-\\x1F]", "g");

/* Extra Modules */
/* Note: Improve Implementation */
if(settings.extra["opencc"].enabled)
    var OpenCC = require("opencc");

/* Body */
function command(str){
    return (settings.command.prefix + settings.command[str]);
}


function output_help(channel){
    bot.say(channel, "Script eval bot - syntax: [" + command("eval_js") + "|" + command("eval_bf") + "][.linelimit<=" + max_limit + "] [script] // ',' in BF is not supported");
}


function handle_message(nick, channel, message){
    if(settings.banlist[nick])
	return;

    var message = message.split(' ');
    var head = message.shift().split('.');
    
    /* Lines Limit */
    var lines_limit = default_limit;
    if(head[1]){
	lines_limit = Number(head[1]);
	lines_limit = (lines_limit>0 && lines_limit<=max_limit)? lines_limit: max_limit;
    }

    /* Commands */
    /* Note: Improve Implementation */
    if(head[0] == command("help")){
	output_help(channel);
    }else if(head[0] == command("ping")){
	bot.say(channel, "pong");
    }else if(head[0] == command("eval_js")){
	/* Eval */
	var code = message.join(" ");
	if(code){
	    /* Log to Console */
	    if(settings.debug)
		console.log(nick + " => " + code);
	    /* Run Script */
	    sandbox.run(code, function(output){
		/* Return Result */
		var result;
		bot.say(channel, output.result);
		/* Console Logs */
		var console = output.console
		for(var i=0; i<console.length; i++){
		    /* Cut at Limited Line */
		    if(i == lines_limit){
			bot.say(channel, "Cut at line " + lines_limit);
			break;
		    }
		    result = (''+console[i]).replace(filter, "");
		    if(result)
			bot.say(channel, result);
		    else
			bot.say(channel, "Empty or non-printable");
		}
	    });
	}else {
	    output_help(channel);
	}
    }else if(head[0] == command("eval_bf")){
	var code = message.join(" ");
	if(settings.debug)
	    console.log(nick + " => " + code);
	if(code){
	    var result;
	    try {
		result = Bf.eval(code).replace(filter, "").split('\n');
		if(result.length == 1 && !result[0]){
		    bot.say(channel, "No output or non-printable");
		    return;
		}
	    } catch(err){
		result = [];
		result[0] = err;
	    }
	    for(var i=0; i<result.length; i++){
		if(i == lines_limit){
		    bot.say(channel, "Cut at line " + lines_limit);
		    break;
		}
		result[i] = result[i].replace(filter, "");
		if(result[i])
		    bot.say(channel, result[i]);
		else
		    bot.say(channel, "Empty or non-printable");
	    }
	    /* Note: Repeated Part to be Merged */
	}else{
	    output_help(channel);
	}
    }else if(head[0] == command("opencc") && OpenCC){
	var configs = settings.extra["opencc"].configs;
	var str = message.join(" ");
	var result = "";
	if(str){
	    var config = "t2s.json";
	    if(head[1])
		if(configs.indexOf(head[1]) != -1)
		    config = head[1] + ".json";
	    var opencc = new OpenCC(config);
	    result += opencc.convertSync(str);
	}else{
	    var i;
	    for(i=0; i<configs.length; i++)
		result += (configs[i] + " ");
	}
	bot.say(channel, result);
    }
}


/* Main Procedure */
sandbox = new Sandbox();
bot = new IRC.Client(settings.server, settings.nick, settings.options);
bot.addListener("message", function(nick, channel, message){
    if(channel.indexOf("#") != 0){
	channel = nick;
    }
    /*
    if(settings.debug)
	console.log("["+channel+"] "+nick+" => "+message);
    */
    handle_message(nick, channel, message);
});
