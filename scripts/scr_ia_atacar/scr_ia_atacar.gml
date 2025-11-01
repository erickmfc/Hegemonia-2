/// @description Comandar unidades da IA para atacar inimigos (TERRESTRE + NAVAL + AÉREO)
/// @param _ia_id ID da IA

function scr_ia_atacar(_ia_id) {
    var _ia = _ia_id;
    
    if (!variable_global_exists("ia_dinheiro")) {
        show_debug_message("❌ ERRO: Recursos da IA não inicializados!");
        return;
    }
    
    // ✅ NOVO: Detectar tipo de guerra e escolher estratégia
    var _inimigos_terrestres = ds_list_create();
    var _inimigos_navais = ds_list_create();
    var _inimigos_aereos = ds_list_create();
    
    // === DETECTAR INIMIGOS TERRESTRES ===
    var _tipos_terrestres = [
        obj_infantaria,
        obj_tanque,
        obj_soldado_antiaereo,
        obj_blindado_antiaereo
    ];
    
    for (var i = 0; i < array_length(_tipos_terrestres); i++) {
        var _tipo = _tipos_terrestres[i];
        if (!object_exists(_tipo)) continue;
        
        with (_tipo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                if (_dist <= _ia.raio_expansao) {
                    ds_list_add(_inimigos_terrestres, id);
                }
            }
        }
    }
    
    // === DETECTAR INIMIGOS NAVAIS ===
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
        var _tipo = _tipos_navais[i];
        if (!object_exists(_tipo)) continue;
        
        with (_tipo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                if (_dist <= _ia.raio_expansao * 1.5) {
                    ds_list_add(_inimigos_navais, id);
                }
            }
        }
    }
    
    // === DETECTAR INIMIGOS AÉREOS ===
    var _tipos_aereos = [
        obj_helicoptero_militar,
        obj_caca_f5,
        obj_f6,
        obj_f15,
        obj_c100
    ];
    
    for (var i = 0; i < array_length(_tipos_aereos); i++) {
        var _tipo = _tipos_aereos[i];
        if (!object_exists(_tipo)) continue;
        
        with (_tipo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                if (_dist <= _ia.raio_expansao * 1.2) {
                    ds_list_add(_inimigos_aereos, id);
                }
            }
        }
    }
    
    // === ESCOLHER PRIORIDADE DE ATAQUE ===
    var _alvo_prioritario = noone;
    var _tipo_guerra = "terrestre";
    
    // Prioridade: Naval > Aéreo > Terrestre (navios são mais perigosos)
    if (ds_list_size(_inimigos_navais) > 0) {
        _tipo_guerra = "naval";
        // Escolher navio mais próximo
        var _menor_dist = 999999;
        for (var i = 0; i < ds_list_size(_inimigos_navais); i++) {
            var _alvo = ds_list_find_value(_inimigos_navais, i);
            if (instance_exists(_alvo)) {
                var _dist = point_distance(_alvo.x, _alvo.y, _ia.base_x, _ia.base_y);
                if (_dist < _menor_dist) {
                    _menor_dist = _dist;
                    _alvo_prioritario = _alvo;
                }
            }
        }
    } else if (ds_list_size(_inimigos_aereos) > 0) {
        _tipo_guerra = "aereo";
        var _menor_dist = 999999;
        for (var i = 0; i < ds_list_size(_inimigos_aereos); i++) {
            var _alvo = ds_list_find_value(_inimigos_aereos, i);
            if (instance_exists(_alvo)) {
                var _dist = point_distance(_alvo.x, _alvo.y, _ia.base_x, _ia.base_y);
                if (_dist < _menor_dist) {
                    _menor_dist = _dist;
                    _alvo_prioritario = _alvo;
                }
            }
        }
    } else if (ds_list_size(_inimigos_terrestres) > 0) {
        _tipo_guerra = "terrestre";
        var _menor_dist = 999999;
        for (var i = 0; i < ds_list_size(_inimigos_terrestres); i++) {
            var _alvo = ds_list_find_value(_inimigos_terrestres, i);
            if (instance_exists(_alvo)) {
                var _dist = point_distance(_alvo.x, _alvo.y, _ia.base_x, _ia.base_y);
                if (_dist < _menor_dist) {
                    _menor_dist = _dist;
                    _alvo_prioritario = _alvo;
                }
            }
        }
    }
    
    // === EXECUTAR ATAQUE ===
    if (instance_exists(_alvo_prioritario)) {
        // ✅ Ativar squad antes de atacar
        scr_activate_enemy_squad(_alvo_prioritario.x, _alvo_prioritario.y, 1500);
        
        // ✅ NOVO: Distribuir unidades antes de atacar (não ficar grudadas)
        if (_tipo_guerra != "naval") {
            // Distribuir unidades em formação ao redor da base antes de atacar
            scr_ia_distribuir_unidades(_ia, _ia.base_x, _ia.base_y, 250);
        }
        
        var _comandos = 0;
        
        // === ATAQUE BASEADO NO TIPO ===
        if (_tipo_guerra == "naval") {
            // Usar navios para atacar
            scr_ia_atacar_naval(_ia);
        } else {
            // ✅ NOVO: Mover tropas estrategicamente (não tudo junto)
            scr_ia_mover_tropas_estrategico(_ia, _alvo_prioritario.x, _alvo_prioritario.y, 350);
            
            // Também comandar unidades individualmente para garantir
            // Comandar infantaria
            with (obj_infantaria) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_prioritario.x;
                        destino_y = _alvo_prioritario.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _comandos++;
                }
            }
            
            // Comandar tanques
            with (obj_tanque) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_prioritario.x;
                        destino_y = _alvo_prioritario.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _comandos++;
                }
            }
        }
        
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("⚔️ IA ATAQUE [" + _tipo_guerra + "]! " + string(_comandos) + " unidades | Alvo: (" + string(round(_alvo_prioritario.x)) + ", " + string(round(_alvo_prioritario.y)) + ")");
        }
    } else {
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("⚠️ IA não encontrou alvos para atacar");
        }
    }
    
    // Limpar listas
    ds_list_destroy(_inimigos_terrestres);
    ds_list_destroy(_inimigos_navais);
    ds_list_destroy(_inimigos_aereos);
}
