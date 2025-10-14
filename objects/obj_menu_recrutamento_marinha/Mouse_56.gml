// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO NAVAL
// Sistema de Cliques Corrigido - SINCRONIZADO COM DRAW
// ===============================================

// ✅ CORRIGIDO: Usar coordenadas GUI para compatibilidade com zoom
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

// ✅ CORRIGIDO: Dimensões EXATAS do Draw (65% x 75%)
var _mw = display_get_gui_width() * 0.65;   // 65% da largura
var _mh = display_get_gui_height() * 0.75;  // 75% da altura
var _mx = (display_get_gui_width() - _mw) / 2;
var _my = (display_get_gui_height() - _mh) / 2;

// ✅ CORRIGIDO: Botão fechar com coordenadas EXATAS do Draw
var _close_w = 130;
var _close_h = 50;
var _close_x = _mx + _mw - _close_w - 25;
var _close_y = _my + _mh - 65;

if (_mouse_gui_x >= _close_x && _mouse_gui_x <= _close_x + _close_w &&
    _mouse_gui_y >= _close_y && _mouse_gui_y <= _close_y + _close_h) {
    show_debug_message("✅ Botão FECHAR clicado!");
    if (instance_exists(meu_quartel_id)) {
        meu_quartel_id.menu_recrutamento = noone;
    }
    instance_destroy();
    exit;
}

// Verificar se o quartel ainda existe
if (meu_quartel_id == noone || !instance_exists(meu_quartel_id)) {
    instance_destroy();
    exit;
}

// ✅ CORRIGIDO: Clique no botão de produção com coordenadas EXATAS do Draw
var _content_start_y = _my + 120; // Mais espaço após o header
var _unit_card_w = _mw - 50;
var _unit_card_h = 160; // Mais alto para melhor organização
var _unit_card_x = _mx + 25;
var _unit_card_y = _content_start_y;

// ✅ CORRIGIDO: Coordenadas do botão PRODUZIR EXATAS do Draw
var _btn_x = _unit_card_x + _unit_card_w - 160;
var _btn_y = _unit_card_y + (_unit_card_h - 50) / 2;
var _btn_w = 150;
var _btn_h = 50;

if (_mouse_gui_x >= _btn_x && _mouse_gui_x <= _btn_x + _btn_w &&
    _mouse_gui_y >= _btn_y && _mouse_gui_y <= _btn_y + _btn_h) {
    show_debug_message("🎯 BOTÃO PRODUZIR CLICADO!");
    
    if (meu_quartel_id != noone && instance_exists(meu_quartel_id)) {
        
        // ✅ CORRIGIDO: Usar sistema de recursos correto (global.dinheiro)
        if (ds_list_size(meu_quartel_id.unidades_disponiveis) > 0) {
            var _unidade_data = meu_quartel_id.unidades_disponiveis[| 0]; // Lancha Patrulha
            var _custo_unidade = _unidade_data.custo_dinheiro;
            var _dinheiro_atual = global.dinheiro;
            
            show_debug_message("🔍 Tentando comprar: " + _unidade_data.nome);
            show_debug_message("💰 Custo: $" + string(_custo_unidade));
            show_debug_message("💵 Dinheiro atual: $" + string(_dinheiro_atual));
            
            if (_dinheiro_atual >= _custo_unidade) {
                
                // ✅ CORRIGIDO: Deduzir recursos do sistema correto
                global.dinheiro -= _custo_unidade;
                
                // ✅ CORRIGIDO: Adicionar objeto completo da unidade à fila
                ds_queue_enqueue(meu_quartel_id.fila_producao, _unidade_data);
                
                show_debug_message("📋 Unidade adicionada à fila. Tamanho da fila: " + string(ds_queue_size(meu_quartel_id.fila_producao)));
                
                // ✅ CORRIGIDO: Iniciar produção usando ALARM EVENT
                if (!meu_quartel_id.produzindo) {
                    meu_quartel_id.produzindo = true;
                    var _proxima_unidade = ds_queue_head(meu_quartel_id.fila_producao);
                    meu_quartel_id.alarm[0] = _proxima_unidade.tempo_treino; // ✅ USAR ALARM[0]
                    show_debug_message("🚀 Iniciando produção de " + _proxima_unidade.nome);
                    show_debug_message("⏱️ Alarm[0] definido para: " + string(_proxima_unidade.tempo_treino) + " frames");
                } else {
                    show_debug_message("ℹ️ Quartel já está produzindo, unidade adicionada à fila");
                }
                
                show_debug_message("✅ " + _unidade_data.nome + " adicionada à fila de produção!");
                show_debug_message("💵 Dinheiro restante: $" + string(global.dinheiro));
                show_debug_message("⏱️ Tempo de produção: " + string(_unidade_data.tempo_treino) + " frames");
                
            } else {
                show_debug_message("❌ Recursos insuficientes! Precisa: $" + string(_custo_unidade) + ", Tem: $" + string(_dinheiro_atual));
            }
        } else {
            show_debug_message("❌ Nenhuma unidade disponível no quartel!");
        }
    } else {
        show_debug_message("❌ ERRO: Quartel de marinha não encontrado!");
    }
} else {
    show_debug_message("🖱️ Clique fora do botão - X:" + string(mouse_x) + " Y:" + string(mouse_y));
}