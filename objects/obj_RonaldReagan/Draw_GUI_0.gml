/// @description Menu de Desembarque do Porta-Aviões
// ===============================================
// HEGEMONIA GLOBAL - PORTA-AVIÕES
// Draw GUI - Menu de desembarque lateral
// ===============================================

if (!menu_desembarque_aberto || !selecionado) {
    // Não desenhar menu se estiver fechado ou navio não selecionado
    exit;
}

// === MENU DE DESEMBARQUE ===
var _menu_x = 20;
var _menu_y = 200;
var _menu_w = 300;
var _menu_h = 400;

// Contar unidades armazenadas
var _avioes = 0;
var _unidades = 0;
var _soldados = 0;

if (variable_instance_exists(id, "avioes_embarcados")) {
    _avioes = ds_list_size(avioes_embarcados);
}
if (variable_instance_exists(id, "unidades_embarcadas")) {
    _unidades = ds_list_size(unidades_embarcadas);
}
if (variable_instance_exists(id, "soldados_embarcados")) {
    _soldados = ds_list_size(soldados_embarcados);
}

var _total_unidades = _avioes + _unidades + _soldados;

// Fundo do menu
draw_set_color(c_black);
draw_set_alpha(0.85);
draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, false);
draw_set_alpha(1.0);

// Borda
draw_set_color(c_blue);
draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, true);

// Título
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(_menu_x + _menu_w/2, _menu_y + 10, "UNIDADES A BORDO");
draw_set_halign(fa_left);

// Lista de unidades
if (_total_unidades > 0) {
    var _lista_y = _menu_y + 40;
    var _items = [];
    
    // Coletar todas as unidades
    if (variable_instance_exists(id, "avioes_embarcados")) {
        for (var i = 0; i < ds_list_size(avioes_embarcados); i++) {
            var _id = avioes_embarcados[| i];
            if (instance_exists(_id)) {
                array_push(_items, {id: _id, tipo: "Avião", nome: object_get_name(_id.object_index)});
            }
        }
    }
    
    if (variable_instance_exists(id, "unidades_embarcadas")) {
        for (var i = 0; i < ds_list_size(unidades_embarcadas); i++) {
            var _id = unidades_embarcadas[| i];
            if (instance_exists(_id)) {
                array_push(_items, {id: _id, tipo: "Unidade", nome: object_get_name(_id.object_index)});
            }
        }
    }
    
    if (variable_instance_exists(id, "soldados_embarcados")) {
        for (var i = 0; i < ds_list_size(soldados_embarcados); i++) {
            var _id = soldados_embarcados[| i];
            if (instance_exists(_id)) {
                array_push(_items, {id: _id, tipo: "Soldado", nome: object_get_name(_id.object_index)});
            }
        }
    }
    
    // Desenhar lista (máximo 10 itens visíveis)
    var _max_items = min(10, array_length(_items));
    for (var i = 0; i < _max_items; i++) {
        var _index = i + menu_desembarque_scroll;
        if (_index >= array_length(_items)) break;
        var _item = _items[_index];
        
        var _y = _lista_y + (i * 30);
        
        // Verificar se está selecionado
        if (menu_desembarque_selecionado == i + menu_desembarque_scroll) {
            draw_set_color(c_yellow);
            draw_rectangle(_menu_x + 10, _y - 5, _menu_x + _menu_w - 10, _y + 25, false);
        }
        
        draw_set_color(c_white);
        var _texto = _item.nome + " (" + _item.tipo + ")";
        draw_text(_menu_x + 20, _y, _texto);
    }
    
    // Botão DESEMBARCAR
    var _btn_y = _menu_y + _menu_h - 40;
    var _btn_w = _menu_w - 40;
    
    draw_set_color(menu_desembarque_selecionado >= 0 ? c_green : c_gray);
    draw_rectangle(_menu_x + 20, _btn_y, _menu_x + 20 + _btn_w, _btn_y + 30, false);
    
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(_menu_x + _menu_w/2, _btn_y + 15, "DESEMBARCAR");
    
    // Contador
    draw_set_color(c_aqua);
    draw_text(_menu_x + 20, _menu_y + 20, "Total: " + string(_total_unidades));
    
    draw_set_halign(fa_left);
} else {
    // Menu vazio
    draw_set_color(c_gray);
    draw_set_halign(fa_center);
    draw_text(_menu_x + _menu_w/2, _menu_y + _menu_h/2, "Nenhuma unidade");
    draw_text(_menu_x + _menu_w/2, _menu_y + _menu_h/2 + 20, "a bordo");
    draw_set_halign(fa_left);
}
