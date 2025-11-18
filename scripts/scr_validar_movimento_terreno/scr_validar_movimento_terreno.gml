// ===============================================
// HEGEMONIA GLOBAL - VALIDAÇÃO DE MOVIMENTO EM TERRENO
// Verifica se unidade pode se mover para posição
// ===============================================

/// @function scr_validar_movimento_terreno(_unidade_id, _destino_x, _destino_y)
/// @description Valida se uma unidade pode se mover para uma posição específica
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _destino_x - Posição X de destino
/// @param {real} _destino_y - Posição Y de destino
/// @returns {bool} True se pode mover, false caso contrário

function scr_validar_movimento_terreno(_unidade_id, _destino_x, _destino_y) {
    if (!instance_exists(_unidade_id)) return false;
    
    // Usar função existente para verificar terreno
    return scr_unidade_pode_terreno(_unidade_id, _destino_x, _destino_y);
}

/// @function scr_validar_caminho_terreno(_unidade_id, _x1, _y1, _x2, _y2, _passos)
/// @description Valida se o caminho entre dois pontos é válido para a unidade
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _x1 - Posição X inicial
/// @param {real} _y1 - Posição Y inicial
/// @param {real} _x2 - Posição X final
/// @param {real} _y2 - Posição Y final
/// @param {int} _passos - Número de pontos intermediários para verificar
/// @returns {bool} True se caminho é válido

function scr_validar_caminho_terreno(_unidade_id, _x1, _y1, _x2, _y2, _passos = 10) {
    if (!instance_exists(_unidade_id)) return false;
    
    // Verificar pontos intermediários
    for (var i = 0; i <= _passos; i++) {
        var _t = i / _passos;
        var _x = lerp(_x1, _x2, _t);
        var _y = lerp(_y1, _y2, _t);
        
        if (!scr_unidade_pode_terreno(_unidade_id, _x, _y)) {
            return false; // Caminho bloqueado
        }
    }
    
    return true; // Caminho válido
}

/// @function scr_validar_caminho_terreno_com_seguranca(_unidade_id, _x1, _y1, _x2, _y2, _passos, _distancia_minima)
/// @description Valida caminho considerando zona de segurança da costa
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _x1 - Posição X inicial
/// @param {real} _y1 - Posição Y inicial
/// @param {real} _x2 - Posição X destino
/// @param {real} _y2 - Posição Y destino
/// @param {real} _passos - Número de pontos a verificar (padrão: 10)
/// @param {real} _distancia_minima - Distância mínima da terra (padrão: 150)
/// @returns {bool} true se caminho é válido e seguro

function scr_validar_caminho_terreno_com_seguranca(_unidade_id, _x1, _y1, _x2, _y2, _passos = 10, _distancia_minima = 150) {
    if (!instance_exists(_unidade_id)) return false;
    
    // ✅ CORREÇÃO: Verificar se função existe antes de usar (fallback se não estiver disponível)
    var _funcao_seguranca_existe = script_exists(asset_get_index("scr_unidade_pode_terreno_com_seguranca"));
    
    // Verificar pontos ao longo do caminho
    for (var i = 0; i <= _passos; i++) {
        var _t = i / _passos;
        var _check_x = lerp(_x1, _x2, _t);
        var _check_y = lerp(_y1, _y2, _t);
        
        // Verificar se ponto está na zona de segurança (com fallback)
        var _ponto_valido = true;
        if (_funcao_seguranca_existe) {
            _ponto_valido = scr_unidade_pode_terreno_com_seguranca(_unidade_id, _check_x, _check_y, _distancia_minima);
        } else {
            // Fallback: usar verificação básica
            _ponto_valido = scr_unidade_pode_terreno(_unidade_id, _check_x, _check_y);
        }
        
        if (!_ponto_valido) {
            return false; // Caminho bloqueado ou muito perto da terra
        }
    }
    
    return true; // Caminho válido e seguro
}
