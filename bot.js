/* Modules */
var IRC = require("irc");
var Sandbox = require("sandbox")

/* Settings */
var settings = require("./config.js");
const default_limit = settings.console.lines_limit;
const max_limit = settings.console.max_limit;


/* Body */
function command(str){
    return (settings.command.prefix + settings.command[str]);
}


function output_help(channel){
    bot.say(channel, "Javascript eval bot - syntax: " + command("eval") + "[.linelimit<=" + max_limit + "] [script]");
}


function handle_message(nick, channel, message){
    var message = message.split(' ');
    var head = message.shift().split('.');

    /* Commands */
    if(head[0] == command("help")){
	output_help(channel);
    }else if(head[0] == command("eval")){
	/* Lines Limit */
	var lines_limit = default_limit;
	if(head[1]){
	    lines_limit = Number(head[1]);
	    lines_limit = (lines_limit>0 && lines_limit<=max_limit)? lines_limit: max_limit;
	}
	
	/* Eval */
	var code = message.join(" ");
	if(code){
	    /* Log to Console */
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
		    bot.say(channel, output.console[i]+'');
		}
	    });
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
    handle_message(nick, channel, message);
});
