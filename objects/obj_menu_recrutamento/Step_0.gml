// ===============================================
// HEGEMONIA GLOBAL - MENU MILITAR MODERNO
// Sistema de Cliques Integrado ao Step
// ===============================================

// Reduzir o delay de abertura
if (delay_abertura > 0) {
    delay_abertura--;
}

// Reduzir o debounce de navegação
if (debounce_navegacao > 0) {
    debounce_navegacao--;
}

// === SISTEMA DE ANIMAÇÕES SIMPLIFICADO ===
animation_timer++;

// === SISTEMA DE CONFIRMAÇÃO DE RECRUTAMENTO ===
if (recruitment_confirmation) {
    confirmation_timer--;
    if (confirmation_timer <= 0) {
        recruitment_confirmation = false;
        confirmation_timer = 0;
    }
}

// === SISTEMA DE FILA DE RECRUTAMENTO ===
queue_display_timer++;
if (queue_display_timer > 60) {
    queue_display_timer = 0;
}

// === SISTEMA DE FEEDBACK VISUAL ===
if (resource_update_flash) {
    resource_flash_timer--;
    if (resource_flash_timer <= 0) {
        resource_update_flash = false;
        resource_flash_timer = 0;
    }
}

// Animar cards individualmente
for (var i = 0; i < 6; i++) {
    var _anim = card_animations[i];
    
    // Incrementar timer do card
    if (!variable_instance_exists(id, "animation_timer")) {
        animation_timer = 0;
    }
    
    // Atualizar animações
    _anim.alpha = lerp(_anim.alpha, 1, 0.1);
    _anim.scale = lerp(_anim.scale, 1, 0.15);
    _anim.pulse = (_anim.pulse + 0.05) mod (pi * 2);
}

// === DETECÇÃO DE HOVER PARA CARDS ===
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _menu_w = _gui_w * 0.9;
var _menu_h = _gui_h * 0.9;
var _menu_x = (_gui_w - _menu_w) / 2;
var _menu_y = (_gui_h - _menu_h) / 2;

var _header_h = 100;
var _recursos_y = _menu_y + _header_h + 10;
var _recursos_h = 60;
var _grid_start_y = _recursos_y + _recursos_h + 20;

var _cols = 3;
var _rows = 2;
var _card_spacing = 20;
var _card_w = (_menu_w - 40 - (_cols - 1) * _card_spacing) / _cols;
var _card_h = ((_menu_h - _header_h - _recursos_h - 180 - (_rows - 1) * _card_spacing) / _rows) * 0.8;

// Obter unidades disponíveis
var _unidades;
if (instance_exists(id_do_quartel)) {
    // Garantir que é uma estrutura (ds_list)
    if (is_struct(id_do_quartel.unidades_disponiveis)) {
        _unidades = ds_list_create();
    } else {
        _unidades = id_do_quartel.unidades_disponiveis;
    }
} else {
    _unidades = ds_list_create();
}

// Verificar hover em cada card
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

var _total_units = ds_list_size(_unidades);
for (var i = 0; i < min(6, _total_units); i++) {
    var _unidade = ds_list_find_value(_unidades, i);
    var _col = i mod _cols;
    var _row = floor(i / _cols);
    
    var _card_x = _menu_x + 20 + _col * (_card_w + _card_spacing);
    var _card_y = _grid_start_y + _row * (_card_h + _card_spacing);
    
    // Verificar se mouse está sobre o card
    var _mouse_over_card = (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _card_w && 
                           _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _card_h);
    
    var _anim = card_animations[i];
    
    if (_mouse_over_card) {
        _anim.hover_intensity = lerp(_anim.hover_intensity, 1, 0.2);
    } else {
        _anim.hover_intensity = lerp(_anim.hover_intensity, 0, 0.2);
    }
}

// ========================================
// === PROCESSAMENTO DE CLIQUES AQUI ===
// ========================================

// ✅ CORREÇÃO: Ignorar cliques durante o delay de abertura (previne recrutamento acidental)
if (delay_abertura > 0) {
    // Ainda está no período de delay - ignorar cliques
    exit;
}

