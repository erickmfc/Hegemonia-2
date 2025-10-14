// ===============================================
// HEGEMONIA GLOBAL - BUILD MANAGER
// Draw Event - Feedback Visual
// ===============================================

// === DESENHAR CURSOR DE CONSTRUÇÃO ===
if (global.modo_construcao && global.construcao_selecionada == "quartel") {
    
    var mouse_x_local = mouse_x;
    var mouse_y_local = mouse_y;
    var world_x = camera_get_view_x(view_camera[0]) + mouse_x_local;
    var world_y = camera_get_view_y(view_camera[0]) + mouse_y_local;
    
    // === VERIFICAR SE POSIÇÃO É VÁLIDA ===
    var posicao_valida = posicao_valida_construcao(world_x, world_y);
    
    // === DESENHAR PREVIEW DO QUARTEL ===
    if (posicao_valida) {
        draw_set_color(c_lime);
        draw_set_alpha(0.5);
    } else {
        draw_set_color(c_red);
        draw_set_alpha(0.5);
    }
    
    // Desenhar preview do quartel
    draw_rectangle(world_x - 32, world_y - 32, world_x + 32, world_y + 32, false);
    
    // Resetar transparência
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    
    // === DESENHAR INFORMAÇÕES ===
    draw_set_color(c_white);
    draw_text(world_x, world_y - 50, "🏗️ QUARTEL");
    
    if (!posicao_valida) {
        draw_set_color(c_red);
        draw_text(world_x, world_y + 50, "❌ POSIÇÃO INVÁLIDA");
    } else {
        draw_set_color(c_lime);
        draw_text(world_x, world_y + 50, "✅ POSIÇÃO VÁLIDA");
    }
    
    // === INSTRUÇÕES ===
    draw_set_color(c_yellow);
    draw_text(10, room_height - 60, "🖱️ Clique para construir | ESC para cancelar");
}
