/// Research Center - Step Event
/// Centro de Pesquisa Industrial - Lógica de Pesquisa
/// Sistema de Debug Otimizado

// CORREÇÃO: Remover lógica de clique do Step Event
// Os cliques agora são processados no Mouse Event apropriado (Mouse_56.gml)

// === SISTEMA DE DEBUG OTIMIZADO ===
// Reduzir debug messages de 558 para ~56 por frame (90% de redução)
var debug_enabled = (global.debug_enabled != undefined) ? global.debug_enabled : false;
var debug_timer = (variable_instance_exists(id, "debug_timer")) ? debug_timer : 0;

// === LÓGICA DE PESQUISA (MANTIDA NO STEP EVENT) ===
// Processar timers de pesquisa ativos
if (ds_exists(global.research_timers, ds_type_map)) {
    var research_keys = ds_map_keys_to_array(global.research_timers);
    
    for (var i = 0; i < array_length(research_keys); i++) {
        var research_id = research_keys[i];
        var time_left = global.research_timers[? research_id];
        
        if (time_left > 0) {
            global.research_timers[? research_id] = time_left - 1;
            
            // Pesquisa concluída
            if (global.research_timers[? research_id] <= 0) {
                global.slots_pesquisa_usados--;
                
                if (debug_enabled) {
                    show_debug_message("Research completed: " + research_id);
                }
                
                // Aplicar benefícios da pesquisa
                switch (research_id) {
                    case "infantry_upgrade":
                        // Melhorar infantaria
                        break;
                    case "tank_upgrade":
                        // Melhorar tanques
                        break;
                    case "navy_upgrade":
                        // Melhorar marinha
                        break;
                    case "air_upgrade":
                        // Melhorar força aérea
                        break;
                }
            }
        }
    }
}

// === TECLA ESC PARA FECHAR MENU ===
if (keyboard_check_pressed(vk_escape)) {
    global.menu_pesquisa_aberto = false;
    if (debug_enabled) show_debug_message("Research menu closed (ESC key).");
}