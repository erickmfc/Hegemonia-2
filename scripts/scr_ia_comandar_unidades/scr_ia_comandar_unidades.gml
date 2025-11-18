// ===============================================
// HEGEMONIA GLOBAL - COMANDO DE UNIDADES
// Sistema de comando centralizado para unidades da IA
// ===============================================

/// @function scr_ia_comandar_unidades(_presidente_id)
/// @description Comanda todas as unidades da IA de forma centralizada
/// @param {id} _presidente_id - ID do presidente

function scr_ia_comandar_unidades(_presidente_id) {
    if (!instance_exists(_presidente_id)) return;
    
    // === COMANDAR AVIÕES ===
    with (obj_f15) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            if (!variable_instance_exists(id, "alvo") || alvo == noone) {
                var _script_alvos = asset_get_index("scr_ia_detectar_alvos_estrategicos");
                if (_script_alvos != -1) {
                    var _alvo = scr_ia_encontrar_alvo_prioritario();
                    if (_alvo != noone) {
                        alvo = _alvo;
                        x_destino = _alvo.x;
                        y_destino = _alvo.y;
                        if (variable_instance_exists(id, "em_movimento")) {
                            em_movimento = true;
                        }
                    }
                }
            }
        }
    }
    
    // === COMANDAR TANQUES ===
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            if (!variable_instance_exists(id, "alvo") || alvo == noone) {
                var _script_alvos = asset_get_index("scr_ia_detectar_alvos_estrategicos");
                if (_script_alvos != -1) {
                    var _alvo = scr_ia_encontrar_alvo_prioritario();
                    if (_alvo != noone) {
                        alvo = _alvo;
                        x_destino = _alvo.x;
                        y_destino = _alvo.y;
                        if (variable_instance_exists(id, "em_movimento")) {
                            em_movimento = true;
                        }
                    }
                }
            }
        }
    }
    
    // === COMANDAR NAVIOS ===
    with (obj_RonaldReagan) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            if (!variable_instance_exists(id, "alvo") || alvo == noone) {
                var _script_alvos = asset_get_index("scr_ia_detectar_alvos_estrategicos");
                if (_script_alvos != -1) {
                    var _alvo = scr_ia_encontrar_alvo_prioritario();
                    if (_alvo != noone) {
                        alvo = _alvo;
                        x_destino = _alvo.x;
                        y_destino = _alvo.y;
                        if (variable_instance_exists(id, "em_movimento")) {
                            em_movimento = true;
                        }
                    }
                }
            }
        }
    }
}

/// @function scr_ia_comandar_unidade_especifica(_unidade_id, _presidente_id)
/// @description Comanda uma unidade específica
/// @param {id} _unidade_id - ID da unidade
/// @param {id} _presidente_id - ID do presidente
/// @returns {bool} True se comando foi dado

function scr_ia_comandar_unidade_especifica(_unidade_id, _presidente_id) {
    if (!instance_exists(_unidade_id) || !instance_exists(_presidente_id)) return false;
    
    // Verificar se unidade pertence à IA
    if (!variable_instance_exists(_unidade_id, "nacao_proprietaria") || 
        _unidade_id.nacao_proprietaria != 2) {
        return false;
    }
    
    // Encontrar alvo
    var _script_alvos = asset_get_index("scr_ia_detectar_alvos_estrategicos");
    if (_script_alvos != -1) {
        var _alvo = scr_ia_encontrar_alvo_prioritario();
        if (_alvo != noone) {
            _unidade_id.alvo = _alvo;
            _unidade_id.x_destino = _alvo.x;
            _unidade_id.y_destino = _alvo.y;
            if (variable_instance_exists(_unidade_id, "em_movimento")) {
                _unidade_id.em_movimento = true;
            }
            return true;
        }
    }
    
    return false;
}
