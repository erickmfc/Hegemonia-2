// ========================================
// BR120 - IMPLEMENTAÇÃO COMPLETA
// ========================================

// Evento: Create
// Adicionar estas variáveis se não existirem:
moving_to_target = false;
target_x = 0;
target_y = 0;
ship_speed = 1;
ship_width = 574;
ship_height = 118;

// Evento: Step
// Substituir ou adicionar ao código existente:
if (moving_to_target) {
    var distance = point_distance(x, y, target_x, target_y);
    
    if (distance > 20) {
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

// Evento: Left Pressed
// Adicionar ao código existente:
if (scr_check_water_tile(mouse_x, mouse_y)) {
    // Posição clicada é água - pode mover
    target_x = mouse_x;
    target_y = mouse_y;
    moving_to_target = true;
} else {
    // Posição clicada é terra - busca água próxima
    var nearest_water = scr_find_nearest_water(mouse_x, mouse_y, 500);
    if (nearest_water[0] != -1) {
        target_x = nearest_water[0];
        target_y = nearest_water[1];
        moving_to_target = true;
    } else {
        show_message("Não há água próxima para mover o navio!");
    }
}
