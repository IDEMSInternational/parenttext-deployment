const fs = require('fs');

let input_args = process.argv.slice(2);

let input_path = input_args[0];
let new_flow_uuid = input_args[1];
let new_flow_name = input_args[2];
let json_string = fs.readFileSync(input_path).toString();
let obj = JSON.parse(json_string);


obj.triggers.filter(tr => (tr.trigger_type == "C"))[0].flow.uuid = new_flow_uuid;
obj.triggers.filter(tr => (tr.trigger_type == "C"))[0].flow.name = new_flow_name;
let new_flows = JSON.stringify(obj, null, 2);

let output_path = input_args[3];
fs.writeFile(output_path, new_flows, function (err, result) {
    if (err) console.log('error', err);
 });
