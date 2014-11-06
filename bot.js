/* Modules */
var IRC = require("irc");
var Sandbox = require("sandbox");
var Bf = require("./bf.js");

/* Settings */
var settings = require("./config.js");
const default_limit = settings.console.lines_limit;
const max_limit = settings.console.max_limit;

/* Body */
function command(str){
    return (settings.command.prefix + settings.command[str]);
}


function output_help(channel){
    bot.say(channel, "Script eval bot - syntax: [" + command("eval_js") + "|" + command("eval_bf") + "][.linelimit<=" + max_limit + "] [script] // ',' in BF is not supported");
}


function handle_message(nick, channel, message){
    var message = message.split(' ');
    var head = message.shift().split('.');
    
    /* Lines Limit */
    var lines_limit = default_limit;
    if(head[1]){
	lines_limit = Number(head[1]);
	lines_limit = (lines_limit>0 && lines_limit<=max_limit)? lines_limit: max_limit;
    }

    /* Commands */
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
		bot.say(channel, output.result+'');
		/* Console Logs */
		var console = output.console
		for(var i=0; i<console.length; i++){
		    /* Cut at Limited Line */
		    if(i == lines_limit){
			bot.say(channel, "Cut at line " + lines_limit);
			break;
		    }
		    bot.say(channel, console[i]+'');
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
		result = Bf.eval(code).split('\n');
	    } catch(err){
		result = [];
		result[0] = err;
	    }
	    for(var i=0; i<result.length; i++){
		if(i == lines_limit){
		    bot.say(channel, "Cut at line " + lines_limit);
		    break;
		}
		bot.say(channel, result[i]+'');
	    }
	    /* Note: Repeated Part to be Merged */
	}else{
	    output_help(channel);
	}
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
