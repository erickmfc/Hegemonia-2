// ===============================================
// HEGEMONIA GLOBAL - PATHFINDING EM ÁGUA
// Encontra caminho válido para unidades navais
// ===============================================

/// @function scr_encontrar_caminho_agua(_unidade_id, _destino_x, _destino_y)
/// @description Encontra caminho válido em água para unidade naval
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _destino_x - Posição X de destino
/// @param {real} _destino_y - Posição Y de destino
/// @returns {array} Array de pontos do caminho ou array vazio

function scr_encontrar_caminho_agua(_unidade_id, _destino_x, _destino_y) {
    if (!instance_exists(_unidade_id)) return [];
    
    // Verificar se destino é válido para terreno naval (água)
    if (!scr_unidade_pode_terreno(_unidade_id, _destino_x, _destino_y)) {
        // Tentar encontrar água próxima
        var _agua_proxima = scr_encontrar_agua_proxima(_destino_x, _destino_y, 500);
        if (_agua_proxima == noone || array_length(_agua_proxima) < 2) {
            return []; // Sem caminho possível
        }
        _destino_x = _agua_proxima[0];
        _destino_y = _agua_proxima[1];
    }
    
    // Verificar se caminho direto é válido (todos os pontos em água)
    if (scr_validar_caminho_terreno(_unidade_id, _unidade_id.x, _unidade_id.y, _destino_x, _destino_y, 20)) {
        // Caminho direto válido
        return [[_destino_x, _destino_y]];
    }
    
    // Caminho direto bloqueado - usar pathfinding específico
    var _caminho = scr_pathfinding_terreno_especifico(_unidade_id, _destino_x, _destino_y);
    return _caminho;
}

/// @function scr_encontrar_caminho_agua_com_grid(_unidade_id, _destino_x, _destino_y)
/// @description Encontra caminho usando grid de pathfinding naval (se disponível)
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _destino_x - Posição X de destino
/// @param {real} _destino_y - Posição Y de destino
/// @returns {array} Array de pontos do caminho ou array vazio

function scr_encontrar_caminho_agua_com_grid(_unidade_id, _destino_x, _destino_y) {
    if (!instance_exists(_unidade_id)) return [];
    
    // ✅ CORREÇÃO: Verificar se grid naval existe e é mp_grid
    if (!variable_global_exists("grid_pathfinding_naval") || 
        !mp_grid_exists(global.grid_pathfinding_naval)) {
        // Fallback: usar método simples
        return scr_encontrar_caminho_agua(_unidade_id, _destino_x, _destino_y);
    }
    
    var _grid = global.grid_pathfinding_naval;
    
    // ✅ CORREÇÃO: Verificar se destino é válido usando mp_grid
    if (mp_grid_get_cell(_grid, _destino_x, _destino_y) == 1) {
        // Destino é obstáculo (não é água) - encontrar água próxima
        var _agua_proxima = scr_encontrar_agua_proxima(_destino_x, _destino_y, 500);
        if (_agua_proxima == noone || array_length(_agua_proxima) < 2) {
            return [];
        }
        _destino_x = _agua_proxima[0];
        _destino_y = _agua_proxima[1];
    }
    
    // ✅ CORREÇÃO: Usar mp_grid_path() para calcular caminho
    var _path = path_add();
    if (mp_grid_path(_grid, _path, _unidade_id.x, _unidade_id.y, _destino_x, _destino_y, true)) {
        // Converter path para array de pontos
        var _caminho = [];
        var _path_length = path_get_length(_path);
        var _num_points = max(1, floor(_path_length / 20)); // Um ponto a cada 20 pixels
        
        for (var i = 0; i <= _num_points; i++) {
            var _t = (_num_points > 0) ? (i / _num_points) : 0;
            var _px = path_get_x(_path, _t * _path_length);
            var _py = path_get_y(_path, _t * _path_length);
            array_push(_caminho, [_px, _py]);
        }
        
        path_delete(_path);
        return _caminho;
    } else {
        // Caminho não encontrado - usar método alternativo
        path_delete(_path);
        return scr_encontrar_caminho_agua(_unidade_id, _destino_x, _destino_y);
    }
}
