/// Research Center - Alarm 0 Event
/// Centro de Pesquisa Industrial - Processamento de Pesquisas

// Check if it's time for daily bonuses (every 24 hours game time)
if (!variable_global_exists("last_daily_bonus_time")) {
    global.last_daily_bonus_time = current_time;
}

// Calculate if 24 hours have passed (in milliseconds: 24 * 60 * 60 * 1000 = 86400000)
var daily_bonus_interval = 86400000; // 24 hours in milliseconds
var time_since_last_bonus = current_time - global.last_daily_bonus_time;

if (time_since_last_bonus >= daily_bonus_interval) {
    // Verificar se research_names existe e é válido
    if (!variable_instance_exists(id, "research_names")) {
        show_debug_message("ERRO: research_names não existe nesta instância!");
        alarm[0] = game_get_speed(gamespeed_fps) * 1;
        return;
    }
    
    if (!is_array(research_names)) {
        show_debug_message("ERRO: research_names não é um array válido!");
        alarm[0] = game_get_speed(gamespeed_fps) * 1;
        return;
    }
    
    // Process daily bonuses for completed researches
    for (var i = 0; i < array_length(research_names); i++) {
        var research_name = research_names[i];
        var status = global.nacao_recursos[? research_name];
        
        if (status == RESOURCE_STATUS.RESEARCHED) {
            // Give daily production bonuses for completed researches
            switch(research_name) {
                case "Aluminio":
                    if (ds_map_exists(global.estoque_recursos, "Alumínio")) {
                        global.estoque_recursos[? "Alumínio"] += 50;
                        show_debug_message("Daily Alumínio bonus: +50");
                    }
                    break;
                case "Borracha":
                    if (ds_map_exists(global.estoque_recursos, "Borracha")) {
                        global.estoque_recursos[? "Borracha"] += 50;
                        show_debug_message("Daily Borracha bonus: +50");
                    }
                    break;
                case "Centro":
                    global.dinheiro += global.renda_diaria;
                    show_debug_message("Daily Centro bonus: +$" + string(global.renda_diaria));
                    break;
                case "Cobre":
                    if (ds_map_exists(global.estoque_recursos, "Cobre")) {
                        global.estoque_recursos[? "Cobre"] += 50;
                        show_debug_message("Daily Cobre bonus: +50");
                    }
                    break;
                case "Litio":
                    if (ds_map_exists(global.estoque_recursos, "Lítio")) {
                        global.estoque_recursos[? "Lítio"] += 40;
                        show_debug_message("Daily Lítio bonus: +40");
                    }
                    break;
                case "Mina":
                    if (ds_map_exists(global.estoque_recursos, "Minério")) {
                        global.estoque_recursos[? "Minério"] += 100;
                        show_debug_message("Daily Mina bonus: +100 Minério");
                    }
                    break;
                case "Ouro":
                    if (ds_map_exists(global.estoque_recursos, "Ouro")) {
                        global.estoque_recursos[? "Ouro"] += 25;
                        show_debug_message("Daily Ouro bonus: +25");
                    }
                    break;
                case "Petroleo":
                    if (ds_map_exists(global.estoque_recursos, "Petróleo")) {
                        global.estoque_recursos[? "Petróleo"] += 60;
                        show_debug_message("Daily Petróleo bonus: +60");
                    }
                    break;
                case "Serraria":
                    if (ds_map_exists(global.estoque_recursos, "Madeira")) {
                        global.estoque_recursos[? "Madeira"] += 75;
                        show_debug_message("Daily Serraria bonus: +75 Madeira");
                    }
                    break;
                case "Silicio":
                    if (ds_map_exists(global.estoque_recursos, "Silício")) {
                        global.estoque_recursos[? "Silício"] += 45;
                        show_debug_message("Daily Silício bonus: +45");
                    }
                    break;
                case "Titanio":
                    if (ds_map_exists(global.estoque_recursos, "Titânio")) {
                        global.estoque_recursos[? "Titânio"] += 30;
                        show_debug_message("Daily Titânio bonus: +30");
                    }
                    break;
                case "Uranio":
                    if (ds_map_exists(global.estoque_recursos, "Urânio")) {
                        global.estoque_recursos[? "Urânio"] += 15;
                        show_debug_message("Daily Urânio bonus: +15");
                    }
                    break;
            }
        }
    }
    
    // Update the last bonus time
    global.last_daily_bonus_time = current_time;
    show_debug_message("Daily research bonuses processed!");
}

