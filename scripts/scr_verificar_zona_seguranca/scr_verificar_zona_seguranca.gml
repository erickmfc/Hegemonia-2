// ===============================================
// HEGEMONIA GLOBAL - ZONA DE SEGURANÇA DA COSTA
// Verifica se um ponto está longe o suficiente da terra
// ===============================================

/// @function scr_verificar_zona_seguranca(_unidade_id, _x, _y, _distancia_minima)
/// @description Verifica se um ponto está dentro da zona de segurança (longe da terra)
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _x - Posição X para verificar
/// @param {real} _y - Posição Y para verificar
/// @param {real} _distancia_minima - Distância mínima da terra em pixels (padrão: 150)
/// @returns {bool} true se está na zona de segurança, false se muito perto da terra

function scr_verificar_zona_seguranca(_unidade_id, _x, _y, _distancia_minima = 150) {
    if (!instance_exists(_unidade_id)) return false;
    
    // Verificar se global.map_grid existe
    if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
        return true; // Se não tem grid, permitir (fallback)
    }
    
    var _tile_size = global.tile_size;
    var _tile_x = floor(_x / _tile_size);
    var _tile_y = floor(_y / _tile_size);
    
    // Calcular quantos tiles verificar ao redor
    var _raio_tiles = ceil(_distancia_minima / _tile_size) + 1;
    
    // Verificar tiles ao redor em círculo
    for (var _dx = -_raio_tiles; _dx <= _raio_tiles; _dx++) {
        for (var _dy = -_raio_tiles; _dy <= _raio_tiles; _dy++) {
            var _dist_tiles = sqrt(_dx * _dx + _dy * _dy);
            var _dist_pixels = _dist_tiles * _tile_size;
            
            // Se está dentro da zona de segurança, verificar se há terra
            if (_dist_pixels <= _distancia_minima) {
                var _tx = _tile_x + _dx;
                var _ty = _tile_y + _dy;
                
                // Verificar limites
                if (_tx >= 0 && _tx < global.map_width && _ty >= 0 && _ty < global.map_height) {
                    var _tile_data = global.map_grid[_tx][_ty];
                    if (!is_undefined(_tile_data) && !is_undefined(_tile_data.terreno)) {
                        var _terreno = _tile_data.terreno;
                        
                        // Se encontrar terra dentro da zona de segurança, retornar false
                        if (_terreno != TERRAIN.AGUA) {
                            return false;
                        }
                    }
                }
            }
        }
    }
    
    // Verificar também o tile atual
    if (_tile_x >= 0 && _tile_x < global.map_width && _tile_y >= 0 && _tile_y < global.map_height) {
        var _tile_data = global.map_grid[_tile_x][_tile_y];
        if (!is_undefined(_tile_data) && !is_undefined(_tile_data.terreno)) {
            var _terreno = _tile_data.terreno;
            if (_terreno != TERRAIN.AGUA) {
                return false;
            }
        }
    }
    
    return true; // Está na zona de segurança
}

/// @function scr_unidade_pode_terreno_com_seguranca(_unidade_id, _x, _y, _distancia_minima)
/// @description Verifica se unidade pode estar no terreno E está na zona de segurança
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _x - Posição X
/// @param {real} _y - Posição Y
/// @param {real} _distancia_minima - Distância mínima da terra (padrão: 150)
/// @returns {bool} true se pode estar e está seguro

function scr_unidade_pode_terreno_com_seguranca(_unidade_id, _x, _y, _distancia_minima = 150) {
    // Primeiro verificar se pode estar no terreno
    if (!scr_unidade_pode_terreno(_unidade_id, _x, _y)) {
        return false;
    }
    
    // Depois verificar zona de segurança
    return scr_verificar_zona_seguranca(_unidade_id, _x, _y, _distancia_minima);
}

