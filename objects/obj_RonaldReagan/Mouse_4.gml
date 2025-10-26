/// @description Clique Direito - Ordem de Embarque OU Menu de Desembarque
// ===============================================
// HEGEMONIA GLOBAL - PORTA-AVIÕES
// Sistema de Embarque por Clique Direto + Menu de Desembarque
// ===============================================

if (mouse_check_button_pressed(mb_right)) {
    // === PROCURAR UNIDADE SELECIONADA ===
    var _unidade_selecionada = noone;
    
    // Procurar qualquer unidade com selecionado = true
    with (all) {
        if (variable_instance_exists(id, "selecionado") && 
            selecionado && 
            id != other.id && 
            other.eh_embarcavel(id)) {
            _unidade_selecionada = id;
            break;
        }
    }
    
    // === SE UNIDADE SELECIONADA E NAVIO SELECIONADO ===
    if (variable_instance_exists(id, "selecionado") && selecionado && _unidade_selecionada != noone) {
        // Verificar se está em modo embarque
        if (variable_instance_exists(id, "estado_embarque") && estado_embarque == "embarcando") {
            // ✅ ORDENAR UNIDADE PARA EMBARCAR
            if (variable_instance_exists(_unidade_selecionada, "destino_x")) {
                // Definir destino para o navio
                _unidade_selecionada.destino_x = x;
                _unidade_selecionada.destino_y = y;
                
                // Marcar como indo embarcar
                _unidade_selecionada.indo_embarcar = true;
                
                // Ativar movimento
                if (variable_instance_exists(_unidade_selecionada, "velocidade_atual")) {
                    _unidade_selecionada.velocidade_atual = 5;
                }
                
                // Ativar estado de movimento
                if (variable_instance_exists(_unidade_selecionada, "estado")) {
                    _unidade_selecionada.estado = "movendo";
                }
                
                show_debug_message("✅ " + object_get_name(_unidade_selecionada.object_index) + " recebeu ordem de embarcar!");
            }
        } else {
            // Aviso: portas fechadas
            show_debug_message("❌ Porta-Aviões não está em modo embarque! Pressione P para abrir as portas.");
        }
    } else if (variable_instance_exists(id, "selecionado") && selecionado) {
        // === NENHUMA UNIDADE SELECIONADA - ABRIR MENU DE DESEMBARQUE ===
        var _total_unidades = (variable_instance_exists(id, "avioes_count") ? avioes_count : 0) +
                              (variable_instance_exists(id, "unidades_count") ? unidades_count : 0) +
                              (variable_instance_exists(id, "soldados_count") ? soldados_count : 0);
        
        if (_total_unidades > 0) {
            menu_desembarque_aberto = !menu_desembarque_aberto;
            show_debug_message("📋 Menu de Desembarque: " + (menu_desembarque_aberto ? "ABERTO" : "FECHADO"));
        } else {
            show_debug_message("❌ Nenhuma unidade a bordo!");
        }
    }
}

// === PROCESSAR INPUT DO MENU ===
if (menu_desembarque_aberto && variable_instance_exists(id, "selecionado") && selecionado) {
    // Teclas numéricas para selecionar
    for (var i = 0; i <= 9; i++) {
        if (keyboard_check_pressed(i)) {
            var _index = i - 1; // Numérico 0 = índice 0
            
            // Contar total
            var _total = (variable_instance_exists(id, "avioes_count") ? avioes_count : 0) +
                        (variable_instance_exists(id, "unidades_count") ? unidades_count : 0) +
                        (variable_instance_exists(id, "soldados_count") ? soldados_count : 0);
            
            if (_index >= 0 && _index < _total) {
                menu_desembarque_selecionado = _index;
                show_debug_message("📌 Selecionado: Índice " + string(_index));
            }
        }
    }
    
    // ESC para fechar
    if (keyboard_check_pressed(vk_escape)) {
        menu_desembarque_aberto = false;
        menu_desembarque_selecionado = -1;
        show_debug_message("📋 Menu de Desembarque FECHADO!");
    }
}

