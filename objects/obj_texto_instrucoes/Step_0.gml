/// @description Step - Gerenciar scroll e interações

// === CONTROLE DE SCROLL COM MOUSE WHEEL ===
var _mouse_wheel = device_mouse_wheel_delta(0);
if (_mouse_wheel != 0) {
    scroll_y -= _mouse_wheel * scroll_speed * 2;
    scroll_y = clamp(scroll_y, 0, max_scroll);
}

// === CONTROLE DE SCROLL COM TECLAS ===
if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
    scroll_y -= scroll_speed;
    scroll_y = clamp(scroll_y, 0, max_scroll);
}
if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
    scroll_y += scroll_speed;
    scroll_y = clamp(scroll_y, 0, max_scroll);
}

// === CONTROLE DE SCROLL COM BARRA DE ROLAGEM ===
// ✅ CORREÇÃO: Só processar se max_scroll > 0
if (max_scroll > 0) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _menu_w = _gui_w * 0.85;
    var _menu_h = _gui_h * 0.85;
    var _menu_x = (_gui_w - _menu_w) / 2;
    var _menu_y = (_gui_h - _menu_h) / 2;
    var _header_h = 100;
    var _content_y = _menu_y + _header_h + 20;
    var _content_h = _menu_h - _header_h - 160; // ✅ AUMENTADO: Espaço para footer (botão voltar) - era 140, agora 160

    var _scrollbar_x = _menu_x + _menu_w - 35;
    var _scrollbar_y = _content_y;
    var _scrollbar_w = 15;
    var _scrollbar_h = _content_h;

    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);

    // ✅ CORREÇÃO: Detecção melhorada de clique na barra
    if (mouse_check_button_pressed(mb_left)) {
        // Verificar se clicou na área da barra de rolagem (incluindo o thumb)
        if (_mouse_gui_x >= _scrollbar_x && _mouse_gui_x <= _scrollbar_x + _scrollbar_w &&
            _mouse_gui_y >= _scrollbar_y && _mouse_gui_y <= _scrollbar_y + _scrollbar_h) {
            arrastando_scrollbar = true;
            // Calcular posição inicial do scroll baseado no clique
            var _relative_y = _mouse_gui_y - _scrollbar_y;
            var _ratio = clamp(_relative_y / _scrollbar_h, 0, 1);
            scroll_y = _ratio * max_scroll;
            scroll_y = clamp(scroll_y, 0, max_scroll);
        }
    }

    // Se está arrastando, atualizar scroll continuamente
    if (arrastando_scrollbar && mouse_check_button(mb_left)) {
        // Calcular posição de scroll baseada na posição do mouse
        var _relative_y = _mouse_gui_y - _scrollbar_y;
        var _ratio = clamp(_relative_y / _scrollbar_h, 0, 1);
        scroll_y = _ratio * max_scroll;
        scroll_y = clamp(scroll_y, 0, max_scroll);
    }

    // Parar de arrastar quando soltar o botão
    if (!mouse_check_button(mb_left)) {
        arrastando_scrollbar = false;
    }
} else {
    // Se não há scroll, garantir que não está arrastando
    arrastando_scrollbar = false;
}
