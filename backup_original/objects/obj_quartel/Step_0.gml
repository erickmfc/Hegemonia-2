// ===============================================
// HEGEMONIA GLOBAL - QUARTEL: LÓGICA DE RECRUTAMENTO
// Sistema Avançado com Múltiplas Unidades (FASE 2)
// ===============================================

// === SISTEMA DE RECRUTAMENTO AVANÇADO ===
if (recrutamento_em_andamento) {
    tempo_treinamento_restante--;
    
    if (tempo_treinamento_restante <= 0) {
        // Recrutamento concluído!
        
        // Obter dados da unidade sendo treinada
        var unidade_atual = ds_list_find_value(unidades_disponiveis, unidade_selecionada);
        
        // Criar a unidade próxima ao quartel
        var _spawn_x = x + 40; // Um pouco ao lado do quartel
        var _spawn_y = y + 40;
        var _nova_unidade = instance_create_layer(_spawn_x, _spawn_y, "Instances", unidade_atual.objeto);
        
        if (instance_exists(_nova_unidade)) {
            _nova_unidade.nacao_proprietaria = nacao_proprietaria;
            
            // Aplicar modificadores baseados no tipo de unidade
            switch(unidade_atual.nome) {
                case "Infantaria Pesada":
                    _nova_unidade.hp_max = 150;
                    _nova_unidade.hp_atual = 150;
                    _nova_unidade.velocidade = 2.0; // Mais lenta
                    break;
                case "Atirador de Elite":
                    _nova_unidade.dano_ataque = 45;
                    _nova_unidade.alcance_ataque = 300;
                    break;
            }
        }
        
        // Atualizar estatísticas
        unidades_treinadas_total++;
        tempo_total_treinamento += unidade_atual.tempo_treino;
        
        // Reset do sistema de recrutamento
        recrutamento_em_andamento = false;
        unidade_sendo_treinada = noone;
        tempo_treinamento_restante = 0;
        
        // Verificar se há mais unidades na fila
        if (!ds_queue_empty(fila_recrutamento)) {
            var proxima_unidade = ds_queue_dequeue(fila_recrutamento);
            // Iniciar recrutamento da próxima unidade
            var unidade_data = ds_list_find_value(unidades_disponiveis, proxima_unidade);
            global.dinheiro -= unidade_data.custo_dinheiro;
            global.populacao -= unidade_data.custo_populacao;
            recrutamento_em_andamento = true;
            unidade_sendo_treinada = unidade_data.objeto;
            tempo_treinamento_restante = unidade_data.tempo_treino;
            unidade_selecionada = proxima_unidade;
        }
    }
}

// === SISTEMA DE COMANDO TÁTICO (MELHORADO) ===
// Atalhos de teclado para comandos táticos
if (keyboard_check_pressed(ord("S"))) {
    // Ativar modo de comando SEGUIR
    comando_selecionado = "seguir";
    modo_selecao = true;
    show_debug_message("=== MODO SEGUIR ATIVADO ===");
    show_debug_message("Selecione as unidades e depois o alvo");
    show_debug_message("Comando selecionado: " + comando_selecionado);
}

if (keyboard_check_pressed(ord("P"))) {
    // Ativar modo de comando PATRULHAR
    comando_selecionado = "patrulhar";
    modo_selecao = true;
    show_debug_message("=== MODO PATRULHAR ATIVADO ===");
    show_debug_message("Selecione as unidades e depois os pontos");
    show_debug_message("Comando selecionado: " + comando_selecionado);
}

if (keyboard_check_pressed(ord("A"))) {
    // Definir postura AGRESSIVA
    var unidades_afetadas = 0;
    with (obj_infantaria) {
        if (nacao_proprietaria == other.nacao_proprietaria) {
            postura = "AGRESSIVA";
            unidades_afetadas++;
            show_debug_message("Unidade " + string(id) + " - Postura AGRESSIVA aplicada");
        }
    }
    show_debug_message("=== POSTURA AGRESSIVA APLICADA ===");
    show_debug_message("Unidades afetadas: " + string(unidades_afetadas));
}

if (keyboard_check_pressed(ord("D"))) {
    // Definir postura DEFENSIVA
    var unidades_afetadas = 0;
    with (obj_infantaria) {
        if (nacao_proprietaria == other.nacao_proprietaria) {
            postura = "DEFENSIVA";
            unidades_afetadas++;
            show_debug_message("Unidade " + string(id) + " - Postura DEFENSIVA aplicada");
        }
    }
    show_debug_message("=== POSTURA DEFENSIVA APLICADA ===");
    show_debug_message("Unidades afetadas: " + string(unidades_afetadas));
}

