/// Strategic Dashboard - Alarm 0 Event
/// Dashboard Estratégico - Atualização Periódica (a cada 2 segundos)

// Update cached financial data
current_money = global.dinheiro;
current_population = global.populacao;

// Update tourists if exists
if (variable_global_exists("turistas")) {
    current_tourists = global.turistas;
}

// Update military if exists
if (variable_global_exists("militares_totais")) {
    current_military = global.militares_totais;
}

// Update ranking if exists
if (variable_global_exists("ranking_posicao")) {
    current_ranking = global.ranking_posicao;
}

// Update daily income if exists
if (variable_global_exists("renda_diaria")) {
    daily_income = global.renda_diaria;
}

// Update resource counts from global resource storage
if (variable_global_exists("estoque_recursos")) {
    // Count key resources
    var key_resources = ["Minério", "Petróleo", "Ouro", "Alumínio", "Cobre", "Lítio", "Titânio", "Urânio"];
    
    ds_map_clear(current_resources);
    
    for (var i = 0; i < array_length(key_resources); i++) {
        var resource_name = key_resources[i];
        if (ds_map_exists(global.estoque_recursos, resource_name)) {
            ds_map_add(current_resources, resource_name, global.estoque_recursos[? resource_name]);
        } else {
            ds_map_add(current_resources, resource_name, 0);
        }
    }
}

// Update research status
research_completed_count = 0;
research_active_count = 0;

if (variable_global_exists("nacao_recursos")) {
    var research_names = ["Aluminio", "Borracha", "Centro", "Cobre", "Litio", "Mina", "Ouro", "Petroleo", "Serraria", "Silicio", "Titanio", "Uranio"];
    
    for (var i = 0; i < array_length(research_names); i++) {
        var research_name = research_names[i];
        if (ds_map_exists(global.nacao_recursos, research_name)) {
            var status = global.nacao_recursos[? research_name];
            if (status == RESOURCE_STATUS.RESEARCHED) {
                research_completed_count++;
            } else if (status == RESOURCE_STATUS.RESEARCHING) {
                research_active_count++;
            }
        }
    }
    
    // DEBUG: Mostrar valores atualizados
    show_debug_message("Dashboard atualizado: " + string(research_completed_count) + " concluidas, " + string(research_active_count) + " ativas");
}

// Count total buildings (approximate)
total_buildings = instance_number(obj_mina) + instance_number(obj_serraria) + 
                 instance_number(obj_poco_petroleo) + instance_number(obj_mina_ouro) +
                 instance_number(obj_mina_aluminio) + instance_number(obj_mina_cobre) +
                 instance_number(obj_mina_litio) + instance_number(obj_mina_titanio) +
                 instance_number(obj_mina_uranio) + instance_number(obj_plantacao_borracha) +
                 instance_number(obj_extrator_silicio);

// Reset alarm for next update (2 seconds as per memory)
alarm[0] = game_get_speed(gamespeed_fps) * 2;