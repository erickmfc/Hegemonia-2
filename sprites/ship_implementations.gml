// ========================================
// IMPLEMENTAÇÃO ESPECÍFICA POR TIPO DE NAVIO
// ========================================

// OBJETO: Lancha Patrulha (spr_lancha_patrulha)
// Evento: Create
/*
// Variáveis específicas da lancha
ship_speed = 3;
moving_to_target = false;
target_x = 0;
target_y = 0;
*/

// Evento: Step
/*
// Movimento da lancha patrulha
if (moving_to_target) {
    var distance = point_distance(x, y, target_x, target_y);
    
    if (distance > 5) {
        // Move em direção ao alvo
        if (!move_ship_smoothly(target_x, target_y, ship_speed)) {
            moving_to_target = false;
            show_message("Lancha não pode sair da água!");
        }
    } else {
        // Chegou ao destino
        moving_to_target = false;
    }
}
*/

// Evento: Left Pressed
/*
// Clique para mover lancha
if (is_water_tile(mouse_x, mouse_y)) {
    target_x = mouse_x;
    target_y = mouse_y;
    moving_to_target = true;
} else {
    var nearest_water = find_nearest_water_position(mouse_x, mouse_y);
    if (nearest_water != -1) {
        target_x = nearest_water.x;
        target_y = nearest_water.y;
        moving_to_target = true;
    } else {
        show_message("Não há água próxima para mover a lancha!");
    }
}
*/

// ========================================

// OBJETO: Marinha (spr_marinha)
// Evento: Create
/*
// Variáveis específicas da marinha
ship_speed = 2;
moving_to_target = false;
target_x = 0;
target_y = 0;
*/

// Evento: Step
/*
// Movimento da marinha
if (moving_to_target) {
    var distance = point_distance(x, y, target_x, target_y);
    
    if (distance > 10) {
        // Move em direção ao alvo
        if (!move_ship_smoothly(target_x, target_y, ship_speed)) {
            moving_to_target = false;
            show_message("Navio não pode sair da água!");
        }
    } else {
        // Chegou ao destino
        moving_to_target = false;
    }
}
*/

// Evento: Left Pressed
/*
// Clique para mover marinha
if (is_water_tile(mouse_x, mouse_y)) {
    target_x = mouse_x;
    target_y = mouse_y;
    moving_to_target = true;
} else {
    var nearest_water = find_nearest_water_position(mouse_x, mouse_y, 300);
    if (nearest_water != -1) {
        target_x = nearest_water.x;
        target_y = nearest_water.y;
        moving_to_target = true;
    } else {
        show_message("Não há água próxima para mover o navio!");
    }
}
*/

// ========================================

// OBJETO: Nav122 (spr_nav122)
// Evento: Create
/*
// Variáveis específicas do nav122
ship_speed = 1.5;
moving_to_target = false;
target_x = 0;
target_y = 0;
*/

// Evento: Step
/*
// Movimento do nav122
if (moving_to_target) {
    var distance = point_distance(x, y, target_x, target_y);
    
    if (distance > 15) {
        // Move em direção ao alvo
        if (!move_ship_smoothly(target_x, target_y, ship_speed)) {
            moving_to_target = false;
            show_message("Navio não pode sair da água!");
        }
    } else {
        // Chegou ao destino
        moving_to_target = false;
    }
}
*/

// Evento: Left Pressed
/*
// Clique para mover nav122
if (is_water_tile(mouse_x, mouse_y)) {
    target_x = mouse_x;
    target_y = mouse_y;
    moving_to_target = true;
} else {
    var nearest_water = find_nearest_water_position(mouse_x, mouse_y, 400);
    if (nearest_water != -1) {
        target_x = nearest_water.x;
        target_y = nearest_water.y;
        moving_to_target = true;
    } else {
        show_message("Não há água próxima para mover o navio!");
    }
}
*/

// ========================================

// OBJETO: BR120 (Sprite_br120)
// Evento: Create
/*
// Variáveis específicas do BR120
ship_speed = 1;
moving_to_target = false;
target_x = 0;
target_y = 0;
*/

// Evento: Step
/*
// Movimento do BR120
if (moving_to_target) {
    var distance = point_distance(x, y, target_x, target_y);
    
    if (distance > 20) {
        // Move em direção ao alvo
        if (!move_ship_smoothly(target_x, target_y, ship_speed)) {
            moving_to_target = false;
            show_message("Navio não pode sair da água!");
        }
    } else {
        // Chegou ao destino
        moving_to_target = false;
    }
}
*/

// Evento: Left Pressed
/*
// Clique para mover BR120
if (is_water_tile(mouse_x, mouse_y)) {
    target_x = mouse_x;
    target_y = mouse_y;
    moving_to_target = true;
} else {
    var nearest_water = find_nearest_water_position(mouse_x, mouse_y, 500);
    if (nearest_water != -1) {
        target_x = nearest_water.x;
        target_y = nearest_water.y;
        moving_to_target = true;
    } else {
        show_message("Não há água próxima para mover o navio!");
    }
}
*/
