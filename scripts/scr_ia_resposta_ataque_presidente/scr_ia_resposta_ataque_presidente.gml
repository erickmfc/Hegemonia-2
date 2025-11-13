// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
/// @description Resposta imediata de ataque quando presidente está em emergência
/// @param {real} _presidente_id ID da instância do presidente

function scr_ia_resposta_ataque_presidente(_presidente_id) {
    if (!instance_exists(_presidente_id)) return;
    
    var _presidente = _presidente_id;
    
    // Obter posição do presidente
    var _pres_x = variable_instance_exists(_presidente, "base_x") ? _presidente.base_x : _presidente.x;
    var _pres_y = variable_instance_exists(_presidente, "base_y") ? _presidente.base_y : _presidente.y;
    var _nacao_ia = variable_instance_exists(_presidente, "nacao_proprietaria") ? _presidente.nacao_proprietaria : 2;
    
    // === OBTER AMEAÇAS DETECTADAS ===
    var _ameacas = scr_ia_detectar_ameacas_presidente(_presidente_id);
    
    // Encontrar alvo prioritário (mais próximo)
    var _alvo_prioritario = noone;
    var _menor_dist = 999999;
    
    // Priorizar ameaças críticas
    for (var i = 0; i < array_length(_ameacas.ameacas_criticas); i++) {
        var _ameaca = _ameacas.ameacas_criticas[i];
        if (instance_exists(_ameaca.id) && _ameaca.distancia < _menor_dist) {
            _menor_dist = _ameaca.distancia;
            _alvo_prioritario = _ameaca.id;
        }
    }
    
    // Se não encontrou em críticas, buscar em alerta
    if (_alvo_prioritario == noone) {
        for (var i = 0; i < array_length(_ameacas.ameacas_alerta); i++) {
            var _ameaca = _ameacas.ameacas_alerta[i];
            if (instance_exists(_ameaca.id) && _ameaca.distancia < _menor_dist) {
                _menor_dist = _ameaca.distancia;
                _alvo_prioritario = _ameaca.id;
            }
        }
    }
    
    if (_alvo_prioritario == noone) return; // Nenhum alvo encontrado
    
    // === ATIVAR SQUAD INIMIGO ===
    scr_activate_enemy_squad(_alvo_prioritario.x, _alvo_prioritario.y, 2000);
    
    // === RAIO DE DEFESA EMERGÊNCIA ===
    var _raio_defesa = 1500; // Raio maior em emergência
    
    // === COMANDAR TODAS AS UNIDADES TERRESTRES PRÓXIMAS ===
    var _unidades_comandadas = 0;
    
    // Infantaria
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
            var _dist = point_distance(x, y, _pres_x, _pres_y);
            if (_dist <= _raio_defesa) {
                // Cancelar qualquer ação anterior e defender
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
                if (variable_instance_exists(id, "modo_ataque")) {
                    modo_ataque = true;
                }
                _unidades_comandadas++;
            }
        }
    }
    
    // Tanques
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
            var _dist = point_distance(x, y, _pres_x, _pres_y);
            if (_dist <= _raio_defesa) {
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
                if (variable_instance_exists(id, "modo_ataque")) {
                    modo_ataque = true;
                }
                _unidades_comandadas++;
            }
        }
    }
    
    // Soldados antiaéreos
    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
            var _dist = point_distance(x, y, _pres_x, _pres_y);
            if (_dist <= _raio_defesa) {
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
                if (variable_instance_exists(id, "modo_ataque")) {
                    modo_ataque = true;
                }
                _unidades_comandadas++;
            }
        }
    }
    
    // Blindados antiaéreos
    with (obj_blindado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
            var _dist = point_distance(x, y, _pres_x, _pres_y);
            if (_dist <= _raio_defesa) {
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
                if (variable_instance_exists(id, "modo_ataque")) {
                    modo_ataque = true;
                }
                _unidades_comandadas++;
            }
        }
    }
    
    // M1A Abrams
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        with (_obj_abrams) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                var _dist = point_distance(x, y, _pres_x, _pres_y);
                if (_dist <= _raio_defesa) {
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
                    if (variable_instance_exists(id, "modo_ataque")) {
                        modo_ataque = true;
                    }
                    _unidades_comandadas++;
                }
            }
        }
    }
    
    // === COMANDAR UNIDADES AÉREAS ===
    var _raio_aereo = 2000; // Raio maior para unidades aéreas
    
    var _tipos_aereos = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_f15, obj_c100];
    for (var i = 0; i < array_length(_tipos_aereos); i++) {
        if (!object_exists(_tipos_aereos[i])) continue;
        
        with (_tipos_aereos[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                var _dist = point_distance(x, y, _pres_x, _pres_y);
                if (_dist <= _raio_aereo) {
                    if (variable_instance_exists(id, "alvo_em_mira")) {
                        alvo_em_mira = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "alvo")) {
                        alvo = _alvo_prioritario;
                    }
                    if (variable_instance_exists(id, "estado")) {
                        estado = "atacando";
                    }
                    _unidades_comandadas++;
                }
            }
        }
    }
    
    // === COMANDAR UNIDADES NAVAIS ===
    var _raio_naval = 2500; // Raio maior para unidades navais
    
    var _tipos_navais = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_navio_transporte, obj_Constellation, obj_Independence, obj_RonaldReagan];
    var _obj_fragata = asset_get_index("obj_fragata");
    if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object) {
        array_push(_tipos_navais, _obj_fragata);
    }
    
    for (var i = 0; i < array_length(_tipos_navais); i++) {
        if (!object_exists(_tipos_navais[i])) continue;
        
        with (_tipos_navais[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                var _dist = point_distance(x, y, _pres_x, _pres_y);
                if (_dist <= _raio_naval) {
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
                    if (variable_instance_exists(id, "modo_combate")) {
                        modo_combate = "atacando";
                    }
                    _unidades_comandadas++;
                }
            }
        }
    }
    
    // === DEBUG ===
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🚨 RESPOSTA EMERGÊNCIA: " + string(_unidades_comandadas) + " unidades enviadas para defender presidente!");
    }
}
