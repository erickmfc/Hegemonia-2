/// @description Step do Quartel - Lógica de barra de vida e processamento de fila

// Herdar lógica do pai
event_inherited();

// === SISTEMA DE BARRA DE VIDA ===
// Se a vida foi reduzida, mostrar barra
if (hp_atual < hp_max) {
    mostrar_barra_vida = true;
    timer_barra_vida = 0;
}

// Decrementar timer da barra de vida
if (mostrar_barra_vida) {
    timer_barra_vida++;
    
    // Desaparecer após duração
    if (timer_barra_vida >= duracao_barra_vida) {
        mostrar_barra_vida = false;
        timer_barra_vida = 0;
    }
}

// === SISTEMA DE PROCESSAMENTO DE FILA DE RECRUTAMENTO ===
// ✅ CORREÇÃO CRÍTICA: Processar fila no Step para garantir que funcione

// Validar que a fila existe
if (!variable_instance_exists(id, "fila_recrutamento")) {
    fila_recrutamento = ds_queue_create();
    show_debug_message("⚠️ Step - Quartel ID: " + string(id) + " - Fila recriada (não existia)");
}

// Verificar se há fila para processar
if (ds_exists(fila_recrutamento, ds_type_queue) && !ds_queue_empty(fila_recrutamento)) {
    // ✅ Se não está treinando, iniciar imediatamente
    if (!esta_treinando) {
        esta_treinando = true;
        tempo_treinamento_restante = 0;
        
        var _indice_unidade = ds_queue_head(fila_recrutamento);
        unidade_selecionada = _indice_unidade;
        
        var _unidade_data = ds_list_find_value(unidades_disponiveis, _indice_unidade);
        if (_unidade_data != undefined) {
            show_debug_message("🚀 STEP - Quartel ID: " + string(id) + " iniciando treinamento de: " + _unidade_data.nome);
        }
    }
    
    // Processar treinamento se estiver ativo
    if (esta_treinando) {
        var _indice_unidade = ds_queue_head(fila_recrutamento);
        var _unidade_data = ds_list_find_value(unidades_disponiveis, _indice_unidade);
        
        if (_unidade_data != undefined) {
            tempo_treinamento_restante++;
            
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
                    
                    show_debug_message("✅ STEP - " + _unidade_data.nome + " criada! ID: " + string(_unidade_criada));
                    
                    if (ds_queue_empty(fila_recrutamento)) {
                        esta_treinando = false;
                        tempo_treinamento_restante = 0;
                        show_debug_message("✅ STEP - Fila vazia, quartel ocioso");
                    } else {
                        tempo_treinamento_restante = 0;
                        show_debug_message("🔄 STEP - Próxima unidade na fila: " + string(ds_queue_size(fila_recrutamento)) + " restantes");
                    }
                } else {
                    show_debug_message("❌ STEP - ERRO: Não foi possível criar " + _unidade_data.nome);
                }
            }
        } else {
            show_debug_message("❌ STEP - ERRO: Unidade com índice " + string(_indice_unidade) + " não encontrada!");
            // Remover item inválido da fila
            ds_queue_dequeue(fila_recrutamento);
            esta_treinando = false;
            tempo_treinamento_restante = 0;
        }
    }
}

// ✅ GARANTIR QUE ALARM_1 ESTÁ ATIVO (backup)
if (alarm[1] <= 0) {
    alarm[1] = 1;
}
