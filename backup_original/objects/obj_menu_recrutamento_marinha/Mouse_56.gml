// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO MARINHA
// Lógica de Clique (FASE 2)
// ===============================================

// Verificar se o quartel ainda existe
if (!instance_exists(quartel_referencia)) {
    global.menu_recrutamento_aberto = false;
    instance_destroy();
    exit;
}

// Converter coordenadas do mouse para GUI
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

// Debug removido para melhor performance

// Calcular dimensões do menu (igual ao Draw_64 - AJUSTADAS)
var _mw = display_get_gui_width() * 0.4875;  // 65% - 25% = 48.75%
var _mh = display_get_gui_height() * 0.6;    // 75% - 20% = 60%
var _mx = (display_get_gui_width() - _mw) / 2;
var _my = (display_get_gui_height() - _mh) / 2;

// === VERIFICAR CLIQUE NO BOTÃO FECHAR - ÁREA AUMENTADA ===
var _fechar_w = 77;  // 70 + 10% = 77
var _fechar_h = 33;  // 30 + 10% = 33
var _fechar_x = _mx + _mw - (_mw * 0.05) - _fechar_w; // 5% da largura do painel
var _fechar_y = _my + (_mh * 0.03); // 3% da altura do painel

if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _fechar_x, _fechar_y, _fechar_x + _fechar_w, _fechar_y + _fechar_h)) {
    show_debug_message("Botão FECHAR clicado!");
    global.menu_recrutamento_aberto = false;
    instance_destroy();
    exit;
}

