// ===============================================
// HEGEMONIA GLOBAL - QUARTEL MARINHA: LÓGICA DE RECRUTAMENTO
// Sistema Avançado com Múltiplas Unidades Navais (FASE 2)
// ===============================================

// === SISTEMA DE RECRUTAMENTO AVANÇADO ===
if (recrutamento_em_andamento) {
    tempo_treinamento_restante--;
    
    if (tempo_treinamento_restante <= 0) {
        // Recrutamento concluído!
        
        // Obter dados da unidade sendo treinada
        var unidade_atual = ds_list_find_value(unidades_disponiveis, unidade_selecionada);
        
        // Criar a unidade naval na água próxima ao quartel
        var _spawn_x = x + 120; // ✅ AUMENTADO de 60 para 120 - mais afastado do quartel
        var _spawn_y = y + 120; // ✅ AUMENTADO de 60 para 120 - mais afastado do quartel
        var _nova_unidade = instance_create_layer(_spawn_x, _spawn_y, "Instances", unidade_atual.objeto);
        
        if (instance_exists(_nova_unidade)) {
            _nova_unidade.nacao_proprietaria = nacao_proprietaria;
            // Aplicar defaults por classe
            if (is_undefined(unidade_atual.classe)) {
                // fallback simples por nome
                var _classe = NAVAL_CLASS.CORVETA;
                if (unidade_atual.nome == "Fragata") _classe = NAVAL_CLASS.FRAGATA;
                else if (unidade_atual.nome == "Destroyer") _classe = NAVAL_CLASS.DESTROYER;
                else if (unidade_atual.nome == "Cruzador") _classe = NAVAL_CLASS.CRUZADOR;
                if (function_exists(naval_apply_defaults)) naval_apply_defaults(_nova_unidade, _classe); else global.naval_apply_defaults(_nova_unidade, _classe);
            } else {
                if (function_exists(naval_apply_defaults)) naval_apply_defaults(_nova_unidade, unidade_atual.classe); else global.naval_apply_defaults(_nova_unidade, unidade_atual.classe);
            }
            
            show_debug_message("Unidade naval criada: " + unidade_atual.nome);
        }
        
        // Atualizar estatísticas
        unidades_treinadas_total++;
        tempo_total_treinamento += unidade_atual.tempo_treino;
        
        // Verificar se há mais unidades para criar
        if (quantidade_restante > 1) {
            quantidade_restante--;
            // Reiniciar o timer para a próxima unidade
            tempo_treinamento_restante = unidade_atual.tempo_treino;
            show_debug_message("Criando próxima unidade. Restam: " + string(quantidade_restante));
        } else {
            // Reset do sistema de recrutamento
            recrutamento_em_andamento = false;
            unidade_sendo_treinada = noone;
            tempo_treinamento_restante = 0;
            quantidade_restante = 0;
            show_debug_message("Recrutamento concluído!");
        }
        
        // Verificar se há mais unidades na fila
        if (!ds_queue_empty(fila_recrutamento)) {
            var proxima_unidade = ds_queue_dequeue(fila_recrutamento);
            // Iniciar recrutamento da próxima unidade
            var unidade_data = ds_list_find_value(unidades_disponiveis, proxima_unidade);
            global.dinheiro -= unidade_data.custo_dinheiro;
            global.populacao -= unidade_data.custo_populacao;
            global.petroleo -= unidade_data.custo_petroleo; // Consumir petróleo
            recrutamento_em_andamento = true;
            unidade_sendo_treinada = unidade_data.objeto;
            tempo_treinamento_restante = unidade_data.tempo_treino;
            unidade_selecionada = proxima_unidade;
        }
    }
}

// === SISTEMA DE COMANDO TÁTICO (MESMO DO QUARTEL TERRESTRE) ===
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
    var _nacao_quartel = nacao_proprietaria; // Capturar variável localmente
    with (obj_infantaria) {
        if (nacao_proprietaria == _nacao_quartel) {
            postura = "AGRESSIVA";
            unidades_afetadas++;
            show_debug_message("Unidade " + string(id) + " - Postura AGRESSIVA aplicada");
        }
    }
    with (obj_tanque) {
        if (nacao_proprietaria == _nacao_quartel) {
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
    var _nacao_quartel = nacao_proprietaria; // Capturar variável localmente
    with (obj_infantaria) {
        if (nacao_proprietaria == _nacao_quartel) {
            postura = "DEFENSIVA";
            unidades_afetadas++;
            show_debug_message("Unidade " + string(id) + " - Postura DEFENSIVA aplicada");
        }
    }
    with (obj_tanque) {
        if (nacao_proprietaria == _nacao_quartel) {
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
    var _nacao_quartel = nacao_proprietaria; // Capturar variável localmente
    with (obj_infantaria) {
        if (nacao_proprietaria == _nacao_quartel) {
            postura = "PASSIVA";
            unidades_afetadas++;
            show_debug_message("Unidade " + string(id) + " - Postura PASSIVA aplicada");
        }
    }
    with (obj_tanque) {
        if (nacao_proprietaria == _nacao_quartel) {
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

// O quartel marinha usa o menu separado (obj_menu_recrutamento_marinha)
// A lógica de menu foi movida para o Mouse_53.gml
}