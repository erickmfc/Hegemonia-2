/// @description Detecta se a IA está sendo atacada
/// @param {real} _ia_id ID da IA
/// @return {array} {sendo_atacada: bool, unidades_atacadas: array, alvo_atacante: instance}

function scr_ia_detectar_ataque(_ia_id) {
    var _ia = _ia_id;
    var _resultado = {
        sendo_atacada: false,
        unidades_atacadas: [],
        alvo_atacante: noone,
        tipo_guerra: "nenhum", // "terrestre", "naval", "aereo", "misto"
        unidades_terrestres_atacadas: 0,
        unidades_navais_atacadas: 0,
        unidades_aereas_atacadas: 0
    };
    
    // === DETECTAR ATAQUES TERRESTRES ===
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            // Verificar se tem alvo inimigo atacando
            if (variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo)) {
                var _alvo = alvo;
                if (variable_instance_exists(_alvo, "nacao_proprietaria") && _alvo.nacao_proprietaria == 1) {
                    // Inimigo está atacando esta unidade
                    _resultado.sendo_atacada = true;
                    _resultado.unidades_terrestres_atacadas++;
                    array_push(_resultado.unidades_atacadas, id);
                    
                    if (_resultado.alvo_atacante == noone) {
                        _resultado.alvo_atacante = _alvo;
                    }
                }
            }
        }
    }
    
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            if (variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo)) {
                var _alvo = alvo;
                if (variable_instance_exists(_alvo, "nacao_proprietaria") && _alvo.nacao_proprietaria == 1) {
                    _resultado.sendo_atacada = true;
                    _resultado.unidades_terrestres_atacadas++;
                    array_push(_resultado.unidades_atacadas, id);
                    
                    if (_resultado.alvo_atacante == noone) {
                        _resultado.alvo_atacante = _alvo;
                    }
                }
            }
        }
    }
    
    // === DETECTAR ATAQUES NAVAIS ===
    // ✅ CORRIGIDO: Implementação direta (sem depender de função externa)
    var _navios_ia = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_navio_transporte, obj_Constellation, obj_Independence, obj_RonaldReagan];
    var _obj_fragata_detectar = asset_get_index("obj_fragata");
    if (_obj_fragata_detectar != -1 && asset_get_type(_obj_fragata_detectar) == asset_object) {
        array_push(_navios_ia, _obj_fragata_detectar);
    }
    
    for (var i = 0; i < array_length(_navios_ia); i++) {
        var _navio_tipo = _navios_ia[i];
        if (!object_exists(_navio_tipo)) continue;
        
        with (_navio_tipo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                // Verificar se navio está sendo atacado
                if (variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo)) {
                    var _alvo = alvo;
                    if (variable_instance_exists(_alvo, "nacao_proprietaria") && _alvo.nacao_proprietaria == 1) {
                        _resultado.sendo_atacada = true;
                        _resultado.unidades_navais_atacadas++;
                        array_push(_resultado.unidades_atacadas, id);
                        
                        if (_resultado.alvo_atacante == noone || _resultado.alvo_atacante == _alvo) {
                            _resultado.alvo_atacante = _alvo;
                        }
                    }
                }
            }
        }
    }
    
    // === DETECTAR ATAQUES AÉREOS ===
    var _aeronaves_ia = [
        obj_helicoptero_militar,
        obj_caca_f5,
        obj_f6,
        obj_f15,
        obj_c100
    ];
    
    for (var i = 0; i < array_length(_aeronaves_ia); i++) {
        var _aereo_tipo = _aeronaves_ia[i];
        if (!object_exists(_aereo_tipo)) continue;
        
        with (_aereo_tipo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                if (variable_instance_exists(id, "alvo") || (variable_instance_exists(id, "alvo_em_mira") && alvo_em_mira != noone)) {
                    var _alvo = (variable_instance_exists(id, "alvo") && alvo != noone) ? alvo : alvo_em_mira;
                    
                    if (instance_exists(_alvo) && variable_instance_exists(_alvo, "nacao_proprietaria") && _alvo.nacao_proprietaria == 1) {
                        _resultado.sendo_atacada = true;
                        _resultado.unidades_aereas_atacadas++;
                        array_push(_resultado.unidades_atacadas, id);
                        
                        if (_resultado.alvo_atacante == noone) {
                            _resultado.alvo_atacante = _alvo;
                        }
                    }
                }
            }
        }
    }
    
    // === DETERMINAR TIPO DE GUERRA ===
    if (_resultado.sendo_atacada) {
        var _tipos = [];
        if (_resultado.unidades_terrestres_atacadas > 0) array_push(_tipos, "terrestre");
        if (_resultado.unidades_navais_atacadas > 0) array_push(_tipos, "naval");
        if (_resultado.unidades_aereas_atacadas > 0) array_push(_tipos, "aereo");
        
        if (array_length(_tipos) > 1) {
            _resultado.tipo_guerra = "misto";
        } else if (array_length(_tipos) == 1) {
            _resultado.tipo_guerra = _tipos[0];
        }
    }
    
    return _resultado;
}
