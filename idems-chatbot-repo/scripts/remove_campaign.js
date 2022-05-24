const fs = require('fs');

let input_args = process.argv.slice(2);

let input_path = input_args[0];
let json_string = fs.readFileSync(input_path).toString();
let obj = JSON.parse(json_string);

let campaign_to_remove = input_args[1];


obj.campaigns = obj.campaigns.filter(cmp => (cmp.name != campaign_to_remove))


let new_flows = JSON.stringify(obj, null, 2);

let output_path = input_args[2];
fs.writeFile(output_path, new_flows, function (err, result) {
    if (err) console.log('error', err);
 });
