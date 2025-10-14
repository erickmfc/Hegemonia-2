// ================================================
// HEGEMONIA GLOBAL - ESTRUTURA: BANCO
// Step Event - Sistema de Economia Baseada na População
// ================================================

// === SISTEMA DE ECONOMIA BASEADA NA POPULAÇÃO ===
timer_economia++;

if (timer_economia >= ciclo_economia) {
    // Calcular dinheiro baseado na população
    if (variable_global_exists("populacao_cidade")) {
        var dinheiro_gerado = global.populacao_cidade * taxa_por_habitante;
        
        // Adicionar dinheiro ao país
        if (variable_global_exists("dinheiro_pais")) {
            global.dinheiro_pais += dinheiro_gerado;
        } else {
            global.dinheiro_pais = dinheiro_gerado;
        }
        
        show_debug_message("🏦 Banco gerou " + string(dinheiro_gerado) + " de dinheiro!");
        show_debug_message("👥 População: " + string(global.populacao_cidade) + " | 💰 Dinheiro total: " + string(global.dinheiro_pais));
    } else {
        show_debug_message("🏦 Banco aguardando população para gerar dinheiro...");
    }
    
    timer_economia = 0;
}

// === SISTEMA DE SELEÇÃO E MOVIMENTO ===
if (selecionado) {
    // Seguir o mouse quando selecionado (sem distância mínima)
    x = mouse_x;
    y = mouse_y;
    
    // Mostrar feedback visual
    if (timer_feedback <= 0) {
        show_debug_message("🏦 Banco seguindo mouse - Posição: " + string(x) + ", " + string(y));
        timer_feedback = 30; // Feedback a cada 30 frames
    }
    timer_feedback--;
}

// === SISTEMA DE SELEÇÃO COM MOUSE ===
if (mouse_check_button_pressed(mb_left)) {
    // Verificar se clicou no banco
    if (point_distance(mouse_x, mouse_y, x, y) <= 30) {
        // Selecionar o banco
        selecionado = true;
        timer_feedback = 0;
        show_debug_message("🏦 Banco selecionado - Clique direito para posicionar");
    }
}

// === POSICIONAMENTO COM CLIQUE DIREITO ===
if (selecionado && mouse_check_button_pressed(mb_right)) {
    // Posicionar o banco
    selecionado = false;
    show_debug_message("🏦 Banco posicionado em: " + string(x) + ", " + string(y));
}
