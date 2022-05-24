// node idems-chatbot-repo/scripts/swap_localization_and_base.js "parenttext-jamaica-repo/flows/split_flows/nutrition_renamed_spanish.json" "eng" "spa" "parenttext-jamaica-repo/flows/split_flows/nutrition_renamed_english.json"


const fs = require('fs');

let input_args = process.argv.slice(2);

let input_path = input_args[0];
let lang_base = input_args[1];
let lang_loc = input_args[2];
let json_string = fs.readFileSync(input_path).toString();
let original_flows = JSON.parse(json_string);


original_flows.flows.forEach(fl => {
    console.log(fl.name)
    fl.nodes.forEach(nd => {
        if (nd.hasOwnProperty("actions")){
            nd.actions.forEach(ac =>{
                if (ac.type == "send_msg"){
                    if (fl.localization[lang_base].hasOwnProperty(ac.uuid)){
                       
                        let lang_msg = fl.localization[lang_base][ac.uuid].text[0];
                        fl.localization[lang_base][ac.uuid].text[0] = ac.text;
                        ac.text = lang_msg;

                        if (fl.localization[lang_base][ac.uuid].hasOwnProperty("quick_replies")){
                            for (let q=0; q<ac.quick_replies.length; q++){
                                let lang_qr = fl.localization[lang_base][ac.uuid].quick_replies[q];
                                fl.localization[lang_base][ac.uuid].quick_replies[q] = ac.quick_replies[q];
                                ac.quick_replies[q] = lang_qr;
                            }
                        }
                        
                    }
                }
            })
        } else if (nd.hasOwnProperty("router")){
            nd.router.cases.forEach(cs =>{
                if (fl.localization[lang_base].hasOwnProperty(cs.uuid)){
                    let lang_args = fl.localization[lang_base][cs.uuid].arguments;
                    fl.localization[lang_base][cs.uuid].arguments = cs.arguments;
                    cs.arguments = lang_args;
                }
            })
        }

        
    })
    delete Object.assign(fl.localization, {[lang_loc]: fl.localization[lang_base] })[lang_base];
});





new_flows = JSON.stringify(original_flows, null, 2);

let output_path = input_args[3];
fs.writeFile(output_path, new_flows, function (err, result) {
    if (err) console.log('error', err);
 });