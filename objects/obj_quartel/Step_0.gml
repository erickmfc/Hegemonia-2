// ===============================================
// HEGEMONIA GLOBAL - QUARTEL: PROCESSAMENTO DE FILA
// Sistema de Produção Terrestre com Fila
// ===============================================

// === PROTEÇÃO CONTRA DESATIVAÇÃO ===
// ✅ CORREÇÃO: Garantir que quartel sempre esteja visível e ativo
visible = true;
if (!variable_instance_exists(id, "force_always_active") || !force_always_active) {
    force_always_active = true;
}
instance_activate_object(id); // Garantir que está ativo

// === SISTEMA DE VIDA ===
// Verificar se HP chegou a 0 e destruir
if (variable_instance_exists(id, "destrutivel") && variable_instance_exists(id, "hp_atual") && hp_atual <= 0) {
    show_debug_message("💥 Quartel destruído - HP: " + string(hp_atual) + "/" + string(hp_max));
    instance_destroy();
    exit;
}

// === DEBUG: Verificar se Step está sendo executado ===
// Incrementar contador de steps
if (!variable_instance_exists(id, "step_counter")) {
    step_counter = 0;
}
step_counter++;

// ✅ DEBUG: Informações importantes sempre
var _fila_size_debug = 0; // ✅ RENOMEADO para evitar conflito
if (ds_exists(fila_recrutamento, ds_type_queue)) {
    _fila_size_debug = ds_queue_size(fila_recrutamento);
}

// ✅ DEBUG MELHORADO: Informações a cada 3 segundos (180 frames) se tiver algo na fila ou estiver treinando
if ((_fila_size_debug > 0 || esta_treinando) && step_counter % 180 == 0) {
    show_debug_message("⚙️ Quartel Step - Treinando: " + string(esta_treinando) + " | Fila: " + string(_fila_size_debug) + " | Timer: " + string(tempo_treinamento_restante));
}

// ✅ DEBUG REDUZIDO: Apenas a cada 10 segundos se debug_enabled e não há atividade
if (variable_global_exists("debug_enabled") && global.debug_enabled && _fila_size_debug == 0 && !esta_treinando && step_counter % 600 == 0) {
    show_debug_message("⚙️ Quartel Step - Ocioso - ID: " + string(id));
}

// === SISTEMA DE PRODUÇÃO COM FILA ===

// ✅ CORREÇÃO: Iniciar produção se tiver unidades na fila mas não estiver treinando
// Verificar se fila existe antes de usar
if (ds_exists(fila_recrutamento, ds_type_queue)) {
    if (!esta_treinando && !ds_queue_empty(fila_recrutamento)) {
        esta_treinando = true;
        tempo_treinamento_restante = 0;
        
        // Obter próxima unidade da fila
        var _indice_unidade = ds_queue_head(fila_recrutamento);
        unidade_selecionada = _indice_unidade;
        
        var _unidade_data = ds_list_find_value(unidades_disponiveis, _indice_unidade);
        if (_unidade_data != undefined) {
            show_debug_message("🚀 Quartel iniciando treinamento de: " + _unidade_data.nome);
            show_debug_message("📊 Unidades na fila: " + string(ds_queue_size(fila_recrutamento)));
        }
    }
} else {
    // Se fila não existe, recriar (proteção)
    fila_recrutamento = ds_queue_create();
    show_debug_message("⚠️ Fila de recrutamento recriada");
}

