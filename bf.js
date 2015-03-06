/* Brainfvck Programming Language Interpreter */


const BUF_SIZE = 30000;
const LOOP_LIMIT = 10000;


function check(str){
    var stack = ['#'];
    var temp_map = {};
    var pair_map = {};
    var i;
    for(i=0; i<str.length; i++){
	if(str[i] == '['){
	    temp_map[stack.length] = i;
	    stack.push('[');
	}else if(str[i] == ']'){
	    if(stack[stack.length-1] == '['){
		stack.pop();
		pair_map[temp_map[stack.length]] = i;
		pair_map[i] = temp_map[stack.length];
	    }else{
		throw "Syntax Error: Missing '['";
	    }
	}else if(".+-<>".indexOf(str[i]) == -1){
	    throw "Syntax Error: Invalid character at #" + i;
	}
    }
    if(stack.length != 1)
	throw "Syntax Error: Missing ']'";
    return pair_map;
}


exports.eval = function(str){
    var buffer = new ArrayBuffer(BUF_SIZE);
    var data = new Uint8Array(buffer);
    var ptr = 0;
    var output = "";

    var pair_map = check(str);
    var loop_count = 0;

    var i = 0;
    while(i < str.length){
	switch(str[i]){
	case '+':
	    data[ptr]++;
	    break;
	case '-':
	    data[ptr]--;
	    break;
      	case '>':
	    ptr++;
	    if(ptr == BUF_SIZE) ptr = 0;
	    break;
	case '<':
	    ptr--;
	    if(ptr < 0) ptr = BUF_SIZE - 1;
	    break;
	case '.':
	    output += String.fromCharCode(data[ptr]);
	    break;
	case '[':
	    if(!data[ptr])
		i = pair_map[i];
	    break;
	case ']':
	    if(data[ptr]){
		i = pair_map[i];
		if(++loop_count > LOOP_LIMIT)
		    throw "Loop limit exceed";
	    }
	    break;
	}
	i++;
    }

    return output;
}
