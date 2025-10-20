// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO AÉREO
// Evento Mouse Left Pressed - Interação Melhorada
// ===============================================

// Verificar se o aeroporto ainda existe
if (id_do_aeroporto == noone || !instance_exists(id_do_aeroporto)) {
    instance_destroy();
    exit;
}

// Obter coordenadas do mouse na GUI
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

// === DIMENSÕES DO MENU (CONSISTENTES COM DRAW) ===
var _mw = display_get_gui_width() * 0.5;
var _mh = display_get_gui_height() * 0.6;
var _mx = (display_get_gui_width() - _mw) / 2;
var _my = (display_get_gui_height() - _mh) / 2;

// === OBTER DADOS DAS UNIDADES ===
var _unidades = id_do_aeroporto.unidades_disponiveis;
var _content_start_y = _my + 100;

// === VERIFICAR CLIQUE NO BOTÃO FECHAR ===
var _fechar_w = 80;
var _fechar_h = 30;
var _fechar_x = _mx + _mw - _fechar_w - 20;
var _fechar_y = _my + _mh - _fechar_h - 20;

if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _fechar_x, _fechar_y, _fechar_x + _fechar_w, _fechar_y + _fechar_h)) {
    show_debug_message("❌ Menu aéreo fechado pelo jogador.");
    instance_destroy();
    exit;
}

// === VERIFICAR CLIQUE NAS UNIDADES ===

// UNIDADE 1: CAÇA F-5
if (ds_list_size(_unidades) > 0) {
    var _unidade_f5 = ds_list_find_value(_unidades, 0);
    
    var _card_w = _mw - 40;
    var _card_h = 100;
    var _card_x = _mx + 20;
    var _card_y = _content_start_y;
    
    // Botão de produção F-5
    var _btn_w = 120;
    var _btn_h = 35;
    var _btn_x = _card_x + _card_w - _btn_w - 15;
    var _btn_y = _card_y + (_card_h - _btn_h) / 2;
    
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h)) {
        
        // Verificar se pode produzir
        if (global.dinheiro >= _unidade_f5.custo_dinheiro) {
            
            // Subtrair recursos
            global.dinheiro -= _unidade_f5.custo_dinheiro;
            
            // Adicionar à fila de produção
            ds_queue_enqueue(id_do_aeroporto.fila_producao, _unidade_f5);
            
            // Ativar produção
            id_do_aeroporto.produzindo = true;
            
            show_debug_message("✅ Ordem de produção para " + _unidade_f5.nome + " enviada ao aeroporto!");
            show_debug_message("💰 Dinheiro restante: $" + string(global.dinheiro));
            instance_destroy();
            
        } else {
            show_debug_message("❌ Dinheiro insuficiente para produzir " + _unidade_f5.nome);
            show_debug_message("💰 Necessário: $" + string(_unidade_f5.custo_dinheiro) + " | Disponível: $" + string(global.dinheiro));
        }
    }
}

// UNIDADE 2: HELICÓPTERO MILITAR
if (ds_list_size(_unidades) > 1) {
    var _unidade_heli = ds_list_find_value(_unidades, 1);
    
    var _card_w = _mw - 40;
    var _card_h = 100;
    var _card_x = _mx + 20;
    var _card_y = _content_start_y + 120;
    
    // Botão de produção Helicóptero
    var _btn_w = 120;
    var _btn_h = 35;
    var _btn_x = _card_x + _card_w - _btn_w - 15;
    var _btn_y = _card_y + (_card_h - _btn_h) / 2;
    
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h)) {
        
        // Verificar se pode produzir
        if (global.dinheiro >= _unidade_heli.custo_dinheiro) {
            
            // Subtrair recursos
            global.dinheiro -= _unidade_heli.custo_dinheiro;
            
            // Adicionar à fila de produção
            ds_queue_enqueue(id_do_aeroporto.fila_producao, _unidade_heli);
            
            // Ativar produção
            id_do_aeroporto.produzindo = true;
            
            show_debug_message("✅ Ordem de produção para " + _unidade_heli.nome + " enviada ao aeroporto!");
            show_debug_message("💰 Dinheiro restante: $" + string(global.dinheiro));
            instance_destroy();
            
        } else {
            show_debug_message("❌ Dinheiro insuficiente para produzir " + _unidade_heli.nome);
            show_debug_message("💰 Necessário: $" + string(_unidade_heli.custo_dinheiro) + " | Disponível: $" + string(global.dinheiro));
        }
    }
}

// UNIDADE 3: C-100 TRANSPORTE
if (ds_list_size(_unidades) > 2) {
    var _unidade_c100 = ds_list_find_value(_unidades, 2);
    
    var _card_w = _mw - 40;
    var _card_h = 100;
    var _card_x = _mx + 20;
    var _card_y = _content_start_y + 240;
    
    var _btn_w = 120;
    var _btn_h = 35;
    var _btn_x = _card_x + _card_w - _btn_w - 15;
    var _btn_y = _card_y + (_card_h - _btn_h) / 2;
    
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h)) {
        if (global.dinheiro >= _unidade_c100.custo_dinheiro) {
            global.dinheiro -= _unidade_c100.custo_dinheiro;
            ds_queue_enqueue(id_do_aeroporto.fila_producao, _unidade_c100);
            id_do_aeroporto.produzindo = true;
            show_debug_message("✅ Ordem de produção para " + _unidade_c100.nome + " enviada ao aeroporto!");
            show_debug_message("💰 Dinheiro restante: $" + string(global.dinheiro));
            instance_destroy();
        } else {
            show_debug_message("❌ Dinheiro insuficiente para produzir " + _unidade_c100.nome);
            show_debug_message("💰 Necessário: $" + string(_unidade_c100.custo_dinheiro) + " | Disponível: $" + string(global.dinheiro));
        }
    }
}

// === CLIQUE FORA DO MENU ===
// Se clicou fora do menu, não fazer nada (manter menu aberto)
// O jogador pode clicar no botão fechar para sair