// Verificar se houve clique do mouse
if (mouse_check_button_pressed(mb_left)) {
    show_debug_message("🖱️ === CLIQUE DETECTADO NO STEP ===");
    show_debug_message("📍 Mouse GUI: (" + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");
    
    // Verificar se quartel ainda existe
    if (id_do_quartel == noone || !instance_exists(id_do_quartel)) {
        show_debug_message("❌ Quartel não existe, destruindo menu");
        instance_destroy();
        exit;
    }
    
    // === BOTÃO FECHAR ===
    var _close_w = 168;
    var _close_h = 54;
    var _close_x = _menu_x + _menu_w - _close_w - 20;
    var _close_y = _menu_y + _menu_h - 72;
    
    if (_mouse_gui_x >= _close_x && _mouse_gui_x <= _close_x + _close_w &&
        _mouse_gui_y >= _close_y && _mouse_gui_y <= _close_y + _close_h) {
        show_debug_message("🔴 Botão FECHAR clicado!");
        instance_destroy();
        exit;
    }
    
    // === CALCULAR POSIÇÕES DO GRID (SINCRONIZADO COM DRAW) ===
    var _header_h2 = 100;
    var _recursos_y2 = _menu_y + _header_h2 + 15;
    var _recursos_h2 = 72;
    var _grid_start_y2 = _recursos_y2 + _recursos_h2 + 25;
    var _grid_h2 = _menu_h - _header_h2 - _recursos_h2 - 220;
    
    var _card_spacing2 = 24; // Sincronizado com Draw
    var _card_w2 = (_menu_w - 40 - (_cols - 1) * _card_spacing2) / _cols;
    // ✅ CORREÇÃO: Sincronizar EXATAMENTE com Draw (incluindo aumento de 5%)
    var _card_h2 = ((_grid_h2 - (_rows - 1) * _card_spacing2) / _rows) * 1.05;
    
    var _total_unidades = ds_list_size(_unidades);
    
    // === VERIFICAR CLIQUE NOS CARDS ===
    for (var i = 0; i < min(_total_unidades, 6); i++) {
        var _unidade = ds_list_find_value(_unidades, i);
        
        // Calcular posição do card
        var _col = i mod _cols;
        var _row = floor(i / _cols);
        var _card_x = _menu_x + 20 + _col * (_card_w2 + _card_spacing2);
        var _card_y = _grid_start_y2 + _row * (_card_h2 + _card_spacing2);
        
        // Verificar se clique está dentro do card
        if (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _card_w2 &&
            _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _card_h2) {
            
            show_debug_message("🎯 CLIQUE NO CARD: " + _unidade.nome + " (índice " + string(i) + ")");
            
            // Verificar recursos disponíveis
            var _populacao = variable_global_exists("populacao") ? global.populacao : 50;
            var _dinheiro = variable_global_exists("dinheiro") ? global.dinheiro : 1000;
            
            show_debug_message("💰 Recursos: $" + string(_dinheiro) + " | Pop: " + string(_populacao));
            show_debug_message("📦 Custo unidade: $" + string(_unidade.custo_dinheiro) + " | Pop: " + string(_unidade.custo_populacao));
            
            // === VERIFICAR BOTÕES DE QUANTIDADE ===
            // ✅ AJUSTE: Sincronizar com Draw (aumentado em 20%)
            var _btn_quant_y = _card_y + _card_h2 - 85;
            var _btn_quant_h = 33.6; // ✅ AJUSTE: Aumentado em 20% (28 * 1.2)
            var _btn_quant_w = ((_card_w2 - 30) / 3 - 2); // ✅ AJUSTE: Tamanho normal (não reduzido)
            var _btn_quant_spacing = 3; // ✅ AJUSTE: Aumentado espaçamento
            
            var _quantidades = [1, 5, 10];
            var _quantidade_clicada = -1;
            
            for (var _q = 0; _q < 3; _q++) {
                var _quant = _quantidades[_q];
                var _btn_q_x = _card_x + 15 + _q * (_btn_quant_w + _btn_quant_spacing);
                var _btn_q_y = _btn_quant_y;
                
                if (_mouse_gui_x >= _btn_q_x && _mouse_gui_x <= _btn_q_x + _btn_quant_w &&
                    _mouse_gui_y >= _btn_q_y && _mouse_gui_y <= _btn_q_y + _btn_quant_h) {
                    _quantidade_clicada = _quant;
                    show_debug_message("🎯 Botão de quantidade " + string(_quant) + " clicado!");
                    break;
                }
            }
            
            // === VERIFICAR BOTÃO TREINAR ===
            // ✅ AJUSTE: Sincronizar com Draw (reduzido em 20%)
            var _btn_treinar_y = _card_y + _card_h2 - 50;
            var _btn_treinar_h = 28.8; // ✅ AJUSTE: Reduzido em 20% (36 * 0.8)
            var _btn_treinar_w = (_card_w2 - 30) * 0.8; // ✅ AJUSTE: Reduzido em 20%
            var _btn_treinar_x = _card_x + 15;
            
            var _botao_treinar_clicado = (_mouse_gui_x >= _btn_treinar_x && _mouse_gui_x <= _btn_treinar_x + _btn_treinar_w &&
                                          _mouse_gui_y >= _btn_treinar_y && _mouse_gui_y <= _btn_treinar_y + _btn_treinar_h);
            
            if (_botao_treinar_clicado) {
                show_debug_message("✅ Botão TREINAR clicado!");
                _quantidade_clicada = 1;
            }
            
            // === PROCESSAR RECRUTAMENTO ===
            if (_quantidade_clicada > 0) {
                var _custo_total_dinheiro = _unidade.custo_dinheiro * _quantidade_clicada;
                var _custo_total_populacao = _unidade.custo_populacao * _quantidade_clicada;
                
                var _pode_recrutar = (_dinheiro >= _custo_total_dinheiro && 
                                      _populacao >= _custo_total_populacao);
                
                show_debug_message("🔍 Custo total: $" + string(_custo_total_dinheiro) + " | Pop: " + string(_custo_total_populacao));
                show_debug_message("🔍 Pode recrutar? " + string(_pode_recrutar));
                
                if (_pode_recrutar) {
                    // Deduzir recursos
                    global.dinheiro -= _custo_total_dinheiro;
                    if (variable_global_exists("populacao")) {
                        global.populacao -= _custo_total_populacao;
                    }
                    
                    show_debug_message("💸 Recursos deduzidos!");
                    show_debug_message("💰 Novo saldo: $" + string(global.dinheiro) + " | Pop: " + string(global.populacao));
                    
                    // Adicionar à fila
                    show_debug_message("🔄 Adicionando " + string(_quantidade_clicada) + " unidades à fila do quartel ID: " + string(id_do_quartel));
                    
                    if (!instance_exists(id_do_quartel)) {
                        show_debug_message("❌ ERRO CRÍTICO: Quartel não existe!");
                        break;
                    }
                    
                    // ✅ CORREÇÃO CRÍTICA: Validar que a fila existe e pertence ao quartel correto
                    if (!variable_instance_exists(id_do_quartel, "fila_recrutamento")) {
                        show_debug_message("❌ ERRO CRÍTICO: fila_recrutamento não existe no quartel ID: " + string(id_do_quartel));
                        break;
                    }
                    
                    if (!ds_exists(id_do_quartel.fila_recrutamento, ds_type_queue)) {
                        show_debug_message("❌ ERRO CRÍTICO: fila_recrutamento inválida no quartel ID: " + string(id_do_quartel));
                        // Recriar a fila para este quartel
                        id_do_quartel.fila_recrutamento = ds_queue_create();
                        show_debug_message("⚠️ Fila recriada para quartel ID: " + string(id_do_quartel));
                    }
                    
                    // ✅ VALIDAÇÃO: Confirmar que estamos usando a fila do quartel correto
                    var _quartel_id = id_do_quartel;
                    var _fila_id = id_do_quartel.fila_recrutamento;
                    var _tamanho_antes = ds_queue_size(id_do_quartel.fila_recrutamento);
                    
                    for (var j = 0; j < _quantidade_clicada; j++) {
                        ds_queue_enqueue(id_do_quartel.fila_recrutamento, i);
                        show_debug_message("   ✅ Unidade " + string(j + 1) + " adicionada à fila do quartel ID: " + string(_quartel_id));
                    }
                    
                    var _tamanho_depois = ds_queue_size(id_do_quartel.fila_recrutamento);
                    show_debug_message("✅ " + string(_quantidade_clicada) + "x " + _unidade.nome + " adicionadas à fila!");
                    show_debug_message("📊 Quartel ID: " + string(_quartel_id) + " | Fila ID: " + string(_fila_id));
                    show_debug_message("📊 Tamanho da fila ANTES: " + string(_tamanho_antes) + " | DEPOIS: " + string(_tamanho_depois));
                    show_debug_message("🎯 Estado do quartel - esta_treinando: " + string(id_do_quartel.esta_treinando));
                    
                    // ✅ FORÇAR INÍCIO DE PRODUÇÃO SE ESTIVER OCIOSO
                    if (!id_do_quartel.esta_treinando) {
                        show_debug_message("🚀 Quartel está ocioso - iniciando produção imediatamente!");
                        id_do_quartel.esta_treinando = true;
                        id_do_quartel.tempo_treinamento_restante = 0;
                        // ✅ CRÍTICO: Ativar Alarm_1 para processar a fila
                        if (id_do_quartel.alarm[1] <= 0) {
                            id_do_quartel.alarm[1] = 1;
                            show_debug_message("🔔 Alarm_1 ativado para processar fila!");
                        }
                    } else {
                        show_debug_message("⏸️ Quartel já está treinando - unidade adicionada à fila");
                    }
                    
                } else {
                    show_debug_message("❌ RECURSOS INSUFICIENTES!");
                    if (_dinheiro < _custo_total_dinheiro) {
                        show_debug_message("   Falta: $" + string(_custo_total_dinheiro - _dinheiro));
                    }
                    if (_populacao < _custo_total_populacao) {
                        show_debug_message("   Falta: " + string(_custo_total_populacao - _populacao) + " população");
                    }
                }
                
                // Sair do loop
                break;
            }
        }
    }
}