if (keyboard_check_pressed(ord("F"))) {
    // Definir postura PASSIVA
    var unidades_afetadas = 0;
    with (obj_infantaria) {
        if (nacao_proprietaria == other.nacao_proprietaria) {
            postura = "PASSIVA";
            unidades_afetadas++;
            show_debug_message("Unidade " + string(id) + " - Postura PASSIVA aplicada");
        }
    }
    show_debug_message("=== POSTURA PASSIVA APLICADA ===");
    show_debug_message("Unidades afetadas: " + string(unidades_afetadas));
}

if (keyboard_check_pressed(ord("C"))) {
    // Cancelar comando atual
    comando_selecionado = "nenhum";
    modo_selecao = false;
    ds_list_clear(unidades_selecionadas);
    ponto_patrulha_temp = noone;
    show_debug_message("=== COMANDO CANCELADO ===");
    show_debug_message("Todos os comandos foram cancelados");
}

// === DETECÇÃO DE CLIQUES NO MENU ===
if (mostrar_menu && mouse_check_button_pressed(mb_left)) {
    
    // Converter coordenadas do mouse para GUI
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    // Calcular dimensões do menu (igual ao Draw_64)
    var _menu_largura = display_get_gui_width() * 0.45;
    var _menu_altura = display_get_gui_height() * 0.6;
    var _menu_x = (display_get_gui_width() - _menu_largura) / 2;
    var _menu_y = (display_get_gui_height() - _menu_altura) / 2;
    
    // === VERIFICAR CLIQUE NO BOTÃO FECHAR ===
    var _fechar_x = _menu_x + _menu_largura - 80;
    var _fechar_y = _menu_y + 15;
    var _fechar_w = 70;
    var _fechar_h = 30;
    
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _fechar_x, _fechar_y, _fechar_x + _fechar_w, _fechar_y + _fechar_h)) {
        mostrar_menu = false;
        exit;
    }
    
    // === VERIFICAR CLIQUE NOS BOTÕES DE UNIDADE ===
    var _unidades_y = _menu_y + 200;
    var _unidade_h = 60;
    
    for (var i = 0; i < ds_list_size(unidades_disponiveis); i++) {
        var _unidade_y = _unidades_y + (i * (_unidade_h + 10));
        var _unidade_w = _menu_largura - 50;
        
        if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _menu_x + 25, _unidade_y, _menu_x + 25 + _unidade_w, _unidade_y + _unidade_h)) {
            unidade_selecionada = i;
            break;
        }
    }
    
    // === VERIFICAR CLIQUE NO BOTÃO DE RECRUTAMENTO ===
    if (!recrutamento_em_andamento) {
        var _botao_x = _menu_x + 25;
        var _botao_y = _menu_y + _menu_altura - 120;
        var _botao_w = _menu_largura - 50;
        var _botao_h = 45;
        
        if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _botao_x, _botao_y, _botao_x + _botao_w, _botao_y + _botao_h)) {
            var unidade_atual = ds_list_find_value(unidades_disponiveis, unidade_selecionada);
            
            // Verificar se tem recursos suficientes
            if (global.dinheiro >= unidade_atual.custo_dinheiro && global.populacao >= unidade_atual.custo_populacao) {
                
                // Verificar se pode adicionar à fila
                if (ds_queue_size(fila_recrutamento) < max_fila) {
                    // Adicionar à fila de recrutamento
                    ds_queue_enqueue(fila_recrutamento, unidade_selecionada);
                    
                    // Iniciar recrutamento se não estiver treinando
                    if (!recrutamento_em_andamento) {
                        var proxima_unidade = ds_queue_dequeue(fila_recrutamento);
                        // Iniciar recrutamento
                        var unidade_data = ds_list_find_value(unidades_disponiveis, proxima_unidade);
                        global.dinheiro -= unidade_data.custo_dinheiro;
                        global.populacao -= unidade_data.custo_populacao;
                        recrutamento_em_andamento = true;
                        unidade_sendo_treinada = unidade_data.objeto;
                        tempo_treinamento_restante = unidade_data.tempo_treino;
                        unidade_selecionada = proxima_unidade;
                    }
                }
            }
        }
    }
    
    // === VERIFICAR CLIQUE FORA DO MENU (FECHAR) ===
    if (!point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _menu_x, _menu_y, _menu_x + _menu_largura, _menu_y + _menu_altura)) {
        mostrar_menu = false;
    }
}
