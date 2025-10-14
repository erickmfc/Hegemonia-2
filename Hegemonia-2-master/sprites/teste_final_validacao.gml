// ========================================
// TESTE FINAL - VALIDAÇÃO QUARTEL MARINHA
// ========================================
// Use este código para testar se a validação está funcionando corretamente

// Evento: Create
test_mode = false;
test_validation = false;

// Evento: Step
if (keyboard_check_pressed(vk_space)) {
    test_mode = !test_mode;
    if (test_mode) {
        show_message("=== TESTE DE VALIDAÇÃO ATIVADO ===");
        show_message("V - Testar Validação");
        show_message("Q - Testar Quartel Marinha");
        show_message("C - Verificar Terreno");
    } else {
        show_message("Modo teste desativado");
    }
}

// Teste da função de validação (tecla V)
if (test_mode && keyboard_check_pressed(vk_v)) {
    test_validation = true;
    show_message("Testando função scr_validacao_terreno_simples...");
    
    // Testa com Quartel Marinha
    if (scr_validacao_terreno_simples(obj_quartel_marinha, mouse_x, mouse_y)) {
        show_message("✓ Quartel Marinha: VÁLIDO nesta posição!");
        show_debug_message("Validação: SUCESSO - Terreno é água");
    } else {
        show_message("✗ Quartel Marinha: INVÁLIDO nesta posição!");
        show_debug_message("Validação: FALHA - Terreno não é água");
    }
}

// Teste do Quartel Marinha (tecla Q)
if (test_mode && keyboard_check_pressed(vk_q)) {
    show_message("Testando construção do Quartel Marinha...");
    
    // Simula o código do botão
    if (scr_validacao_terreno_simples(obj_quartel_marinha, mouse_x, mouse_y)) {
        show_message("✓ PODE construir Quartel Marinha aqui!");
        show_debug_message("Construção: PERMITIDA");
        
        // Opcional: criar uma instância de teste
        // instance_create_layer(mouse_x, mouse_y, "Instances", obj_quartel_marinha);
        
    } else {
        show_message("✗ NÃO PODE construir Quartel Marinha aqui!");
        show_debug_message("Construção: BLOQUEADA");
    }
}

// Verificação de terreno (tecla C)
if (test_mode && keyboard_check_pressed(vk_c)) {
    if (scr_check_water_tile(mouse_x, mouse_y)) {
        show_message("Terreno atual: ÁGUA");
        show_debug_message("Detecção: ÁGUA");
    } else {
        show_message("Terreno atual: TERRA");
        show_debug_message("Detecção: TERRA");
    }
}

// Evento: Draw (informações visuais)
if (test_mode) {
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    
    var y_pos = 50;
    draw_text(10, y_pos, "=== TESTE DE VALIDAÇÃO ===");
    y_pos += 20;
    draw_text(10, y_pos, "ESPAÇO - Ativar/Desativar");
    y_pos += 15;
    draw_text(10, y_pos, "V - Testar Validação");
    y_pos += 15;
    draw_text(10, y_pos, "Q - Testar Quartel Marinha");
    y_pos += 15;
    draw_text(10, y_pos, "C - Verificar Terreno");
    y_pos += 20;
    
    // Informações da posição
    draw_text(10, y_pos, "Mouse X: " + string(mouse_x));
    y_pos += 15;
    draw_text(10, y_pos, "Mouse Y: " + string(mouse_y));
    y_pos += 15;
    
    // Tipo de terreno
    if (scr_check_water_tile(mouse_x, mouse_y)) {
        draw_set_color(c_blue);
        draw_text(10, y_pos, "Terreno: ÁGUA");
    } else {
        draw_set_color(c_brown);
        draw_text(10, y_pos, "Terreno: TERRA");
    }
    
    draw_set_color(c_white);
    y_pos += 20;
    
    // Status da validação
    if (scr_validacao_terreno_simples(obj_quartel_marinha, mouse_x, mouse_y)) {
        draw_set_color(c_green);
        draw_text(10, y_pos, "Quartel Marinha: VÁLIDO");
    } else {
        draw_set_color(c_red);
        draw_text(10, y_pos, "Quartel Marinha: INVÁLIDO");
    }
    
    draw_set_color(c_white);
}

// ========================================
// INSTRUÇÕES DE TESTE FINAL
// ========================================

/*
TESTE FINAL - INSTRUÇÕES:

1. TESTE BÁSICO:
   - Execute o jogo
   - Pressione ESPAÇO para ativar modo teste
   - Use as teclas V, Q, C para testar diferentes funcionalidades

2. TESTE DE VALIDAÇÃO (tecla V):
   - Posicione o mouse sobre água
   - Pressione V - deve mostrar "VÁLIDO"
   - Posicione o mouse sobre terra
   - Pressione V - deve mostrar "INVÁLIDO"

3. TESTE DE CONSTRUÇÃO (tecla Q):
   - Posicione o mouse sobre água
   - Pressione Q - deve mostrar "PODE construir"
   - Posicione o mouse sobre terra
   - Pressione Q - deve mostrar "NÃO PODE construir"

4. TESTE REAL DO BOTÃO:
   - Clique no botão do Quartel Marinha
   - Tente construir em terra - deve mostrar erro
   - Tente construir em água - deve construir normalmente

5. VERIFICAÇÃO DE MENSAGENS:
   - Verifique se as mensagens de debug aparecem no console
   - Confirme se as mensagens de erro são claras
   - Teste se as mensagens de sucesso aparecem

RESULTADO ESPERADO:
- Quartel Marinha só constrói em água
- Mensagens de erro claras para terreno inválido
- Mensagens de sucesso para construção válida
- Sistema funciona sem erros ou crashes

Se tudo funcionar conforme esperado, a implementação está COMPLETA! 🎉
*/

