// ================================================
// HEGEMONIA GLOBAL - ESTRUTURA: CASA
// Step Event - Sistema de Seleção e Movimento
// ================================================

// === SISTEMA DE SELEÇÃO E MOVIMENTO ===
if (selecionado) {
    // Seguir o mouse quando selecionado (sem distância mínima)
    x = mouse_x;
    y = mouse_y;
    
    // Mostrar feedback visual
    if (timer_feedback <= 0) {
        show_debug_message("🏠 Casa seguindo mouse - Posição: " + string(x) + ", " + string(y));
        timer_feedback = 30; // Feedback a cada 30 frames
    }
    timer_feedback--;
}

// === SISTEMA DE POPULAÇÃO COM LIMITE ===
// Cada casa tem limite de 10 pessoas
if (!populacao_adicionada) {
    // Verificar se a cidade pode receber mais pessoas
    var pessoas_disponiveis = limite_pessoas_por_casa;
    
    if (variable_global_exists("populacao_cidade")) {
        // Verificar se não excedeu o limite total da cidade
        if (global.populacao_cidade < limite_maximo_cidade) {
            // Verificar se esta casa específica não excedeu seu limite
            if (pessoas_esta_casa < limite_pessoas_por_casa) {
                global.populacao_cidade += pessoas_disponiveis;
                pessoas_esta_casa = pessoas_disponiveis;
                show_debug_message("🏠 Casa adicionou " + string(pessoas_disponiveis) + " pessoas! População total: " + string(global.populacao_cidade));
                show_debug_message("🏠 Esta casa: " + string(pessoas_esta_casa) + "/" + string(limite_pessoas_por_casa) + " pessoas");
            } else {
                show_debug_message("🏠 Esta casa atingiu seu limite de " + string(limite_pessoas_por_casa) + " pessoas!");
            }
        } else {
            show_debug_message("🏠 Casa não pode ser construída! Cidade atingiu limite máximo de população (" + string(limite_maximo_cidade) + ")");
            // Destruir a casa se não puder adicionar população
            instance_destroy();
            return;
        }
    } else {
        // Inicializar população se não existir
        global.populacao_cidade = pessoas_disponiveis;
        pessoas_esta_casa = pessoas_disponiveis;
        show_debug_message("🏠 Primeira casa criada! População inicial: " + string(global.populacao_cidade));
        show_debug_message("🏠 Esta casa: " + string(pessoas_esta_casa) + "/" + string(limite_pessoas_por_casa) + " pessoas");
    }
    
    populacao_adicionada = true;
}

// === SISTEMA DE SELEÇÃO COM MOUSE ===
if (mouse_check_button_pressed(mb_left)) {
    // Verificar se clicou na casa
    if (point_distance(mouse_x, mouse_y, x, y) <= 30) {
        // Selecionar a casa
        selecionado = true;
        timer_feedback = 0;
        show_debug_message("🏠 Casa selecionada - Clique direito para posicionar");
    }
}

// === POSICIONAMENTO COM CLIQUE DIREITO ===
if (selecionado && mouse_check_button_pressed(mb_right)) {
    // Posicionar a casa
    selecionado = false;
    show_debug_message("🏠 Casa posicionada em: " + string(x) + ", " + string(y));
}
