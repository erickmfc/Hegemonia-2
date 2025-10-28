// ===============================================
// HEGEMONIA GLOBAL - QUARTEL: PROCESSAMENTO DE FILA
// Sistema de Produção Terrestre com Fila
// ===============================================

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

// Mostrar debug a cada segundo (60 frames)
if (step_counter % 60 == 0) {
    show_debug_message("⚙️ Step executado - esta_treinando: " + string(esta_treinando) + " | Fila: " + string(ds_queue_size(fila_recrutamento)));
}

// === SISTEMA DE PRODUÇÃO COM FILA ===

// ✅ CORREÇÃO: Iniciar produção se tiver unidades na fila mas não estiver treinando
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

// Processar treinamento
if (esta_treinando && !ds_queue_empty(fila_recrutamento)) {
    tempo_treinamento_restante++;
    
    var _indice_unidade = ds_queue_head(fila_recrutamento);
    var _unidade_data = ds_list_find_value(unidades_disponiveis, _indice_unidade);
    
    if (_unidade_data != undefined) {
        var _tempo_necessario = _unidade_data.tempo_treino;
        
        // Debug a cada segundo
        if (tempo_treinamento_restante % 60 == 0) {
            var _fila_size = ds_queue_size(fila_recrutamento);
            show_debug_message("⏱️ Treinamento: " + string(tempo_treinamento_restante) + "/" + string(_tempo_necessario) + " frames | Fila: " + string(_fila_size));
        }
        
        // Verificar se treinamento concluído
        if (tempo_treinamento_restante >= _tempo_necessario) {
            // Posição de spawn
            var _offset_x = (unidades_criadas mod 3) * 40;
            var _offset_y = floor(unidades_criadas / 3) * 40;
            var _spawn_x = x + sprite_width + _offset_x;
            var _spawn_y = y + sprite_height + _offset_y;
            
            // ✅ REMOVER DA FILA APENAS UMA VEZ
            ds_queue_dequeue(fila_recrutamento);
            
            show_debug_message("✚ Criando: " + _unidade_data.nome);
            show_debug_message("📍 Posição: (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
            
            // Verificar se objeto existe antes de criar
            if (!object_exists(_unidade_data.objeto)) {
                show_debug_message("❌ ERRO: Objeto '" + string(_unidade_data.objeto) + "' não existe!");
                esta_treinando = false;
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
                
                if (instance_exists(_unidade_criada)) {
                    unidades_criadas++;
                    
                    // Atribuir nação
                    if (variable_instance_exists(_unidade_criada, "nacao_proprietaria")) {
                        _unidade_criada.nacao_proprietaria = nacao_proprietaria;
                    }
                    
                    // Definir propriedades básicas da unidade
                    if (variable_instance_exists(_unidade_criada, "estado")) {
                        _unidade_criada.estado = "parado";
                    }
                    
                    if (variable_instance_exists(_unidade_criada, "selecionado")) {
                        _unidade_criada.selecionado = false;
                    }
                    
                    show_debug_message("✅ " + _unidade_data.nome + " criada com sucesso! ID: " + string(_unidade_criada));
                    show_debug_message("📍 Posição final: (" + string(_unidade_criada.x) + ", " + string(_unidade_criada.y) + ")");
                    
                    if (variable_instance_exists(_unidade_criada, "nacao_proprietaria")) {
                        show_debug_message("🏴 Nação: " + string(_unidade_criada.nacao_proprietaria));
                    }
                } else {
                    show_debug_message("❌ ERRO: Falha ao criar unidade! Objeto: " + string(_unidade_data.objeto));
                    show_debug_message("❌ Spawn pos: (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
                }
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
        }
    }
}
