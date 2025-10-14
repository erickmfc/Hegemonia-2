// ========================================
// OBJETO: obj_lancha_patrulha
// EVENTO: Left Pressed
// ========================================

// Clique para mover com verificação de água
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
