var fs = require('fs');

let input_args = process.argv.slice(2);

let input_path = input_args[0];

let filter_type = input_args[3]


let json_string = fs.readFileSync(input_path).toString();
let obj_full = JSON.parse(json_string);

//console.log(obj_full.flows.length)


let flow_dict = {};
obj_full.flows.forEach(flow => {flow_dict[flow.uuid] = flow.name});

let filtered_flows

if (filter_type == "-name"){
    let condition_list = fs.readFileSync(input_args[2]).toString();
    condition_list = JSON.parse(condition_list);
    filtered_flows = obj_full.flows.filter(fl => condition_list.includes(fl.name));
} else if (filter_type == "-prefix"){
    // string with ; separated values that needs to be translaformed into a list
    let condition_list = input_args[2].split(";");
    console.log(typeof condition_list)
    filtered_flows = obj_full.flows.filter(fl => (startsWithList(fl.name,condition_list)));
} else {
    error("filter type not recognised")
}



let obj_filtered = JSON.parse(JSON.stringify(obj_full))
obj_filtered.flows = filtered_flows;
console.log(obj_filtered.flows.length)

//remove triggers if the corresponding flow is not in the batch
remove_triggers(obj_filtered);
//rename flow in enter flow nodes if the name is not up to date
rename_flows(flow_dict,obj_filtered)

   

let output_path = input_args[1];
let batch = JSON.stringify(obj_filtered, null, 2);
    
fs.writeFile(output_path, batch, function (err, result) {
    if (err) console.log('error', err);
});



////////////////////////////////////////////////////////////

function startsWithList(name, list_starts){
    for (let pr = 0; pr< list_starts.length; pr++){
        if (name.startsWith(list_starts[pr])){
            return true
        }
    }    
    return false
}

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