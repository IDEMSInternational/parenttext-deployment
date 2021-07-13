var fs = require('fs');
let input_args = process.argv.slice(2);

let input_path = input_args[0];

let json_string = fs.readFileSync(input_path).toString();
let obj_full = JSON.parse(json_string);

let flow_dict = {};

obj_full.flows.forEach(flow => {flow_dict[flow.uuid] = flow.name});

obj_full.flows.forEach(flow =>{
    flow.nodes.forEach(node =>{
        if (node.actions.length>0 && node.actions[0].type == "enter_flow"){
            let fl_uuid = node.actions[0].flow.uuid;
            let fl_name = node.actions[0].flow.name;

            if (flow_dict[fl_uuid] != fl_name){
                node.actions[0].flow.name = fl_name;
            }
        }
    })
})

let updated_flows = JSON.stringify(obj_full, null, 2);

fs.writeFile(input_path, updated_flows, function (err, result) {
    if (err) console.log('error', err);
});