// ===============================================
// HEGEMONIA GLOBAL - PATHFINDING ESPECÍFICO POR TERRENO
// Pathfinding que respeita terrenos permitidos
// ===============================================

/// @function scr_pathfinding_terreno_especifico(_unidade_id, _destino_x, _destino_y)
/// @description Calcula caminho respeitando terrenos permitidos da unidade
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _destino_x - Posição X de destino
/// @param {real} _destino_y - Posição Y de destino
/// @returns {array} Array de pontos do caminho ou array vazio

function scr_pathfinding_terreno_especifico(_unidade_id, _destino_x, _destino_y) {
    if (!instance_exists(_unidade_id)) return [];
    
    // Verificar se destino é válido
    if (!scr_unidade_pode_terreno(_unidade_id, _destino_x, _destino_y)) {
        // Tentar encontrar posição válida próxima
        var _pos_valida = scr_encontrar_terra_proxima(_unidade_id, _destino_x, _destino_y);
        if (_pos_valida == noone) {
            return []; // Sem caminho possível
        }
        _destino_x = _pos_valida[0];
        _destino_y = _pos_valida[1];
    }
    
    // Pathfinding simples: linha reta com validação
    var _x_atual = _unidade_id.x;
    var _y_atual = _unidade_id.y;
    
    // Verificar se caminho direto é válido
    if (scr_validar_caminho_terreno(_unidade_id, _x_atual, _y_atual, _destino_x, _destino_y, 20)) {
        // Caminho direto válido
        return [[_destino_x, _destino_y]];
    }
    
    // Caminho direto bloqueado - calcular desvio
    var _caminho_desvio = scr_calcular_desvio_terreno(_unidade_id, _x_atual, _y_atual, _destino_x, _destino_y);
    return _caminho_desvio;
}

/// @function scr_pathfinding_a_star_terreno(_unidade_id, _destino_x, _destino_y)
/// @description Pathfinding A* simplificado respeitando terreno
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _destino_x - Posição X de destino
/// @param {real} _destino_y - Posição Y de destino
/// @returns {array} Array de pontos do caminho

function scr_pathfinding_a_star_terreno(_unidade_id, _destino_x, _destino_y) {
    if (!instance_exists(_unidade_id)) return [];
    
    // Implementação simplificada: usar pathfinding direto se possível
    // Para implementação completa A*, seria necessário usar mp_grid do GameMaker
    
    var _x_atual = _unidade_id.x;
    var _y_atual = _unidade_id.y;
    
    // Se caminho direto é válido, usar
    if (scr_validar_caminho_terreno(_unidade_id, _x_atual, _y_atual, _destino_x, _destino_y, 30)) {
        return [[_destino_x, _destino_y]];
    }
    
    // Caso contrário, usar desvio
    return scr_calcular_desvio_terreno(_unidade_id, _x_atual, _y_atual, _destino_x, _destino_y);
}