// === PROCESSAR CLIQUE NO MENU (se estiver aberto) ===
if (menu_desembarque_aberto && variable_instance_exists(id, "selecionado") && selecionado && mouse_check_button_pressed(mb_left)) {
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    // Coordenadas do menu
    var _menu_x = 20;
    var _menu_y = 200;
    var _menu_w = 300;
    var _menu_h = 400;
    var _btn_y = _menu_y + _menu_h - 40;
    var _btn_w = _menu_w - 40;
    
    // Verificar clique no botão DESEMBARCAR
    if (_mouse_gui_x >= _menu_x + 20 && _mouse_gui_x <= _menu_x + 20 + _btn_w &&
        _mouse_gui_y >= _btn_y && _mouse_gui_y <= _btn_y + 30) {
        
        // Processar desembarque se houver seleção
        if (menu_desembarque_selecionado >= 0) {
            // Coletar todas as unidades
            var _items_ids = [];
            
            if (variable_instance_exists(id, "avioes_embarcados")) {
                for (var i = 0; i < ds_list_size(avioes_embarcados); i++) {
                    var _id = avioes_embarcados[| i];
                    if (instance_exists(_id)) {
                        array_push(_items_ids, _id);
                    }
                }
            }
            
            if (variable_instance_exists(id, "unidades_embarcadas")) {
                for (var i = 0; i < ds_list_size(unidades_embarcadas); i++) {
                    var _id = unidades_embarcadas[| i];
                    if (instance_exists(_id)) {
                        array_push(_items_ids, _id);
                    }
                }
            }
            
            if (variable_instance_exists(id, "soldados_embarcados")) {
                for (var i = 0; i < ds_list_size(soldados_embarcados); i++) {
                    var _id = soldados_embarcados[| i];
                    if (instance_exists(_id)) {
                        array_push(_items_ids, _id);
                    }
                }
            }
            
            // Adicionar à fila
            if (array_length(_items_ids) > menu_desembarque_selecionado) {
                adicionar_fila_desembarque(_items_ids[menu_desembarque_selecionado]);
                show_debug_message("🚢 Unidade adicionada à fila de desembarque!");
            }
            
            menu_desembarque_selecionado = -1;
        }
    }
    
    // Verificar clique na lista de unidades
    var _lista_y = _menu_y + 40;
    var _items = [];
    
    // Coletar todas as unidades
    if (variable_instance_exists(id, "avioes_embarcados")) {
        for (var i = 0; i < ds_list_size(avioes_embarcados); i++) {
            var _id = avioes_embarcados[| i];
            if (instance_exists(_id)) {
                array_push(_items, _id);
            }
        }
    }
    
    if (variable_instance_exists(id, "unidades_embarcadas")) {
        for (var i = 0; i < ds_list_size(unidades_embarcadas); i++) {
            var _id = unidades_embarcadas[| i];
            if (instance_exists(_id)) {
                array_push(_items, _id);
            }
        }
    }
    
    if (variable_instance_exists(id, "soldados_embarcados")) {
        for (var i = 0; i < ds_list_size(soldados_embarcados); i++) {
            var _id = soldados_embarcados[| i];
            if (instance_exists(_id)) {
                array_push(_items, _id);
            }
        }
    }
    
    // Verificar clique em item da lista
    for (var i = 0; i < array_length(_items); i++) {
        var _item_y = _lista_y + (i * 30);
        
        if (_mouse_gui_y >= _item_y - 5 && _mouse_gui_y <= _item_y + 25 &&
            _mouse_gui_x >= _menu_x + 10 && _mouse_gui_x <= _menu_x + _menu_w - 10) {
            menu_desembarque_selecionado = i;
            show_debug_message("📌 Unidade " + string(i) + " selecionada");
            break;
        }
    }
}
