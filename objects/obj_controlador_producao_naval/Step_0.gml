// ===============================================
// HEGEMONIA GLOBAL - CONTROLADOR DE PRODUÇÃO NAVAL
// Sistema de Monitoramento Independente
// ===============================================

// === MONITORAMENTO DE PRODUÇÃO ===
if (monitorando) {
    timer_monitoramento++;
    
    // Verificar a cada frame
    if (timer_monitoramento >= intervalo_verificacao) {
        timer_monitoramento = 0;
        
        // Processar todos os quartéis
        with (obj_quartel_marinha) {
            if (produzindo && !ds_queue_empty(fila_producao)) {
                
                // Verificar se tempo de produção concluído
                var tempo_concluido = false;
                
                // Verificar timer alternativo
                if (variable_instance_exists(id, "timer_producao_step")) {
                    var _unidade_data = ds_queue_head(fila_producao);
                    var _tempo_necessario = _unidade_data.tempo_treino;
                    
                    if (timer_producao_step >= _tempo_necessario) {
                        tempo_concluido = true;
                        show_debug_message("🎯 CONTROLADOR: Timer alternativo concluído!");
                    }
                }
                
                // Verificar alarm
                if (alarm[0] <= 0) {
                    tempo_concluido = true;
                    show_debug_message("🎯 CONTROLADOR: Alarm concluído!");
                }
                
                // Se tempo concluído, criar unidade
                if (tempo_concluido) {
                    show_debug_message("🚨 CONTROLADOR: Processando produção!");
                    
                    // Criar unidade naval
                    var _spawn_x = x + 80;
                    var _spawn_y = y + 80;
                    
                    var _unidade_data = ds_queue_dequeue(fila_producao);
                    
                    show_debug_message("🚢 CONTROLADOR: Criando " + _unidade_data.nome);
                    show_debug_message("📍 Posição: (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
                    
                    // Tentar criar unidade
                    var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", obj_lancha_patrulha);
                    
                    if (instance_exists(_unidade_criada)) {
                        unidades_produzidas++;
                        producoes_processadas++;
                        
                        show_debug_message("✅ CONTROLADOR: Unidade criada com sucesso!");
                        show_debug_message("   - ID: " + string(_unidade_criada));
                        show_debug_message("   - Posição: (" + string(_unidade_criada.x) + ", " + string(_unidade_criada.y) + ")");
                        show_debug_message("   - Total produzidas: " + string(unidades_produzidas));
                        show_debug_message("   - Total processadas pelo controlador: " + string(producoes_processadas));
                        
                        // Configurar unidade
                        _unidade_criada.nacao_proprietaria = nacao_proprietaria;
                        
                        // Verificar próxima unidade
                        if (!ds_queue_empty(fila_producao)) {
                            var _proxima = ds_queue_head(fila_producao);
                            alarm[0] = _proxima.tempo_treino;
                            timer_producao_step = 0;
                            show_debug_message("🔄 CONTROLADOR: Iniciando próxima produção...");
                        } else {
                            produzindo = false;
                            timer_producao_step = 0;
                            show_debug_message("🏁 CONTROLADOR: Fila vazia - Quartel ocioso");
                        }
                        
                    } else {
                        show_debug_message("❌ CONTROLADOR: Falha ao criar unidade!");
                        
                        // Tentar criação alternativa
                        show_debug_message("🔄 CONTROLADOR: Tentando criação alternativa...");
                        var _alt_criada = instance_create_layer(_spawn_x + 50, _spawn_y + 50, "rm_mapa_principal", obj_lancha_patrulha);
                        
                        if (instance_exists(_alt_criada)) {
                            unidades_produzidas++;
                            producoes_processadas++;
                            show_debug_message("✅ CONTROLADOR: Criação alternativa funcionou!");
                            _alt_criada.nacao_proprietaria = nacao_proprietaria;
                            ds_queue_dequeue(fila_producao);
                        } else {
                            show_debug_message("❌ CONTROLADOR: Criação alternativa também falhou!");
                        }
                    }
                } else {
                    // Incrementar timer alternativo
                    if (variable_instance_exists(id, "timer_producao_step")) {
                        timer_producao_step++;
                    }
                    
                    // Debug do progresso
                    if (debug_ativo && timer_monitoramento % 300 == 0) { // A cada 5 segundos
                        var _unidade_data = ds_queue_head(fila_producao);
                        show_debug_message("⏱️ CONTROLADOR: Progresso - " + string(timer_producao_step) + "/" + string(_unidade_data.tempo_treino) + " frames");
                        show_debug_message("   - Alarm[0]: " + string(alarm[0]));
                    }
                }
            }
        }
    }
}

// === DEBUG DO CONTROLADOR ===
if (debug_ativo) {
    ultima_verificacao++;
    if (ultima_verificacao % 1800 == 0) { // A cada 30 segundos
        show_debug_message("🎮 CONTROLADOR ATIVO:");
        show_debug_message("   - ID: " + string(id));
        show_debug_message("   - Monitorando: " + string(monitorando));
        show_debug_message("   - Produções processadas: " + string(producoes_processadas));
        show_debug_message("   - Quartéis: " + string(instance_number(obj_quartel_marinha)));
        show_debug_message("   - Navios: " + string(instance_number(obj_lancha_patrulha)));
    }
}
