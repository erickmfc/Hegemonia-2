/// @description Ativa todas as unidades inimigas de um grupo/squad para ataque
/// @param {real} _center_x Centro X do grupo
/// @param {real} _center_y Centro Y do grupo
/// @param {real} _radius Raio de ativação (padrão: 1500 pixels)

function scr_activate_enemy_squad(_center_x, _center_y, _radius = 1500) {
    
    var _activated = 0;
    var _unit_types = [
        obj_infantaria,
        obj_tanque,
        obj_soldado_antiaereo,
        obj_blindado_antiaereo,
        obj_helicoptero_militar,
        obj_caca_f5,
        obj_f6,
        obj_f15,
        obj_c100,
        obj_lancha_patrulha,
        obj_navio_base,
        obj_submarino_base,
        obj_navio_transporte
    ];
    
    // Verificar se obj_fragata existe antes de adicionar
    var _obj_fragata = asset_get_index("obj_fragata");
    if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object) {
        array_push(_unit_types, _obj_fragata);
    }
    
    for (var i = 0; i < array_length(_unit_types); i++) {
        var _obj_type = _unit_types[i];
        
        if (!object_exists(_obj_type)) continue;
        
        with (_obj_type) {
            // Verificar se é unidade inimiga
            if (!scr_is_enemy_unit(id)) continue;
            
            // Verificar distância
            var _dist = point_distance(x, y, _center_x, _center_y);
            if (_dist > _radius) continue;
            
            // ✅ ATIVAR unidade
            instance_activate_object(id);
            
            // Remover modo standby se estiver
            if (variable_instance_exists(id, "standby_mode")) {
                standby_mode = false;
            }
            if (variable_instance_exists(id, "force_always_active")) {
                force_always_active = true; // Garantir que permaneça ativa
            }
            
            // Tornar visível
            if (variable_instance_exists(id, "visible")) {
                visible = true;
            }
            
            _activated++;
        }
    }
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("⚔️ SQUAD ATIVADO: " + string(_activated) + " unidades inimigas ativadas em (" + string(_center_x) + ", " + string(_center_y) + ")");
    }
    
    return _activated;
}
