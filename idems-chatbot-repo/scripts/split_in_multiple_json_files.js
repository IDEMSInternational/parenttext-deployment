var fs = require('fs');

let input_args = process.argv.slice(2);

let input_path = input_args[0];
var json_string = fs.readFileSync(input_path).toString();
var obj_full = JSON.parse(json_string);

var batch_1 = JSON.parse(json_string);
var batch_2 = JSON.parse(json_string);

let flow_dict = {};
obj_full.flows.forEach(flow => {flow_dict[flow.uuid] = flow.name});

let n_tot_flows = obj_full.flows.length;

let quot = Math.floor(n_tot_flows/2);

batch_1.flows = obj_full.flows.slice(0,quot)
batch_2.flows = obj_full.flows.slice(quot,n_tot_flows);


//remove triggers if the corresponding flow is not in the batch
remove_triggers(batch_1);
remove_triggers(batch_2);

//rename flow in enter flow nodes if the name is not up to date
rename_flows(flow_dict,batch_1)
rename_flows(flow_dict,batch_2)


let output_path_1 = input_path.substring(0, input_path.length - 5) + "_1" + ".json";
let output_path_2 = input_path.substring(0, input_path.length - 5)  + "_2" + ".json";

batch_1 = JSON.stringify(batch_1, null, 2);
batch_2 = JSON.stringify(batch_2, null, 2);

fs.writeFile(output_path_1, batch_1, function (err, result) {
    if (err) console.log('error', err);
});

fs.writeFile(output_path_2, batch_2, function (err, result) {
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