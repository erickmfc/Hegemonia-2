// ===============================================
// HEGEMONIA GLOBAL - ENCONTRAR ÁGUA PRÓXIMA
// Encontra posição de água mais próxima
// ===============================================

/// @function scr_encontrar_agua_proxima(_x, _y, _raio_maximo)
/// @description Encontra posição de água mais próxima
/// @param {real} _x - Posição X de referência
/// @param {real} _y - Posição Y de referência
/// @param {real} _raio_maximo - Raio máximo de busca (padrão: 1000)
/// @returns {array} [x, y] da água próxima ou noone

function scr_encontrar_agua_proxima(_x, _y, _raio_maximo = 1000) {
    
    if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
        return noone;
    }
    
    var _tile_size = global.tile_size;
    var _tile_x = floor(_x / _tile_size);
    var _tile_y = floor(_y / _tile_size);
    
    var _menor_dist = 999999;
    var _agua_proxima = noone;
    
    // Buscar em espiral ao redor da posição
    var _raio_busca = 1;
    var _max_raio = floor(_raio_maximo / _tile_size);
    
    while (_raio_busca <= _max_raio) {
        for (var _dx = -_raio_busca; _dx <= _raio_busca; _dx++) {
            for (var _dy = -_raio_busca; _dy <= _raio_busca; _dy++) {
                // Verificar apenas bordas do quadrado (não o interior)
                if (abs(_dx) != _raio_busca && abs(_dy) != _raio_busca) continue;
                
                var _tx = _tile_x + _dx;
                var _ty = _tile_y + _dy;
                
                // Verificar limites
                if (_tx < 0 || _tx >= global.map_width || _ty < 0 || _ty >= global.map_height) {
                    continue;
                }
                
                var _tile = global.map_grid[_tx][_ty];
                if (!is_undefined(_tile) && !is_undefined(_tile.terreno)) {
                    var _terreno = _tile.terreno;
                    // ✅ CORREÇÃO: Usar enum TERRAIN em vez de strings
                    if (_terreno == TERRAIN.AGUA) {
                        var _px = _tx * _tile_size + _tile_size / 2;
                        var _py = _ty * _tile_size + _tile_size / 2;
                        var _dist = point_distance(_x, _y, _px, _py);
                        
                        if (_dist < _menor_dist) {
                            _menor_dist = _dist;
                            _agua_proxima = [_px, _py];
                        }
                    }
                }
            }
        }
        
        // Se encontrou água, retornar
        if (_agua_proxima != noone) {
            return _agua_proxima;
        }
        
        _raio_busca++;
    }
    
    return _agua_proxima;
}

/// @function scr_encontrar_agua_para_unidade(_unidade_id, _raio_maximo)
/// @description Encontra água próxima para unidade naval
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _raio_maximo - Raio máximo de busca
/// @returns {array} [x, y] da água ou noone

function scr_encontrar_agua_para_unidade(_unidade_id, _raio_maximo = 1000) {
    if (!instance_exists(_unidade_id)) return noone;
    return scr_encontrar_agua_proxima(_unidade_id.x, _unidade_id.y, _raio_maximo);
}
