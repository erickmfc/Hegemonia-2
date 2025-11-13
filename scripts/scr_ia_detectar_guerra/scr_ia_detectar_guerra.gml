/// @description Detecta se o país da IA entrou em guerra
/// @param {real} _ia_id ID da IA
/// @return {struct} {em_guerra: bool, estado_guerra: EstadoGuerra, unidades_em_combate: int, frentes_ativas: array}
function scr_ia_detectar_guerra(_ia_id) {
    if (!instance_exists(_ia_id)) {
        return {
            em_guerra: false,
            estado_guerra: EstadoGuerra.PAZ,
            unidades_em_combate: 0,
            unidades_atacadas: 0,
            unidades_atacando: 0,
            frentes_ativas: [],
            tipo_guerra: "nenhum"
        };
    }
    
    var _ia = _ia_id;
    
    var _resultado = {
        em_guerra: false,
        estado_guerra: EstadoGuerra.PAZ,
        unidades_em_combate: 0,
        unidades_atacadas: 0,
        unidades_atacando: 0,
        frentes_ativas: [],
        tipo_guerra: "nenhum" // "terrestre", "naval", "aereo", "misto"
    };
    
    // === DETECTAR UNIDADES EM COMBATE ===
    var _unidades_combate_terrestre = 0;
    var _unidades_combate_naval = 0;
    var _unidades_combate_aereo = 0;
    
    var _nacao_ia = variable_instance_exists(_ia, "nacao_proprietaria") ? _ia.nacao_proprietaria : 2;
    
    // Terrestres
    var _tipos_terrestres = [obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo];
    
    // Verificar M1A Abrams
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        array_push(_tipos_terrestres, _obj_abrams);
    }
    
    for (var i = 0; i < array_length(_tipos_terrestres); i++) {
        if (!object_exists(_tipos_terrestres[i])) continue;
        
        with (_tipos_terrestres[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                // Verificar se está atacando ou sendo atacado
                var _em_combate = false;
                
                // Verificar se tem alvo inimigo
                if (variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo)) {
                    var _alvo = alvo;
                    if (variable_instance_exists(_alvo, "nacao_proprietaria") && _alvo.nacao_proprietaria == 1) {
                        _em_combate = true;
                        _resultado.unidades_atacando++;
                    }
                }
                
                // Verificar se está sendo atacado
                if (variable_instance_exists(id, "estado") && estado == "atacando") {
                    _em_combate = true;
                    _resultado.unidades_atacadas++;
                }
                
                if (_em_combate) {
                    _unidades_combate_terrestre++;
                    _resultado.unidades_em_combate++;
                }
            }
        }
    }
    
    // Navais
    var _tipos_navais = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_navio_transporte, obj_Constellation, obj_Independence, obj_RonaldReagan];
    var _obj_fragata = asset_get_index("obj_fragata");
    if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object) {
        array_push(_tipos_navais, _obj_fragata);
    }
    
    for (var i = 0; i < array_length(_tipos_navais); i++) {
        if (!object_exists(_tipos_navais[i])) continue;
        
        with (_tipos_navais[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                var _em_combate = false;
                
                if (variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo)) {
                    var _alvo = alvo;
                    if (variable_instance_exists(_alvo, "nacao_proprietaria") && _alvo.nacao_proprietaria == 1) {
                        _em_combate = true;
                        _resultado.unidades_atacando++;
                    }
                }
                
                if (variable_instance_exists(id, "estado") && (estado == "atacando" || (variable_instance_exists(id, "estado_string") && estado_string == "atacando"))) {
                    _em_combate = true;
                    _resultado.unidades_atacadas++;
                }
                
                if (_em_combate) {
                    _unidades_combate_naval++;
                    _resultado.unidades_em_combate++;
                }
            }
        }
    }
    
    // Aéreas
    var _tipos_aereos = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_f15, obj_c100];
    var _obj_su35 = asset_get_index("obj_su35");
    if (_obj_su35 != -1 && asset_get_type(_obj_su35) == asset_object) {
        array_push(_tipos_aereos, _obj_su35);
    }
    
    for (var i = 0; i < array_length(_tipos_aereos); i++) {
        if (!object_exists(_tipos_aereos[i])) continue;
        
        with (_tipos_aereos[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                var _em_combate = false;
                
                if (variable_instance_exists(id, "alvo") || (variable_instance_exists(id, "alvo_em_mira") && alvo_em_mira != noone)) {
                    var _alvo = (variable_instance_exists(id, "alvo") && alvo != noone) ? alvo : alvo_em_mira;
                    if (instance_exists(_alvo) && variable_instance_exists(_alvo, "nacao_proprietaria") && _alvo.nacao_proprietaria == 1) {
                        _em_combate = true;
                        _resultado.unidades_atacando++;
                    }
                }
                
                if (variable_instance_exists(id, "estado") && estado == "atacando") {
                    _em_combate = true;
                    _resultado.unidades_atacadas++;
                }
                
                if (_em_combate) {
                    _unidades_combate_aereo++;
                    _resultado.unidades_em_combate++;
                }
            }
        }
    }
    
    // === DETERMINAR ESTADO DE GUERRA ===
    if (_resultado.unidades_em_combate > 0) {
        _resultado.em_guerra = true;
        
        // Determinar tipo de guerra
        var _tipos = [];
        if (_unidades_combate_terrestre > 0) array_push(_tipos, "terrestre");
        if (_unidades_combate_naval > 0) array_push(_tipos, "naval");
        if (_unidades_combate_aereo > 0) array_push(_tipos, "aereo");
        
        if (array_length(_tipos) > 1) {
            _resultado.tipo_guerra = "misto";
        } else if (array_length(_tipos) == 1) {
            _resultado.tipo_guerra = _tipos[0];
        }
        
        // Determinar estado de guerra
        if (_resultado.unidades_em_combate >= 10) {
            _resultado.estado_guerra = EstadoGuerra.GUERRA_TOTAL;
        } else if (_resultado.unidades_em_combate >= 5) {
            _resultado.estado_guerra = EstadoGuerra.GUERRA_ATIVA;
        } else {
            _resultado.estado_guerra = EstadoGuerra.ALERTA;
        }
        
        // Adicionar frentes ativas
        _resultado.frentes_ativas = _tipos;
    }
    
    return _resultado;
}
