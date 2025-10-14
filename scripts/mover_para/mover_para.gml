function mover_para(xx, yy) {
    destino_x = xx;
    destino_y = yy;
    movendo = true;
    
    // Cria caminho até o destino usando o grid global
    if (variable_global_exists("pathfinding_grid") && global.pathfinding_grid != noone) {
        if (mp_grid_path(global.pathfinding_grid, caminho_atual, x, y, xx, yy, true)) {
            path_start(caminho_atual, velocidade, path_action_stop, false);
        } else {
            // Se não conseguir criar path, move diretamente
            var dir = point_direction(x, y, xx, yy);
            x += lengthdir_x(velocidade, dir);
            y += lengthdir_y(velocidade, dir);
        }
    } else {
        // Se não há grid, move diretamente
        var dir = point_direction(x, y, xx, yy);
        x += lengthdir_x(velocidade, dir);
        y += lengthdir_y(velocidade, dir);
    }
}
