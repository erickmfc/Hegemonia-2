// Evento Mouse Left Pressed - obj_centro_pesquisa

if (global.menu_pesquisa_aberto) {
    var _menu_w = window_get_width() * 0.6;
    var _menu_h = window_get_height() * 0.6;
    var _menu_x = (window_get_width()/2) - (_menu_w/2);
    var _menu_y = (window_get_height()/2) - (_menu_h/2);
    
    // Verificar clique no botão fechar
    var close_x = _menu_x + _menu_w * 0.8;
    var close_y = _menu_y + _menu_h * 0.9;
    var close_w = _menu_w * 0.15;
    var close_h = _menu_h * 0.06;
    if (point_in_rectangle(mouse_x, mouse_y, close_x, close_y, close_x+close_w, close_y+close_h)) {
        global.menu_pesquisa_aberto = false;
        exit;
    }
    
    // Verificar clique no botão slot extra
    if (global.pode_comprar_slot_extra && !global.slot_extra_comprado) {
        var btn_x = _menu_x + _menu_w * 0.05;
        var btn_y = _menu_y + _menu_h * 0.83;
        var btn_w = _menu_w * 0.25;
        var btn_h = _menu_h * 0.06;
        
        if (point_in_rectangle(mouse_x, mouse_y, btn_x, btn_y, btn_x+btn_w, btn_y+btn_h)) {
            if (global.estoque_recursos[? "Dinheiro"] >= global.custo_slot_extra) {
                global.estoque_recursos[? "Dinheiro"] -= global.custo_slot_extra;
                global.slots_pesquisa_total = 4;
                global.slot_extra_comprado = true;
                show_debug_message("Slot extra de pesquisa comprado!");
            }
            exit;
        }
    }
    
    // Verificar cliques nos cards de recursos
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
        
        if (point_in_rectangle(mouse_x, mouse_y, card_x, card_y, card_x+_card_w, card_y+_card_h)) {
            var recurso = recursos[i];
            var status = global.nacao_recursos[? recurso];
            var preco = precos[i];
            var tempo = tempos[i];
            
            // Verificar se pode iniciar pesquisa
            if (status == RESOURCE_STATUS.AVAILABLE && 
                global.slots_pesquisa_usados < global.slots_pesquisa_total &&
                global.estoque_recursos[? "Dinheiro"] >= preco &&
                ds_list_find_index(global.pesquisas_ativas, recurso) == -1) {
                
                // Iniciar pesquisa
                global.estoque_recursos[? "Dinheiro"] -= preco;
                global.slots_pesquisa_usados++;
                ds_list_add(global.pesquisas_ativas, recurso);
                ds_map_add(global.pesquisas_tempo_restante, recurso, tempo);
                
                show_debug_message("Pesquisa iniciada: " + recurso + " por $" + string(preco));
            }
            break;
        }
    }
}
