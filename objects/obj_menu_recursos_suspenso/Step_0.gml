// =========================================================
// MENU DE RECURSOS SUSPENSO - STEP EVENT
// Lógica de animação, toggle e sincronização de recursos
// =========================================================

// ✅ VERIFICAÇÃO: Garantir que variável de visibilidade existe
if (!variable_instance_exists(id, "menu_visible")) {
    menu_visible = true;
}

// ✅ NOVO: Toggle de visibilidade com tecla X
if (keyboard_check_pressed(ord("X"))) {
    menu_visible = !menu_visible;
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("📊 Menu de Recursos: " + (menu_visible ? "VISÍVEL" : "OCULTO"));
    }
}

// ✅ VERIFICAÇÃO: Garantir que lista de recursos existe
if (!variable_instance_exists(id, "lista_recursos") || array_length(lista_recursos) == 0) {
    exit; // Se não tem recursos, não processa
}

// === ATUALIZAR VALORES DOS RECURSOS (SE GLOBAIS EXISTEM) ===
if (array_length(lista_recursos) > 0 && variable_global_exists("dinheiro")) {
    lista_recursos[0].valor = global.dinheiro;
}

if (array_length(lista_recursos) > 1 && variable_global_exists("populacao")) {
    lista_recursos[1].valor = global.populacao;
}

if (array_length(lista_recursos) > 2 && variable_global_exists("turistas")) {
    lista_recursos[2].valor = global.turistas;
}

if (array_length(lista_recursos) > 3 && variable_global_exists("foida")) {
    lista_recursos[3].valor = global.foida;
}

if (array_length(lista_recursos) > 4 && variable_global_exists("energia")) {
    lista_recursos[4].valor = global.energia;
}

if (array_length(lista_recursos) > 5 && variable_global_exists("petrolo")) {
    lista_recursos[5].valor = global.petrolo;
}

if (array_length(lista_recursos) > 6 && variable_global_exists("militar")) {
    lista_recursos[6].valor = global.militar;
}

if (array_length(lista_recursos) > 7 && variable_global_exists("polaridade")) {
    lista_recursos[7].valor = global.polaridade;
}

// === ANIMAÇÃO DE GLOW ===
// ✅ REMOVIDO: Efeito de piscar - glow_intensity agora é fixo (definido em Create_0.gml)
// glow_intensity não é mais animado

// === ANIMAÇÃO DE EXPANSÃO/FECHAMENTO ===
if (menu_estado == 1) {
    // Abrindo
    timer_animacao += 1.0 / game_get_speed(gamespeed_fps);
    var _progresso = clamp(timer_animacao / duracao_animacao, 0, 1);
    
    // Easing: ease-out cubic
    var _ease = 1 - power(1 - _progresso, 3);
    
    menu_altura_atual = lerp(menu_altura_recolhido, menu_altura_expandido, _ease);
    seta_angulo = lerp(0, 180, _ease);
    
    if (_progresso >= 1.0) {
        menu_estado = 2;
        menu_altura_atual = menu_altura_expandido;
        seta_angulo = 180;
        timer_animacao = 0;
    }
} else if (menu_estado == 3) {
    // Fechando
    timer_animacao += 1.0 / game_get_speed(gamespeed_fps);
    var _progresso = clamp(timer_animacao / duracao_animacao, 0, 1);
    
    // Easing: ease-in cubic
    var _ease = power(_progresso, 3);
    
    menu_altura_atual = lerp(menu_altura_expandido, menu_altura_recolhido, _ease);
    seta_angulo = lerp(180, 0, _ease);
    
    if (_progresso >= 1.0) {
        menu_estado = 0;
        menu_altura_atual = menu_altura_recolhido;
        seta_angulo = 0;
        timer_animacao = 0;
    }
}

// === DETECTAR HOVER SOBRE ITENS ===
if (menu_estado == 2) {
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    // ✅ REDUZIDO EM 20%
    var _item_y = menu_pos_y + 56; // 70 * 0.8 = 56
    var _item_altura = 36; // 45 * 0.8 = 36
    hover_item = -1;
    
    for (var i = 0; i < array_length(lista_recursos); i++) {
        if (point_in_rectangle(
            _mouse_gui_x, _mouse_gui_y,
            menu_pos_x + 12, _item_y, // ✅ REDUZIDO EM 20%: 15 * 0.8 = 12
            menu_pos_x + menu_largura_expandido - 12, _item_y + _item_altura // ✅ REDUZIDO EM 20%: 15 * 0.8 = 12
        )) {
            hover_item = i;
            break;
        }
        _item_y += _item_altura + 4; // ✅ REDUZIDO EM 20%: 5 * 0.8 = 4
    }
}
