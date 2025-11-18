// ===============================================
// HEGEMONIA GLOBAL - MENU NAVAL MODERNO
// Sistema de Cliques no Grid
// ===============================================

show_debug_message("🚀 MOUSE_56 EVENTO EXECUTADO!");
show_debug_message("🔍 Mouse button released: " + string(mouse_check_button_released(mb_left)));
show_debug_message("🔍 Mouse button pressed: " + string(mouse_check_button_pressed(mb_left)));
show_debug_message("🔍 Mouse button down: " + string(mouse_check_button(mb_left)));
show_debug_message("🔍 Mouse button up: " + string(mouse_check_button_pressed(mb_left)));

// === PROTEÇÃO CONTRA CLIQUE AUTOMÁTICO ===
// Evitar que cliques sejam processados imediatamente após abrir o menu
if (menu_aberto_frames < frames_minimos_antes_clique) {
    show_debug_message("⏳ Menu aberto há " + string(menu_aberto_frames) + " frames. Aguardando " + string(frames_minimos_antes_clique) + " frames antes de aceitar cliques.");
    exit; // Sair sem processar cliques
}

show_debug_message("✅ Mouse_56 executado - Menu aberto há " + string(menu_aberto_frames) + " frames. Processando cliques...");
show_debug_message("🔍 Mouse position: (" + string(mouse_x) + ", " + string(mouse_y) + ")");
show_debug_message("🔍 Mouse GUI position: (" + string(device_mouse_x_to_gui(0)) + ", " + string(device_mouse_y_to_gui(0)) + ")");

var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _menu_w = _gui_w * 0.9;
var _menu_h = _gui_h * 0.9;
var _menu_x = (_gui_w - _menu_w) / 2;
var _menu_y = (_gui_h - _menu_h) / 2;

show_debug_message("🔍 Menu dimensions: x=" + string(_menu_x) + ", y=" + string(_menu_y) + ", w=" + string(_menu_w) + ", h=" + string(_menu_h));
show_debug_message("🔍 Mouse inside menu: " + string(_mouse_gui_x >= _menu_x && _mouse_gui_x <= _menu_x + _menu_w && _mouse_gui_y >= _menu_y && _mouse_gui_y <= _menu_y + _menu_h));

// === BOTÃO FECHAR (PADRONIZADO - SINCRONIZADO COM DRAW) ===
var _close_w = 168; // Padronizado com menu de recrutamento
var _close_h = 54;  // Padronizado com menu de recrutamento
var _close_x = _menu_x + _menu_w - _close_w - 20;
var _close_y = _menu_y + _menu_h - 72; // Sincronizado com Draw_64.gml

if (_mouse_gui_x >= _close_x && _mouse_gui_x <= _close_x + _close_w &&
    _mouse_gui_y >= _close_y && _mouse_gui_y <= _close_y + _close_h) {
    show_debug_message("✅ Botão FECHAR clicado!");
    if (instance_exists(meu_quartel_id)) {
        meu_quartel_id.menu_recrutamento = noone;
    }
    instance_destroy();
    exit;
}

// === CLIQUE NOS CARDS DE NAVIOS ===
var _header_h = 100;
var _recursos_y = _menu_y + _header_h + 10;
var _recursos_h = 60;
var _grid_start_y = _recursos_y + _recursos_h + 20;
var _grid_h = _menu_h - _header_h - _recursos_h - 180;

var _cols = 3;
var _rows = 2;
var _card_spacing = 20;
// ✅ CORREÇÃO: Sincronizar cálculo com Draw_64.gml
var _espaco_disponivel_w = _menu_w - 40 - (_cols - 1) * _card_spacing;
var _espaco_disponivel_h = _grid_h - (_rows - 1) * _card_spacing;
var _card_w = (_espaco_disponivel_w / _cols) * 0.85;
var _card_h = (_espaco_disponivel_h / _rows) * 0.85 * 1.1; // ✅ Sincronizado com Draw

if (meu_quartel_id == noone || !instance_exists(meu_quartel_id)) {
    instance_destroy();
    exit;
}

var _navios = meu_quartel_id.unidades_disponiveis;
var _total_navios = ds_list_size(_navios);

