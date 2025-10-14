/// @description Método de patrulha inteligente com pathfinding
/// @return true se está patrulhando, false se parou

// Sistema de patrulha com pathfinding inteligente
if (patrolling && ds_list_size(patrol_points) > 0) {
    var target = patrol_points[| patrol_index];
    var tx = target[0];
    var ty = target[1];
    
    // Verificar se chegou ao ponto atual
    if (point_distance(x, y, tx, ty) <= 8) {
        // Chegou ao ponto -> ir para o próximo
        patrol_index += 1;
        if (patrol_index >= ds_list_size(patrol_points)) {
            patrol_index = 0; // reinicia no primeiro ponto (loop infinito)
        }
        
        // Limpar path atual para recalcular
        if (path != noone) {
            path_delete(path);
            path = noone;
        }
        
        if (global.debug_enabled) {
            show_debug_message("Unidade: Chegou ao ponto de patrulha, indo para o próximo");
        }
    } else {
        // Usar pathfinding para ir ao ponto de patrulha
        if (path == noone) {
            if (timer_verificacao_pathfinding <= 0) {
                if (global.pathfinding_grid != noone) {
                    path = path_add();
                    var path_found = mp_grid_path(global.pathfinding_grid, path, x, y, tx, ty, true);
                    
                    if (path_found && path_get_number(path) > 0) {
                        path_start(path, velocidade, path_action_stop, true);
                        if (global.debug_enabled) {
                            show_debug_message("Unidade: Rota de patrulha calculada");
                        }
                    } else {
                        // Se não encontrou caminho, usa movimento direto
                        path_delete(path);
                        path = noone;
                        if (global.debug_enabled) {
                            show_debug_message("Unidade: Caminho de patrulha não encontrado, usando movimento direto");
                        }
                    }
                }
                timer_verificacao_pathfinding = 90; // Recalcula a cada 90 frames (1.5 segundos)
            } else {
                timer_verificacao_pathfinding--;
            }
        }
        
        // Se não tem path, usa movimento direto
        if (path == noone) {
            var dir = point_direction(x, y, tx, ty);
            x += lengthdir_x(velocidade, dir);
            y += lengthdir_y(velocidade, dir);
            image_angle = dir;
        }
    }
    return true; // Está patrulhando
} else {
    // Se não há pontos, para de patrulhar
    patrolling = false;
    if (global.debug_enabled) {
        show_debug_message("Unidade: Patrulha cancelada - sem pontos");
    }
    return false; // Não está patrulhando
}

