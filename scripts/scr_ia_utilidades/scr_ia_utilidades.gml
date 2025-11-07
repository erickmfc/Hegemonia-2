/// @description Funções auxiliares reutilizáveis para a IA
/// Centraliza verificações e contagens comuns

// ==========================================
// CONSTANTES GLOBAIS DE TIPOS DE UNIDADES
// ==========================================

/// @description Retorna array de tipos terrestres
function scr_ia_obter_tipos_terrestres() {
    return [
        obj_infantaria,
        obj_tanque,
        obj_soldado_antiaereo,
        obj_blindado_antiaereo
    ];
}

/// @description Retorna array de tipos navais (sem obj_fragata)
function scr_ia_obter_tipos_navais_base() {
    return [
        obj_lancha_patrulha,
        obj_navio_base,
        obj_submarino_base,
        obj_navio_transporte,
        obj_Constellation,
        obj_Independence,
        obj_RonaldReagan
    ];
}

/// @description Retorna array de tipos aéreos
function scr_ia_obter_tipos_aereos() {
    return [
        obj_helicoptero_militar,
        obj_caca_f5,
        obj_f6,
        obj_f15,
        obj_c100
    ];
}

// ==========================================
// VERIFICAÇÃO DE OBJETOS
// ==========================================

/// @description Verifica se obj_fragata existe e retorna seu índice
/// Usa cache estático para melhor performance
function scr_ia_obter_obj_fragata() {
    static _cache = -1;
    static _verificado = false;
    
    if (!_verificado) {
        var _idx = asset_get_index("obj_fragata");
        if (_idx != -1 && asset_get_type(_idx) == asset_object) {
            _cache = _idx;
        }
        _verificado = true;
    }
    
    return _cache;
}

/// @description Retorna array completo de tipos navais (incluindo obj_fragata se existir)
function scr_ia_obter_tipos_navais_completo() {
    var _tipos = scr_ia_obter_tipos_navais_base();
    var _obj_fragata = scr_ia_obter_obj_fragata();
    
    if (_obj_fragata != -1) {
        array_push(_tipos, _obj_fragata);
    }
    
    return _tipos;
}

// ==========================================
// CONTAGEM DE UNIDADES
// ==========================================

/// @description Conta unidades da IA por tipo
/// @param {real} _nacao_ia Nação da IA (geralmente 2)
/// @return {struct} {total, terrestres, navais, aereas}
function scr_ia_contar_unidades(_nacao_ia) {
    var _resultado = {
        total: 0,
        terrestres: 0,
        navais: 0,
        aereas: 0
    };
    
    // Contar unidades terrestres
    var _tipos_terrestres = scr_ia_obter_tipos_terrestres();
    for (var i = 0; i < array_length(_tipos_terrestres); i++) {
        if (!object_exists(_tipos_terrestres[i])) continue;
        with (_tipos_terrestres[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                _resultado.total++;
                _resultado.terrestres++;
            }
        }
    }
    
    // Contar unidades navais
    var _tipos_navais = scr_ia_obter_tipos_navais_completo();
    for (var i = 0; i < array_length(_tipos_navais); i++) {
        if (!object_exists(_tipos_navais[i])) continue;
        with (_tipos_navais[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                _resultado.total++;
                _resultado.navais++;
            }
        }
    }
    
    // Contar unidades aéreas
    var _tipos_aereos = scr_ia_obter_tipos_aereos();
    for (var i = 0; i < array_length(_tipos_aereos); i++) {
        if (!object_exists(_tipos_aereos[i])) continue;
        with (_tipos_aereos[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                _resultado.total++;
                _resultado.aereas++;
            }
        }
    }
    
    return _resultado;
}

/// @description Conta unidades do jogador por tipo
/// @param {real} _nacao_jogador Nação do jogador (geralmente 1)
/// @return {struct} {total, terrestres, navais, aereas}
function scr_ia_contar_unidades_jogador(_nacao_jogador) {
    var _resultado = {
        total: 0,
        terrestres: 0,
        navais: 0,
        aereas: 0
    };
    
    // Contar unidades terrestres
    var _tipos_terrestres = scr_ia_obter_tipos_terrestres();
    for (var i = 0; i < array_length(_tipos_terrestres); i++) {
        if (!object_exists(_tipos_terrestres[i])) continue;
        with (_tipos_terrestres[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                _resultado.total++;
                _resultado.terrestres++;
            }
        }
    }
    
    // Contar unidades navais
    var _tipos_navais = scr_ia_obter_tipos_navais_completo();
    for (var i = 0; i < array_length(_tipos_navais); i++) {
        if (!object_exists(_tipos_navais[i])) continue;
        with (_tipos_navais[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                _resultado.total++;
                _resultado.navais++;
            }
        }
    }
    
    // Contar unidades aéreas
    var _tipos_aereos = scr_ia_obter_tipos_aereos();
    for (var i = 0; i < array_length(_tipos_aereos); i++) {
        if (!object_exists(_tipos_aereos[i])) continue;
        with (_tipos_aereos[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                _resultado.total++;
                _resultado.aereas++;
            }
        }
    }
    
    return _resultado;
}

