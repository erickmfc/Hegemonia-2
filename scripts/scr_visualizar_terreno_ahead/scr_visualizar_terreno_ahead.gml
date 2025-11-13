/// @description Verifica terreno à frente em múltiplos pontos para visualização antecipada
/// @param {real} _unidade_id ID da unidade
/// @param {real} _direcao Direção do movimento
/// @param {real} _distancia_ahead Distância à frente para verificar (padrão: 100)
/// @return {struct} {pode_passar: bool, terreno_ahead: enum, distancia_segura: real}

function scr_visualizar_terreno_ahead(_unidade_id, _direcao, _distancia_ahead = 100) {
    if (!instance_exists(_unidade_id)) {
        return {pode_passar: false, terreno_ahead: undefined, distancia_segura: 0};
    }
    
    var _x = _unidade_id.x;
    var _y = _unidade_id.y;
    
    // Verificar múltiplos pontos à frente
    var _pontos_verificar = 5;
    var _distancia_incremento = _distancia_ahead / _pontos_verificar;
    var _distancia_segura = _distancia_ahead;
    var _pode_passar = true;
    var _terreno_ahead = undefined;
    
    for (var i = 1; i <= _pontos_verificar; i++) {
        var _dist_check = _distancia_incremento * i;
        var _x_check = _x + lengthdir_x(_dist_check, _direcao);
        var _y_check = _y + lengthdir_y(_dist_check, _direcao);
        
        if (!scr_unidade_pode_terreno(_unidade_id, _x_check, _y_check)) {
            _pode_passar = false;
            _distancia_segura = _dist_check - _distancia_incremento;
            
            // Obter terreno à frente para debug
            if (variable_global_exists("tile_size") && variable_global_exists("map_grid")) {
                var _tile_size = global.tile_size;
                var _tile_x = floor(_x_check / _tile_size);
                var _tile_y = floor(_y_check / _tile_size);
                
                if (_tile_x >= 0 && _tile_x < global.map_width && 
                    _tile_y >= 0 && _tile_y < global.map_height) {
                    var _tile_data = global.map_grid[_tile_x][_tile_y];
                    if (!is_undefined(_tile_data)) {
                        _terreno_ahead = _tile_data.terreno;
                    }
                }
            }
            
            break;
        }
    }
    
    return {
        pode_passar: _pode_passar,
        terreno_ahead: _terreno_ahead,
        distancia_segura: _distancia_segura
    };
}
