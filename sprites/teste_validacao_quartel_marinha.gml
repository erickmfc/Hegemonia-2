/// @description Script de teste para validar a implementação do Quartel da Marinha
/// Use este código para testar se a regra de construção está funcionando

// ========================================
// TESTE BÁSICO DE VALIDAÇÃO
// ========================================

// Adicione este código em qualquer objeto para testar:

// Evento: Create
test_mode = false;
test_quartel_marinha = false;

// Evento: Step
if (keyboard_check_pressed(vk_space)) {
    test_mode = !test_mode;
    if (test_mode) {
        show_message("Modo teste ativado! Use as teclas para testar:");
        show_message("Q - Testar Quartel Marinha");
        show_message("R - Testar Quartel Normal");
        show_message("C - Verificar terreno atual");
    } else {
        show_message("Modo teste desativado");
    }
}

// Teste do Quartel Marinha (tecla Q)
if (test_mode && keyboard_check_pressed(vk_q)) {
    test_quartel_marinha = true;
    show_message("Testando Quartel Marinha...");
    
    if (scr_validacao_area_construcao(obj_quartel_marinha, mouse_x, mouse_y, 154, 186)) {
        show_message("✓ Quartel Marinha pode ser construído aqui!");
        show_debug_message("Validação: SUCESSO - Terreno é água");
    } else {
        show_message("✗ Quartel Marinha NÃO pode ser construído aqui!");
        show_debug_message("Validação: FALHA - Terreno não é água");
    }
}

// Teste do Quartel Normal (tecla R)
if (test_mode && keyboard_check_pressed(vk_r)) {
    show_message("Testando Quartel Normal...");
    
    if (scr_validacao_area_construcao(obj_quartel, mouse_x, mouse_y, 170, 206)) {
        show_message("✓ Quartel Normal pode ser construído aqui!");
        show_debug_message("Validação: SUCESSO - Terreno é terra");
    } else {
        show_message("✗ Quartel Normal NÃO pode ser construído aqui!");
        show_debug_message("Validação: FALHA - Terreno não é terra");
    }
}

// Verificação de terreno atual (tecla C)
if (test_mode && keyboard_check_pressed(vk_c)) {
    if (scr_check_water_tile(mouse_x, mouse_y)) {
        show_message("Terreno atual: ÁGUA");
        show_debug_message("Terreno detectado: ÁGUA");
    } else {
        show_message("Terreno atual: TERRA");
        show_debug_message("Terreno detectado: TERRA");
    }
}

// ========================================
// TESTE VISUAL
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
    draw_text(10, y_pos, "Q - Testar Quartel Marinha");
    y_pos += 15;
    draw_text(10, y_pos, "R - Testar Quartel Normal");
    y_pos += 15;
    draw_text(10, y_pos, "C - Verificar terreno atual");
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
    y_pos += 20;
    
    // Mostra status da validação
    if (scr_validacao_area_construcao(obj_quartel_marinha, mouse_x, mouse_y, 154, 186)) {
        draw_set_color(c_green);
        draw_text(10, y_pos, "Quartel Marinha: VÁLIDO");
    } else {
        draw_set_color(c_red);
        draw_text(10, y_pos, "Quartel Marinha: INVÁLIDO");
    }
    
    draw_set_color(c_white);
}

// ========================================
// INSTRUÇÕES DE TESTE
// ========================================

/*
INSTRUÇÕES PARA TESTAR A IMPLEMENTAÇÃO:

1. TESTE BÁSICO:
   - Execute o jogo
   - Pressione ESPAÇO para ativar modo teste
   - Use as teclas Q, R, C para testar diferentes funcionalidades
   - Verifique se as mensagens aparecem corretamente

2. TESTE DO QUARTEL MARINHA:
   - Ative o modo teste
   - Posicione o mouse sobre água
   - Pressione Q - deve mostrar "pode ser construído"
   - Posicione o mouse sobre terra
   - Pressione Q - deve mostrar "NÃO pode ser construído"

3. TESTE DO QUARTEL NORMAL:
   - Ative o modo teste
   - Posicione o mouse sobre terra
   - Pressione R - deve mostrar "pode ser construído"
   - Posicione o mouse sobre água
   - Pressione R - deve mostrar "NÃO pode ser construído"

4. TESTE DE CONSTRUÇÃO REAL:
   - Clique no botão de Quartel Marinha
   - Tente construir em terra - deve mostrar erro
   - Tente construir em água - deve construir normalmente
   - Verifique se as mensagens de debug aparecem no console

5. TESTE DE PERFORMANCE:
   - Mova o mouse rapidamente
   - Verifique se não há lag na validação
   - Teste com múltiplas validações simultâneas

PROBLEMAS COMUNS E SOLUÇÕES:

- Se validação não funciona:
  * Verifique se o script scr_validacao_terreno.gml foi criado
  * Confirme se as funções estão sendo chamadas corretamente
  * Verifique se os objetos obj_quartel_marinha e obj_quartel existem

- Se construção não funciona:
  * Verifique se o botão está chamando a função correta
  * Confirme se as variáveis building_width e building_height estão definidas
  * Teste se scr_check_water_tile() funciona isoladamente

- Se mensagens não aparecem:
  * Verifique se show_debug_message() está habilitado
  * Confirme se as mensagens estão sendo chamadas
  * Teste com show_message() para verificar se é problema de debug
*/
