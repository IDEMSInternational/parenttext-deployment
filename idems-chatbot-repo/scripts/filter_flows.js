var fs = require('fs');

let input_args = process.argv.slice(2);

let input_path = input_args[0];
let prefix = input_args[2];


let json_string = fs.readFileSync(input_path).toString();
let obj_full = JSON.parse(json_string);

//console.log(obj_full.flows.length)


let flow_dict = {};
obj_full.flows.forEach(flow => {flow_dict[flow.uuid] = flow.name});

let filtered_flows
if (prefix){
    filtered_flows = obj_full.flows.filter(fl => (fl.name.startsWith(prefix) || fl.name.startsWith("PLH")));
} else {
    filtered_flows = obj_full.flows.filter(fl => (fl.name.startsWith("PLH")));
}


let obj_filtered = JSON.parse(JSON.stringify(obj_full))
obj_filtered.flows = filtered_flows;
//console.log(obj_filtered.flows.length)

//remove triggers if the corresponding flow is not in the batch
remove_triggers(obj_filtered);
//rename flow in enter flow nodes if the name is not up to date
rename_flows(flow_dict,obj_filtered)

   

let output_path = input_args[1];
let batch = JSON.stringify(obj_filtered, null, 2);
    
fs.writeFile(output_path, batch, function (err, result) {
    if (err) console.log('error', err);
});



function remove_triggers(rapidpro_obj){
    let new_triggers = [];
    rapidpro_obj.triggers.forEach(trigger => {
        let corresp_flow_uuid = trigger.flow.uuid;
        if (rapidpro_obj.flows.filter(fl => fl.uuid == corresp_flow_uuid).length >0){
            new_triggers.push(trigger)
        }
    rapidpro_obj.triggers = new_triggers;
        
    });
}

function rename_flows(flow_dict,obj_full){
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
}