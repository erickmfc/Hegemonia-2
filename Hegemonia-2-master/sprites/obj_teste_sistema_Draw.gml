// ========================================
// OBJETO: obj_teste_sistema
// EVENTO: Draw
// ========================================

// Mostra informações na tela quando em modo teste
if (test_mode) {
    // Mostra informações na tela
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    
    var y_pos = 50;
    draw_text(10, y_pos, "=== MODO TESTE ATIVO ===");
    y_pos += 20;
    draw_text(10, y_pos, "Pressione ESPAÇO para desativar");
    y_pos += 20;
    draw_text(10, y_pos, "Clique para verificar água/terra");
    y_pos += 20;
    
    // Mostra informações da posição do mouse
    draw_text(10, y_pos, "Mouse X: " + string(mouse_x));
    y_pos += 15;
    draw_text(10, y_pos, "Mouse Y: " + string(mouse_y));
    y_pos += 15;
    
    // Mostra tipo de terreno
    if (scr_check_water_tile(mouse_x, mouse_y)) {
        draw_set_color(c_blue);
        draw_text(10, y_pos, "Terreno: ÁGUA");
    } else {
        draw_set_color(c_brown);
        draw_text(10, y_pos, "Terreno: TERRA");
    }
    
    draw_set_color(c_white);
}