// === VERIFICAR CLIQUE NOS BOTÕES DE QUANTIDADE ===
var quartel = quartel_referencia;
if (instance_exists(quartel) && !quartel.recrutamento_em_andamento) {
    var unidades_disponiveis = quartel.unidades_disponiveis;
    var _unidades_start_y = _my + 80; // Ajustado para novo layout
    var _unidade_height = 80; // 100 - 20% = 80
    var _unidade_spacing = 15;
    var _card_width = _mw * 0.95;
    var _card_x = _mx + (_mw - _card_width) / 2;
    
    for (var i = 0; i < ds_list_size(unidades_disponiveis); i++) {
        var unidade_naval = ds_list_find_value(unidades_disponiveis, i);
        var _unidade_y = _unidades_start_y + (i * (_unidade_height + _unidade_spacing));
        var _card_y = _unidade_y; // CORRIGIDO: Definir _card_y para consistência
        
        // Verificar se pode recrutar (sem custo neste estágio)
        var pode_recrutar = true;
        
        if (!pode_recrutar) continue;
        
        // === BOTÕES DE QUANTIDADE - TAMANHO REDUZIDO EM 20% ===
        var _btn_width = 56;  // 70 - 20% = 56
        var _btn_height = 32; // 40 - 20% = 32
        var _btn_spacing = 15.75; // 15 + 5% = 15.75
        var _btn_start_x = _card_x + _card_width - 200; // Ajustado para novos tamanhos
        var _btn_y = _unidade_y + 20; // CORRIGIDO: Usar _unidade_y em vez de _card_y
        
        // Botão 1 unidade
        var _btn1_x = _btn_start_x;
        if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _btn1_x, _btn_y, _btn1_x + _btn_width, _btn_y + _btn_height)) {
            show_debug_message("=== BOTÃO 1 CLICADO! ===");
            show_debug_message("Mouse: (" + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");
            show_debug_message("Botão: (" + string(_btn1_x) + ", " + string(_btn_y) + ") - (" + string(_btn1_x + _btn_width) + ", " + string(_btn_y + _btn_height) + ")");
            show_debug_message("Iniciando recrutamento...");
            
            // Construir navio - código inline para evitar erro de script não encontrado
            show_debug_message("Verificando quartel...");
            show_debug_message("Quartel existe: " + string(instance_exists(quartel)));
            if (instance_exists(quartel)) {
                show_debug_message("Recrutamento em andamento: " + string(quartel.recrutamento_em_andamento));
            }
            
            if (instance_exists(quartel) && !quartel.recrutamento_em_andamento) {
                var unidade_data = ds_list_find_value(quartel.unidades_disponiveis, i);
                show_debug_message("Unidade data encontrada: " + string(!is_undefined(unidade_data)));
                if (!is_undefined(unidade_data)) {
                    quartel.recrutamento_em_andamento = true;
                    quartel.unidade_sendo_treinada = unidade_data.objeto;
                    quartel.tempo_treinamento_restante = unidade_data.tempo_treino;
                    quartel.unidade_selecionada = i;
                    quartel.quantidade_restante = 1;
                    show_debug_message("Recrutamento iniciado: 1x " + unidade_data.nome);
                    show_debug_message("Tempo de treino: " + string(unidade_data.tempo_treino) + " steps");
                } else {
                    show_debug_message("ERRO: Unidade data não encontrada!");
                }
            } else {
                show_debug_message("ERRO: Quartel não existe ou recrutamento já em andamento!");
            }
            exit;
        }
        
        // Botão 3 unidades
        var _btn3_x = _btn_start_x + _btn_width + _btn_spacing;
        if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _btn3_x, _btn_y, _btn3_x + _btn_width, _btn_y + _btn_height)) {
            show_debug_message("=== BOTÃO 3 CLICADO! ===");
            show_debug_message("Mouse: (" + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");
            show_debug_message("Botão: (" + string(_btn3_x) + ", " + string(_btn_y) + ") - (" + string(_btn3_x + _btn_width) + ", " + string(_btn_y + _btn_height) + ")");
            show_debug_message("Iniciando recrutamento...");
            
            // Construir navio - código inline para evitar erro de script não encontrado
            if (instance_exists(quartel) && !quartel.recrutamento_em_andamento) {
                var unidade_data = ds_list_find_value(quartel.unidades_disponiveis, i);
                if (!is_undefined(unidade_data)) {
                    quartel.recrutamento_em_andamento = true;
                    quartel.unidade_sendo_treinada = unidade_data.objeto;
                    quartel.tempo_treinamento_restante = unidade_data.tempo_treino;
                    quartel.unidade_selecionada = i;
                    quartel.quantidade_restante = 3;
                    show_debug_message("Recrutamento iniciado: 3x " + unidade_data.nome);
                }
            }
            exit;
        }
        
        // Botão 5 unidades
        var _btn5_x = _btn_start_x + (_btn_width + _btn_spacing) * 2;
        if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _btn5_x, _btn_y, _btn5_x + _btn_width, _btn_y + _btn_height)) {
            show_debug_message("=== BOTÃO 5 CLICADO! ===");
            show_debug_message("Mouse: (" + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");
            show_debug_message("Botão: (" + string(_btn5_x) + ", " + string(_btn_y) + ") - (" + string(_btn5_x + _btn_width) + ", " + string(_btn_y + _btn_height) + ")");
            show_debug_message("Iniciando recrutamento...");
            
            // Construir navio - código inline para evitar erro de script não encontrado
            if (instance_exists(quartel) && !quartel.recrutamento_em_andamento) {
                var unidade_data = ds_list_find_value(quartel.unidades_disponiveis, i);
                if (!is_undefined(unidade_data)) {
                    quartel.recrutamento_em_andamento = true;
                    quartel.unidade_sendo_treinada = unidade_data.objeto;
                    quartel.tempo_treinamento_restante = unidade_data.tempo_treino;
                    quartel.unidade_selecionada = i;
                    quartel.quantidade_restante = 5;
                    show_debug_message("Recrutamento iniciado: 5x " + unidade_data.nome);
                }
            }
            exit;
        }
    }
}

// === VERIFICAR CLIQUE FORA DO MENU (FECHAR) ===
if (!point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _mx, _my, _mx + _mw, _my + _mh)) {
    global.menu_recrutamento_aberto = false;
    instance_destroy();
}
