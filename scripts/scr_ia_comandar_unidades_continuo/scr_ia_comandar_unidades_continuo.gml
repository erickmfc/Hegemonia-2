/// @description Comandar unidades da IA continuamente - verifica unidades órfãs e as comanda
/// @param _ia_id ID da IA
/// @return Número de unidades comandadas

function scr_ia_comandar_unidades_continuo(_ia_id) {
    if (!instance_exists(_ia_id)) {
        return 0;
    }
    
    var _ia = _ia_id;
    var _nacao_ia = _ia.nacao_proprietaria;
    var _comandos_enviados = 0;
    
    // === COLETAR TODAS AS UNIDADES DA IA ===
    var _unidades_orfas = [];
    var _index = 0;
    
    // Tipos de unidades terrestres
    var _tipos_terrestres = [obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo];
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        array_push(_tipos_terrestres, _obj_abrams);
    }
    var _obj_gepard = asset_get_index("obj_Gepard_Anti_Aereo");
    if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object) {
        array_push(_tipos_terrestres, _obj_gepard);
    }
    
    // Verificar unidades terrestres órfãs (sem destino ou alvo)
    for (var i = 0; i < array_length(_tipos_terrestres); i++) {
        if (!object_exists(_tipos_terrestres[i])) continue;
        
        with (_tipos_terrestres[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                // Verificar se está órfã (sem destino/alvo ou parada há muito tempo)
                var _esta_orfa = false;
                
                // Se não tem destino definido
                if (!variable_instance_exists(id, "destino_x") || destino_x == 0) {
                    _esta_orfa = true;
                }
                
                // Se está parada e não tem alvo
                if (variable_instance_exists(id, "estado") && estado == "parado") {
                    if (!variable_instance_exists(id, "alvo") || alvo == noone) {
                        _esta_orfa = true;
                    }
                }
                
                // Se está muito longe da base (pode estar perdida)
                var _dist_base = point_distance(x, y, _ia.base_x, _ia.base_y);
                if (_dist_base > _ia.raio_expansao * 1.5) {
                    _esta_orfa = true;
                }
                
                if (_esta_orfa) {
                    _unidades_orfas[_index] = id;
                    _index++;
                }
            }
        }
    }
    
    // Tipos de unidades navais
    var _tipos_navais = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_Constellation, obj_Independence];
    var _obj_fragata = asset_get_index("obj_fragata");
    if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object) {
        array_push(_tipos_navais, _obj_fragata);
    }
    
    // Verificar unidades navais órfãs
    for (var i = 0; i < array_length(_tipos_navais); i++) {
        if (!object_exists(_tipos_navais[i])) continue;
        
        with (_tipos_navais[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                var _esta_orfa = false;
                
                if (!variable_instance_exists(id, "destino_x") || destino_x == 0) {
                    _esta_orfa = true;
                }
                
                if (variable_instance_exists(id, "estado") && estado == "parado") {
                    if (!variable_instance_exists(id, "alvo") || alvo == noone) {
                        _esta_orfa = true;
                    }
                }
                
                if (_esta_orfa) {
                    _unidades_orfas[_index] = id;
                    _index++;
                }
            }
        }
    }
    
    // Tipos de unidades aéreas
    var _tipos_aereos = [obj_helicoptero_militar, obj_caca_f5, obj_f15, obj_c100];
    var _obj_su35 = asset_get_index("obj_su35");
    if (_obj_su35 != -1 && asset_get_type(_obj_su35) == asset_object) {
        array_push(_tipos_aereos, _obj_su35);
    }
    
    // Verificar unidades aéreas órfãs
    for (var i = 0; i < array_length(_tipos_aereos); i++) {
        if (!object_exists(_tipos_aereos[i])) continue;
        
        with (_tipos_aereos[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                var _esta_orfa = false;
                
                if (!variable_instance_exists(id, "destino_x") || destino_x == 0) {
                    _esta_orfa = true;
                }
                
                if (variable_instance_exists(id, "estado") && estado == "parado") {
                    if (!variable_instance_exists(id, "alvo") || alvo == noone) {
                        _esta_orfa = true;
                    }
                }
                
                if (_esta_orfa) {
                    _unidades_orfas[_index] = id;
                    _index++;
                }
            }
        }
    }
    
    // === COMANDAR UNIDADES ÓRFÃS ===
    if (array_length(_unidades_orfas) > 0) {
        // Buscar alvos próximos
        var _alvo_proximo = noone;
        var _menor_dist = 999999;
        
        // Buscar unidades inimigas próximas
        var _tipos_inimigos = [obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo];
        for (var i = 0; i < array_length(_tipos_inimigos); i++) {
            if (!object_exists(_tipos_inimigos[i])) continue;
            
            with (_tipos_inimigos[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                    var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                    if (_dist < _menor_dist && _dist <= _ia.raio_expansao) {
                        _menor_dist = _dist;
                        _alvo_proximo = id;
                    }
                }
            }
        }
        
        // Se encontrou alvo, comandar unidades para atacar
        if (instance_exists(_alvo_proximo)) {
            for (var i = 0; i < array_length(_unidades_orfas); i++) {
                var _unidade = _unidades_orfas[i];
                if (!instance_exists(_unidade)) continue;
                
                with (_unidade) {
                    // Comandar para atacar alvo
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _alvo_proximo.x;
                        destino_y = _alvo_proximo.y;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_proximo;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    if (variable_instance_exists(id, "modo_ataque")) {
                        modo_ataque = true;
                    }
                }
                _comandos_enviados++;
            }
        } else {
            // Se não há alvos, mover unidades para posições estratégicas ao redor da base
            var _num_unidades = array_length(_unidades_orfas);
            for (var i = 0; i < _num_unidades; i++) {
                var _unidade = _unidades_orfas[i];
                if (!instance_exists(_unidade)) continue;
                
                // Calcular posição em formação circular ao redor da base
                var _angulo = (360 / _num_unidades) * i;
                var _raio = 200 + (i * 30); // Espaçamento entre unidades
                var _pos_x = _ia.base_x + lengthdir_x(_raio, _angulo);
                var _pos_y = _ia.base_y + lengthdir_y(_raio, _angulo);
                
                with (_unidade) {
                    if (variable_instance_exists(id, "destino_x")) {
                        destino_x = _pos_x;
                        destino_y = _pos_y;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "movendo";
                    }
                }
                _comandos_enviados++;
            }
        }
    }
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled && _comandos_enviados > 0) {
        show_debug_message("🎯 IA COMANDOU " + string(_comandos_enviados) + " UNIDADES ÓRFÃS");
    }
    
    return _comandos_enviados;
}

