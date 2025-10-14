// ==========================================
// 🎯 HEGEMONIA GLOBAL - MENU DE AÇÃO
// Sistema de Patrulha - Cadeia de Comando Completa
// ==========================================

// === VERIFICAR SE DEVE MOSTRAR O MENU ===
if (global.unidade_selecionada != noone && instance_exists(global.unidade_selecionada)) {
    menu_visivel = true;
    unidade_atual = global.unidade_selecionada;
    
    // === CORREÇÃO: ARMAZENAR ID ESPECÍFICO DA UNIDADE ===
    if (unidade_id_especifica == noone) {
        unidade_id_especifica = global.unidade_selecionada;
        show_debug_message("📻 RÁDIO SINTONIZADO - Menu conectado à unidade ID: " + string(unidade_id_especifica));
    }
    
    // Identificar tipo de unidade
    if (unidade_atual.object_index == obj_infantaria) {
        tipo_unidade = "INFANTARIA";
    } else {
        tipo_unidade = "UNIDADE";
    }
    
    // Posicionar menu no canto superior direito
    posicao_x = room_width - largura_menu - 20;
    posicao_y = 20;
    
    // Atualizar posições dos botões
    botao_patrulhar.x = posicao_x + 10;
    botao_patrulhar.y = posicao_y + 10;
    
    botao_seguir.x = posicao_x + 10;
    botao_seguir.y = posicao_y + 70;
    
    botao_atacar.x = posicao_x + 10;
    botao_atacar.y = posicao_y + 130;
} else {
    menu_visivel = false;
    unidade_atual = noone;
    tipo_unidade = "";
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
    
    // Botão ATACAR
    botao_atacar.hover = (mouse_x >= botao_atacar.x && 
                         mouse_x <= botao_atacar.x + botao_atacar.largura &&
                         mouse_y >= botao_atacar.y && 
                         mouse_y <= botao_atacar.y + botao_atacar.altura);
}

// === DETECTAR CLIQUES NOS BOTÕES ===
if (menu_visivel && mouse_check_button_pressed(mb_left)) {
    
    // === CLIQUE NO BOTÃO PATRULHAR ===
    if (botao_patrulhar.hover) {
        show_debug_message("🎯 CLIQUE NO BOTÃO PATRULHAR!");
        
        // === PASSO 2: A TRANSMISSÃO (O BOTÃO ENVIA A ORDEM) ===
        // Primeiro, verifica se o alvo que guardamos ainda existe no jogo
        if (instance_exists(unidade_alvo)) {
            show_debug_message("📻 TRANSMITINDO ORDEM para unidade ID: " + string(unidade_alvo));
            
            // Ativa o modo de definição de patrulha no jogo
            global.modo_patrulha = true;
            
            // Diz ao sistema qual unidade específica está recebendo a ordem
            global.unidade_a_comandar = unidade_alvo;
            
            // Limpa a rota de patrulha anterior da unidade, se houver
            if (variable_instance_exists(unidade_alvo, "rota_de_patrulha")) {
                ds_list_clear(unidade_alvo.rota_de_patrulha);
            }
            
            // === TESTE 2: ESPIÃO PARA VERIFICAR TRANSMISSÃO ===
            show_debug_message("[TESTE 2] Botão Patrulhar clicado! Ativando modo para unidade: " + string(unidade_alvo));
            
            show_debug_message("✅ Ordem de patrulha enviada para a unidade: " + string(unidade_alvo));
            show_debug_message("📋 Clique esquerdo para adicionar pontos, clique direito para finalizar");
            
            // Fecha o menu, pois a ordem foi dada
            instance_destroy();
            
        } else {
            show_debug_message("❌ ERRO: Unidade alvo não existe mais! ID: " + string(unidade_alvo));
            // Se o alvo não existe mais, apenas fecha o menu
            instance_destroy();
        }
    }
    
    // === CLIQUE NO BOTÃO SEGUIR ===
    if (botao_seguir.hover && unidade_id_especifica != noone) {
        show_debug_message("🎯 CLIQUE NO BOTÃO SEGUIR!");
        show_debug_message("📻 TRANSMITINDO ORDEM para unidade ID: " + string(unidade_id_especifica));
        // Lógica do botão seguir (se implementada)
    }
    
    // === CLIQUE NO BOTÃO ATACAR ===
    if (botao_atacar.hover && unidade_id_especifica != noone) {
        show_debug_message("🎯 CLIQUE NO BOTÃO ATACAR!");
        show_debug_message("📻 TRANSMITINDO ORDEM para unidade ID: " + string(unidade_id_especifica));
        // Lógica do botão atacar (se implementada)
    }
}
