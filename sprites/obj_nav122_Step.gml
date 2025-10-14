// ========================================
// OBJETO: obj_nav122
// EVENTO: Step
// ========================================

// Movimento com restrição de água
if (moving_to_target) {
    var distance = point_distance(x, y, target_x, target_y);
    
    if (distance > 15) {
        // Calcula próxima posição
        var next_x = x + lengthdir_x(ship_speed, point_direction(x, y, target_x, target_y));
        var next_y = y + lengthdir_y(ship_speed, point_direction(x, y, target_x, target_y));
        
        // Verifica se a próxima posição é água
        if (scr_check_water_area(next_x, next_y, ship_width, ship_height)) {
            // Pode mover - executa movimento
            x = next_x;
            y = next_y;
        } else {
            // Não pode mover - para o navio
            moving_to_target = false;
            show_message("Navio não pode sair da água!");
        }
    } else {
        // Chegou ao destino
        moving_to_target = false;
    }
}
