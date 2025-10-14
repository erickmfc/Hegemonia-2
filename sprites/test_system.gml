// ========================================
// ARQUIVO DE TESTE - VERIFICAÇÃO DO SISTEMA
// ========================================
// Use este código para testar se o sistema está funcionando

// ========================================
// TESTE SIMPLES
// ========================================

// Adicione este código em qualquer objeto para testar:

// Evento: Create
test_mode = false;

// Evento: Step
if (keyboard_check_pressed(vk_space)) {
    test_mode = !test_mode;
    if (test_mode) {
        show_message("Modo teste ativado! Clique para verificar água/terra");
    } else {
        show_message("Modo teste desativado");
    }
}

if (test_mode && mouse_check_button_pressed(mb_left)) {
    if (scr_check_water_tile(mouse_x, mouse_y)) {
        show_message("✓ Posição é ÁGUA - Navios podem mover aqui");
    } else {
        show_message("✗ Posição é TERRA - Navios não podem mover aqui");
    }
}

// ========================================
// TESTE AVANÇADO
// ========================================

// Evento: Draw (para mostrar informações na tela)
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

// ========================================
// TESTE DE NAVIOS
// ========================================

// Para testar navios, adicione este código no evento Step de qualquer navio:

/*
// Teste de movimento (pressione T para testar)
if (keyboard_check_pressed(vk_t)) {
    // Tenta mover para posição aleatória
    var test_x = random(room_width);
    var test_y = random(room_height);
    
    if (scr_check_water_tile(test_x, test_y)) {
        target_x = test_x;
        target_y = test_y;
        moving_to_target = true;
        show_message("Navio movendo para posição de água!");
    } else {
        show_message("Posição aleatória é terra - navio não pode mover!");
    }
}
*/

// ========================================
// TESTE DE CONSTRUÇÃO
// ========================================

// Para testar construção, adicione este código no evento Step do botão de construção:

/*
// Teste de construção (pressione C para testar)
if (keyboard_check_pressed(vk_c)) {
    var test_x = mouse_x;
    var test_y = mouse_y;
    
    if (scr_can_build_on_water(test_x, test_y, 154, 186)) {
        show_message("✓ Pode construir Quartel Marinha aqui!");
    } else {
        show_message("✗ Não pode construir Quartel Marinha aqui!");
    }
}
*/

// ========================================
// INSTRUÇÕES DE TESTE
// ========================================

/*
INSTRUÇÕES PARA TESTAR:

1. TESTE BÁSICO:
   - Execute o jogo
   - Pressione ESPAÇO para ativar modo teste
   - Clique em diferentes posições
   - Verifique se mostra "ÁGUA" ou "TERRA" corretamente

2. TESTE DE NAVIOS:
   - Selecione um navio
   - Clique em terra - deve mostrar erro
   - Clique em água - deve mover normalmente
   - Navio deve parar na borda da água

3. TESTE DE CONSTRUÇÃO:
   - Clique no botão de Quartel Marinha
   - Tente construir em terra - deve mostrar erro
   - Tente construir em água - deve construir normalmente

4. TESTE DE PERFORMANCE:
   - Mova navios rapidamente
   - Verifique se não há lag
   - Teste com múltiplos navios

PROBLEMAS COMUNS E SOLUÇÕES:

- Se navios não param na borda:
  * Verifique se as dimensões (ship_width, ship_height) estão corretas
  * Ajuste o valor de "distance > 10" no Step

- Se construção não funciona:
  * Verifique se o nome do objeto está correto (obj_quartel_marinha)
  * Confirme se os sprites de terreno estão corretos

- Se verificação de água não funciona:
  * Teste scr_check_water_tile() manualmente
  * Verifique se os sprites de terreno estão na layer correta
*/
