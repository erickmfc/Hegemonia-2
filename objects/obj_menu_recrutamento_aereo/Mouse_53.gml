// ===============================================
// HEGEMONIA GLOBAL - MENU AÉREO MODERNO
// Sistema de Cliques no Grid - Mouse_53 (Left Pressed)
// ===============================================

show_debug_message("🚀 MOUSE_53 EVENTO EXECUTADO (Aeroporto)!");

// ✅ PROTEÇÃO CONTRA CLIQUE ACIDENTAL
// Verificar se o menu foi aberto há frames suficientes
if (menu_aberto_frames < frames_minimos_antes_clique) {
    show_debug_message("⚠️ Menu recém-aberto, ignorando clique para evitar ação acidental");
    exit;
}

var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _menu_w = _gui_w * 0.9;
var _menu_h = _gui_h * 0.9;
var _menu_x = (_gui_w - _menu_w) / 2;
var _menu_y = (_gui_h - _menu_h) / 2;

// === BOTÃO FECHAR ===
var _close_w = 140;
var _close_h = 45;
var _close_x = _menu_x + _menu_w - _close_w - 20;
var _close_y = _menu_y + _menu_h - 60;

if (_mouse_gui_x >= _close_x && _mouse_gui_x <= _close_x + _close_w &&
    _mouse_gui_y >= _close_y && _mouse_gui_y <= _close_y + _close_h) {
    show_debug_message("✅ Botão FECHAR clicado!");
    if (instance_exists(id_do_aeroporto)) {
        id_do_aeroporto.menu_recrutamento = noone;
    }
    instance_destroy();
    exit;
}

// === CLIQUE NOS CARDS DE AERONAVES ===
var _header_h = 100;
var _recursos_y = _menu_y + _header_h + 10;
var _recursos_h = 60;
var _grid_start_y = _recursos_y + _recursos_h + 20;
var _grid_h = _menu_h - _header_h - _recursos_h - 180;

var _cols = 3;
var _rows = 2;
var _card_spacing = 20;
var _card_w = (_menu_w - 40 - (_cols - 1) * _card_spacing) / _cols;
var _card_h = (_grid_h - (_rows - 1) * _card_spacing) / _rows;

if (id_do_aeroporto == noone || !instance_exists(id_do_aeroporto)) {
    instance_destroy();
    exit;
}

var _aeronaves = id_do_aeroporto.unidades_disponiveis;
var _total_aeronaves = ds_list_size(_aeronaves);

// Verificar clique em cada card
for (var i = 0; i < min(_total_aeronaves, 6); i++) {
    var _aeronave = ds_list_find_value(_aeronaves, i);
    
    var _col = i mod _cols;
    var _row = floor(i / _cols);
    var _card_x = _menu_x + 20 + _col * (_card_w + _card_spacing);
    var _card_y = _grid_start_y + _row * (_card_h + _card_spacing);
    
    // Verificar clique no card
    if (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _card_w &&
        _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _card_h) {
        
        show_debug_message("🎯 CLIQUE NO CARD: " + _aeronave.nome);
        
        // Verificar se pode produzir
        var _populacao = variable_global_exists("populacao") ? global.populacao : 50;
        var _dinheiro = variable_global_exists("dinheiro") ? global.dinheiro : 1000;
        
        var _can_produce = (_dinheiro >= _aeronave.custo_dinheiro && 
                            _populacao >= _aeronave.custo_populacao);
        
        if (_can_produce) {
            // Sistema de múltiplas unidades
            var _quantidade = 1;
            if (keyboard_check(vk_shift)) _quantidade = 5;
            else if (keyboard_check(vk_control)) _quantidade = 10;
            
            var _custo_total_dinheiro = _aeronave.custo_dinheiro * _quantidade;
            var _custo_total_populacao = _aeronave.custo_populacao * _quantidade;
            
            if (_dinheiro >= _custo_total_dinheiro && _populacao >= _custo_total_populacao) {
                // Deduzir recursos
                global.dinheiro -= _custo_total_dinheiro;
                if (variable_global_exists("populacao")) {
                    global.populacao -= _custo_total_populacao;
                }
                
                // Adicionar unidades à fila
                for (var j = 0; j < _quantidade; j++) {
                    ds_queue_enqueue(id_do_aeroporto.fila_producao, _aeronave);
                }
                
                // ✅ SISTEMA DE FILA: Adicionar unidades sempre funcionará
                // O Step Event do aeroporto iniciará produção automaticamente se estiver ocioso
                var _fila_size = ds_queue_size(id_do_aeroporto.fila_producao);
                show_debug_message("📊 Total na fila: " + string(_fila_size) + " unidades");
                
                if (!id_do_aeroporto.produzindo) {
                    // Se aeroporto está ocioso, iniciar produção imediatamente
                    id_do_aeroporto.produzindo = true;
                    id_do_aeroporto.timer_producao = 0;
                    show_debug_message("🚀 Aeroporto iniciando produção imediatamente");
                } else {
                    // Já está produzindo, apenas adicionou à fila
                    show_debug_message("🔄 Aeroporto já está produzindo, unidade adicionada à fila");
                }
                
                show_debug_message("✅ " + string(_quantidade) + "x " + _aeronave.nome + " adicionadas à fila!");
            } else {
                show_debug_message("❌ Recursos insuficientes para " + string(_quantidade) + " unidades!");
            }
        } else {
            show_debug_message("❌ Não pode produzir: Dinheiro=$" + string(_dinheiro) + "/" + string(_aeronave.custo_dinheiro));
        }
        
        break;
    }
}
