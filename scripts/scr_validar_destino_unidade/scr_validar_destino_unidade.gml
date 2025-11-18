// ===============================================
// HEGEMONIA GLOBAL - VALIDAÇÃO DE DESTINO DE UNIDADE
// Valida se destino é acessível para a unidade
// ===============================================

/// @function scr_validar_destino_unidade(_unidade_id, _destino_x, _destino_y)
/// @description Valida se destino é válido e acessível para a unidade
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _destino_x - Posição X de destino
/// @param {real} _destino_y - Posição Y de destino
/// @returns {struct} Estrutura com resultado da validação

function scr_validar_destino_unidade(_unidade_id, _destino_x, _destino_y) {
    var _resultado = {
        valido: false,
        pode_terreno: false,
        pode_alcancar: false,
        distancia: 0,
        posicao_alternativa: noone,
        motivo: ""
    };
    
    if (!instance_exists(_unidade_id)) {
        _resultado.motivo = "Unidade não existe";
        return _resultado;
    }
    
    // Calcular distância
    _resultado.distancia = point_distance(_unidade_id.x, _unidade_id.y, _destino_x, _destino_y);
    
    // Verificar se pode estar no terreno
    _resultado.pode_terreno = scr_unidade_pode_terreno(_unidade_id, _destino_x, _destino_y);
    
    if (!_resultado.pode_terreno) {
        // Tentar encontrar posição alternativa próxima
        _resultado.posicao_alternativa = scr_encontrar_terra_proxima(_unidade_id, _destino_x, _destino_y);
        if (_resultado.posicao_alternativa != noone) {
            _resultado.motivo = "Destino inválido, posição alternativa encontrada";
            _resultado.destino_x_alternativo = _resultado.posicao_alternativa[0];
            _resultado.destino_y_alternativo = _resultado.posicao_alternativa[1];
        } else {
            _resultado.motivo = "Destino inválido e sem alternativa próxima";
            return _resultado;
        }
    }
    
    // Verificar se pode alcançar (caminho válido)
    _resultado.pode_alcancar = scr_validar_caminho_terreno(_unidade_id, _unidade_id.x, _unidade_id.y, 
                                                           _destino_x, _destino_y, 20);
    
    if (!_resultado.pode_alcancar) {
        // Tentar calcular desvio
        var _caminho_desvio = scr_calcular_desvio_terreno(_unidade_id, _unidade_id.x, _unidade_id.y, 
                                                          _destino_x, _destino_y);
        if (array_length(_caminho_desvio) > 0) {
            _resultado.pode_alcancar = true;
            _resultado.motivo = "Caminho direto bloqueado, mas desvio possível";
            _resultado.caminho_desvio = _caminho_desvio;
        } else {
            _resultado.motivo = "Destino não alcançável (caminho bloqueado)";
            return _resultado;
        }
    }
    
    // Se chegou aqui, destino é válido
    _resultado.valido = true;
    _resultado.motivo = "Destino válido e acessível";
    
    return _resultado;
}

/// @function scr_validar_destino_simples(_unidade_id, _destino_x, _destino_y)
/// @description Validação simples (apenas terreno)
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _destino_x - Posição X de destino
/// @param {real} _destino_y - Posição Y de destino
/// @returns {bool} True se válido

function scr_validar_destino_simples(_unidade_id, _destino_x, _destino_y) {
    if (!instance_exists(_unidade_id)) return false;
    return scr_unidade_pode_terreno(_unidade_id, _destino_x, _destino_y);
}
