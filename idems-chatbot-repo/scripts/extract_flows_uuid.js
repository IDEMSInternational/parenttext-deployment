/*
node .\idems-chatbot-repo\scripts\extract_flows_uuid.js ".\parenttext-international-repo\flows\GG-plh-international-flavour.json" ".\parenttext-international-repo\temp\flows_uuids.csv"
*/ 

var fs = require('fs');
var converter = require("json-2-csv");

let input_args = process.argv.slice(2);

let input_path = input_args[0];
var json_string = fs.readFileSync(input_path).toString();
var obj_full = JSON.parse(json_string);

async function outputFiles() {
    let rows = [];
    obj_full.flows.forEach(flow => {
        rows.push({
            "name": flow.name,
            "uuid": flow.uuid
        })

    });


    let output_path = input_args[1];
    let csvString = await converter.json2csvAsync(rows);
    fs.writeFileSync(output_path, csvString);
}

outputFiles().then(() => {
    console.log("I outputted the files");
});