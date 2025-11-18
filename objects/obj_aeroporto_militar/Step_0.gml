// ===============================================
// HEGEMONIA GLOBAL - AEROPORTO MILITAR
// Sistema de Produção Aérea - STEP EVENT
// ===============================================

// === SISTEMA DE VIDA ===
// Verificar se HP chegou a 0 e destruir
if (destrutivel && hp_atual <= 0) {
    show_debug_message("💥 Aeroporto destruído - HP: " + string(hp_atual) + "/" + string(hp_max));
    instance_destroy();
    exit;
}

// === SISTEMA DE PRODUÇÃO AÉREA COM FILA ===

// ✅ CORREÇÃO: Iniciar produção automaticamente se tiver unidades na fila mas não estiver produzindo
if (!produzindo && !ds_queue_empty(fila_producao)) {
    produzindo = true;
    timer_producao = 0;
    
    var _unidade_data = ds_queue_head(fila_producao);
    if (_unidade_data != undefined) {
        show_debug_message("🚀 Aeroporto iniciando produção de: " + _unidade_data.nome);
        show_debug_message("📊 Unidades na fila: " + string(ds_queue_size(fila_producao)));
    }
}

if (produzindo && !ds_queue_empty(fila_producao)) {
    
    // Incrementar timer
    timer_producao++;
    
    // Obter dados da unidade atual
    var _unidade_data = ds_queue_head(fila_producao);
    
    // ✅ CORREÇÃO: Verificar se dados da unidade são válidos
    if (_unidade_data == undefined || !is_struct(_unidade_data)) {
        show_debug_message("❌ ERRO: Dados da unidade inválidos na fila!");
        // Remover item inválido e continuar
        ds_queue_dequeue(fila_producao);
        if (!ds_queue_empty(fila_producao)) {
            timer_producao = 0; // Reset para próxima unidade
        } else {
            produzindo = false;
            timer_producao = 0;
        }
        exit;
    }
    
    // ✅ CORREÇÃO: Verificar se tem tempo_treino definido
    var _tempo_necessario = 180; // Tempo padrão (3 segundos)
    if (variable_struct_exists(_unidade_data, "tempo_treino")) {
        _tempo_necessario = _unidade_data.tempo_treino;
    } else {
        show_debug_message("⚠️ AVISO: Unidade na fila não tem tempo_treino definido, usando padrão (180 frames)");
        show_debug_message("   Dados: " + string(_unidade_data));
    }
    
    // Debug a cada segundo
    if (timer_producao % 60 == 0) {
        var _fila_size = ds_queue_size(fila_producao);
        show_debug_message("⏱️ Produção: " + string(timer_producao) + "/" + string(_tempo_necessario) + " frames | Fila: " + string(_fila_size));
    }
    
    // Verificar se produção concluída
    if (timer_producao >= _tempo_necessario) {
        
        // Posição de spawn (mais à direita do aeroporto - área de estacionamento)
        // ✅ MELHORADO: Variação aleatória maior para distribuição
        var _variacao_x = random_range(-40, 40);  // Variação horizontal maior
        var _variacao_y = random_range(-30, 30);  // Variação vertical maior
        
        var _spawn_x = x + 220 + _variacao_x; // Mais à direita com maior espaçamento
        var _spawn_y = y + _variacao_y;       // Mesma altura do aeroporto (não abaixo)
        
        // Remover unidade da fila
        var _unidade_data_final = ds_queue_dequeue(fila_producao);
        
        // ✅ CORREÇÃO: Verificar se dados são válidos antes de criar
        if (_unidade_data_final == undefined || !is_struct(_unidade_data_final)) {
            show_debug_message("❌ ERRO: Dados da unidade inválidos ao remover da fila!");
            // Continuar para próxima unidade ou parar
            if (!ds_queue_empty(fila_producao)) {
                timer_producao = 0;
            } else {
                produzindo = false;
                timer_producao = 0;
            }
            exit;
        }
        
        // ✅ CORREÇÃO: Verificar se tem nome e objeto definidos
        if (!variable_struct_exists(_unidade_data_final, "nome") || !variable_struct_exists(_unidade_data_final, "objeto")) {
            show_debug_message("❌ ERRO: Unidade na fila não tem nome ou objeto definido!");
            show_debug_message("   Dados: " + string(_unidade_data_final));
            // Continuar para próxima unidade ou parar
            if (!ds_queue_empty(fila_producao)) {
                timer_producao = 0;
            } else {
                produzindo = false;
                timer_producao = 0;
            }
            exit;
        }
        
        show_debug_message("✈️ Criando: " + _unidade_data_final.nome);
        show_debug_message("📍 Posição de spawn: (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
        show_debug_message("📍 Posição do aeroporto: (" + string(x) + ", " + string(y) + ")");
        show_debug_message("🛫 Decolando da área de estacionamento!");
        
        // Criar unidade aérea
        var _unidade_criada = noone;
        var _objeto_unidade = _unidade_data_final.objeto;
        
        // ✅ CORREÇÃO: Verificar se objeto existe antes de criar
        if (!object_exists(_objeto_unidade)) {
            show_debug_message("❌ ERRO: Objeto da unidade não existe: " + string(_objeto_unidade));
            // Continuar para próxima unidade ou parar
            if (!ds_queue_empty(fila_producao)) {
                timer_producao = 0;
            } else {
                produzindo = false;
                timer_producao = 0;
            }
            exit;
        }
        
        _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "Instances", _objeto_unidade);
        
        // Verificar se criação foi bem-sucedida
        if (instance_exists(_unidade_criada)) {
            unidades_produzidas++;
            _unidade_criada.nacao_proprietaria = nacao_proprietaria;
            show_debug_message("✅ " + _unidade_data_final.nome + " criado! ID: " + string(_unidade_criada));
            
            // ✅ NOVO - FASE 4: Comandar unidade criada se for da IA
            if (nacao_proprietaria == 2) {
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
                        if (global.debug_enabled) {
                            show_debug_message("⚠️ Scripts de classificação/monitoramento não encontrados!");
                        }
                    }
                }
            }
        } else {
            show_debug_message("❌ ERRO: Falha ao criar unidade aérea!");
        }
        
        // Próxima unidade ou parar produção
        if (!ds_queue_empty(fila_producao)) {
            timer_producao = 0; // Reset para próxima unidade
            show_debug_message("🔄 Iniciando próxima produção aérea...");
        } else {
            produzindo = false;
            timer_producao = 0;
            show_debug_message("🏁 Produção aérea concluída - Aeroporto ocioso");
        }
    }
}