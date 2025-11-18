/// @function scr_destruir_estrutura(_estrutura_id)
/// @description Destrói uma estrutura, para produção, libera unidades e dá reembolso parcial
/// @param {instance} _estrutura_id ID da estrutura a ser destruída
/// @return {bool} true se destruiu com sucesso, false caso contrário

function scr_destruir_estrutura(_estrutura_id) {
    
    if (!instance_exists(_estrutura_id)) {
        show_debug_message("❌ ERRO: Estrutura não existe para destruição");
        return false;
    }
    
    var _estrutura = _estrutura_id;
    var _nome_estrutura = object_get_name(_estrutura.object_index);
    
    show_debug_message("💥 DESTRUINDO ESTRUTURA: " + _nome_estrutura + " (ID: " + string(_estrutura) + ")");
    
    // === 1. PARAR PRODUÇÃO DE RECURSOS ===
    // Desativar alarme de produção se existir
    if (variable_instance_exists(_estrutura, "alarm")) {
        if (_estrutura.alarm[0] > 0) {
            _estrutura.alarm[0] = -1; // Desativar alarme
            show_debug_message("🛑 Produção de recursos parada");
        }
    }
    
    // Parar produção se estrutura herda de obj_estrutura_producao
    if (variable_instance_exists(_estrutura, "producao_por_ciclo")) {
        _estrutura.producao_por_ciclo = 0;
        show_debug_message("🛑 Produção por ciclo zerada");
    }
    
    // === 2. LIBERAR UNIDADES DA FILA DE RECRUTAMENTO ===
    // Se for quartel, liberar unidades da fila
    if (variable_instance_exists(_estrutura, "fila_recrutamento")) {
        if (ds_exists(_estrutura.fila_recrutamento, ds_type_queue)) {
            var _tamanho_fila = ds_queue_size(_estrutura.fila_recrutamento);
            if (_tamanho_fila > 0) {
                show_debug_message("🔓 Liberando " + string(_tamanho_fila) + " unidades da fila de recrutamento");
                
                // Limpar fila
                while (!ds_queue_empty(_estrutura.fila_recrutamento)) {
                    ds_queue_dequeue(_estrutura.fila_recrutamento);
                }
                
                // Destruir estrutura de dados
                ds_queue_destroy(_estrutura.fila_recrutamento);
            }
        }
    }
    
    // Parar treinamento se estiver treinando
    if (variable_instance_exists(_estrutura, "esta_treinando")) {
        if (_estrutura.esta_treinando) {
            _estrutura.esta_treinando = false;
            show_debug_message("🛑 Treinamento cancelado");
        }
    }
    
    // === 3. CALCULAR E APLICAR REEMBOLSO PARCIAL ===
    var _reembolso_dinheiro = 0;
    var _reembolso_minerio = 0;
    
    // Obter custos de construção
    var _custo_dinheiro = 0;
    var _custo_minerio = 0;
    
    if (variable_instance_exists(_estrutura, "custo_dinheiro")) {
        _custo_dinheiro = _estrutura.custo_dinheiro;
    } else if (variable_instance_exists(_estrutura, "custo_fazenda")) {
        _custo_dinheiro = _estrutura.custo_fazenda;
    }
    
    if (variable_instance_exists(_estrutura, "custo_minerio")) {
        _custo_minerio = _estrutura.custo_minerio;
    }
    
    // Calcular reembolso baseado no HP restante (percentual)
    if (variable_instance_exists(_estrutura, "hp_atual") && variable_instance_exists(_estrutura, "hp_max")) {
        var _hp_percentual = _estrutura.hp_atual / _estrutura.hp_max;
        
        // Reembolso: 50% do custo baseado no HP restante
        // Exemplo: Se tinha 50% HP, reembolsa 25% do custo (50% * 50%)
        var _percentual_reembolso = _hp_percentual * 0.5; // Máximo 50% do custo
        
        _reembolso_dinheiro = floor(_custo_dinheiro * _percentual_reembolso);
        _reembolso_minerio = floor(_custo_minerio * _percentual_reembolso);
        
        show_debug_message("💰 HP: " + string(_estrutura.hp_atual) + "/" + string(_estrutura.hp_max) + " (" + string(floor(_hp_percentual * 100)) + "%)");
        show_debug_message("💰 Reembolso calculado: " + string(floor(_percentual_reembolso * 100)) + "% do custo");
    } else {
        // Se não tem HP, reembolso mínimo (10%)
        _reembolso_dinheiro = floor(_custo_dinheiro * 0.1);
        _reembolso_minerio = floor(_custo_minerio * 0.1);
        show_debug_message("💰 Reembolso mínimo (10%) - estrutura sem HP");
    }
    
    // Aplicar reembolso baseado na nação proprietária
    if (variable_instance_exists(_estrutura, "nacao_proprietaria")) {
        var _nacao = _estrutura.nacao_proprietaria;
        
        if (_nacao == 1) {
            // Jogador
            if (variable_global_exists("dinheiro")) {
                global.dinheiro += _reembolso_dinheiro;
            }
            if (variable_global_exists("minerio")) {
                global.minerio += _reembolso_minerio;
            }
            show_debug_message("💰 Reembolso ao jogador: $" + string(_reembolso_dinheiro) + " | Minério: " + string(_reembolso_minerio));
        } else if (_nacao == 2) {
            // IA
            if (variable_global_exists("ia_dinheiro")) {
                global.ia_dinheiro += _reembolso_dinheiro;
            }
            if (variable_global_exists("ia_minerio")) {
                global.ia_minerio += _reembolso_minerio;
            }
            show_debug_message("💰 Reembolso à IA: $" + string(_reembolso_dinheiro) + " | Minério: " + string(_reembolso_minerio));
        }
    } else {
        // Nação não definida, dar ao jogador por padrão
        if (variable_global_exists("dinheiro")) {
            global.dinheiro += _reembolso_dinheiro;
        }
        if (variable_global_exists("minerio")) {
            global.minerio += _reembolso_minerio;
        }
        show_debug_message("💰 Reembolso padrão (jogador): $" + string(_reembolso_dinheiro) + " | Minério: " + string(_reembolso_minerio));
    }
    
    // === 4. DESTRUIR A ESTRUTURA ===
    show_debug_message("💥 Estrutura " + _nome_estrutura + " destruída!");
    instance_destroy(_estrutura);
    
    return true;
}

