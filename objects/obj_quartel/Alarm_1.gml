// =========================================================
// HEGEMONIA GLOBAL - QUARTEL: ALARM BACKUP
// Sistema de backup para garantir execução do Step
// =========================================================

// ✅ BACKUP: Se o Step não executar, este Alarm garante que o código rode
// Este Alarm processa a fila apenas se o Step não estiver executando

// ✅ CORREÇÃO CRÍTICA: Validar que a fila existe e pertence a este quartel específico
if (!variable_instance_exists(id, "fila_recrutamento")) {
    // Se a fila não existe, criar uma nova para este quartel
    fila_recrutamento = ds_queue_create();
    show_debug_message("⚠️ Alarm_1 - Quartel ID: " + string(id) + " - Fila recriada (não existia)");
    exit; // Sair, pois a fila está vazia
}

// Verificar se há fila para processar
if (ds_exists(fila_recrutamento, ds_type_queue) && !ds_queue_empty(fila_recrutamento)) {
    // ✅ CORREÇÃO CRÍTICA: Se não está treinando, iniciar imediatamente
    if (!esta_treinando) {
        esta_treinando = true;
        tempo_treinamento_restante = 0;
        
        var _indice_unidade = ds_queue_head(fila_recrutamento);
        unidade_selecionada = _indice_unidade;
        
        var _unidade_data = ds_list_find_value(unidades_disponiveis, _indice_unidade);
        if (_unidade_data != undefined) {
            show_debug_message("🚨 ALARM - Quartel ID: " + string(id) + " iniciando treinamento de: " + _unidade_data.nome);
        } else {
            show_debug_message("⚠️ ALARM - Quartel ID: " + string(id) + " - Unidade com índice " + string(_indice_unidade) + " não encontrada!");
        }
    }
    
    // Processar treinamento se estiver ativo
    if (esta_treinando) {
        var _indice_unidade = ds_queue_head(fila_recrutamento);
        var _unidade_data = ds_list_find_value(unidades_disponiveis, _indice_unidade);
        
        // ✅ Contar quantas unidades do mesmo tipo estão na fila
        var _mesmo_tipo_count = 0;
        var _queue_size = ds_queue_size(fila_recrutamento);
        var _queue_temp = ds_queue_create();
        
        for (var _i = 0; _i < _queue_size; _i++) {
            var _item = ds_queue_dequeue(fila_recrutamento);
            ds_queue_enqueue(_queue_temp, _item);
            if (_item == _indice_unidade) {
                _mesmo_tipo_count++;
            }
        }
        
        // Restaurar fila
        while (!ds_queue_empty(_queue_temp)) {
            ds_queue_enqueue(fila_recrutamento, ds_queue_dequeue(_queue_temp));
        }
        ds_queue_destroy(_queue_temp);
        
        if (_unidade_data != undefined) {
            tempo_treinamento_restante++;
            
            // ✅ SISTEMA DE LOTE: Se houver 5+ unidades, criar todas de uma vez
            if (_mesmo_tipo_count >= 5) {
                var _tempo_lote = 120; // ✅ CORRIGIDO: 2 segundos (120 frames) para lote - mais rápido
                
                if (tempo_treinamento_restante >= _tempo_lote) {
                    show_debug_message("🚨 ALARM BACKUP - Criando " + string(_mesmo_tipo_count) + "x " + _unidade_data.nome + " em LOTE!");
                    
                    // Remover unidades da fila
                    var _queue_temp2 = ds_queue_create();
                    var _removidas = 0;
                    var _queue_size2 = ds_queue_size(fila_recrutamento);
                    
                    for (var _i2 = 0; _i2 < _queue_size2; _i2++) {
                        var _item2 = ds_queue_dequeue(fila_recrutamento);
                        if (_item2 == _indice_unidade && _removidas < _mesmo_tipo_count) {
                            _removidas++;
                        } else {
                            ds_queue_enqueue(_queue_temp2, _item2);
                        }
                    }
                    
                    while (!ds_queue_empty(_queue_temp2)) {
                        ds_queue_enqueue(fila_recrutamento, ds_queue_dequeue(_queue_temp2));
                    }
                    ds_queue_destroy(_queue_temp2);
                    
                    // Criar todas as unidades
                    for (var _c = 0; _c < _mesmo_tipo_count; _c++) {
                        var _offset_x = (_c mod 4) * 50;
                        var _offset_y = floor(_c / 4) * 50;
                        var _spawn_x = x + sprite_width + _offset_x;
                        var _spawn_y = y + sprite_height + _offset_y;
                        
                        var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "Instances", _unidade_data.objeto);
                        
                        if (!instance_exists(_unidade_criada)) {
                            var _camadas = ["Instances_0", "rm_mapa_principal", "Main"];
                            for (var _c2 = 0; _c2 < array_length(_camadas) && !instance_exists(_unidade_criada); _c2++) {
                                var _camada_nome = _camadas[_c2];
                                if (layer_exists(_camada_nome)) {
                                    _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, _camada_nome, _unidade_data.objeto);
                                }
                            }
                        }
                        
                        if (!instance_exists(_unidade_criada)) {
                            _unidade_criada = instance_create(_spawn_x, _spawn_y, _unidade_data.objeto);
                        }
                        
                        if (instance_exists(_unidade_criada)) {
                            unidades_criadas++;
                            _unidade_criada.nacao_proprietaria = nacao_proprietaria;
                            
                            if (variable_instance_exists(_unidade_criada, "estado")) {
                                _unidade_criada.estado = "parado";
                            }
                            if (variable_instance_exists(_unidade_criada, "selecionado")) {
                                _unidade_criada.selecionado = false;
                            }
                            
                            show_debug_message("✅ ALARM BACKUP - " + _unidade_data.nome + " " + string(_c + 1) + "/" + string(_mesmo_tipo_count) + " criada! ID: " + string(_unidade_criada));
                            
                            if (nacao_proprietaria == 2) {
                                show_debug_message("🤖 TROPA DA IA CRIADA VIA ALARM! ID:" + string(_unidade_criada));
                            }
                        }
                    }
                    
                    show_debug_message("✅ ALARM BACKUP - " + string(_mesmo_tipo_count) + "x " + _unidade_data.nome + " criadas em LOTE!");
                    
                    tempo_treinamento_restante = 0;
                    if (ds_queue_empty(fila_recrutamento)) {
                        esta_treinando = false;
                    }
                }
            } else {
                // Sistema normal: criar uma por vez
                var _tempo_necessario = _unidade_data.tempo_treino;
                
                // Se concluído, criar unidade
                if (tempo_treinamento_restante >= _tempo_necessario) {
                    var _spawn_x = x + sprite_width;
                    var _spawn_y = y + sprite_height;
                    
                    var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "Instances", _unidade_data.objeto);
                    
                    if (!instance_exists(_unidade_criada)) {
                        var _camadas = ["Instances_0", "rm_mapa_principal", "Main"];
                        for (var _c = 0; _c < array_length(_camadas) && !instance_exists(_unidade_criada); _c++) {
                            var _camada_nome = _camadas[_c];
                            if (layer_exists(_camada_nome)) {
                                _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, _camada_nome, _unidade_data.objeto);
                            }
                        }
                    }
                    
                    if (!instance_exists(_unidade_criada)) {
                        _unidade_criada = instance_create(_spawn_x, _spawn_y, _unidade_data.objeto);
                    }
                    
                    if (instance_exists(_unidade_criada)) {
                        unidades_criadas++;
                        _unidade_criada.nacao_proprietaria = nacao_proprietaria;
                        ds_queue_dequeue(fila_recrutamento);
                        
                        if (variable_instance_exists(_unidade_criada, "estado")) {
                            _unidade_criada.estado = "parado";
                        }
                        if (variable_instance_exists(_unidade_criada, "selecionado")) {
                            _unidade_criada.selecionado = false;
                        }
                        
                        show_debug_message("✅ ALARM BACKUP - " + _unidade_data.nome + " criada! ID: " + string(_unidade_criada));
                        
                        if (nacao_proprietaria == 2) {
                            show_debug_message("🤖 TROPA DA IA CRIADA VIA ALARM! ID:" + string(_unidade_criada));
                        }
                        
                        if (ds_queue_empty(fila_recrutamento)) {
                            esta_treinando = false;
                            tempo_treinamento_restante = 0;
                        } else {
                            tempo_treinamento_restante = 0;
                        }
                    }
                }
            }
        }
    }
}

// ✅ CRÍTICO: Reagendar para próximo frame (executar continuamente)
// Isso garante que o Alarm sempre processe a fila, mesmo quando está vazia
// Quando novas unidades forem adicionadas, o Alarm já estará rodando
alarm[1] = 1;