// Process all active researches
// Verificar se research_names existe e é válido
if (!variable_instance_exists(id, "research_names")) {
    show_debug_message("ERRO: research_names não existe nesta instância durante processamento!");
    alarm[0] = game_get_speed(gamespeed_fps) * 1;
    return;
}

if (!is_array(research_names)) {
    show_debug_message("ERRO: research_names não é um array válido durante processamento!");
    alarm[0] = game_get_speed(gamespeed_fps) * 1;
    return;
}

for (var i = 0; i < array_length(research_names); i++) {
    var research_name = research_names[i];
    var status = global.nacao_recursos[? research_name];
    
    if (status == RESOURCE_STATUS.RESEARCHING) {
        // Check if research timer exists
        if (ds_map_exists(global.research_timers, research_name)) {
            // Decrease timer
            var current_timer = global.research_timers[? research_name];
            current_timer -= game_get_speed(gamespeed_fps) * 1; // 1 second passed
            
            if (current_timer <= 0) {
                // Research completed!
                global.nacao_recursos[? research_name] = RESOURCE_STATUS.RESEARCHED;
                global.slots_pesquisa_usados--;
                ds_map_delete(global.research_timers, research_name);
                
                show_debug_message("Research completed: " + research_name);
                show_debug_message("Research slots now used: " + string(global.slots_pesquisa_usados) + "/" + string(global.slots_pesquisa_total));
                
                // Add initial resource bonus when research completes
                switch(research_name) {
                    case "Aluminio":
                        if (ds_map_exists(global.estoque_recursos, "Alumínio")) {
                            global.estoque_recursos[? "Alumínio"] += 100;
                        }
                        break;
                    case "Borracha":
                        if (ds_map_exists(global.estoque_recursos, "Borracha")) {
                            global.estoque_recursos[? "Borracha"] += 100;
                        }
                        break;
                    case "Centro":
                        // Special bonus: increase daily income
                        global.renda_diaria += 1000;
                        show_debug_message("Centro research bonus: +$1000 daily income");
                        break;
                    case "Cobre":
                        if (ds_map_exists(global.estoque_recursos, "Cobre")) {
                            global.estoque_recursos[? "Cobre"] += 100;
                        }
                        break;
                    case "Litio":
                        if (ds_map_exists(global.estoque_recursos, "Lítio")) {
                            global.estoque_recursos[? "Lítio"] += 100;
                        }
                        break;
                    case "Mina":
                        // Special bonus: increase mineral production
                        if (ds_map_exists(global.estoque_recursos, "Minério")) {
                            global.estoque_recursos[? "Minério"] += 200;
                        }
                        break;
                    case "Ouro":
                        if (ds_map_exists(global.estoque_recursos, "Ouro")) {
                            global.estoque_recursos[? "Ouro"] += 50;
                        }
                        break;
                    case "Petroleo":
                        if (ds_map_exists(global.estoque_recursos, "Petróleo")) {
                            global.estoque_recursos[? "Petróleo"] += 100;
                        }
                        break;
                    case "Serraria":
                        if (ds_map_exists(global.estoque_recursos, "Madeira")) {
                            global.estoque_recursos[? "Madeira"] += 150;
                        }
                        break;
                    case "Silicio":
                        if (ds_map_exists(global.estoque_recursos, "Silício")) {
                            global.estoque_recursos[? "Silício"] += 100;
                        }
                        break;
                    case "Titanio":
                        if (ds_map_exists(global.estoque_recursos, "Titânio")) {
                            global.estoque_recursos[? "Titânio"] += 75;
                        }
                        break;
                    case "Uranio":
                        if (ds_map_exists(global.estoque_recursos, "Urânio")) {
                            global.estoque_recursos[? "Urânio"] += 25;
                        }
                        break;
                }
                
            } else {
                // Update timer
                global.research_timers[? research_name] = current_timer;
            }
        }
    }
}

// Reset alarm for next check (every 1 second for testing)
alarm[0] = game_get_speed(gamespeed_fps) * 1;