// Verificar clique em cada card
for (var i = 0; i < min(_total_navios, 6); i++) {
    var _navio = _navios[| i];
    
    var _col = i mod _cols;
    var _row = floor(i / _cols);
    var _card_x = _menu_x + 20 + _col * (_card_w + _card_spacing);
    // ✅ CORREÇÃO: Sincronizar cálculo de _card_y com Draw_64.gml
    var _card_y = _grid_start_y + _row * (_card_h + _card_spacing);
    if (_row == 1) {
        _card_y += _card_h * 0.2; // Mover segunda linha 20% para baixo (sincronizado com Draw)
    }
    
    // ✅ CORREÇÃO: Calcular posição do botão PRODUZIR (sincronizado com Draw_64.gml)
    var _btn_y = _card_y + _card_h - 35;
    var _btn_h = 30;
    var _btn_w = _card_w - 30;
    var _btn_x = _card_x + 15;
    
    // ✅ NOVO: Verificar clique especificamente no botão PRODUZIR
    var _clique_no_botao = (_mouse_gui_x >= _btn_x && _mouse_gui_x <= _btn_x + _btn_w &&
                            _mouse_gui_y >= _btn_y && _mouse_gui_y <= _btn_y + _btn_h);
    
    if (_clique_no_botao) {
        
        show_debug_message("🎯 CLIQUE DETECTADO NO CARD " + string(i) + " - " + _navio.nome);
        show_debug_message("   Posição do mouse: (" + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");
        show_debug_message("   Área do card: (" + string(_card_x) + ", " + string(_card_y) + ") até (" + string(_card_x + _card_w) + ", " + string(_card_y + _card_h) + ")");
        
        // Verificar se pode produzir
        var _populacao = 50;
        var _dinheiro = 1000; // Valor padrão
        
        if (variable_global_exists("populacao")) {
            _populacao = global.populacao;
        }
        
        if (variable_global_exists("dinheiro")) {
            _dinheiro = global.dinheiro;
        } else {
            show_debug_message("⚠️ AVISO: global.dinheiro não existe! Usando valor padrão: $" + string(_dinheiro));
        }
        
        var _can_produce = (_dinheiro >= _navio.custo_dinheiro && 
                            _populacao >= _navio.custo_populacao &&
                            !meu_quartel_id.produzindo);
        
        // Debug detalhado das condições
        show_debug_message("🔍 VERIFICAÇÃO DE RECURSOS:");
        show_debug_message("   Dinheiro atual: $" + string(_dinheiro));
        show_debug_message("   Custo necessário: $" + string(_navio.custo_dinheiro));
        show_debug_message("   Dinheiro suficiente: " + string(_dinheiro >= _navio.custo_dinheiro));
        show_debug_message("   População atual: " + string(_populacao));
        show_debug_message("   População necessária: " + string(_navio.custo_populacao));
        show_debug_message("   População suficiente: " + string(_populacao >= _navio.custo_populacao));
        show_debug_message("   Quartel produzindo: " + string(meu_quartel_id.produzindo));
        show_debug_message("   PODE PRODUZIR: " + string(_can_produce));
        
        if (_can_produce) {
            show_debug_message("🎯 CLIQUE NO NAVIO: " + _navio.nome);
            show_debug_message("💰 Custo: $" + string(_navio.custo_dinheiro));
            show_debug_message("👥 População: " + string(_navio.custo_populacao));
            
            // Sistema de múltiplas unidades
            var _quantidade = 1; // Quantidade padrão
            
            // Verificar se Shift está pressionado para 5 unidades
            if (keyboard_check(vk_shift)) {
                _quantidade = 5;
                show_debug_message("🚀 MODO RÁPIDO: Criando 5 unidades!");
            }
            // Verificar se Ctrl está pressionado para 10 unidades
            else if (keyboard_check(vk_control)) {
                _quantidade = 10;
                show_debug_message("🚀 MODO MASSIVO: Criando 10 unidades!");
            }
            
            // Verificar se tem recursos suficientes para a quantidade
            var _custo_total_dinheiro = _navio.custo_dinheiro * _quantidade;
            var _custo_total_populacao = _navio.custo_populacao * _quantidade;
            
            if (_dinheiro >= _custo_total_dinheiro && _populacao >= _custo_total_populacao) {
                // Deduzir recursos
                global.dinheiro -= _custo_total_dinheiro;
                if (variable_global_exists("populacao")) {
                    global.populacao -= _custo_total_populacao;
                }
                
                // Adicionar múltiplas unidades à fila
                for (var j = 0; j < _quantidade; j++) {
                    ds_queue_enqueue(meu_quartel_id.fila_producao, _navio);
                }
                
                show_debug_message("📋 Adicionadas " + string(_quantidade) + " unidades à fila. Tamanho: " + string(ds_queue_size(meu_quartel_id.fila_producao)));
                
                // Iniciar produção se quartel estiver ocioso
                if (!meu_quartel_id.produzindo) {
                    meu_quartel_id.produzindo = true;
                    var _proxima_unidade = ds_queue_head(meu_quartel_id.fila_producao);
                    meu_quartel_id.alarm[0] = _proxima_unidade.tempo_treino;
                    show_debug_message("🚀 Iniciando produção de " + _proxima_unidade.nome);
                    show_debug_message("⏱️ Tempo: " + string(_proxima_unidade.tempo_treino) + " frames");
                }
                
                show_debug_message("✅ " + string(_quantidade) + "x " + _navio.nome + " adicionadas à fila!");
            } else {
                show_debug_message("❌ Recursos insuficientes para " + string(_quantidade) + " unidades!");
                if (_dinheiro < _custo_total_dinheiro) {
                    show_debug_message("   - Dinheiro insuficiente: $" + string(_dinheiro) + " < $" + string(_custo_total_dinheiro));
                }
                if (_populacao < _custo_total_populacao) {
                    show_debug_message("   - População insuficiente: " + string(_populacao) + " < " + string(_custo_total_populacao));
                }
            }
        } else {
            show_debug_message("❌ Recursos insuficientes ou quartel ocupado!");
            if (global.dinheiro < _navio.custo_dinheiro) {
                show_debug_message("   - Dinheiro insuficiente: $" + string(global.dinheiro) + " < $" + string(_navio.custo_dinheiro));
            }
            if (_populacao < _navio.custo_populacao) {
                show_debug_message("   - População insuficiente: " + string(_populacao) + " < " + string(_navio.custo_populacao));
            }
            if (meu_quartel_id.produzindo) {
                show_debug_message("   - Quartel ocupado produzindo");
            }
        }
        
        break;
    }
}