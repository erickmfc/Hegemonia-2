// =========================================================
// MENU DE CONSTRUÇÃO REDESENHADO - DRAW GUI EVENT
// Design Futurista com Efeitos Cinemáticos
// Ativado com tecla C (global.modo_construcao)
// =========================================================

// === CONFIGURAR FONTE ===
// Definir fonte para o menu
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1); // Fonte padrão
}

// Só desenha se o modo de construção estiver ativo
if (!global.modo_construcao || !visible) {
    exit;
}

// === FUNÇÃO: DESENHAR HEXÁGONO ===
function desenhar_hexagono(_cx, _cy, _tamanho, _cor, _alpha, _rotacao = 0) {
    draw_set_alpha(_alpha);
    draw_set_color(_cor);
    
    var _pontos = 6;
    var _angulo_passo = 360 / _pontos;
    
    for (var i = 0; i < _pontos; i++) {
        var _ang1 = (_rotacao + i * _angulo_passo) * pi / 180;
        var _ang2 = (_rotacao + (i + 1) * _angulo_passo) * pi / 180;
        
        var _x1 = _cx + cos(_ang1) * _tamanho;
        var _y1 = _cy + sin(_ang1) * _tamanho;
        var _x2 = _cx + cos(_ang2) * _tamanho;
        var _y2 = _cy + sin(_ang2) * _tamanho;
        
        draw_line(_x1, _y1, _x2, _y2);
    }
}

// === FUNÇÃO: DESENHAR BORDA COM EFEITO ===
function desenhar_borda_ciencia_ficao(_x1, _y1, _x2, _y2, _cor, _espessura, _alpha_glow) {
    draw_set_alpha(_alpha_glow * 0.4);
    draw_set_color(_cor);
    
    // Glow externo
    for (var i = 1; i <= 3; i++) {
        draw_rectangle(_x1 - i, _y1 - i, _x2 + i, _y2 + i, true);
    }
    
    // Borda principal
    draw_set_alpha(_alpha_glow);
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    
    // Borda interna
    draw_set_alpha(_alpha_glow * 0.6);
    draw_rectangle(_x1 + 1, _y1 + 1, _x2 - 1, _y2 - 1, true);
}

