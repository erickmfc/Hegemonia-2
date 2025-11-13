/// @description Verifica se uma unidade pode estar em um terreno específico
/// @param {real} _unidade_id ID da unidade
/// @param {real} _pos_x Posição X para verificar
/// @param {real} _pos_y Posição Y para verificar
/// @return {bool} true se pode estar no terreno, false caso contrário

function scr_unidade_pode_terreno(_unidade_id, _pos_x, _pos_y) {
    if (!instance_exists(_unidade_id)) return false;
    
    // Verificar se global.map_grid existe
    if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
        return true; // Se não tem grid, permitir (fallback)
    }
    
    // Converter posição para tile
    var _tile_size = global.tile_size;
    var _tile_x = floor(_pos_x / _tile_size);
    var _tile_y = floor(_pos_y / _tile_size);
    
    // Verificar limites
    if (_tile_x < 0 || _tile_x >= global.map_width || 
        _tile_y < 0 || _tile_y >= global.map_height) {
        return false;
    }
    
    // Obter terreno no tile
    var _tile_data = global.map_grid[_tile_x][_tile_y];
    if (is_undefined(_tile_data) || is_undefined(_tile_data.terreno)) {
        return true; // Se não tem dados, permitir (fallback)
    }
    
    var _terreno_no_tile = _tile_data.terreno;
    
    // Obter terrenos permitidos da unidade
    var _terrenos_permitidos = [];
    
    if (variable_instance_exists(_unidade_id, "terrenos_permitidos")) {
        _terrenos_permitidos = _unidade_id.terrenos_permitidos;
    } else {
        // Valores padrão baseados no tipo de unidade
        var _obj_name = object_get_name(_unidade_id.object_index);
        
        // Navios e submarinos: só água
        if (string_pos("lancha", _obj_name) > 0 || 
            string_pos("navio", _obj_name) > 0 || 
            string_pos("submarino", _obj_name) > 0 ||
            string_pos("Constellation", _obj_name) > 0 ||
            string_pos("Independence", _obj_name) > 0 ||
            string_pos("RonaldReagan", _obj_name) > 0 ||
            string_pos("Hendrick", _obj_name) > 0) {
            _terrenos_permitidos = [TERRAIN.AGUA];
        }
        // Tanques: terra, deserto (não floresta)
        else if (string_pos("tanque", _obj_name) > 0 || 
                 string_pos("M1A", _obj_name) > 0 ||
                 string_pos("blindado", _obj_name) > 0) {
            _terrenos_permitidos = [TERRAIN.CAMPO, TERRAIN.DESERTO];
        }
        // Outras unidades terrestres: terra, deserto, floresta
        else {
            _terrenos_permitidos = [TERRAIN.CAMPO, TERRAIN.FLORESTA, TERRAIN.DESERTO];
        }
    }
    
    // Verificar se o terreno está na lista de permitidos
    for (var i = 0; i < array_length(_terrenos_permitidos); i++) {
        if (_terrenos_permitidos[i] == _terreno_no_tile) {
            return true;
        }
    }
    
    return false; // Terreno não permitido
}
