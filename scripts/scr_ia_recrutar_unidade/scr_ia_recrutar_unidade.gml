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
    
    // 3. Procurar quartel disponível da IA
    var _quartel_da_ia = noone;
    with (obj_quartel) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            if (!variable_instance_exists(id, "esta_treinando") || !esta_treinando) {
                _quartel_da_ia = id;
                break;
            }
        }
    }
    
    if (!instance_exists(_quartel_da_ia)) {
        show_debug_message("❌ IA não tem quartel disponível");
        return false;
    }
    
    // 4. Iniciar recrutamento no quartel
    with (_quartel_da_ia) {
        // Configurar variáveis de treinamento
        if (!variable_instance_exists(id, "esta_treinando")) {
            esta_treinando = false;
        }
        esta_treinando = true;
        
        // Definir quantidade
        if (!variable_instance_exists(id, "unidades_para_criar")) {
            unidades_para_criar = 1;
        }
        unidades_para_criar = _quantidade;
        unidades_criadas = 0;
        
        // Encontrar índice da unidade nas unidades_disponiveis
        if (variable_instance_exists(id, "unidades_disponiveis")) {
            var _idx_encontrado = -1;
            for (var i = 0; i < ds_list_size(unidades_disponiveis); i++) {
                var _data = ds_list_find_value(unidades_disponiveis, i);
                if (is_struct(_data)) {
                    if (variable_struct_exists(_data, "objeto") && _data.objeto == _tipo_unidade) {
                        _idx_encontrado = i;
                        break;
                    }
                }
            }
            
            if (_idx_encontrado != -1) {
                unidade_selecionada = _idx_encontrado;
                show_debug_message("✅ IA definiu tipo de unidade: " + _nome_unidade + " (índice " + string(_idx_encontrado) + ")");
            } else {
                show_debug_message("⚠️ IA: Tipo não encontrado, usando infantaria como padrão");
                unidade_selecionada = 0; // Fallback para infantaria
            }
        }
        
        // Configurar alarm (5 segundos para completar)
        alarm[0] = 300; // 300 frames = 5 segundos
        
        show_debug_message("✅ IA iniciou recrutamento de " + string(_quantidade) + " " + _nome_unidade);
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
