var fs = require('fs');
let input_args = process.argv.slice(2);

let input_path = input_args[0];
let output_path = input_args[1];

let json_string = fs.readFileSync(input_path).toString();
let obj_full = JSON.parse(json_string);

let flow_names = [];

obj_full.flows.forEach(flow => flow_names.push(flow.name) );

console.log(flow_names.length)
let names = JSON.stringify(flow_names, null, 2);

fs.writeFile(output_path, names, function (err, result) {
    if (err) console.log('error', err);
});