// Processar treinamento
// ✅ CORREÇÃO: Verificar se fila existe antes de usar
if (esta_treinando && ds_exists(fila_recrutamento, ds_type_queue) && !ds_queue_empty(fila_recrutamento)) {
    
    var _quantidade_na_fila = ds_queue_size(fila_recrutamento);
    var _indice_unidade = ds_queue_head(fila_recrutamento);
    var _unidade_data = ds_list_find_value(unidades_disponiveis, _indice_unidade);
    
    // ✅ NOVO: SISTEMA DE CRIAÇÃO EM LOTE
    var _criar_em_lote = false;
    if (_unidade_data != undefined && _quantidade_na_fila >= 5) {
        // Contar quantas unidades do mesmo tipo estão na fila
        var _mesmo_tipo = 0;
        var _queue_temp = ds_queue_create();
        
        // Verificar fila sem desenfileirar
        var _queue_size = _quantidade_na_fila;
        for (var _i = 0; _i < _queue_size; _i++) {
            var _item = ds_queue_dequeue(fila_recrutamento);
            ds_queue_enqueue(_queue_temp, _item);
            if (_item == _indice_unidade) {
                _mesmo_tipo++;
            }
        }
        
        // Restaurar fila
        while (!ds_queue_empty(_queue_temp)) {
            ds_queue_enqueue(fila_recrutamento, ds_queue_dequeue(_queue_temp));
        }
        ds_queue_destroy(_queue_temp);
        
        if (_mesmo_tipo >= 5) {
            _criar_em_lote = true;
        }
    }
    
    // ✅ SISTEMA DE LOTE: Criar todas de uma vez após timer
    if (_criar_em_lote) {
        tempo_treinamento_restante++;
        
        // Tempo fixo de 4 segundos (240 frames) para lote
        if (tempo_treinamento_restante >= 240) {
            show_debug_message("🚀 CRIAÇÃO EM LOTE INICIADA! Quantidade na fila: " + string(_quantidade_na_fila));
            
            // Contar quantas unidades do mesmo tipo
            var _queue_temp = ds_queue_create();
            var _mesmo_tipo_count = 0;
            var _queue_size = ds_queue_size(fila_recrutamento);
            
            // Separar unidades do mesmo tipo
            for (var _i = 0; _i < _queue_size; _i++) {
                var _item = ds_queue_dequeue(fila_recrutamento);
                if (_item == _indice_unidade) {
                    _mesmo_tipo_count++;
                } else {
                    ds_queue_enqueue(_queue_temp, _item); // Manter outros tipos na fila
                }
            }
            
            // Restaurar fila (sem as unidades que serão criadas)
            while (!ds_queue_empty(_queue_temp)) {
                ds_queue_enqueue(fila_recrutamento, ds_queue_dequeue(_queue_temp));
            }
            ds_queue_destroy(_queue_temp);
            
            // ✅ CRIAR TODAS AS UNIDADES DE UMA VEZ
            for (var _c = 0; _c < _mesmo_tipo_count; _c++) {
                var _offset_x = (_c mod 4) * 50; // Grid 4x4
                var _offset_y = floor(_c / 4) * 50;
                var _spawn_x = x + sprite_width + _offset_x;
                var _spawn_y = y + sprite_height + _offset_y;
                
                var _unidade_criada = noone;
                var _quartel_layer = layer_get_name(layer);
                if (layer_exists(_quartel_layer)) {
                    _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, _quartel_layer, _unidade_data.objeto);
                }
                
                if (!instance_exists(_unidade_criada)) {
                    var _camadas = ["Instances", "Instances_0", "rm_mapa_principal", "Main"];
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
                }
            }
            
            show_debug_message("✅ " + string(_mesmo_tipo_count) + "x " + _unidade_data.nome + " criadas em LOTE!");
            
            // Resetar timer e verificar próxima unidade
            tempo_treinamento_restante = 0;
            if (!ds_queue_empty(fila_recrutamento)) {
                _indice_unidade = ds_queue_head(fila_recrutamento);
                unidade_selecionada = _indice_unidade;
                show_debug_message("🔄 Iniciando próximo treinamento...");
            } else {
                esta_treinando = false;
                show_debug_message("🏁 Treinamento completo - Quartel ocioso");
            }
        }
    } else {
        // ✅ SISTEMA NORMAL: Criar uma por vez (menos de 5 unidades)
        tempo_treinamento_restante++;
        
        // ✅ CORREÇÃO CRÍTICA: Verificar se dados da unidade são válidos
        if (_unidade_data == undefined) {
        show_debug_message("❌ ERRO: Dados da unidade inválidos para índice " + string(_indice_unidade));
        show_debug_message("❌ Removendo entrada inválida da fila");
        ds_queue_dequeue(fila_recrutamento); // Remover entrada inválida
        
        // Verificar se há mais unidades na fila
        if (!ds_queue_empty(fila_recrutamento)) {
            tempo_treinamento_restante = 0; // Reset para próxima unidade
            var _novo_indice = ds_queue_head(fila_recrutamento);
            unidade_selecionada = _novo_indice;
            show_debug_message("🔄 Tentando próxima unidade na fila...");
        } else {
            esta_treinando = false;
            tempo_treinamento_restante = 0;
            show_debug_message("🏁 Fila esvaziada após erro - Quartel ocioso");
        }
    } else {
        var _tempo_necessario = _unidade_data.tempo_treino;
        
        // Debug a cada segundo
        if (tempo_treinamento_restante % 60 == 0) {
            var _fila_size_atual = ds_queue_size(fila_recrutamento); // Variável local para evitar conflito
            show_debug_message("⏱️ Treinamento: " + string(tempo_treinamento_restante) + "/" + string(_tempo_necessario) + " frames | Fila: " + string(_fila_size_atual));
        }
        
        // Verificar se treinamento concluído
        if (tempo_treinamento_restante >= _tempo_necessario) {
            // Posição de spawn
            var _offset_x = (unidades_criadas mod 3) * 40;
            var _offset_y = floor(unidades_criadas / 3) * 40;
            var _spawn_x = x + sprite_width + _offset_x;
            var _spawn_y = y + sprite_height + _offset_y;
            
            show_debug_message("✚ Criando: " + _unidade_data.nome);
            show_debug_message("📍 Posição: (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
            
            // Verificar se objeto existe antes de criar
            if (!object_exists(_unidade_data.objeto)) {
                show_debug_message("❌ ERRO: Objeto '" + string(_unidade_data.objeto) + "' não existe!");
                // ✅ CORREÇÃO: Remover da fila mesmo se falhar
                ds_queue_dequeue(fila_recrutamento);
                
                // Verificar se há mais unidades na fila
                if (!ds_queue_empty(fila_recrutamento)) {
                    tempo_treinamento_restante = 0;
                    var _novo_indice = ds_queue_head(fila_recrutamento);
                    unidade_selecionada = _novo_indice;
                    show_debug_message("🔄 Tentando próxima unidade na fila...");
                } else {
                    esta_treinando = false;
                    tempo_treinamento_restante = 0;
                    show_debug_message("🏁 Fila esvaziada após erro - Quartel ocioso");
                }
            } else {
                show_debug_message("📦 Criando instância do objeto: " + string(_unidade_data.objeto));
                
                // Criar unidade - tentar diferentes layers
                var _unidade_criada = noone;
                
                // Tentar criar no layer atual do quartel primeiro
                var _quartel_layer = layer_get_name(layer);
                if (layer_exists(_quartel_layer)) {
                    _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, _quartel_layer, _unidade_data.objeto);
                    show_debug_message("🎯 Tentando criar no layer do quartel: " + _quartel_layer + " → " + string(_unidade_criada));
                }
                
                // Se falhou, tentar camadas padrão
                if (!instance_exists(_unidade_criada)) {
                    var _camadas = ["Instances", "Instances_0", "rm_mapa_principal", "Main"];
                    
                    for (var _c = 0; _c < array_length(_camadas) && !instance_exists(_unidade_criada); _c++) {
                        var _camada_nome = _camadas[_c];
                        if (layer_exists(_camada_nome)) {
                            _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, _camada_nome, _unidade_data.objeto);
                            show_debug_message("🎯 Tentando criar em: " + _camada_nome + " → " + string(_unidade_criada));
                        }
                    }
                }
                
                // ✅ ULTIMO RECURSO: Criar em qualquer camada válida
                if (!instance_exists(_unidade_criada)) {
                    _unidade_criada = instance_create(_spawn_x, _spawn_y, _unidade_data.objeto);
                    show_debug_message("🎯 Usando instance_create() direto → " + string(_unidade_criada));
                }
                
                // ✅ CORREÇÃO CRÍTICA: Só remover da fila se criação foi bem-sucedida
                if (instance_exists(_unidade_criada)) {
                    unidades_criadas++;
                    
                    // Remover da fila apenas após sucesso
                    ds_queue_dequeue(fila_recrutamento);
                    
                    // ✅ FORÇAR nação - CRÍTICO para IA funcionar
                    _unidade_criada.nacao_proprietaria = nacao_proprietaria;
                    
                    // ✅ DEBUG FORTE: Confirmar nação da unidade criada
                    show_debug_message("🏴 UNIDADE CRIADA - Nação do quartel: " + string(nacao_proprietaria) + " → Nação da unidade: " + string(_unidade_criada.nacao_proprietaria));
                    if (nacao_proprietaria == 2) {
                        show_debug_message("🤖 TROPA DA IA CRIADA! ID:" + string(_unidade_criada) + " Tipo:" + object_get_name(_unidade_criada.object_index));
                    }
                    
                    // Definir propriedades básicas da unidade
                    if (variable_instance_exists(_unidade_criada, "estado")) {
                        _unidade_criada.estado = "parado";
                    }
                    
                    if (variable_instance_exists(_unidade_criada, "selecionado")) {
                        _unidade_criada.selecionado = false;
                    }
                    
                    // ✅ CORREÇÃO: Garantir que soldado anti-aéreo tenha variáveis de movimento
                    if (_unidade_criada.object_index == obj_soldado_antiaereo) {
                        if (!variable_instance_exists(_unidade_criada, "destino_x")) {
                            _unidade_criada.destino_x = _unidade_criada.x;
                        }
                        if (!variable_instance_exists(_unidade_criada, "destino_y")) {
                            _unidade_criada.destino_y = _unidade_criada.y;
                        }
                        if (!variable_instance_exists(_unidade_criada, "velocidade")) {
                            _unidade_criada.velocidade = 2; // Velocidade padrão
                        }
                        if (!variable_instance_exists(_unidade_criada, "patrulha")) {
                            _unidade_criada.patrulha = ds_list_create();
                            _unidade_criada.patrulha_indice = 0;
                            _unidade_criada.modo_patrulha = false;
                        }
                        show_debug_message("✅ Soldado Anti-Aéreo configurado com variáveis de movimento");
                    }
                    
                    show_debug_message("✅ " + _unidade_data.nome + " criada com sucesso! ID: " + string(_unidade_criada));
                    show_debug_message("📍 Posição final: (" + string(_unidade_criada.x) + ", " + string(_unidade_criada.y) + ")");
                    
                    if (variable_instance_exists(_unidade_criada, "nacao_proprietaria")) {
                        show_debug_message("🏴 Nação: " + string(_unidade_criada.nacao_proprietaria));
                    }
                    
                    // Próxima unidade ou parar produção
                    if (!ds_queue_empty(fila_recrutamento)) {
                        tempo_treinamento_restante = 0; // Reset para próxima unidade
                        _indice_unidade = ds_queue_head(fila_recrutamento);
                        unidade_selecionada = _indice_unidade;
                        show_debug_message("🔄 Iniciando próximo treinamento...");
                    } else {
                        esta_treinando = false;
                        tempo_treinamento_restante = 0;
                        show_debug_message("🏁 Treinamento completo - Quartel ocioso");
                    }
                } else {
                    show_debug_message("❌ ERRO: Falha ao criar unidade! Objeto: " + string(_unidade_data.objeto));
                    show_debug_message("❌ Spawn pos: (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
                    // ✅ CORREÇÃO: Remover da fila mesmo se falhar para não travar
                    ds_queue_dequeue(fila_recrutamento);
                    
                    // Verificar se há mais unidades na fila
                    if (!ds_queue_empty(fila_recrutamento)) {
                        tempo_treinamento_restante = 0;
                        var _novo_indice = ds_queue_head(fila_recrutamento);
                        unidade_selecionada = _novo_indice;
                        show_debug_message("🔄 Tentando próxima unidade na fila...");
                    } else {
                        esta_treinando = false;
                        tempo_treinamento_restante = 0;
                        show_debug_message("🏁 Fila esvaziada após erro - Quartel ocioso");
                    }
                }
            }
        }
    }
} else if (esta_treinando && (ds_queue_empty(fila_recrutamento) || !ds_exists(fila_recrutamento, ds_type_queue))) {
    // ✅ CORREÇÃO: Resetar estado se fila estiver vazia ou não existir
    show_debug_message("⚠️ Quartel estava treinando mas fila está vazia ou não existe - resetando estado");
    esta_treinando = false;
    tempo_treinamento_restante = 0;
}
