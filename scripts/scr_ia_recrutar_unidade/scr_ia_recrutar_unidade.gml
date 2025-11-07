/// @description Recrutar Unidades para a IA
/// @param _ia_id ID da IA
/// @param _tipo_unidade Tipo de unidade (obj_infantaria, obj_tanque, etc)
/// @param _quantidade Quantidade a recrutar
/// @return true se conseguiu iniciar recrutamento

function scr_ia_recrutar_unidade(_ia_id, _tipo_unidade, _quantidade) {
    var _ia = _ia_id;
    
    // 1. Obter custos baseados no tipo de unidade
    var _custo_d = 0;
    var _custo_p = 0;
    var _custo_m = 0;
    var _nome_unidade = "";
    
    if (_tipo_unidade == obj_infantaria) {
        _custo_d = 100;
        _custo_p = 1;
        _custo_m = 0;
        _nome_unidade = "Infantaria";
    } else if (_tipo_unidade == obj_tanque) {
        _custo_d = 500;
        _custo_p = 3;
        _custo_m = 250;
        _nome_unidade = "Tanque";
    } else if (_tipo_unidade == obj_soldado_antiaereo) {
        _custo_d = 150;
        _custo_p = 1;
        _custo_m = 50;
        _nome_unidade = "Soldado Anti-Aéreo";
    }
    
    // Calcular custos totais
    var _custo_total_d = _custo_d * _quantidade;
    var _custo_total_p = _custo_p * _quantidade;
    var _custo_total_m = _custo_m * _quantidade;
    
    // 2. Verificar recursos da IA
    if (global.ia_dinheiro < _custo_total_d || global.ia_populacao < _custo_total_p || global.ia_minerio < _custo_total_m) {
        show_debug_message("❌ IA sem recursos para recrutar " + _nome_unidade + " (Precisa: $" + string(_custo_total_d) + ", " + string(_custo_total_p) + " população, " + string(_custo_total_m) + " minério)");
        return false;
    }
    
    // 3. Procurar quartel da IA (pode estar treinando - fila aceita sempre)
    var _quartel_da_ia = noone;
    var _nacao_ia = 2; // Nação da IA (normalmente 2 para IA vs 1 para jogador)
    
    with (obj_quartel) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
            // ✅ CORREÇÃO: Pode usar quartel mesmo se estiver treinando (fila aceita)
            _quartel_da_ia = id;
            break;
        }
    }
    
    if (_quartel_da_ia == noone) {
        show_debug_message("❌ IA não tem quartel disponível (não encontrou quartel da nação " + string(_nacao_ia) + ")");
        return false;
    }
    
    // ✅ CORREÇÃO: 4. Adicionar unidades à FILA do quartel (não usar alarm!)
    with (_quartel_da_ia) {
        // Verificar se fila existe
        if (!ds_exists(fila_recrutamento, ds_type_queue)) {
            fila_recrutamento = ds_queue_create();
            show_debug_message("⚠️ Fila de recrutamento criada");
        }
        
        // Encontrar índice da unidade nas unidades_disponiveis
        var _idx_unidade = -1;
        if (variable_instance_exists(id, "unidades_disponiveis")) {
            for (var i = 0; i < ds_list_size(unidades_disponiveis); i++) {
                var _data = ds_list_find_value(unidades_disponiveis, i);
                if (is_struct(_data)) {
                    if (variable_struct_exists(_data, "objeto") && _data.objeto == _tipo_unidade) {
                        _idx_unidade = i;
                        break;
                    }
                }
            }
        }
        
        if (_idx_unidade == -1) {
            show_debug_message("⚠️ IA: Tipo não encontrado, usando infantaria como padrão");
            _idx_unidade = 0; // Fallback para infantaria
        }
        
        // ✅ ADICIONAR MÚLTIPLAS UNIDADES À FILA
        for (var j = 0; j < _quantidade; j++) {
            ds_queue_enqueue(fila_recrutamento, _idx_unidade);
        }
        
        show_debug_message("✅ IA adicionou " + string(_quantidade) + "x " + _nome_unidade + " à fila (índice " + string(_idx_unidade) + ")");
        show_debug_message("📊 Tamanho da fila: " + string(ds_queue_size(fila_recrutamento)));
        
        // ✅ FORÇAR INÍCIO DE PRODUÇÃO SE ESTIVER OCIOSO
        if (!variable_instance_exists(id, "esta_treinando") || !esta_treinando) {
            show_debug_message("🚀 Quartel da IA está ocioso - iniciando produção imediatamente!");
            esta_treinando = true;
            tempo_treinamento_restante = 0;
        } else {
            show_debug_message("⏸️ Quartel da IA já está treinando - unidade adicionada à fila");
        }
    }
    
    // 5. DEDUZIR recursos da IA
    global.ia_dinheiro -= _custo_total_d;
    global.ia_populacao -= _custo_total_p;
    if (_custo_total_m > 0) {
        global.ia_minerio -= _custo_total_m;
    }
    
    show_debug_message("💰 IA recursos restantes: $" + string(global.ia_dinheiro) + " | População: " + string(global.ia_populacao) + " | Minério: " + string(global.ia_minerio));
    
    return true;
}
