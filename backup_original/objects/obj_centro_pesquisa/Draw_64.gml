// Interface do Sistema de Pesquisa Tecnológica

if (global.menu_pesquisa_aberto) {
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(0, 0, window_get_width(), window_get_height(), false);
    draw_set_alpha(1);

    var _menu_w = window_get_width() * 0.6;
    var _menu_h = window_get_height() * 0.6;
    var _menu_x = (window_get_width()/2) - (_menu_w/2);
    var _menu_y = (window_get_height()/2) - (_menu_h/2);
    
    // Fundo do menu
    draw_set_color(make_color_rgb(25,25,35));
    draw_roundrect_ext(_menu_x, _menu_y, _menu_x+_menu_w, _menu_y+_menu_h, 15, 15, false);
    draw_set_color(make_color_rgb(45,45,55));
    draw_roundrect_ext(_menu_x+3, _menu_y+3, _menu_x+_menu_w-3, _menu_y+_menu_h-3, 12, 12, true);

    // Título
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_set_font(-1);
    draw_text(_menu_x + _menu_w/2, _menu_y + 20, "CENTRO DE PESQUISA TECNOLÓGICA");
    
    // Informações de slots e dinheiro
    var slots_disponiveis = global.slots_pesquisa_total - global.slots_pesquisa_usados;
    draw_set_color(c_yellow);
    draw_text(_menu_x + _menu_w * 0.15, _menu_y + _menu_h * 0.08, "Dinheiro: $" + string(global.estoque_recursos[? "Dinheiro"]));
    draw_text(_menu_x + _menu_w * 0.85, _menu_y + _menu_h * 0.08, "Slots: " + string(slots_disponiveis) + "/" + string(global.slots_pesquisa_total));
    
    // Grade de recursos (3x4)
    var _grid_start_x = _menu_x + _menu_w * 0.05;
    var _grid_start_y = _menu_y + _menu_h * 0.15;
    var _card_w = _menu_w * 0.2;
    var _card_h = _menu_h * 0.15;
    var _spacing_x = _menu_w * 0.22;
    var _spacing_y = _menu_h * 0.18;
    
    var recursos = ["Borracha", "Petróleo", "Silício", "Minério",
                   "Alumínio", "Aço", "Ouro", "Madeira", 
                   "Cobre", "Urânio", "Lítio", "Titânio"];
    
    var precos = [6000, 7500, 8000, 5000,
                 9000, 10000, 15000, 4000,
                 7000, 25000, 12000, 18000];
    
    var tempos = [40, 45, 60, 30,
                 50, 70, 80, 25,
                 35, 120, 90, 100];
    
    for (var i = 0; i < array_length(recursos); i++) {
        var col = i % 4;
        var row = i div 4;
        var card_x = _grid_start_x + (col * _spacing_x);
        var card_y = _grid_start_y + (row * _spacing_y);
        
        var recurso = recursos[i];
        var status = global.nacao_recursos[? recurso];
        var preco = precos[i];
        var tempo = tempos[i];
        
        // Cor do card baseada no status
        var card_color = make_color_rgb(60,60,70); // Não disponível
        var text_color = c_gray;
        
        if (status == RESOURCE_STATUS.AVAILABLE) {
            card_color = make_color_rgb(40,60,80); // Disponível para pesquisa
            text_color = c_white;
        } else if (status == RESOURCE_STATUS.RESEARCHED) {
            card_color = make_color_rgb(40,80,40); // Já pesquisado
            text_color = c_lime;
        }
        
        // Verificar se está sendo pesquisado
        var sendo_pesquisado = ds_list_find_index(global.pesquisas_ativas, recurso) != -1;
        if (sendo_pesquisado) {
            card_color = make_color_rgb(80,60,40); // Em pesquisa
            text_color = c_yellow;
        }
        
        // Desenhar card
        draw_set_color(card_color);
        draw_roundrect_ext(card_x, card_y, card_x+_card_w, card_y+_card_h, 8, 8, false);
        draw_set_color(make_color_rgb(80,80,90));
        draw_roundrect_ext(card_x+2, card_y+2, card_x+_card_w-2, card_y+_card_h-2, 6, 6, true);
        
        // Texto do recurso
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(text_color);
        draw_text(card_x + _card_w/2, card_y + 20, recurso);
        
        // Informações de custo e tempo
        draw_set_color(c_white);
        draw_text(card_x + _card_w/2, card_y + 40, "$" + string(preco));
        draw_text(card_x + _card_w/2, card_y + 55, string(tempo) + "s");
        
        // Status específico
        if (sendo_pesquisado) {
            var tempo_restante = global.pesquisas_tempo_restante[? recurso];
            draw_set_color(c_yellow);
            draw_text(card_x + _card_w/2, card_y + 75, string(ceil(tempo_restante)) + "s");
        } else if (status == RESOURCE_STATUS.RESEARCHED) {
            draw_set_color(c_lime);
            draw_text(card_x + _card_w/2, card_y + 75, "COMPLETO");
        } else if (status == RESOURCE_STATUS.AVAILABLE && slots_disponiveis > 0 && global.estoque_recursos[? "Dinheiro"] >= preco) {
            draw_set_color(c_aqua);
            draw_text(card_x + _card_w/2, card_y + 75, "CLIQUE");
        }
    }
    
    // Botão para comprar slot extra
    if (global.pode_comprar_slot_extra && !global.slot_extra_comprado) {
        var btn_x = _menu_x + _menu_w * 0.05;
        var btn_y = _menu_y + _menu_h * 0.83;
        var btn_w = _menu_w * 0.25;
        var btn_h = _menu_h * 0.06;
        
        var pode_comprar = global.estoque_recursos[? "Dinheiro"] >= global.custo_slot_extra;
        draw_set_color(pode_comprar ? make_color_rgb(40,80,40) : make_color_rgb(60,40,40));
        draw_roundrect_ext(btn_x, btn_y, btn_x+btn_w, btn_y+btn_h, 8, 8, false);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(btn_x + btn_w/2, btn_y + btn_h/2, "SLOT EXTRA ($" + string(global.custo_slot_extra) + ")");
    }
    
    // Botão Fechar
    var close_x = _menu_x + _menu_w * 0.8;
    var close_y = _menu_y + _menu_h * 0.9;
    var close_w = _menu_w * 0.15;
    var close_h = _menu_h * 0.06;
    draw_set_color(c_red);
    draw_roundrect_ext(close_x, close_y, close_x+close_w, close_y+close_h, 8, 8, false);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(close_x+close_w/2, close_y+close_h/2, "FECHAR");
    
    // Instruções
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_yellow);
    draw_text(_menu_x + _menu_w/2, _menu_y + _menu_h * 0.97, "Clique nos recursos para pesquisar (máx. " + string(global.slots_pesquisa_total) + ") | ESC para fechar");
}