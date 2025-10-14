// ========================================
// QUARTEL MARINHA - IMPLEMENTAÇÃO COMPLETA
// ========================================

// Evento: Create do Quartel Marinha
// Adicionar estas variáveis se não existirem:
building_width = 154;
building_height = 186;

// ========================================
// BOTÃO DE CONSTRUÇÃO DO QUARTEL MARINHA
// ========================================

// Evento: Left Pressed do botão de construção
// Substituir ou adicionar ao código existente:
if (scr_validacao_area_construcao(obj_quartel_marinha, mouse_x, mouse_y, 154, 186)) {
    // Posição clicada é água - pode construir
    // Executa construção (substitua pelo seu código de criação)
    instance_create_layer(mouse_x, mouse_y, "Instances", obj_quartel_marinha);
    
    // Opcional: mostrar confirmação
    show_message("Quartel Marinha construído com sucesso!");
    show_debug_message("Construção bem-sucedida em terreno válido!");
    
} else {
    // Posição clicada é terra - não pode construir
    show_message("Quartel Marinha deve ser construído na água!");
    show_debug_message("ERRO: Terreno inválido para esta estrutura!");
}

// ========================================
// SISTEMA DE CONSTRUÇÃO COM PREVIEW
// ========================================

// Se você quiser um sistema mais avançado com preview visual:

// Evento: Create do botão (adicionar variáveis):
/*
construction_mode = false;
construction_type = "";
preview_x = 0;
preview_y = 0;
*/

// Evento: Left Pressed do botão (modo construção):
/*
construction_mode = true;
construction_type = "quartel_marinha";
show_message("Clique em uma posição de água para construir o Quartel Marinha");
*/

// Evento: Step (quando em modo construção):
/*
if (construction_mode && construction_type == "quartel_marinha") {
    // Segue o mouse para mostrar preview
    preview_x = mouse_x;
    preview_y = mouse_y;
}
*/

// Evento: Left Pressed (quando em modo construção):
/*
if (construction_mode && construction_type == "quartel_marinha") {
    if (scr_validacao_area_construcao(obj_quartel_marinha, mouse_x, mouse_y, 154, 186)) {
        // Pode construir - executa construção
        instance_create_layer(mouse_x, mouse_y, "Instances", obj_quartel_marinha);
        construction_mode = false;
        construction_type = "";
        show_message("Quartel Marinha construído com sucesso!");
    } else {
        // Não pode construir - mostra erro
        show_message("Quartel Marinha deve ser construído na água!");
    }
}
*/

// Evento: Draw (preview visual):
/*
if (construction_mode && construction_type == "quartel_marinha") {
    // Desenha preview do edifício
    if (scr_validacao_area_construcao(obj_quartel_marinha, mouse_x, mouse_y, 154, 186)) {
        // Posição válida - preview verde
        draw_set_color(c_green);
        draw_set_alpha(0.5);
        draw_rectangle(mouse_x - 154/2, mouse_y - 186/2, 
                      mouse_x + 154/2, mouse_y + 186/2, false);
        draw_set_alpha(1);
    } else {
        // Posição inválida - preview vermelho
        draw_set_color(c_red);
        draw_set_alpha(0.5);
        draw_rectangle(mouse_x - 154/2, mouse_y - 186/2, 
                      mouse_x + 154/2, mouse_y + 186/2, false);
        draw_set_alpha(1);
    }
}
*/
