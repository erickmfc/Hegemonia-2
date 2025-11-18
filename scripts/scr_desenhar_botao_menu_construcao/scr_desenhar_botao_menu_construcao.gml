// =========================================================
// HEGEMONIA GLOBAL - DESENHAR BOTÃO DO MENU DE CONSTRUÇÃO
// Desenha um botão com ícone hexágono, texto e efeitos visuais
// =========================================================
// @param _x Posição X do botão
// @param _y Posição Y do botão
// @param _largura Largura do botão
// @param _altura Altura do botão
// @param _dados_botao Struct com dados do botão
// @param _hover Se o botão está com hover
// @param _menu_obj Instância do objeto do menu (para acessar variáveis)

function scr_desenhar_botao_menu_construcao(_x, _y, _largura, _altura, _dados_botao, _hover, _menu_obj) {
    
    // Verificar se o objeto do menu existe
    if (!instance_exists(_menu_obj)) {
        return; // Menu não existe, não desenhar
    }
    
    // === CORES BASEADAS NO ESTADO ===
    var _cor_fundo = _menu_obj.cor_botao_normal;
    var _cor_borda = make_color_rgb(100, 150, 200);
    var _alpha_glow = 0.3;
    
    if (_hover || _dados_botao.hover) {
        _cor_fundo = _menu_obj.cor_botao_hover;
        _cor_borda = _menu_obj.cor_borda;
        var _glow_val = _menu_obj.hover_glow_intensity;
        _alpha_glow = 0.7 + (sin(_glow_val * 360 * pi / 180) * 0.3); // Glow pulsante
    }
    
    // === SOMBRA DO BOTÃO ===
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.3);
    draw_rectangle(_x + 2, _y + 2, _x + _largura + 2, _y + _altura + 2, false);
    
    // === FUNDO DO BOTÃO ===
    draw_set_alpha(0.9);
    draw_set_color(_cor_fundo);
    draw_rectangle(_x, _y, _x + _largura, _y + _altura, false);
    
    // === GLOW NA BORDA (SE HOVER) ===
    if (_hover || _dados_botao.hover) {
        draw_set_alpha(_alpha_glow);
        draw_set_color(_cor_borda);
        // Borda externa com glow
        draw_rectangle(_x - 2, _y - 2, _x + _largura + 2, _y + _altura + 2, false);
        // Borda interna
        draw_set_alpha(0.5);
        draw_rectangle(_x - 1, _y - 1, _x + _largura + 1, _y + _altura + 1, false);
    } else {
        // Borda normal
        draw_set_alpha(0.4);
        draw_set_color(_cor_borda);
        draw_rectangle(_x - 1, _y - 1, _x + _largura + 1, _y + _altura + 1, false);
    }
    
    // === ÍCONE HEXÁGONO (SIMULADO COM CÍRCULO) ===
    var _icone_x = _x + 20;
    var _icone_y = _y + _altura / 2;
    var _icone_raio = 20;
    
    // Fundo do ícone (hexágono simulado)
    draw_set_alpha(0.6);
    draw_set_color(make_color_rgb(50, 100, 150));
    draw_circle(_icone_x, _icone_y, _icone_raio, false);
    
    // Ícone baseado no tipo
    draw_set_alpha(1);
    draw_set_color(_menu_obj.cor_texto);
    var _icone_texto = "?";
    
    switch (_dados_botao.icone_tipo) {
        case "casa":
            _icone_texto = "🏠";
            break;
        case "banco":
            _icone_texto = "$";
            break;
        case "fazenda":
            _icone_texto = "🌾";
            break;
        case "quartel":
            _icone_texto = "⚔";
            break;
        case "marinha":
            _icone_texto = "⚓";
            break;
        case "aeroporto":
            _icone_texto = "✈";
            break;
    }
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_icone_x, _icone_y, _icone_texto);
    
    // === TEXTO DO BOTÃO ===
    var _texto_x = _x + 60;
    var _texto_y = _y + 15;
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_menu_obj.cor_texto);
    draw_set_alpha(1);
    
    // Nome do botão
    if (font_exists(fnt_ui_main)) {
        draw_set_font(fnt_ui_main);
    }
    draw_text(_texto_x, _texto_y, _dados_botao.nome);
    
    // Descrição (menor)
    var _desc_y = _texto_y + 20;
    draw_set_color(_menu_obj.cor_texto_descricao);
    draw_set_alpha(0.8);
    var _desc_font_size = 0.7;
    
    // Desenhar descrição (usar função se existir, senão draw_text normal)
    try {
        scr_desenhar_texto_ui(_texto_x, _desc_y, _dados_botao.descricao, _desc_font_size, _desc_font_size);
    } catch (_e) {
        // Fallback: usar draw_text normal se função não existir
        draw_text(_texto_x, _desc_y, _dados_botao.descricao);
    }
    
    // Custo
    var _custo_y = _desc_y + 18;
    draw_set_color(make_color_rgb(255, 255, 100));
    draw_set_alpha(0.9);
    var _custo_texto = "$" + string(_dados_botao.custo_dinheiro);
    
    // Adicionar recursos se houver
    if (is_struct(_dados_botao.custo_recursos)) {
        var _keys = struct_get_names(_dados_botao.custo_recursos);
        if (array_length(_keys) > 0) {
            var _recursos_texto = "";
            for (var i = 0; i < array_length(_keys); i++) {
                var _key = _keys[i];
                var _valor = _dados_botao.custo_recursos[$_key];
                if (_recursos_texto != "") _recursos_texto += ", ";
                _recursos_texto += _key + ": " + string(_valor);
            }
            _custo_texto += " + " + _recursos_texto;
        }
    }
    
    // Desenhar custo (usar função se existir, senão draw_text normal)
    try {
        scr_desenhar_texto_ui(_texto_x, _custo_y, _custo_texto, 0.65, 0.65);
    } catch (_e) {
        // Fallback: usar draw_text normal se função não existir
        draw_text(_texto_x, _custo_y, _custo_texto);
    }
    
    // Resetar configurações
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}
