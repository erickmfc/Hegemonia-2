// ===============================================
// HEGEMONIA GLOBAL - QUARTEL MILITAR MODERNO
// Interface Redesenhada com Layout Profissional
// ===============================================

// Só desenha o menu se estiver ativo
if (mostrar_menu) {
    
    // Configurar fonte
    if (font_exists(fnt_ui_main)) {
        draw_set_font(fnt_ui_main);
    } else {
        draw_set_font(-1);
    }
    
    // === OVERLAY DE FUNDO MODERNO ===
    draw_set_alpha(0.9);
    draw_set_color(make_color_rgb(10, 15, 25));
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    
    // === PAINEL PRINCIPAL - LAYOUT MODERNO ===
    var _mw = display_get_gui_width() * 0.75;  // 75% da largura
    var _mh = display_get_gui_height() * 0.8;   // 80% da altura
    var _mx = (display_get_gui_width() - _mw) / 2;
    var _my = (display_get_gui_height() - _mh) / 2;
    
    // Sombra do painel principal
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.4);
    draw_roundrect_ext(_mx + 6, _my + 6, _mx + _mw + 6, _my + _mh + 6, 16, 16, false);
    draw_set_alpha(1);
    
    // Fundo do painel principal - azul militar escuro
    draw_set_color(make_color_rgb(20, 30, 45));
    draw_set_alpha(0.95);
    draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 16, 16, false);
    draw_set_alpha(1);
    
    // Borda principal com gradiente simulado
    draw_set_color(make_color_rgb(60, 100, 150));
    draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 16, 16, true);
    
    // === CABEÇALHO MODERNO ===
    var _header_h = 80;
    draw_set_color(make_color_rgb(30, 45, 65));
    draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _header_h, 16, 16, false);
    
    // Linha decorativa no cabeçalho
    draw_set_color(make_color_rgb(80, 140, 200));
    draw_rectangle(_mx + 20, _my + _header_h - 3, _mx + _mw - 20, _my + _header_h, false);
    
    // Título principal com ícone
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(220, 230, 250));
    draw_text(_mx + _mw/2, _my + 30, "🏛️ QUARTEL MILITAR 🏛️");
    
    // Subtítulo
    draw_set_color(make_color_rgb(180, 200, 220));
    draw_text(_mx + _mw/2, _my + 55, "Recrutamento de Unidades Terrestres");
    
    // === PAINEL DE INFORMAÇÕES LATERAL ===
    var _info_w = 220;
    var _info_x = _mx + _mw - _info_w;
    var _info_y = _my + _header_h;
    var _info_h = _mh - _header_h - 60; // Footer height
    
    // Fundo do painel de informações
    draw_set_color(make_color_rgb(25, 35, 50));
    draw_roundrect_ext(_info_x, _info_y, _info_x + _info_w, _info_y + _info_h, 0, 16, false);
    
    // Borda do painel de informações
    draw_set_color(make_color_rgb(70, 110, 160));
    draw_roundrect_ext(_info_x, _info_y, _info_x + _info_w, _info_y + _info_h, 0, 16, true);
    
    // Título do painel
    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(200, 220, 240));
    draw_text(_info_x + 15, _info_y + 20, "📊 INFORMAÇÕES");
    
    // Recursos disponíveis
    var _res_y = _info_y + 50;
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(_info_x + 15, _res_y, "💰 Dinheiro: $" + string(global.dinheiro));
    
    draw_set_color(make_color_rgb(192, 192, 192));
    draw_text(_info_x + 15, _res_y + 25, "👥 População: " + string(global.populacao) + "/20");
    
    // Status do quartel
    var _status_y = _res_y + 60;
    draw_set_color(make_color_rgb(200, 220, 240));
    draw_text(_info_x + 15, _status_y, "🏛️ Status do Quartel:");
    
    if (instance_exists(id_do_quartel)) {
        if (id_do_quartel.esta_treinando) {
            draw_set_color(make_color_rgb(255, 180, 0));
            var _tempo_restante = max(0, id_do_quartel.alarm[0]);
            draw_text(_info_x + 15, _status_y + 25, "⏳ Treinando...");
            draw_text(_info_x + 15, _status_y + 45, "Tempo: " + string(ceil(_tempo_restante / 60)) + "s");
        } else {
            draw_set_color(make_color_rgb(80, 200, 80));
            draw_text(_info_x + 15, _status_y + 25, "✅ Disponível");
        }
    } else {
        draw_set_color(make_color_rgb(200, 80, 80));
        draw_text(_info_x + 15, _status_y + 25, "❌ Erro");
    }
    
    // === GRID DE UNIDADES (2x2) ===
    var _grid_x = _mx + 20;
    var _grid_y = _my + _header_h + 20;
    var _grid_w = _mw - _info_w - 40;
    var _grid_h = _mh - _header_h - 100; // Footer space
    
    var _card_w = (_grid_w - 20) / 2;  // 2 colunas
    var _card_h = (_grid_h - 20) / 2;  // 2 linhas
    
    // Obter unidades disponíveis
    var _unidades = [];
    if (instance_exists(id_do_quartel)) {
        _unidades = id_do_quartel.unidades_disponiveis;
    }
    
    // Desenhar cards das unidades
    for (var i = 0; i < min(4, ds_list_size(_unidades)); i++) {
        var _unidade = ds_list_find_value(_unidades, i);
        var _row = i div 2;
        var _col = i mod 2;
        
        var _card_x = _grid_x + _col * (_card_w + 20);
        var _card_y = _grid_y + _row * (_card_h + 20);
        
        // Determinar cor baseada na disponibilidade
        var _can_afford = (global.dinheiro >= _unidade.custo_dinheiro && global.populacao >= _unidade.custo_populacao);
        var _quartel_livre = (!instance_exists(id) || !esta_treinando);
        var _disponivel = _can_afford && _quartel_livre;
        
        var _card_color = _disponivel ? make_color_rgb(35, 65, 45) : 
                         (!_can_afford ? make_color_rgb(65, 35, 35) : make_color_rgb(65, 55, 35));
        
        var _border_color = _disponivel ? make_color_rgb(120, 255, 150) :
                           (!_can_afford ? make_color_rgb(255, 120, 120) : make_color_rgb(255, 200, 100));
        
        // Sombra do card
        draw_set_color(make_color_rgb(0, 0, 0));
        draw_set_alpha(0.3);
        draw_roundrect_ext(_card_x + 3, _card_y + 3, _card_x + _card_w + 3, _card_y + _card_h + 3, 8, 8, false);
        draw_set_alpha(1);
        
        // Fundo do card
        draw_set_color(_card_color);
    draw_set_alpha(0.9);
        draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 8, 8, false);
        draw_set_alpha(1);
        
        // Borda do card
        draw_set_color(_border_color);
        draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 8, 8, true);
        
        // Ícone da unidade
        if (sprite_exists(_unidade.sprite)) {
            var _icon_x = _card_x + _card_w/2;
            var _icon_y = _card_y + 40;
            draw_sprite_ext(_unidade.sprite, 0, _icon_x, _icon_y, 2.5, 2.5, 0, c_white, 1);
        }
        
        // Nome da unidade
        draw_set_halign(fa_center);
        draw_set_color(c_white);
        draw_text(_card_x + _card_w/2, _card_y + 80, _unidade.nome);
        
        // Custos
        draw_set_color(make_color_rgb(255, 215, 0));
        draw_text(_card_x + _card_w/2, _card_y + 105, "💰 $" + string(_unidade.custo_dinheiro));
        draw_set_color(make_color_rgb(192, 192, 192));
        draw_text(_card_x + _card_w/2, _card_y + 125, "👥 " + string(_unidade.custo_populacao) + " pop");
        
        // Tempo de treino
        draw_set_color(make_color_rgb(180, 180, 180));
        draw_text(_card_x + _card_w/2, _card_y + 145, "⏱️ " + string(_unidade.tempo_treino / 60) + "s");
        
        // Botão de recrutar
        var _btn_x = _card_x + 15;
        var _btn_y = _card_y + _card_h - 35;
        var _btn_w = _card_w - 30;
        var _btn_h = 25;
        
        var _btn_color = _disponivel ? make_color_rgb(70, 130, 200) : make_color_rgb(100, 100, 100);
        draw_set_color(_btn_color);
        draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 4, 4, false);
        
        draw_set_color(c_white);
        draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 4, 4, true);
        
        draw_set_halign(fa_center);
        draw_set_color(c_white);
        var _btn_text = _disponivel ? "RECRUTAR" : (!_can_afford ? "SEM RECURSOS" : "QUARTEL OCUPADO");
        draw_text(_btn_x + _btn_w/2, _btn_y + _btn_h/2, _btn_text);
    }
    
    // === FOOTER MODERNO ===
    var _footer_y = _my + _mh - 60;
    draw_set_color(make_color_rgb(30, 45, 65));
    draw_roundrect_ext(_mx, _footer_y, _mx + _mw, _my + _mh, 0, 16, false);
    
    // Botão fechar
    var _close_w = 100;
    var _close_h = 35;
    var _close_x = _mx + _mw - _close_w - 20;
    var _close_y = _footer_y + 12;
    
    draw_set_color(make_color_rgb(150, 50, 50));
    draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 6, 6, false);
    
    draw_set_color(c_white);
    draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 6, 6, true);
    
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR");
    
    // Instruções
    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(150, 150, 150));
    draw_text(_mx + 20, _footer_y + 20, "Clique em uma unidade para recrutar ou fora do menu para fechar");
    
    // === RESETAR CONFIGURAÇÕES ===
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
