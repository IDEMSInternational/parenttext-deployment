var fs = require('fs');


let input_args = process.argv.slice(2);

let input_path = input_args[0];
var json_string = fs.readFileSync(input_path).toString();
var obj = JSON.parse(json_string);

// var count = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];

var exceptions = ["no", "prefer not to say", "prefer not to answer", "prefer not to tell", "i prefer not to tell", "does not apply", "go back to the previous options"];

var curr_quick_replies;
var curr_act;
var arg_list;
var r_exp;
var arg;
var new_test = "";
var quick_reply;

var debug ="";

for (var fl = 0; fl < obj.flows.length; fl++) {
    debug = debug +"\n\n" + obj.flows[fl].name + "*************************************"+"\n";
    for (var nd = 0; nd < obj.flows[fl].nodes.length; nd++) {
        for (var ac = 0; ac < obj.flows[fl].nodes[nd].actions.length; ac++) {
            curr_act = obj.flows[fl].nodes[nd].actions[ac];
            if (curr_act.type == "send_msg") {
                if (curr_act.quick_replies.length > 0) {
                    
                    obj.flows[fl].nodes[nd].actions[ac].text = obj.flows[fl].nodes[nd].actions[ac].text + "\n\n" + "Please select the number for the following options:";
                    
                    var selectors = [];
                    for (qr = 0; qr < curr_act.quick_replies.length; qr++) {
                        // letters
                        //obj.flows[fl].nodes[nd].actions[ac].text = obj.flows[fl].nodes[nd].actions[ac].text + "\n" + count[qr] + ". " + curr_act.quick_replies[qr];

                        // decreasing numbers
                        //selectors.push(curr_act.quick_replies.length - qr -1);

                        //increasing numbers with 0s
                        if (qr == curr_act.quick_replies.length-1){
                            if (qr == 9 || exceptions.includes(curr_act.quick_replies[qr].toLowerCase().trim())){
                                selectors.push(0)
                            } else {
                                selectors.push(qr+1);
                            }
                        } else {
                            selectors.push(qr+1);
                        }


                        obj.flows[fl].nodes[nd].actions[ac].text = obj.flows[fl].nodes[nd].actions[ac].text + "\n" + selectors[qr] + ". " + curr_act.quick_replies[qr];

                    }
                    curr_quick_replies = obj.flows[fl].nodes[nd].actions[ac].quick_replies;
                    obj.flows[fl].nodes[nd].actions[ac].quick_replies = [];
                    dest_id = obj.flows[fl].nodes[nd].exits[0].destination_uuid;

                    
                    debug = debug + obj.flows[fl].nodes[nd].actions[ac].text  + "\n";

                    for (var j = 0; j < obj.flows[fl].nodes.length; j++) {
                        if (obj.flows[fl].nodes[j].uuid == dest_id) {
                            if (obj.flows[fl].nodes[j].hasOwnProperty('router')) {
                                if (obj.flows[fl].nodes[j].router.operand == "@input.text") {
                                    for (var c = 0; c < obj.flows[fl].nodes[j].router.cases.length; c++) {
                                        if (obj.flows[fl].nodes[j].router.cases[c].type == "has_any_word") {
                                            
                                        
                                            arg_list = obj.flows[fl].nodes[j].router.cases[c].arguments[0].split(/[\s,]+/).filter(function(i){return i});
                                            old_test = arg_list.join(",")+ ",";
                                            new_test = arg_list.join(",")+ ",";
                                            
                                            debug = debug + "arg list: " + arg_list + "\n";
                                            for (var ar = 0; ar < arg_list.length; ar++) {

                                                arg = arg_list[ar];
                                                debug = debug + "arg: " + arg + "\n";
                                                r_exp = new RegExp(`\\b${arg}\\b`, "i");

                                                for (var qr = 0; qr < curr_quick_replies.length; qr++) {
                                                    quick_reply = curr_quick_replies[qr];

                                                    if (r_exp.test(quick_reply)) {
                                                        // new_test = new_test + count[qr] + ",";
                                                        new_test = new_test + selectors[qr] + ",";
                                                        debug = debug + new_test + "\n";
                                                    }
                                                }
                                            }
                                           
                                            if (new_test == old_test){
                                                //console.log("no match"+ obj.flows[fl].name)
                                                debug = debug + "NO MATCH " +"\n";
                                            }
                                            else {
                                            obj.flows[fl].nodes[j].router.cases[c].arguments = [new_test];
                                            new_test = "";
                                           
                                             }

                                        }
                                        else if (obj.flows[fl].nodes[j].router.cases[c].type == "has_all_words") {

                                            arg_list = obj.flows[fl].nodes[j].router.cases[c].arguments[0].split(/[\s,]+/).filter(function(i){return i});;
                                            new_test = "";
                                            for (qr = 0; qr < curr_quick_replies.length; qr++) {
                                                quick_reply = curr_quick_replies[qr];
                                                var match_all = arg_list.every(function (word) {

                                                    r_exp = new RegExp(word, "i");
                                                    return r_exp.test(quick_reply)

                                                });

                                                if (match_all) {
                                                    // new_test = new_test + count[qr] + ",";
                                                    new_test = new_test + selectors[qr] + ",";


                                                }



                                            }
                                            if (new_test == ""){
                                                //console.log("no match"+ obj.flows[fl].name)
                                                debug = debug + "NO MATCH " +"\n";
                                            }
                                            else {
                                            obj.flows[fl].nodes[j].router.cases[c].arguments = [new_test];
                                            new_test = "";
                                            }
                                        }
                                        else if (obj.flows[fl].nodes[j].router.cases[c].type == "has_phrase") {
                                            arg = obj.flows[fl].nodes[j].router.cases[c].arguments[0];

                                            for (var qr = 0; qr < curr_quick_replies.length; qr++) {
                                                quick_reply = curr_quick_replies[qr];

                                                r_exp = new RegExp(arg, "i");


                                                if (r_exp.test(quick_reply)) {

                                                    //new_test = new_test + count[qr] + ",";
                                                    new_test = new_test + selectors[qr]+ ",";

                                                }



                                            }
                                            
                                            if (new_test == ""){
                                                //console.log("no match"+ obj.flows[fl].name)
                                            }
                                            else {
                                            obj.flows[fl].nodes[j].router.cases[c].arguments = [new_test];
                                            new_test = "";
                                            
                                            }


                                        }
                                        else if (obj.flows[fl].nodes[j].router.cases[c].type == "has_only_phrase") {
                                            arg = obj.flows[fl].nodes[j].router.cases[c].arguments[0];
                                            debug = debug + "arg: " + arg + "\n";
                                            new_test ="";
                                            for (var qr = 0; qr < curr_quick_replies.length; qr++) {
                                                quick_reply = curr_quick_replies[qr];

                                                if (quick_reply.toLowerCase().trim() == arg.toLowerCase().trim()) {
                                                    //new_test = new_test + count[qr] + ",";
                                                    new_test = new_test + selectors[qr]+ ",";
                                                    debug = debug + new_test + "\n";

                                                }



                                            }
                                            if (new_test == ""){
                                                debug = debug + "NO MATCH " +"\n";
                                                //console.log("no match"+ obj.flows[fl].name)
                                                

                                            }
                                            else {
                                            obj.flows[fl].nodes[j].router.cases[c].arguments = [new_test];
                                            new_test = "";
                                            }

                                        }



                                        obj.flows[fl].nodes[j].router.cases[c].type = "has_any_word";

                                    }

                                }






                            }

                            break;
                        }
                    }
                }
            }


        }
    }

}
let new_flows = JSON.stringify(obj, null, 2);

let output_path = input_args[1];

fs.writeFile(output_path, new_flows, function (err, result) {
    if (err) console.log('error', err);
});


let output_path_debug = input_args[2];
fs.writeFile(output_path_debug, debug, function (err, result) {
    if (err) console.log('error', err);
});