const fs = require('fs');

let input_args = process.argv.slice(2);

let input_path = input_args[0];
let json_string = fs.readFileSync(input_path).toString();
let obj = JSON.parse(json_string);

let default_expiration = input_args[2];

let input_path_exp = input_args[1];
let json_string_exp = fs.readFileSync(input_path_exp).toString();
let obj_exp = JSON.parse(json_string_exp);


for (let fl = 0; fl < obj.flows.length; fl++) {
    if (obj.flows[fl].name in obj_exp){
        obj.flows[fl].expire_after_minutes = parseInt(obj_exp[obj.flows[fl].name]);
        if (obj.flows[fl].hasOwnProperty("metadata") && obj.flows[fl].metadata.hasOwnProperty("expires")){
            obj.flows[fl].metadata.expires = parseInt(obj_exp[obj.flows[fl].name]);
        }
    } else {
        obj.flows[fl].expire_after_minutes = parseInt(default_expiration);
        if (obj.flows[fl].hasOwnProperty("metadata") && obj.flows[fl].metadata.hasOwnProperty("expires")){
            obj.flows[fl].metadata.expires =  parseInt(default_expiration);
        }
    }
    
};

let new_flows = JSON.stringify(obj, null, 2);

let output_path = input_args[3];
fs.writeFile(output_path, new_flows, function (err, result) {
    if (err) console.log('error', err);
 });
