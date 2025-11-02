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