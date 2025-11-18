// ===============================================
// HEGEMONIA GLOBAL - VERIFICAÇÃO DE ÁGUA
// Verifica se uma posição está em água usando global.map_grid
// ===============================================

/// @function scr_verificar_agua(_x, _y)
/// @description Verifica se posição é água usando global.map_grid
/// @param {real} _x - Posição X
/// @param {real} _y - Posição Y
/// @returns {bool} True se é água, false caso contrário

function scr_verificar_agua(_x, _y) {
    // ✅ CORREÇÃO: Usar APENAS global.map_grid (método confiável)
    if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
        return false;
    }
    
    if (!variable_global_exists("tile_size")) {
        return false;
    }
    
    // Verificar limites do mapa primeiro
    if (_x < 0 || _y < 0 || _x >= room_width || _y >= room_height) {
        return false; // Fora dos limites = não é água válida
    }
    
    // Converter posição para tile
    var _tile_size = global.tile_size;
    var _tile_x = floor(_x / _tile_size);
    var _tile_y = floor(_y / _tile_size);
    
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
