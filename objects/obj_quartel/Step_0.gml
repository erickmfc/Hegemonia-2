// =========================================================
// ===============================================
// HEGEMONIA GLOBAL - QUARTEL: PROCESSAMENTO DE FILA
// Sistema de Produção Terrestre com Fila
// ===============================================

// Herdar comportamento do pai (se houver)
event_inherited();

// ✅ DEBUG IMEDIATO: Verificar se Step está executando
if (!variable_instance_exists(id, "step_counter")) {
    step_counter = 0;
}
step_counter++;

// ✅ REMOVIDO: Debug excessivo removido para melhorar performance
// Debug apenas se necessário e debug_enabled estiver ativo
if (variable_global_exists("debug_enabled") && global.debug_enabled && step_counter % 600 == 0) {
    show_debug_message("⚙️ Quartel Step executando - ID: " + string(id));
}

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

// ✅ OTIMIZADO: Debug reduzido - apenas quando necessário e debug_enabled ativo
var _tem_fila = ds_exists(fila_recrutamento, ds_type_queue);
var _tamanho_fila = _tem_fila ? ds_queue_size(fila_recrutamento) : 0;
var _debug_habilitado = (variable_global_exists("debug_enabled") && global.debug_enabled);

// Debug apenas a cada 5 segundos (300 frames) se houver atividade
if (_debug_habilitado && (_tamanho_fila > 0 || esta_treinando) && step_counter % 300 == 0) {
    show_debug_message("⚙️ Quartel ID: " + string(id) + " | Nação: " + string(nacao_proprietaria) + 
                       " | Treinando: " + string(esta_treinando) + " | Fila: " + string(_tamanho_fila) + 
                       " | Timer: " + string(tempo_treinamento_restante));
}

	// === SISTEMA DE PRODUÇÃO COM FILA ===

	// ✅ CORREÇÃO: Iniciar produção se tiver unidades na fila mas não estiver treinando
	// Verificar se fila existe antes de usar
	if (!ds_exists(fila_recrutamento, ds_type_queue)) {
	    // Se fila não existe, recriar (proteção)
	    fila_recrutamento = ds_queue_create();
	    show_debug_message("⚠️ Fila de recrutamento recriada");
	}
	
	// ✅ VERIFICAR SE FILA MUDOU E RECOMEÇAR TREINAMENTO SE NECESSÁRIO
	var _fila_tamanho_agora = ds_queue_size(fila_recrutamento);
	if (!esta_treinando && _fila_tamanho_agora > 0) {
	    esta_treinando = true;
	    tempo_treinamento_restante = 0;
	    
	    // Obter próxima unidade da fila
	    var _indice_unidade = ds_queue_head(fila_recrutamento);
	    unidade_selecionada = _indice_unidade;
	    
	    var _unidade_data = ds_list_find_value(unidades_disponiveis, _indice_unidade);
	    if (_unidade_data != undefined) {
	        if (_debug_habilitado) {
	            show_debug_message("🚀 Quartel iniciando treinamento de: " + _unidade_data.nome + " | Fila: " + string(_fila_tamanho_agora));
	        }
	    } else {
	        if (_debug_habilitado) {
	            show_debug_message("❌ ERRO: Dados da unidade não encontrados para índice " + string(_indice_unidade));
	        }
	    }
	}

	// Processar treinamento
	// ✅ CORREÇÃO: Verificar se fila existe antes de usar
	// ✅ DEBUG: Verificar condições de processamento
	// ✅ REMOVIDO: Debug excessivo removido para melhorar performance
	
	if (esta_treinando && ds_exists(fila_recrutamento, ds_type_queue) && !ds_queue_empty(fila_recrutamento)) {
	    
	    var _indice_unidade = ds_queue_head(fila_recrutamento);
	    var _unidade_data = ds_list_find_value(unidades_disponiveis, _indice_unidade);
	    
	    // ✅ CORREÇÃO: Contar quantas unidades do mesmo tipo estão na fila (SEM REMOVER)
	    var _mesmo_tipo_count = 0;
	    var _queue_size = ds_queue_size(fila_recrutamento);
	    
	    // Contar unidades do mesmo tipo sem desenfileirar
	    var _queue_temp = ds_queue_create();
	    for (var _i = 0; _i < _queue_size; _i++) {
	        var _item = ds_queue_dequeue(fila_recrutamento);
	        ds_queue_enqueue(_queue_temp, _item);
	        if (_item == _indice_unidade) {
	            _mesmo_tipo_count++;
	        }
	    }
	    
	    // Restaurar fila completa
	    while (!ds_queue_empty(_queue_temp)) {
	        ds_queue_enqueue(fila_recrutamento, ds_queue_dequeue(_queue_temp));
	    }
	    ds_queue_destroy(_queue_temp);
	    
	    // ✅ OTIMIZADO: Debug apenas se habilitado e a cada 5 segundos
	    if (_debug_habilitado && step_counter % 300 == 0) {
	        show_debug_message("⚙️ Quartel treinando - ID: " + string(id) + " | Tipo: " + string(_indice_unidade) + 
	                           " | Quantidade: " + string(_mesmo_tipo_count) + " | Timer: " + string(tempo_treinamento_restante));
	    }
	    
	    // ✅ SISTEMA DE LOTE: Se houver 5+ unidades do mesmo tipo, criar todas de uma vez
	    if (_unidade_data != undefined && _mesmo_tipo_count >= 5) {
	        if (tempo_treinamento_restante == 0 && _debug_habilitado) {
	            show_debug_message("🚀 Iniciando criação em LOTE de " + string(_mesmo_tipo_count) + "x " + _unidade_data.nome);
	        }
	        
	        tempo_treinamento_restante++;
	        
	        // ✅ OTIMIZADO: Debug apenas se habilitado e a cada 3 segundos
	        if (_debug_habilitado && tempo_treinamento_restante % 180 == 0 && tempo_treinamento_restante > 0) {
	            show_debug_message("⏱️ Criação em LOTE: " + string(tempo_treinamento_restante) + "/180 frames");
	        }
	        
	        // ✅ MUDADO: Tempo fixo de 3 segundos (180 frames) para lote
	        if (tempo_treinamento_restante >= 180) {
	            if (_debug_habilitado) {
	                show_debug_message("🚀 CRIAÇÃO EM LOTE INICIADA! Criando " + string(_mesmo_tipo_count) + "x " + _unidade_data.nome);
	            }
	            
	            // ✅ REMOVER unidades do mesmo tipo da fila
	            var _queue_temp2 = ds_queue_create();
	            var _removidas = 0;
	            var _queue_size2 = ds_queue_size(fila_recrutamento);
	            
	            for (var _i2 = 0; _i2 < _queue_size2; _i2++) {
	                var _item2 = ds_queue_dequeue(fila_recrutamento);
	                if (_item2 == _indice_unidade && _removidas < _mesmo_tipo_count) {
	                    _removidas++; // Não adicionar à fila temporária (será criada)
	                } else {
	                    ds_queue_enqueue(_queue_temp2, _item2); // Manter na fila
	                }
	            }
	            
	            // Restaurar fila sem as unidades que serão criadas
	            while (!ds_queue_empty(_queue_temp2)) {
	                ds_queue_enqueue(fila_recrutamento, ds_queue_dequeue(_queue_temp2));
	            }
	            ds_queue_destroy(_queue_temp2);
	            
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
	                    
	                    if (nacao_proprietaria == 2) {
	                        show_debug_message("🤖 TROPA DA IA CRIADA! ID:" + string(_unidade_criada) + " Tipo:" + object_get_name(_unidade_criada.object_index));
	                    }
	                } else {
	                    show_debug_message("❌ ERRO: Falha ao criar unidade " + string(_c + 1) + "/" + string(_mesmo_tipo_count));
	                }
	            }
	            
	            if (_debug_habilitado) {
	                show_debug_message("✅ " + string(_mesmo_tipo_count) + "x " + _unidade_data.nome + " criadas em LOTE!");
	            }
	            
	            // Resetar timer e verificar próxima unidade
	            tempo_treinamento_restante = 0;
	            if (!ds_queue_empty(fila_recrutamento)) {
	                _indice_unidade = ds_queue_head(fila_recrutamento);
	                unidade_selecionada = _indice_unidade;
	                // ✅ REMOVIDO: Debug excessivo
	            } else {
	                esta_treinando = false;
	                if (_debug_habilitado) {
	                    show_debug_message("🏁 Treinamento completo - Quartel ocioso");
	                }
	            }
	        }
	    } else {
	        // ✅ SISTEMA NORMAL: Criar uma por vez (menos de 5 unidades)
	        if (tempo_treinamento_restante == 0 && _unidade_data != undefined && _debug_habilitado) {
	            show_debug_message("🚀 Iniciando treinamento de 1x " + _unidade_data.nome);
	        }
	        tempo_treinamento_restante++;
	        
	        // ✅ CORREÇÃO CRÍTICA: Verificar se dados da unidade são válidos
	        if (_unidade_data == undefined) {
	            if (_debug_habilitado) {
	                show_debug_message("❌ ERRO: Dados da unidade inválidos para índice " + string(_indice_unidade) + " - removendo da fila");
	            }
	            ds_queue_dequeue(fila_recrutamento); // Remover entrada inválida
	            
	            // Verificar se há mais unidades na fila
	            if (!ds_queue_empty(fila_recrutamento)) {
	                tempo_treinamento_restante = 0; // Reset para próxima unidade
	                var _novo_indice = ds_queue_head(fila_recrutamento);
	                unidade_selecionada = _novo_indice;
	            } else {
	                esta_treinando = false;
	                tempo_treinamento_restante = 0;
	                if (_debug_habilitado) {
	                    show_debug_message("🏁 Fila esvaziada após erro - Quartel ocioso");
	                }
	            }
	        } else {
	            var _tempo_necessario = _unidade_data.tempo_treino;
	            
	            // ✅ OTIMIZADO: Debug apenas se habilitado e a cada 3 segundos
	            if (_debug_habilitado && tempo_treinamento_restante % 180 == 0 && tempo_treinamento_restante > 0) {
	                var _fila_size_atual = ds_queue_size(fila_recrutamento);
	                show_debug_message("⏱️ Treinamento: " + string(tempo_treinamento_restante) + "/" + string(_tempo_necessario) + " frames | Fila: " + string(_fila_size_atual));
	            }
	            
	            // Verificar se treinamento concluído
	            if (tempo_treinamento_restante >= _tempo_necessario) {
	                // Posição de spawn
	                var _offset_x = (unidades_criadas mod 3) * 40;
	                var _offset_y = floor(unidades_criadas / 3) * 40;
	                var _spawn_x = x + sprite_width + _offset_x;
	                var _spawn_y = y + sprite_height + _offset_y;
	                
	                if (_debug_habilitado) {
	                    show_debug_message("✚ Criando: " + _unidade_data.nome);
	                }
	                
	                // Verificar se objeto existe antes de criar
	                if (!object_exists(_unidade_data.objeto)) {
	                    if (_debug_habilitado) {
	                        show_debug_message("❌ ERRO: Objeto '" + string(_unidade_data.objeto) + "' não existe!");
	                    }
	                    // ✅ CORREÇÃO: Remover da fila mesmo se falhar
	                    ds_queue_dequeue(fila_recrutamento);
	                    
	                    // Verificar se há mais unidades na fila
	                    if (!ds_queue_empty(fila_recrutamento)) {
	                        tempo_treinamento_restante = 0;
	                        var _novo_indice = ds_queue_head(fila_recrutamento);
	                        unidade_selecionada = _novo_indice;
	                    } else {
	                        esta_treinando = false;
	                        tempo_treinamento_restante = 0;
	                        if (_debug_habilitado) {
	                            show_debug_message("🏁 Fila esvaziada após erro - Quartel ocioso");
	                        }
	                    }
	                } else {
	                    // Criar unidade - tentar diferentes layers
	                    var _unidade_criada = noone;
	                    
	                    // Tentar criar no layer atual do quartel primeiro
	                    var _quartel_layer = layer_get_name(layer);
	                    if (layer_exists(_quartel_layer)) {
	                        _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, _quartel_layer, _unidade_data.objeto);
	                    }
	                    
	                    // Se falhou, tentar camadas padrão
	                    if (!instance_exists(_unidade_criada)) {
	                        var _camadas = ["Instances", "Instances_0", "rm_mapa_principal", "Main"];
	                        
	                        for (var _c = 0; _c < array_length(_camadas) && !instance_exists(_unidade_criada); _c++) {
	                            var _camada_nome = _camadas[_c];
	                            if (layer_exists(_camada_nome)) {
	                                _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, _camada_nome, _unidade_data.objeto);
	                            }
	                        }
	                    }
	                    
	                    // ✅ ULTIMO RECURSO: Criar em qualquer camada válida
	                    if (!instance_exists(_unidade_criada)) {
	                        _unidade_criada = instance_create(_spawn_x, _spawn_y, _unidade_data.objeto);
	                    }
	                    
	                    // ✅ CORREÇÃO CRÍTICA: Só remover da fila se criação foi bem-sucedida
	                    if (instance_exists(_unidade_criada)) {
	                        unidades_criadas++;
	                        
	                        // Remover da fila apenas após sucesso
	                        ds_queue_dequeue(fila_recrutamento);
	                        
	                        // ✅ FORÇAR nação - CRÍTICO para IA funcionar
	                        _unidade_criada.nacao_proprietaria = nacao_proprietaria;
	                        
	                        // ✅ OTIMIZADO: Debug apenas se habilitado
	                        if (_debug_habilitado && nacao_proprietaria == 2) {
	                            show_debug_message("🤖 TROPA DA IA CRIADA! ID:" + string(_unidade_criada) + " Tipo:" + object_get_name(_unidade_criada.object_index));
	                            
	                            // ✅ NOVO - FASE 4: Comandar unidade criada imediatamente
	                            var _presidente = instance_find(obj_presidente_1, 0);
	                            if (instance_exists(_presidente)) {
	                                // ✅ CORREÇÃO: Verificar se script existe antes de chamar
	                                var _script_id = asset_get_index("scr_ia_comando_unidades");
	                                if (_script_id != -1) {
	                                    scr_ia_comando_unidade_criada(_unidade_criada, _presidente);
	                                } else {
	                                    show_debug_message("⚠️ scr_ia_comando_unidades não encontrado!");
	                                }
	                                
	                                // ✅ NOVO - FASE 7: Registrar recrutamento
	                                // ✅ CORREÇÃO: Verificar se scripts existem antes de chamar
	                                var _script_classificar = asset_get_index("scr_ia_classificar_poder_unidades");
	                                var _script_monitorar = asset_get_index("scr_ia_monitorar_performance");
	                                
	                                if (_script_classificar != -1 && _script_monitorar != -1) {
	                                    var _tier = classificar_poder_unidade(_unidade_criada.object_index);
	                                    var _eh_elite = eh_tier_elite(_tier);
	                                    scr_ia_registrar_recrutamento(_presidente, _unidade_criada.object_index, _eh_elite);
	                                } else {
	                                    if (_script_classificar == -1) {
	                                        show_debug_message("⚠️ scr_ia_classificar_poder_unidades não encontrado!");
	                                    }
	                                    if (_script_monitorar == -1) {
	                                        show_debug_message("⚠️ scr_ia_monitorar_performance não encontrado!");
	                                    }
	                                }
	                            }
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
	                            // ✅ REMOVIDO: Debug excessivo
	                        }
	                        
	                        // ✅ OTIMIZADO: Debug apenas se habilitado
	                        if (_debug_habilitado) {
	                            show_debug_message("✅ " + _unidade_data.nome + " criada com sucesso! ID: " + string(_unidade_criada));
	                        }
	                        
	                        // Próxima unidade ou parar produção
	                        if (!ds_queue_empty(fila_recrutamento)) {
	                            tempo_treinamento_restante = 0; // Reset para próxima unidade
	                            _indice_unidade = ds_queue_head(fila_recrutamento);
	                            unidade_selecionada = _indice_unidade;
	                            // ✅ REMOVIDO: Debug excessivo
	                        } else {
	                            esta_treinando = false;
	                            tempo_treinamento_restante = 0;
	                            if (_debug_habilitado) {
	                                show_debug_message("🏁 Treinamento completo - Quartel ocioso");
	                            }
	                        }
	                    } else {
	                        // ✅ CORREÇÃO: Remover da fila mesmo se falhar para não travar
	                        if (_debug_habilitado) {
	                            show_debug_message("❌ ERRO: Falha ao criar unidade! Objeto: " + string(_unidade_data.objeto) + 
	                                             " | Pos: (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
	                        }
	                        ds_queue_dequeue(fila_recrutamento);
	                        
	                        // Verificar se há mais unidades na fila
	                        if (!ds_queue_empty(fila_recrutamento)) {
	                            tempo_treinamento_restante = 0;
	                            var _novo_indice = ds_queue_head(fila_recrutamento);
	                            unidade_selecionada = _novo_indice;
	                        } else {
	                            esta_treinando = false;
	                            tempo_treinamento_restante = 0;
	                            if (_debug_habilitado) {
	                                show_debug_message("🏁 Fila esvaziada após erro - Quartel ocioso");
	                            }
	                        }
	                    }
	                }
	            }
	        }
	    }
	} else {
	    // Verificar condições separadamente para evitar erros de parsing
	    var _fila_existe = ds_exists(fila_recrutamento, ds_type_queue);
	    var _fila_vazia = true;
	    
	    if (_fila_existe) {
	        _fila_vazia = ds_queue_empty(fila_recrutamento);
	    }
	    
	    // Resetar estado se fila não existe ou está vazia
	    if (esta_treinando && (!_fila_existe || _fila_vazia)) {
	        if (_debug_habilitado) {
	            show_debug_message("⚠️ Quartel estava treinando mas fila está vazia - resetando estado");
	        }
	        esta_treinando = false;
	        tempo_treinamento_restante = 0;
	    }
	}