// === FUNÇÃO: DESENHAR BOTÃO COM DESIGN FUTURISTA ===
function desenhar_botao_futurista(_x, _y, _largura, _altura, _dados_botao, _hover, _scale, _glow_intensity, _text_scale = 0.85) {
    var _centro_x = _x + _largura / 2;
    var _centro_y = _y + _altura / 2;
    
    // Aplicar escala
    var _scaled_largura = _largura * _scale;
    var _scaled_altura = _altura * _scale;
    var _scaled_x = _centro_x - _scaled_largura / 2;
    var _scaled_y = _centro_y - _scaled_altura / 2;
    
    // === CORES DINAMICAMENTE AJUSTADAS ===
    var _cor_fundo = cor_botao_normal;
    var _cor_borda = cor_borda_secundaria;
    var _cor_acento_local = cor_acento;
    
    if (_hover) {
        _cor_fundo = cor_botao_hover;
        _cor_borda = cor_borda_principal;
        _cor_acento_local = cor_botao_ativo;
    }
    
    // === SOMBRA COM BLUR SIMULADO ===
    draw_set_alpha(0.25);
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_rectangle(_scaled_x + 3, _scaled_y + 3, _scaled_x + _scaled_largura + 3, _scaled_y + _scaled_altura + 3, false);
    
    // === FUNDO PRINCIPAL COM GRADIENTE SIMULADO ===
    draw_set_alpha(0.85);
    draw_set_color(_cor_fundo);
    draw_rectangle(_scaled_x, _scaled_y, _scaled_x + _scaled_largura, _scaled_y + _scaled_altura, false);
    
    // Camada de brilho simulada
    draw_set_alpha(0.15);
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_rectangle(_scaled_x, _scaled_y, _scaled_x + _scaled_largura, _scaled_y + _scaled_altura / 4, false);
    
    // === BORDAS COM EFEITO GLOW ===
    var _alpha_glow = 0.4 + (_glow_intensity * 0.6);
    
    // Glow externo pulsante
    if (_glow_intensity > 0.2) {
        draw_set_alpha(_alpha_glow * 0.3);
        draw_set_color(_cor_acento_local);
        draw_rectangle(_scaled_x - 3, _scaled_y - 3, _scaled_x + _scaled_largura + 3, _scaled_y + _scaled_altura + 3, false);
    }
    
    // Borda principal
    draw_set_alpha(_alpha_glow);
    draw_set_color(_cor_borda);
    draw_rectangle(_scaled_x, _scaled_y, _scaled_x + _scaled_largura, _scaled_y + _scaled_altura, true);
    
    // Borda interna sutil
    draw_set_alpha(_alpha_glow * 0.6);
    draw_set_color(_cor_acento_local);
    draw_rectangle(_scaled_x + 1, _scaled_y + 1, _scaled_x + _scaled_largura - 1, _scaled_y + _scaled_altura - 1, true);
    
    // === ÍCONE HEXAGONAL COM ANIMAÇÃO ===
    var _icone_x = _scaled_x + 25;
    var _icone_y = _scaled_y + _scaled_altura / 2;
    var _icone_tamanho = 14;
    
    // Hexágono externo (glow)
    if (_glow_intensity > 0.1) {
        draw_set_alpha(0.3 * _glow_intensity);
        draw_set_color(_cor_acento_local);
        draw_circle(_icone_x, _icone_y, _icone_tamanho + 3, false);
    }
    
    // Hexágono principal
    draw_set_alpha(0.7);
    draw_set_color(cor_borda_principal);
    desenhar_hexagono(_icone_x, _icone_y, _icone_tamanho, cor_borda_principal, 1.0, glow_time * 2);
    
    // Preenchimento do hexágono
    draw_set_alpha(0.4);
    draw_set_color(_cor_acento_local);
    draw_circle(_icone_x, _icone_y, _icone_tamanho * 0.6, false);
    
    // Ícone (símbolo)
    draw_set_alpha(1.0);
    draw_set_color(cor_texto_normal);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // ✅ CORREÇÃO: Removidos emojis - usando apenas letras
    var _icone_char = "?";
    switch (_dados_botao.icone_tipo) {
        case "casa": _icone_char = "H"; break;
        case "banco": _icone_char = "$"; break;
        case "fazenda": _icone_char = "F"; break;
        case "quartel": _icone_char = "Q"; break;
        case "marinha": _icone_char = "M"; break;
        case "aeroporto": _icone_char = "A"; break;
    }
    
    if (font_exists(fnt_ui_main)) {
        draw_set_font(fnt_ui_main);
    }
    draw_text_transformed(_icone_x, _icone_y, _icone_char, _text_scale, _text_scale, 0);
    
    // === TEXTOS (NOME, DESCRIÇÃO, CUSTO) ===
    var _texto_x = _scaled_x + 55;
    var _texto_y = _scaled_y + 10;
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1.0);
    
    // Nome
    draw_set_color(cor_texto_titulo);
    draw_text_transformed(_texto_x, _texto_y, _dados_botao.nome, _text_scale, _text_scale, 0);
    
    // ✅ CORREÇÃO: Descrição removida - não desenhar mais
    
    // Custo
    draw_set_color(cor_custo);
    draw_set_alpha(0.9);
    var _custo_y = _texto_y + 18; // Ajustado para ficar logo abaixo do nome
    var _custo_texto = "$" + string(_dados_botao.custo_dinheiro);
    
    if (is_struct(_dados_botao.custo_recursos)) {
        var _keys = struct_get_names(_dados_botao.custo_recursos);
        if (array_length(_keys) > 0) {
            for (var i = 0; i < array_length(_keys); i++) {
                var _key = _keys[i];
                var _valor = _dados_botao.custo_recursos[$_key];
                _custo_texto += " + " + _key + ":" + string(_valor);
            }
        }
    }
    
    draw_text_transformed(_texto_x, _custo_y, _custo_texto, _text_scale, _text_scale, 0);
}

// === ESCALA DE TEXTO (Reduzida para tamanho normal) ===
// ✅ CORREÇÃO: Tamanho de fonte reduzido para tamanho normal
var _text_scale = 0.7;

// === DESENHAR FUNDO DO MENU ===
// Sombra grande
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.5);
draw_rectangle(menu_pos_x - 20, menu_pos_y - 20, menu_pos_x + menu_largura + 20, menu_pos_y + menu_altura + 20, false);

// Fundo principal
draw_set_alpha(0.95);
draw_set_color(cor_fundo_principal);
draw_rectangle(menu_pos_x, menu_pos_y, menu_pos_x + menu_largura, menu_pos_y + menu_altura, false);

