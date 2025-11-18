/// @description Verifica se uma posição (x,y) está em um tile de água
/// @param {real} check_x Coordenada X para verificar
/// @param {real} check_y Coordenada Y para verificar
/// @return {bool} true se for água, false se for terra

/// @function scr_check_water_tile(check_x, check_y)
/// @description Verifica se uma posição está em água (DEPRECATED - usar scr_verificar_agua)
/// @param {real} check_x - Coordenada X
/// @param {real} check_y - Coordenada Y
/// @return {bool} true se for água
/// @deprecated Use scr_verificar_agua() em vez desta função

function scr_check_water_tile(check_x, check_y) {
    // ✅ DEPRECATED: Implementação direta para evitar erro GM1019/GM2039
    // Esta função está obsoleta, mas mantida para compatibilidade
    // Use scr_verificar_agua() em novos códigos
    
    if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
        return false;
    }
    
    if (!variable_global_exists("tile_size")) {
        return false;
    }
    
    // Verificar limites do mapa primeiro
    if (check_x < 0 || check_y < 0 || check_x >= room_width || check_y >= room_height) {
        return false; // Fora dos limites = não é água válida
    }
    
    // Converter posição para tile
    var _tile_size = global.tile_size;
    var _tile_x = floor(check_x / _tile_size);
    var _tile_y = floor(check_y / _tile_size);
    
    // Verificar limites do grid
    if (_tile_x < 0 || _tile_x >= global.map_width || 
        _tile_y < 0 || _tile_y >= global.map_height) {
        return false; // Fora dos limites do grid = não é água
    }
    
    // Obter tile do grid
    var _tile = global.map_grid[_tile_x][_tile_y];
    if (is_undefined(_tile) || is_undefined(_tile.terreno)) {
        return false; // Sem dados = não é água
    }
    
    // ✅ CORREÇÃO: Usar enum TERRAIN diretamente
    return (_tile.terreno == TERRAIN.AGUA);
}
