/// @description Método de movimento inteligente com pathfinding
/// @return true se chegou ao destino, false se ainda está se movendo

// Sistema de pathfinding melhorado com validação
if (path == noone) {
    if (timer_verificacao_pathfinding <= 0) {
        // Verificar se o grid de pathfinding existe
        if (global.pathfinding_grid != noone) {
            path = path_add();
            var path_found = mp_grid_path(global.pathfinding_grid, path, x, y, destino_x, destino_y, true);
            
            if (path_found && path_get_number(path) > 0) {
                path_start(path, velocidade, path_action_stop, true);
                if (global.debug_enabled) {
                    show_debug_message("Unidade: Rota calculada com sucesso para (" + string(destino_x) + ", " + string(destino_y) + ")");
                }
            } else {
                // Se não encontrou caminho, tenta movimento direto
                path_delete(path);
                path = noone;
                if (global.debug_enabled) {
                    show_debug_message("Unidade: Caminho não encontrado, usando movimento direto");
                }
            }
        } else {
            // Se não há grid, usa movimento direto
            if (global.debug_enabled) {
                show_debug_message("Unidade: Grid não disponível, usando movimento direto");
            }
        }
        timer_verificacao_pathfinding = 60; // Recalcula a cada 60 frames (1 segundo)
    } else {
        timer_verificacao_pathfinding--;
    }
}

// Se tem um caminho válido, verifica se chegou ao fim
if (path != noone && path_position >= 1) {
    path_delete(path);
    path = noone;
    return true; // Chegou ao destino
} else if (path == noone) {
    // Movimento direto quando não há pathfinding
    var dist = point_distance(x, y, destino_x, destino_y);
    if (dist > 5) {
        var dir = point_direction(x, y, destino_x, destino_y);
        x += lengthdir_x(velocidade, dir);
        y += lengthdir_y(velocidade, dir);
        image_angle = dir;
    } else {
        return true; // Chegou ao destino
    }
}
return false; // Ainda está se movendo

