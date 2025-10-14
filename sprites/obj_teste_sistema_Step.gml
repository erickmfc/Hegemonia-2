// ========================================
// OBJETO: obj_teste_sistema
// EVENTO: Step
// ========================================

// Ativa/desativa modo teste com ESPAÇO
if (keyboard_check_pressed(vk_space)) {
    test_mode = !test_mode;
    if (test_mode) {
        show_message("Modo teste ativado! Clique para verificar água/terra");
    } else {
        show_message("Modo teste desativado");
    }
}

// Teste com clique do mouse
if (test_mode && mouse_check_button_pressed(mb_left)) {
    if (scr_check_water_tile(mouse_x, mouse_y)) {
        show_message("✓ Posição é ÁGUA - Navios podem mover aqui");
    } else {
        show_message("✗ Posição é TERRA - Navios não podem mover aqui");
    }
    
    // Teste adicional: validação de terreno para Quartel Marinha
    if (scr_validacao_terreno_simples(obj_quartel_marinha, mouse_x, mouse_y)) {
        show_message("✓ Quartel Marinha PODE ser construído aqui!");
    } else {
        show_message("✗ Quartel Marinha NÃO pode ser construído aqui!");
    }
}
