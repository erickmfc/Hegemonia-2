/// @description Ataque naval coordenado da IA
/// @param {real} _ia_id ID da IA

function scr_ia_atacar_naval(_ia_id) {
    var _ia = _ia_id;
    
    // === ENCONTRAR ALVOS NAVAIS INIMIGOS ===
    var _alvos_navais = ds_list_create();
    
    // Procurar navios inimigos do jogador
    var _tipos_navais = [
        obj_lancha_patrulha,
        obj_navio_base,
        obj_submarino_base,
        obj_navio_transporte,
        obj_Constellation,
        obj_Independence,
        obj_RonaldReagan
    ];
    
    // Verificar se obj_fragata existe antes de adicionar
    var _obj_fragata = asset_get_index("obj_fragata");
    if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object) {
        array_push(_tipos_navais, _obj_fragata);
    }
    
    for (var i = 0; i < array_length(_tipos_navais); i++) {
        var _navio_tipo = _tipos_navais[i];
        if (!object_exists(_navio_tipo)) continue;
        
        with (_navio_tipo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                if (_dist <= _ia.raio_expansao * 1.5) { // Alcance naval maior
                    ds_list_add(_alvos_navais, {
                        id: id,
                        tipo: "naval",
                        distancia: _dist
                    });
                }
            }
        }
    }
    
    // === ESCOLHER ALVO NAVAL ===
    var _alvo_naval = noone;
    var _menor_distancia = 999999;
    
    for (var i = 0; i < ds_list_size(_alvos_navais); i++) {
        var _alvo_data = ds_list_find_value(_alvos_navais, i);
        if (instance_exists(_alvo_data.id)) {
            if (_alvo_data.distancia < _menor_distancia) {
                _menor_distancia = _alvo_data.distancia;
                _alvo_naval = _alvo_data.id;
            }
        }
    }
    
    // === COMANDAR NAVIOS DA IA ===
    if (instance_exists(_alvo_naval)) {
        // ✅ Ativar squad antes de atacar
        scr_activate_enemy_squad(_alvo_naval.x, _alvo_naval.y, 1500);
        
        var _navios_comandados = 0;
        var _navios_ia = [
            obj_lancha_patrulha,
            obj_navio_base,
            obj_submarino_base
        ];
        
        // ✅ CORREÇÃO: Reutilizar _obj_fragata já declarado acima
        // Verificar se obj_fragata existe antes de adicionar
        if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object) {
            array_push(_navios_ia, _obj_fragata);
        }
        
        for (var i = 0; i < array_length(_navios_ia); i++) {
            var _navio_tipo = _navios_ia[i];
            if (!object_exists(_navio_tipo)) continue;
            
            with (_navio_tipo) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    // Comandar navio para atacar
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_naval.x;
                        destino_y = _alvo_naval.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_naval;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    if (variable_instance_exists(id, "modo_combate")) {
                        modo_combate = "atacando";
                    }
                    _navios_comandados++;
                }
            }
        }
        
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("🌊 IA ATAQUE NAVAL! " + string(_navios_comandados) + " navios atacando alvo em (" + string(round(_alvo_naval.x)) + ", " + string(round(_alvo_naval.y)) + ")");
        }
    }
    
    ds_list_destroy(_alvos_navais);
    
    return instance_exists(_alvo_naval);
}
