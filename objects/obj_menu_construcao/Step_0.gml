// =========================================================
// MENU DE CONSTRUÇÃO REDESENHADO - STEP EVENT
// Processamento de animações, hover e controle de visibilidade
// =========================================================

// === CONTROLE DE VISIBILIDADE ===
if (global.modo_construcao) {
    if (!visible) {
        visible = true;
        menu_ativo = true;
        // Recalcular posição quando o menu for aberto (caso a resolução tenha mudado)
        menu_pos_x = display_get_gui_width() / 2 - menu_largura / 2;
        menu_pos_y = display_get_gui_height() / 2 - menu_altura / 2;
        botao_start_y = menu_pos_y + 130;
    }
} else {
    if (visible) {
        visible = false;
        menu_ativo = false;
    }
}

// === ANIMAÇÃO DE GLOW GLOBAL ===
glow_time += glow_speed;
if (glow_time > 360) {
    glow_time -= 360;
}

// === PROCESSAR HOVER DOS BOTÕES ===
if (global.modo_construcao && visible) {
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    var _botao_y_atual = botao_start_y;
    var _nenhum_hover = true;
    
    for (var i = 0; i < array_length(lista_botoes); i++) {
        var _botao = lista_botoes[i];
        var _botao_x = menu_pos_x + (menu_largura - botao_largura) / 2;
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
