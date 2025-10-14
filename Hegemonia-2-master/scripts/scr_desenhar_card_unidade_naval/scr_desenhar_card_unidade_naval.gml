/// @description Desenhar card de unidade naval
/// @param {real} x Posição X
/// @param {real} y Posição Y
/// @param {real} w Largura
/// @param {real} h Altura
/// @param {string} nome Nome da unidade
/// @param {string} descricao Descrição
/// @param {real} custo_dinheiro Custo em dinheiro
/// @param {real} custo_populacao Custo em população
/// @param {real} custo_petroleo Custo em petróleo
/// @param {real} tempo_treino Tempo de treino em segundos
/// @param {string} sprite_nome Nome do sprite
/// @param {bool} disponivel Se está disponível

function scr_desenhar_card_unidade_naval(x, y, w, h, nome, descricao, custo_dinheiro, custo_populacao, custo_petroleo, tempo_treino, sprite_nome, disponivel) {
    
    // Verificar se pode recrutar
    var pode_recrutar = (global.dinheiro >= custo_dinheiro && global.populacao >= custo_populacao && global.petroleo >= custo_petroleo);
    var quartel_ocupado = (instance_exists(id_do_quartel) && id_do_quartel.esta_treinando);
    
    // Sombra do card
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.2);
    draw_roundrect_ext(x + 3, y + 3, x + w + 3, y + h + 3, 8, 8, false);
    draw_set_alpha(1);
    
    // Fundo do card
    var _bg_color = make_color_rgb(25, 40, 65);
    if (quartel_ocupado) {
        _bg_color = make_color_rgb(60, 45, 30);
    } else if (!disponivel) {
        _bg_color = make_color_rgb(40, 40, 40);
    }
    
    draw_set_color(_bg_color);
    draw_set_alpha(0.9);
    draw_roundrect_ext(x, y, x + w, y + h, 8, 8, false);
    draw_set_alpha(1);
    
    // Borda do card
    var _border_color = make_color_rgb(70, 130, 200);
    if (pode_recrutar && disponivel && !quartel_ocupado) {
        _border_color = make_color_rgb(80, 200, 80);
    } else if (quartel_ocupado) {
        _border_color = make_color_rgb(255, 180, 0);
    } else if (!disponivel) {
        _border_color = make_color_rgb(100, 100, 100);
    } else {
        _border_color = make_color_rgb(200, 80, 80);
    }
    
    draw_set_color(_border_color);
    draw_roundrect_ext(x, y, x + w, y + h, 8, 8, true);
    
    // Ícone da unidade
    if (sprite_exists(asset_get_index(sprite_nome))) {
        var _icon_x = x + w/2;
        var _icon_y = y + 40;
        draw_sprite_ext(asset_get_index(sprite_nome), 0, _icon_x, _icon_y, 2.0, 2.0, 0, c_white, 1);
    }
    
    // Nome da unidade
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text_transformed(x + w/2, y + 80, nome, 1.0, 1.0, 0);
    
    // Descrição
    draw_set_color(make_color_rgb(180, 180, 180));
    draw_text_transformed(x + w/2, y + 100, descricao, 0.7, 0.7, 0);
    
    // Custos
    var _cost_y = y + 120;
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text_transformed(x + w/2, _cost_y, "Custo: $" + string(custo_dinheiro), 0.8, 0.8, 0);
    
    draw_set_color(make_color_rgb(100, 200, 250));
    draw_text_transformed(x + w/2, _cost_y + 15, "Pop: " + string(custo_populacao), 0.8, 0.8, 0);
    
    draw_set_color(make_color_rgb(200, 100, 100));
    draw_text_transformed(x + w/2, _cost_y + 30, "Petróleo: " + string(custo_petroleo), 0.8, 0.8, 0);
    
    // Tempo de treino
    draw_set_color(make_color_rgb(180, 180, 180));
    draw_text_transformed(x + w/2, _cost_y + 50, "Tempo: " + string(tempo_treino) + "s", 0.7, 0.7, 0);
    
    // Botões de quantidade
    var _buttons_y = _cost_y + 75;
    var _button_height = 25;
    var _button_spacing = 5;
    var _button_width = (w - 20 - 2 * _button_spacing) / 3;
    
    // Botão 1
    var _btn1_x = x + 10;
    var _btn1_y = _buttons_y;
    var _btn1_w = _button_width;
    var _btn1_h = _button_height;
    
    // Botão 5
    var _btn5_x = _btn1_x + _button_width + _button_spacing;
    var _btn5_y = _buttons_y;
    var _btn5_w = _button_width;
    var _btn5_h = _button_height;
    
    // Botão 10
    var _btn10_x = _btn5_x + _button_width + _button_spacing;
    var _btn10_y = _buttons_y;
    var _btn10_w = _button_width;
    var _btn10_h = _button_height;
    
    // Cor dos botões
    var _btn_color = make_color_rgb(50, 100, 150);
    if (pode_recrutar && disponivel && !quartel_ocupado) {
        _btn_color = make_color_rgb(60, 150, 60);
    } else {
        _btn_color = make_color_rgb(150, 60, 60);
    }
    
    // Desenhar botões
    draw_set_color(_btn_color);
    draw_roundrect_ext(_btn1_x, _btn1_y, _btn1_x + _btn1_w, _btn1_y + _btn1_h, 4, 4, false);
    draw_roundrect_ext(_btn5_x, _btn5_y, _btn5_x + _btn5_w, _btn5_y + _btn5_h, 4, 4, false);
    draw_roundrect_ext(_btn10_x, _btn10_y, _btn10_x + _btn10_w, _btn10_y + _btn10_h, 4, 4, false);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_btn1_x + _btn1_w/2, _btn1_y + _btn1_h/2, "1");
    draw_text(_btn5_x + _btn5_w/2, _btn5_y + _btn5_h/2, "5");
    draw_text(_btn10_x + _btn10_w/2, _btn10_y + _btn10_h/2, "10");
    
    // Status
    if (!disponivel) {
        draw_set_color(make_color_rgb(200, 100, 100));
        draw_text_transformed(x + w/2, y + h - 20, "BLOQUEADA", 0.8, 0.8, 0);
    } else if (quartel_ocupado) {
        draw_set_color(make_color_rgb(255, 180, 0));
        draw_text_transformed(x + w/2, y + h - 20, "QUARTEL OCUPADO", 0.8, 0.8, 0);
    } else if (!pode_recrutar) {
        draw_set_color(make_color_rgb(200, 100, 100));
        draw_text_transformed(x + w/2, y + h - 20, "RECURSOS INSUFICIENTES", 0.8, 0.8, 0);
    } else {
        draw_set_color(make_color_rgb(80, 200, 80));
        draw_text_transformed(x + w/2, y + h - 20, "DISPONÍVEL", 0.8, 0.8, 0);
    }
    
    draw_set_halign(fa_left);
}
