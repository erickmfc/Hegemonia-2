// ===============================================
// HEGEMONIA GLOBAL - CLASSIFICAÇÃO DE PODER DE UNIDADES
// Sistema para classificar unidades por poder de combate
// ===============================================

/// @function scr_ia_classificar_unidades_poder(_unidade_id)
/// @description Classifica uma unidade por seu poder de combate
/// @param {id} _unidade_id - ID da unidade
/// @returns {real} Valor de poder (0-100)

function scr_ia_classificar_unidades_poder(_unidade_id) {
    if (!instance_exists(_unidade_id)) return 0;
    
    var _obj_name = object_get_name(_unidade_id.object_index);
    var _poder = 0;
    
    // === CLASSIFICAÇÃO POR TIPO ===
    
    // Aviões Elite
    if (string_pos("f15", _obj_name) > 0) {
        _poder = 90; // F-15: muito poderoso
    } else if (string_pos("f6", _obj_name) > 0) {
        _poder = 70; // F-6: poderoso
    } else if (string_pos("f5", _obj_name) > 0) {
        _poder = 60; // F-5: médio
    } else if (string_pos("su35", _obj_name) > 0) {
        _poder = 85; // SU-35: muito poderoso
    }
    
    // Navios
    else if (string_pos("Ronald", _obj_name) > 0) {
        _poder = 95; // Porta-aviões: extremamente poderoso
    } else if (string_pos("Independence", _obj_name) > 0) {
        _poder = 80; // Independence: muito poderoso
    } else if (string_pos("Constellation", _obj_name) > 0) {
        _poder = 75; // Constellation: poderoso
    } else if (string_pos("submarino", _obj_name) > 0) {
        _poder = 70; // Submarino: poderoso
    } else if (string_pos("lancha", _obj_name) > 0) {
        _poder = 40; // Lancha: fraco
    }
    
    // Terrestres
    else if (string_pos("tanque", _obj_name) > 0) {
        _poder = 65; // Tanque: poderoso
    } else if (string_pos("blindado_antiaereo", _obj_name) > 0) {
        _poder = 70; // Blindado AA: poderoso
    } else if (string_pos("soldado_antiaereo", _obj_name) > 0) {
        _poder = 50; // Soldado AA: médio
    } else if (string_pos("infantaria", _obj_name) > 0) {
        _poder = 30; // Infantaria: fraco
    }
    
    // Helicópteros
    else if (string_pos("helicoptero", _obj_name) > 0) {
        _poder = 55; // Helicóptero: médio
    }
    
    // Ajustar por HP se disponível
    if (variable_instance_exists(_unidade_id, "hp") && 
        variable_instance_exists(_unidade_id, "hp_max")) {
        var _hp_percent = _unidade_id.hp / _unidade_id.hp_max;
        _poder = _poder * _hp_percent; // Reduzir poder se danificado
    }
    
    return _poder;
}

/// @function scr_ia_comparar_poder_unidades(_unidade1_id, _unidade2_id)
/// @description Compara poder de duas unidades
/// @param {id} _unidade1_id - ID da primeira unidade
/// @param {id} _unidade2_id - ID da segunda unidade
/// @returns {int} -1 se unidade1 < unidade2, 0 se iguais, 1 se unidade1 > unidade2

function scr_ia_comparar_poder_unidades(_unidade1_id, _unidade2_id) {
    var _poder1 = scr_ia_classificar_unidades_poder(_unidade1_id);
    var _poder2 = scr_ia_classificar_unidades_poder(_unidade2_id);
    
    if (_poder1 < _poder2) return -1;
    if (_poder1 > _poder2) return 1;
    return 0;
}

/// @function scr_ia_listar_unidades_por_poder(_nacao)
/// @description Lista unidades de uma nação ordenadas por poder
/// @param {int} _nacao - Nação (1 = jogador, 2 = IA)
/// @returns {array} Array de IDs ordenados por poder (maior para menor)

function scr_ia_listar_unidades_por_poder(_nacao) {
    var _unidades = [];
    var _poderes = [];
    
    // Coletar todas as unidades da nação
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao) {
            array_push(_unidades, id);
            array_push(_poderes, scr_ia_classificar_unidades_poder(id));
        }
    }
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao) {
            array_push(_unidades, id);
            array_push(_poderes, scr_ia_classificar_unidades_poder(id));
        }
    }
    with (obj_f15) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao) {
            array_push(_unidades, id);
            array_push(_poderes, scr_ia_classificar_unidades_poder(id));
        }
    }
    with (obj_RonaldReagan) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao) {
            array_push(_unidades, id);
            array_push(_poderes, scr_ia_classificar_unidades_poder(id));
        }
    }
    
    // Ordenar por poder (bubble sort simples)
    var _n = array_length(_unidades);
    for (var i = 0; i < _n - 1; i++) {
        for (var j = 0; j < _n - i - 1; j++) {
            if (_poderes[j] < _poderes[j + 1]) {
                // Trocar unidades
                var _temp_unidade = _unidades[j];
                _unidades[j] = _unidades[j + 1];
                _unidades[j + 1] = _temp_unidade;
                
                // Trocar poderes
                var _temp_poder = _poderes[j];
                _poderes[j] = _poderes[j + 1];
                _poderes[j + 1] = _temp_poder;
            }
        }
    }
    
    return _unidades;
}
