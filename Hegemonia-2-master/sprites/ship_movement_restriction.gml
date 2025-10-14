// ========================================
// RESTRIÇÃO DE MOVIMENTO DOS NAVIOS
// ========================================
// Implementação mínima - intercepta movimento antes de executar

// ========================================
// LANCHA PATRULHA (spr_lancha_patrulha)
// ========================================

// Evento: Create (adicionar estas variáveis se não existirem)
/*
// Variáveis de movimento
moving_to_target = false;
target_x = 0;
target_y = 0;
ship_speed = 3;
ship_width = 78;
ship_height = 19;
*/

// Evento: Step (substituir ou adicionar ao código existente)
/*
// Intercepta movimento antes de executar
if (moving_to_target) {
    var distance = point_distance(x, y, target_x, target_y);
    
    if (distance > 5) {
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
            show_message("Lancha não pode sair da água!");
        }
    } else {
        // Chegou ao destino
        moving_to_target = false;
    }
}
*/

// Evento: Left Pressed (adicionar ao código existente)
/*
// Intercepta clique antes de definir destino
if (scr_check_water_tile(mouse_x, mouse_y)) {
    // Posição clicada é água - pode mover
    target_x = mouse_x;
    target_y = mouse_y;
    moving_to_target = true;
} else {
    // Posição clicada é terra - busca água próxima
    var nearest_water = scr_find_nearest_water(mouse_x, mouse_y, 200);
    if (nearest_water[0] != -1) {
        target_x = nearest_water[0];
        target_y = nearest_water[1];
        moving_to_target = true;
    } else {
        show_message("Não há água próxima para mover a lancha!");
    }
}
*/

// ========================================
// MARINHA (spr_marinha)
// ========================================

// Evento: Create (adicionar estas variáveis se não existirem)
/*
// Variáveis de movimento
moving_to_target = false;
target_x = 0;
target_y = 0;
ship_speed = 2;
ship_width = 154;
ship_height = 186;
*/

// Evento: Step (substituir ou adicionar ao código existente)
/*
// Intercepta movimento antes de executar
if (moving_to_target) {
    var distance = point_distance(x, y, target_x, target_y);
    
    if (distance > 10) {
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
*/

// Evento: Left Pressed (adicionar ao código existente)
/*
// Intercepta clique antes de definir destino
if (scr_check_water_tile(mouse_x, mouse_y)) {
    // Posição clicada é água - pode mover
    target_x = mouse_x;
    target_y = mouse_y;
    moving_to_target = true;
} else {
    // Posição clicada é terra - busca água próxima
    var nearest_water = scr_find_nearest_water(mouse_x, mouse_y, 300);
    if (nearest_water[0] != -1) {
        target_x = nearest_water[0];
        target_y = nearest_water[1];
        moving_to_target = true;
    } else {
        show_message("Não há água próxima para mover o navio!");
    }
}
*/

// ========================================
// NAV122 (spr_nav122)
// ========================================

// Evento: Create (adicionar estas variáveis se não existirem)
/*
// Variáveis de movimento
moving_to_target = false;
target_x = 0;
target_y = 0;
ship_speed = 1.5;
ship_width = 600;
ship_height = 139;
*/

// Evento: Step (substituir ou adicionar ao código existente)
/*
// Intercepta movimento antes de executar
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
*/

// Evento: Left Pressed (adicionar ao código existente)
/*
// Intercepta clique antes de definir destino
if (scr_check_water_tile(mouse_x, mouse_y)) {
    // Posição clicada é água - pode mover
    target_x = mouse_x;
    target_y = mouse_y;
    moving_to_target = true;
} else {
    // Posição clicada é terra - busca água próxima
    var nearest_water = scr_find_nearest_water(mouse_x, mouse_y, 400);
    if (nearest_water[0] != -1) {
        target_x = nearest_water[0];
        target_y = nearest_water[1];
        moving_to_target = true;
    } else {
        show_message("Não há água próxima para mover o navio!");
    }
}
*/

// ========================================
// BR120 (Sprite_br120)
// ========================================

// Evento: Create (adicionar estas variáveis se não existirem)
/*
// Variáveis de movimento
moving_to_target = false;
target_x = 0;
target_y = 0;
ship_speed = 1;
ship_width = 574;
ship_height = 118;
*/

// Evento: Step (substituir ou adicionar ao código existente)
/*
// Intercepta movimento antes de executar
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
*/

// Evento: Left Pressed (adicionar ao código existente)
/*
// Intercepta clique antes de definir destino
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
*/