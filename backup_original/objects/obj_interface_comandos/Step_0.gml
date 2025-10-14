// ==========================================
// HEGEMONIA GLOBAL - INTERFACE DE COMANDOS
// Step Event - Lógica do Menu
// ==========================================

// === VERIFICAR SE DEVE MOSTRAR O MENU ===
// DESABILITAR ESTE OBJETO PARA EVITAR CONFLITO
menu_visivel = false;
exit;

if (global.unidade_selecionada != noone && instance_exists(global.unidade_selecionada)) {
    menu_visivel = true;
    unidade_atual = global.unidade_selecionada;
    
    // Identificar tipo de unidade
    if (unidade_atual.object_index == obj_infantaria) {
        tipo_unidade = "INFANTARIA";
    } else if (unidade_atual.object_index == obj_aviao) {
        tipo_unidade = "AVIAO";
    } else if (unidade_atual.object_index == obj_navio) {
        tipo_unidade = "NAVIO";
    } else {
        tipo_unidade = "UNIDADE";
    }
    
    show_debug_message("MENU DE AÇÃO ATIVO - Tipo: " + tipo_unidade + " | ID: " + string(global.unidade_selecionada));
    
    // Posicionar menu no canto superior direito
    posicao_x = room_width - largura_menu - 20;
    posicao_y = 20;
        
        // Atualizar posições dos botões
        botao_patrulhar.x = posicao_x + 10;
        botao_patrulhar.y = posicao_y + 10;
        
        botao_seguir.x = posicao_x + 10;
        botao_seguir.y = posicao_y + 55;
        
        // Verificar estado dos botões baseado na unidade
        if (variable_instance_exists(unidade_atual, "comando_atual")) {
            botao_patrulhar.ativo = (unidade_atual.comando_atual == "PATRULHAR");
            botao_seguir.ativo = (unidade_atual.comando_atual == "SEGUIR");
        }
    } else {
        menu_visivel = false;
        unidade_atual = noone;
    }
} else {
    menu_visivel = false;
    unidade_atual = noone;
}

// === DETECTAR HOVER DOS BOTÕES ===
if (menu_visivel) {
    // Botão PATRULHAR
    botao_patrulhar.hover = (mouse_x >= botao_patrulhar.x && 
                            mouse_x <= botao_patrulhar.x + botao_patrulhar.largura &&
                            mouse_y >= botao_patrulhar.y && 
                            mouse_y <= botao_patrulhar.y + botao_patrulhar.altura);
    
    // Botão SEGUIR
    botao_seguir.hover = (mouse_x >= botao_seguir.x && 
                         mouse_x <= botao_seguir.x + botao_seguir.largura &&
                         mouse_y >= botao_seguir.y && 
                         mouse_y <= botao_seguir.y + botao_seguir.altura);
}

// === DETECTAR CLIQUES NOS BOTÕES ===
if (menu_visivel && mouse_check_button_pressed(mb_left)) {
    // Clique no botão PATRULHAR
    if (botao_patrulhar.hover && unidade_atual != noone) {
        if (variable_instance_exists(unidade_atual, "comando_atual")) {
            if (unidade_atual.comando_atual == "PATRULHAR") {
                // Desativar patrulha
                unidade_atual.comando_atual = "LIVRE";
                unidade_atual.patrulha_ativa = false;
                show_debug_message("PATRULHA DESATIVADA");
            } else {
                // Ativar patrulha
                unidade_atual.comando_atual = "PATRULHAR";
                unidade_atual.patrulha_ativa = true;
                unidade_atual.ponto_patrulha_a_x = unidade_atual.x;
                unidade_atual.ponto_patrulha_a_y = unidade_atual.y;
                unidade_atual.ponto_patrulha_b_x = unidade_atual.x + 100;
                unidade_atual.ponto_patrulha_b_y = unidade_atual.y + 100;
                show_debug_message("PATRULHA ATIVADA");
            }
        }
    }
    
    // Clique no botão SEGUIR
    if (botao_seguir.hover && unidade_atual != noone) {
        if (variable_instance_exists(unidade_atual, "comando_atual")) {
            if (unidade_atual.comando_atual == "SEGUIR") {
                // Desativar seguir
                unidade_atual.comando_atual = "LIVRE";
                unidade_atual.unidade_seguindo = noone;
                show_debug_message("COMANDO SEGUIR DESATIVADO");
            } else {
                // Ativar seguir (aguardar clique em alvo)
                unidade_atual.comando_atual = "SEGUIR";
                show_debug_message("COMANDO SEGUIR ATIVADO - Clique em uma unidade para seguir");
            }
        }
    }
}
