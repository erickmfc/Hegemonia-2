// ===============================================
// HEGEMONIA GLOBAL - ENCONTRAR TERRA PRÓXIMA
// Encontra posição de terra válida mais próxima para unidade
// ===============================================

/// @function scr_encontrar_terra_proxima(_unidade_id, _x, _y, _raio_maximo)
/// @description Encontra posição de terra válida mais próxima para a unidade
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _x - Posição X de referência
/// @param {real} _y - Posição Y de referência
/// @param {real} _raio_maximo - Raio máximo de busca (padrão: 500)
/// @returns {array} [x, y] da terra próxima ou noone

function scr_encontrar_terra_proxima(_unidade_id, _x, _y, _raio_maximo = 500) {
    if (!instance_exists(_unidade_id)) return noone;
    
    if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
        return [_x, _y]; // Fallback: retornar posição original
    }
    
    var _tile_size = global.tile_size;
    var _tile_x = floor(_x / _tile_size);
    var _tile_y = floor(_y / _tile_size);
    
    var _menor_dist = 999999;
    var _terra_proxima = noone;
    
    // Buscar em espiral ao redor da posição
    var _raio_busca = 1;
    var _max_raio = floor(_raio_maximo / _tile_size);
    
    while (_raio_busca <= _max_raio) {
        for (var _dx = -_raio_busca; _dx <= _raio_busca; _dx++) {
            for (var _dy = -_raio_busca; _dy <= _raio_busca; _dy++) {
                // Verificar apenas bordas do quadrado
                if (_raio_busca > 1 && abs(_dx) != _raio_busca && abs(_dy) != _raio_busca) continue;
                
                var _tx = _tile_x + _dx;
                var _ty = _tile_y + _dy;
                
                // Verificar limites
                if (_tx < 0 || _tx >= global.map_width || _ty < 0 || _ty >= global.map_height) {
                    continue;
                }
                
                var _px = _tx * _tile_size + _tile_size / 2;
                var _py = _ty * _tile_size + _tile_size / 2;
                
                // Verificar se unidade pode estar neste terreno
                if (scr_unidade_pode_terreno(_unidade_id, _px, _py)) {
                    var _dist = point_distance(_x, _y, _px, _py);
                    
                    if (_dist < _menor_dist) {
                        _menor_dist = _dist;
                        _terra_proxima = [_px, _py];
                    }
                }
            }
        }
        
        // Se encontrou terra válida, retornar
        if (_terra_proxima != noone) {
            return _terra_proxima;
        }
        
        _raio_busca++;
    }
    
    // Se não encontrou, retornar posição original (fallback)
    if (_terra_proxima == noone) {
        return [_x, _y];
    }
    
    return _terra_proxima;
}

/// @function scr_encontrar_terra_para_unidade(_unidade_id, _raio_maximo)
/// @description Encontra terra próxima para unidade (usa posição atual)
/// @param {id} _unidade_id - ID da unidade
/// @param {real} _raio_maximo - Raio máximo de busca
/// @returns {array} [x, y] da terra ou noone

function scr_encontrar_terra_para_unidade(_unidade_id, _raio_maximo = 500) {
    if (!instance_exists(_unidade_id)) return noone;
    return scr_encontrar_terra_proxima(_unidade_id, _unidade_id.x, _unidade_id.y, _raio_maximo);
}
