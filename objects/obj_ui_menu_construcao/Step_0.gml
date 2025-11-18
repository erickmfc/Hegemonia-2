// =========================================================
// MENU DE CONSTRUÇÃO REDESENHADO - STEP EVENT
// Processamento de animações, hover e entrada do teclado
// =========================================================

// === PROCESSAR TECLA V (ABRIR/FECHAR) ===
if (keyboard_check_pressed(ord("V"))) {
    if (menu_estado == 0 || menu_estado == 3) {
        menu_estado = 1;
        menu_aberto = true;
        timer_animacao = 0;
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("✅ Menu Redesenhado: Abrindo...");
        }
    } else if (menu_estado == 2) {
        menu_estado = 3;
        menu_aberto = false;
        timer_animacao = 0;
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("✅ Menu Redesenhado: Fechando...");
        }
    }
}

// === PROCESSAR TECLA ESC (FECHAR) ===
if (keyboard_check_pressed(vk_escape) && menu_estado == 2) {
    menu_estado = 3;
    menu_aberto = false;
    timer_animacao = 0;
}

// === ANIMAÇÃO DE ABERTURA/FECHAMENTO ===
if (menu_estado == 1) {
    timer_animacao += 1.0 / game_get_speed(gamespeed_fps);
    var _progresso = clamp(timer_animacao / duracao_animacao, 0, 1);
    
    // Easing: ease-out cubic
    var _ease = 1 - power(1 - _progresso, 3);
    menu_pos_x_atual = lerp(menu_pos_x_fechado, menu_pos_x_aberto, _ease);
    
    if (_progresso >= 1.0) {
        menu_estado = 2;
        menu_pos_x_atual = menu_pos_x_aberto;
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("✅ Menu Redesenhado: Aberto");
        }
    }
} else if (menu_estado == 3) {
    timer_animacao += 1.0 / game_get_speed(gamespeed_fps);
    var _progresso = clamp(timer_animacao / duracao_animacao, 0, 1);
    
    // Easing: ease-in cubic
    var _ease = power(_progresso, 3);
    menu_pos_x_atual = lerp(menu_pos_x_aberto, menu_pos_x_fechado, _ease);
    
    if (_progresso >= 1.0) {
        menu_estado = 0;
        menu_pos_x_atual = menu_pos_x_fechado;
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("✅ Menu Redesenhado: Fechado");
        }
    }
}

// === ANIMAÇÃO DE GLOW GLOBAL ===
glow_time += glow_speed;
if (glow_time > 360) {
    glow_time -= 360;
}

// === PROCESSAR HOVER DOS BOTÕES ===
if (menu_estado == 2) {
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    var _botao_y_atual = botao_start_y;
    var _nenhum_hover = true;
    
    for (var i = 0; i < array_length(lista_botoes); i++) {
        var _botao = lista_botoes[i];
        var _botao_x = menu_pos_x_atual + (menu_largura - botao_largura) / 2;
        var _botao_y = _botao_y_atual;
        
        var _hover = point_in_rectangle(
            _mouse_gui_x, _mouse_gui_y,
            _botao_x, _botao_y,
            _botao_x + botao_largura, _botao_y + botao_altura
        );
        
        // === ANIMAÇÃO DE HOVER ===
        if (_hover) {
            _botao.scale_anim = lerp(_botao.scale_anim, 1.05, 0.15);
            _botao.glow_anim = lerp(_botao.glow_anim, 1.0, 0.12);
            _nenhum_hover = false;
            botao_selecionado = i;
        } else {
            _botao.scale_anim = lerp(_botao.scale_anim, 1.0, 0.12);
            _botao.glow_anim = lerp(_botao.glow_anim, 0.0, 0.1);
        }
        
        _botao.hover = _hover;
        _botao_y_atual += botao_altura + botao_espacamento;
    }
    
    if (_nenhum_hover) {
        botao_selecionado = -1;
    }
}
