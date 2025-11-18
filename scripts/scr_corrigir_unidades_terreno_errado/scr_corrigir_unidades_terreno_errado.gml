// ===============================================
// HEGEMONIA GLOBAL - CORRIGIR UNIDADES EM TERRENO ERRADO
// Move unidades que estão em terreno inválido
// ===============================================

/// @function scr_corrigir_unidades_terreno_errado()
/// @description Encontra e corrige unidades em terreno inválido
/// @returns {int} Número de unidades corrigidas

function scr_corrigir_unidades_terreno_errado() {
    var _unidades_corrigidas = 0;
    
    // === CORRIGIR UNIDADES TERRESTRES ===
    with (obj_infantaria) {
        if (!scr_unidade_pode_terreno(id, x, y)) {
            var _pos_valida = scr_encontrar_terra_proxima(id, x, y, 300);
            if (_pos_valida != noone) {
                x = _pos_valida[0];
                y = _pos_valida[1];
                _unidades_corrigidas++;
                
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🔧 Infantaria corrigida: movida para terreno válido");
                }
            }
        }
    }
    
    with (obj_tanque) {
        if (!scr_unidade_pode_terreno(id, x, y)) {
            var _pos_valida = scr_encontrar_terra_proxima(id, x, y, 300);
            if (_pos_valida != noone) {
                x = _pos_valida[0];
                y = _pos_valida[1];
                _unidades_corrigidas++;
                
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🔧 Tanque corrigido: movido para terreno válido");
                }
            }
        }
    }
    
    // === CORRIGIR UNIDADES NAVALS ===
    with (obj_lancha_patrulha) {
        if (!scr_unidade_pode_terreno(id, x, y)) {
            var _pos_valida = scr_encontrar_agua_proxima(x, y, 500);
            if (_pos_valida != noone) {
                x = _pos_valida[0];
                y = _pos_valida[1];
                _unidades_corrigidas++;
                
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🔧 Lancha corrigida: movida para água");
                }
            }
        }
    }
    
    with (obj_RonaldReagan) {
        if (!scr_unidade_pode_terreno(id, x, y)) {
            var _pos_valida = scr_encontrar_agua_proxima(x, y, 500);
            if (_pos_valida != noone) {
                x = _pos_valida[0];
                y = _pos_valida[1];
                _unidades_corrigidas++;
                
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🔧 Navio corrigido: movido para água");
                }
            }
        }
    }
    
    with (obj_Independence) {
        if (!scr_unidade_pode_terreno(id, x, y)) {
            var _pos_valida = scr_encontrar_agua_proxima(x, y, 500);
            if (_pos_valida != noone) {
                x = _pos_valida[0];
                y = _pos_valida[1];
                _unidades_corrigidas++;
            }
        }
    }
    
    with (obj_Constellation) {
        if (!scr_unidade_pode_terreno(id, x, y)) {
            var _pos_valida = scr_encontrar_agua_proxima(x, y, 500);
            if (_pos_valida != noone) {
                x = _pos_valida[0];
                y = _pos_valida[1];
                _unidades_corrigidas++;
            }
        }
    }
    
    with (obj_submarino_base) {
        if (!scr_unidade_pode_terreno(id, x, y)) {
            var _pos_valida = scr_encontrar_agua_proxima(x, y, 500);
            if (_pos_valida != noone) {
                x = _pos_valida[0];
                y = _pos_valida[1];
                _unidades_corrigidas++;
            }
        }
    }
    
    if (_unidades_corrigidas > 0 && variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("✅ " + string(_unidades_corrigidas) + " unidades corrigidas de terreno inválido");
    }
    
    return _unidades_corrigidas;
}

/// @function scr_corrigir_unidade_especifica(_unidade_id)
/// @description Corrige uma unidade específica
/// @param {id} _unidade_id - ID da unidade
/// @returns {bool} True se foi corrigida

function scr_corrigir_unidade_especifica(_unidade_id) {
    if (!instance_exists(_unidade_id)) return false;
    
    if (!scr_unidade_pode_terreno(_unidade_id, _unidade_id.x, _unidade_id.y)) {
        // Determinar tipo de unidade
        // ✅ CORREÇÃO: Usar função centralizada para identificar tipo de unidade
        // ✅ SEGURANÇA: Verificar se script existe antes de chamar
        var _script_id = asset_get_index("scr_identificar_tipo_unidade_terreno");
        var _eh_naval = false;
        
        if (_script_id != -1) {
            _eh_naval = scr_unidade_eh_naval(_unidade_id);
        } else {
            // ✅ FALLBACK: Verificação básica se script não existe
            var _obj_name = object_get_name(_unidade_id.object_index);
            _eh_naval = (string_pos("lancha", _obj_name) > 0 || string_pos("navio", _obj_name) > 0 || 
                        string_pos("submarino", _obj_name) > 0 || string_pos("Constellation", _obj_name) > 0 ||
                        string_pos("Independence", _obj_name) > 0 || string_pos("RonaldReagan", _obj_name) > 0);
        }
        
        if (_eh_naval) {
            
            var _pos_valida = scr_encontrar_agua_proxima(_unidade_id.x, _unidade_id.y, 500);
            if (_pos_valida != noone) {
                _unidade_id.x = _pos_valida[0];
                _unidade_id.y = _pos_valida[1];
                return true;
            }
        } else {
            // Terrestre ou aérea, buscar terra válida
            var _pos_valida = scr_encontrar_terra_proxima(_unidade_id, _unidade_id.x, _unidade_id.y, 300);
            if (_pos_valida != noone) {
                _unidade_id.x = _pos_valida[0];
                _unidade_id.y = _pos_valida[1];
                return true;
            }
        }
    }
    
    return false;
}

