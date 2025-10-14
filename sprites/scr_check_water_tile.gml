/// @description Verifica se uma posição (x,y) está em um tile de água
/// @param {real} check_x Coordenada X para verificar
/// @param {real} check_y Coordenada Y para verificar
/// @return {bool} true se for água, false se for terra

function scr_check_water_tile(check_x, check_y) {
    // Converte coordenadas do mundo para coordenadas de tile
    // Tiles têm 90x32 pixels conforme análise dos sprites
    var tile_x = floor(check_x / 90);
    var tile_y = floor(check_y / 32);
    
    // Verifica colisão com sprite de água
    // Usa collision_point para detectar o sprite específico
    if (collision_point(check_x, check_y, spr_terreno_agua, false, true)) {
        return true;
    }
    
    // Alternativa: se usar tilemap, descomente as linhas abaixo
    // var tile_id = layer_tilemap_get_id_at(terrain_layer, tile_x, tile_y);
    // return (tile_id == spr_terreno_agua);
    
    return false;
}

/// @description Verifica se uma área é segura para navios (múltiplos pontos)
/// @param {real} center_x Coordenada X central
/// @param {real} center_y Coordenada Y central
/// @param {real} ship_width Largura do navio
/// @param {real} ship_height Altura do navio
/// @return {bool} true se toda a área for água

function scr_check_water_area(center_x, center_y, ship_width, ship_height) {
    // Verifica múltiplos pontos do navio para garantir que toda a área seja água
    var check_points = [
        // Centro
        [center_x, center_y],
        // Cantos
        [center_x - ship_width/2, center_y - ship_height/2],
        [center_x + ship_width/2, center_y - ship_height/2],
        [center_x - ship_width/2, center_y + ship_height/2],
        [center_x + ship_width/2, center_y + ship_height/2],
        // Pontos médios
        [center_x, center_y - ship_height/2],
        [center_x, center_y + ship_height/2],
        [center_x - ship_width/2, center_y],
        [center_x + ship_width/2, center_y]
    ];
    
    // Verifica se todos os pontos são água
    for (var i = 0; i < array_length(check_points); i++) {
        if (!scr_check_water_tile(check_points[i][0], check_points[i][1])) {
            return false;
        }
    }
    
    return true;
}

/// @description Encontra a posição de água mais próxima
/// @param {real} target_x Coordenada X alvo
/// @param {real} target_y Coordenada Y alvo
/// @param {real} max_radius Raio máximo de busca
/// @return {array} [x, y] da posição encontrada ou [-1, -1] se não encontrar

function scr_find_nearest_water(target_x, target_y, max_radius = 200) {
    var best_distance = max_radius;
    var best_x = -1;
    var best_y = -1;
    
    // Busca em círculo ao redor da posição alvo
    for (var radius = 0; radius < max_radius; radius += 10) {
        for (var angle = 0; angle < 360; angle += 15) {
            var check_x = target_x + lengthdir_x(radius, angle);
            var check_y = target_y + lengthdir_y(radius, angle);
            
            if (scr_check_water_tile(check_x, check_y)) {
                var distance = point_distance(target_x, target_y, check_x, check_y);
                if (distance < best_distance) {
                    best_distance = distance;
                    best_x = check_x;
                    best_y = check_y;
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

/// @description Verifica se uma posição é válida para construção naval
/// @param {real} build_x Coordenada X para construção
/// @param {real} build_y Coordenada Y para construção
/// @param {real} building_width Largura do edifício
/// @param {real} building_height Altura do edifício
/// @return {bool} true se pode construir, false se não pode

function scr_can_build_on_water(build_x, build_y, building_width, building_height) {
    // Verifica se toda a área do edifício está em água
    return scr_check_water_area(build_x, build_y, building_width, building_height);
}