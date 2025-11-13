/// @description Encontra a posição de água mais próxima usando global.map_grid
/// @param {real} target_x Coordenada X alvo
/// @param {real} target_y Coordenada Y alvo
/// @param {real} max_radius Raio máximo de busca
/// @return {array} [x, y] da posição encontrada ou [-1, -1] se não encontrar

function scr_find_nearest_water(target_x, target_y, max_radius = 200) {
    // === VERIFICAÇÕES DE SEGURANÇA ===
    if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
        return [-1, -1];
    }
    
    if (!variable_global_exists("tile_size") || !variable_global_exists("map_width") || !variable_global_exists("map_height")) {
        return [-1, -1];
    }
    
    var _tile_size = global.tile_size;
    var _tile_x = floor(target_x / _tile_size);
    var _tile_y = floor(target_y / _tile_size);
    
    var best_distance = max_radius;
    var best_x = -1;
    var best_y = -1;
    
    // Busca em círculo ao redor da posição alvo usando o grid real
    var _max_radius_tiles = ceil(max_radius / _tile_size);
    
    for (var radius = 0; radius <= _max_radius_tiles; radius++) {
        for (var angle = 0; angle < 360; angle += 15) {
            var check_tile_x = _tile_x + round(lengthdir_x(radius, angle));
            var check_tile_y = _tile_y + round(lengthdir_y(radius, angle));
            
            // Verificar limites
            if (check_tile_x < 0 || check_tile_x >= global.map_width || check_tile_y < 0 || check_tile_y >= global.map_height) {
                continue;
            }
            
            // Verificar no grid real
            if (check_tile_x >= array_length(global.map_grid)) continue;
            if (check_tile_y >= array_length(global.map_grid[check_tile_x])) continue;
            
            var _tile_data = global.map_grid[check_tile_x][check_tile_y];
            if (is_undefined(_tile_data)) continue;
            
            var _terreno = _tile_data.terreno;
            if (is_undefined(_terreno)) continue;
            
            // Verificar se é água real
            if (_terreno == TERRAIN.AGUA) {
                var world_x = check_tile_x * _tile_size + _tile_size / 2;
                var world_y = check_tile_y * _tile_size + _tile_size / 2;
                var distance = point_distance(target_x, target_y, world_x, world_y);
                
                if (distance < best_distance) {
                    best_distance = distance;
                    best_x = world_x;
                    best_y = world_y;
                }
            }
        }
        
        // Se encontrou uma posição válida, retorna
        if (best_x != -1) {
            return [best_x, best_y];
        }
    }
    
    return [-1, -1]; // Não encontrou posição de água
}