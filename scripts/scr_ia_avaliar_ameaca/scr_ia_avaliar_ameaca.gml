/// @description Avalia o nível de ameaça do jogador (conta todas as unidades)
/// @param {real} _ia_id ID da IA
/// @return {struct} {nivel_ameaca: string, total_unidades_jogador: real, precisa_preparar: bool}

function scr_ia_avaliar_ameaca(_ia_id) {
    // ✅ CORREÇÃO: Validar entrada
    if (!instance_exists(_ia_id)) {
        // Retornar valores padrão se IA não existir
        return {
            nivel_ameaca: "baixo",
            total_unidades_jogador: 0,
            unidades_terrestres: 0,
            unidades_navais: 0,
            unidades_aereas: 0,
            precisa_preparar: false,
            alerta_critico: false
        };
    }
    
    var _ia = _ia_id;
    
    // === CONTAR TODAS AS UNIDADES DO JOGADOR (qualquer tipo) ===
    var _total_unidades_jogador = 0;
    var _unidades_terrestres_jogador = 0;
    var _unidades_navais_jogador = 0;
    var _unidades_aereas_jogador = 0;
    
    // Unidades terrestres do jogador
    var _tipos_terrestres = [
        obj_infantaria,
        obj_tanque,
        obj_soldado_antiaereo,
        obj_blindado_antiaereo
    ];
    
    for (var i = 0; i < array_length(_tipos_terrestres); i++) {
        if (!object_exists(_tipos_terrestres[i])) continue;
        
        with (_tipos_terrestres[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                _total_unidades_jogador++;
                _unidades_terrestres_jogador++;
            }
        }
    }
    
    // Unidades navais do jogador
    var _tipos_navais = [
        obj_lancha_patrulha,
        obj_navio_base,
        obj_submarino_base,
        obj_navio_transporte,
        obj_Constellation,
        obj_Independence,
        obj_RonaldReagan
    ];
    
    // Verificar obj_fragata
    var _obj_fragata = asset_get_index("obj_fragata");
    if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object && object_exists(_obj_fragata)) {
        array_push(_tipos_navais, _obj_fragata);
    }
    
    for (var i = 0; i < array_length(_tipos_navais); i++) {
        if (!object_exists(_tipos_navais[i])) continue;
        
        with (_tipos_navais[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                _total_unidades_jogador++;
                _unidades_navais_jogador++;
            }
        }
    }
    
    // Unidades aéreas do jogador
    var _tipos_aereos = [
        obj_helicoptero_militar,
        obj_caca_f5,
        obj_f6,
        obj_f15,
        obj_c100
    ];
    
    for (var i = 0; i < array_length(_tipos_aereos); i++) {
        if (!object_exists(_tipos_aereos[i])) continue;
        
        with (_tipos_aereos[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                _total_unidades_jogador++;
                _unidades_aereas_jogador++;
            }
        }
    }
    
    // === AVALIAR NÍVEL DE AMEAÇA ===
    var _nivel_ameaca = "baixo";
    var _precisa_preparar = false;
    var _alerta_critico = false;
    
    if (_total_unidades_jogador >= 20) {
        _nivel_ameaca = "critico"; // Muito perigoso!
        _precisa_preparar = true;
        _alerta_critico = true;
    } else if (_total_unidades_jogador >= 15) {
        _nivel_ameaca = "alto"; // Muito perigoso!
        _precisa_preparar = true;
        _alerta_critico = true;
    } else if (_total_unidades_jogador >= 10) {
        _nivel_ameaca = "medio_alto"; // Ameaça significativa
        _precisa_preparar = true;
    } else if (_total_unidades_jogador >= 5) {
        _nivel_ameaca = "medio"; // Ameaça moderada
        _precisa_preparar = false;
    } else {
        _nivel_ameaca = "baixo"; // Pouca ameaça
        _precisa_preparar = false;
    }
    
    // === RESULTADO ===
    var _resultado = {
        nivel_ameaca: _nivel_ameaca,
        total_unidades_jogador: _total_unidades_jogador,
        unidades_terrestres: _unidades_terrestres_jogador,
        unidades_navais: _unidades_navais_jogador,
        unidades_aereas: _unidades_aereas_jogador,
        precisa_preparar: _precisa_preparar,
        alerta_critico: _alerta_critico
    };
    
    return _resultado;
}

