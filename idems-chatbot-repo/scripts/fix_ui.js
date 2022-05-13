const fs = require('fs');

let input_args = process.argv.slice(2);

let input_path = input_args[0];
let json_string = fs.readFileSync(input_path).toString();
let obj = JSON.parse(json_string);


obj.flows.forEach(fl => {
    for (n_uuid in fl._ui.nodes){
        let ui_el = fl._ui.nodes[n_uuid];
        
        if (ui_el.hasOwnProperty('config') && ui_el.config && ui_el.config.hasOwnProperty('operand')){
            
            let split_node = fl.nodes.filter(n => (n.uuid == n_uuid))[0];
            let operand = split_node.router.operand.substring(1).split(".");
            let id = operand[1];
            let type = operand[0].substring(0, operand[0].length -1);
            let name = operand[1].replace(/_/g, " ");
            
            
            if (ui_el.config.operand.id != id){
                ui_el.config.operand.id = id;
                ui_el.config.operand.type = type;
                ui_el.config.operand.name = name;
                
            }
                       

        }
        
    }
});



let new_flows = JSON.stringify(obj, null, 2);

let output_path = input_args[1];
fs.writeFile(output_path, new_flows, function (err, result) {
    if (err) console.log('error', err);
 });
