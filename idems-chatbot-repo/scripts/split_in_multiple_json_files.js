const fs = require('fs');
const path = require('path')

let input_args = process.argv.slice(2);

let input_path = input_args[0];
let n_files = input_args[1];

let json_string = fs.readFileSync(input_path).toString();
let obj_full = JSON.parse(json_string);

let logfile = "";


let flow_dict = {};
obj_full.flows.forEach(flow => {flow_dict[flow.uuid] = flow.name});

let n_tot_flows = obj_full.flows.length;
//console.log(n_tot_flows)

let quot = Math.floor(n_tot_flows/n_files);
let batches = [];
let i = 0;

for (let start=0; start < n_tot_flows; start+= quot){
    batches.push(JSON.parse(json_string));
    if (n_tot_flows-start-quot >= quot){
        batches[i].flows = batches[i].flows.slice(start, start + quot);
        //console.log(batches[i].flows.length)
    }
    else{
        batches[i].flows = batches[i].flows.slice(start, n_tot_flows);
        //console.log(batches[i].flows.length)
        break
    }
    
   
    i++
    
}


//console.log(batches.length)

for (let i=0; i < n_files; i++){
    //remove triggers if the corresponding flow is not in the batch
    remove_triggers(batches[i]);

    //remove campaigns if the corresponding flow is not in the batch
    logfile += "\n  BATCH " + (i+1)
    remove_campaigns(batches[i]);

    //rename flow in enter flow nodes if the name is not up to date
    rename_flows(flow_dict,batches[i])
    let output_path = input_path.substring(0, input_path.length - 5) + "_" + (i+1) + ".json";
    let batch = JSON.stringify(batches[i], null, 2);
    
    fs.writeFile(output_path, batch, function (err, result) {
        if (err) console.log('error', err);
    });
}

let log_file_path = path.join(path.dirname(input_path),"split_json_log.txt");

fs.writeFile(log_file_path, logfile, function (err, result) {
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

function remove_campaigns(rapidpro_obj){
    let new_campaigns = [];
    rapidpro_obj.campaigns.forEach(campaign => {
        if (campaign.events.length == 0){
            new_campaigns.push(campaign)
        } else {
            let new_campaign =  JSON.parse(JSON.stringify(campaign, null, 2));
            new_campaign.events = [];
           for (let ev =0; ev < campaign.events.length; ev++){
               if (campaign.events[ev].event_type == "M" || (campaign.events[ev].event_type == "F" && rapidpro_obj.flows.filter(fl => (fl.name == campaign.events[ev].flow.name)).length > 0)){
                    new_campaign.events.push(campaign.events[ev]);
               } else {
                logfile += "\nfor campaign "+ campaign.name +" event removed of type: " + campaign.events[ev].event_type;
                   if (campaign.events[ev].event_type == "F"){
                    logfile += "\nflow not present " + campaign.events[ev].flow.name;
                   }
               }

           }
           if (new_campaign.events.length >0){
            new_campaigns.push(new_campaign)
           }
            
        } 
  
    });
    rapidpro_obj.campaigns = new_campaigns;
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