// Bordas com glow animado
var _glow_val = 0.5 + (sin(glow_time * pi / 180) * 0.3);
draw_set_alpha(_glow_val);
draw_set_color(cor_borda_principal);
draw_line(menu_pos_x, menu_pos_y, menu_pos_x, menu_pos_y + menu_altura);
draw_line(menu_pos_x + menu_largura, menu_pos_y, menu_pos_x + menu_largura, menu_pos_y + menu_altura);
draw_line(menu_pos_x, menu_pos_y, menu_pos_x + menu_largura, menu_pos_y);
draw_line(menu_pos_x, menu_pos_y + menu_altura, menu_pos_x + menu_largura, menu_pos_y + menu_altura);

// === CABEÇALHO FUTURISTA ===
var _header_height = 130;

// Fundo header
draw_set_alpha(0.8);
draw_set_color(cor_fundo_header);
draw_rectangle(menu_pos_x, menu_pos_y, menu_pos_x + menu_largura, menu_pos_y + _header_height, false);

// Linha decorativa
draw_set_alpha(0.6);
draw_set_color(cor_borda_principal);
draw_line(menu_pos_x + 10, menu_pos_y + _header_height - 2, menu_pos_x + menu_largura - 10, menu_pos_y + _header_height - 2);

// Ícone do cabeçalho (hexágono grande)
var _header_icon_x = menu_pos_x + 35;
var _header_icon_y = menu_pos_y + 35;
draw_set_alpha(0.5);
draw_set_color(cor_borda_principal);
desenhar_hexagono(_header_icon_x, _header_icon_y, 18, cor_borda_principal, 0.8, glow_time * 2);
draw_set_alpha(0.3);
draw_set_color(cor_acento);
draw_circle(_header_icon_x, _header_icon_y, 12, false);

// Textos do cabeçalho
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(cor_texto_titulo);
draw_set_alpha(1.0);
var _titulo_x = _header_icon_x + 30;
var _titulo_y = menu_pos_y + 20;

if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
}
draw_text_transformed(_titulo_x, _titulo_y, "MENU DE CONSTRUÇÃO", _text_scale, _text_scale, 0);
draw_set_color(cor_texto_descricao);
draw_set_alpha(0.7);
draw_text_transformed(_titulo_x, _titulo_y + 22, "Selecione uma estrutura", _text_scale, _text_scale, 0);

// === BOTÃO DE FECHAR FUTURISTA ===
var _close_btn_size = 30;
var _close_x = menu_pos_x + menu_largura - _close_btn_size - 10;
var _close_y = menu_pos_y + 10;
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);
var _hover_close = point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _close_x, _close_y, _close_x + _close_btn_size, _close_y + _close_btn_size);

// Fundo do botão fechar
if (_hover_close) {
    draw_set_alpha(0.8);
    draw_set_color(make_color_rgb(255, 100, 100));
} else {
    draw_set_alpha(0.6);
    draw_set_color(make_color_rgb(200, 200, 200));
}
draw_rectangle(_close_x, _close_y, _close_x + _close_btn_size, _close_y + _close_btn_size, false);

// Borda do botão fechar
draw_set_alpha(0.9);
draw_set_color(cor_borda_principal);
draw_rectangle(_close_x, _close_y, _close_x + _close_btn_size, _close_y + _close_btn_size, true);

// X no botão de fechar
draw_set_color(make_color_rgb(255, 255, 255));
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(1.0);
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
}
draw_text_transformed(_close_x + _close_btn_size / 2, _close_y + _close_btn_size / 2, "X", _text_scale, _text_scale, 0);

// === DESENHAR BOTÕES ===
var _botao_y_atual = botao_start_y;

for (var i = 0; i < array_length(lista_botoes); i++) {
    var _botao = lista_botoes[i];
    var _botao_x = menu_pos_x + (menu_largura - botao_largura) / 2;
    var _botao_y = _botao_y_atual;
    
    var _glow = _botao.glow_anim;
    
    desenhar_botao_futurista(_botao_x, _botao_y, botao_largura, botao_altura, _botao, _botao.hover, _botao.scale_anim, _glow, _text_scale);
    
    _botao_y_atual += botao_altura + botao_espacamento;
}

// === RODAPÉ COM INSTRUÇÕES ===
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(cor_texto_descricao);
draw_set_alpha(0.6);
var _rodape_y = menu_pos_y + menu_altura - 20;
draw_text_transformed(menu_pos_x + menu_largura / 2, _rodape_y, "Pressione C ou ESC para fechar", _text_scale, _text_scale, 0);

// Resetar
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
