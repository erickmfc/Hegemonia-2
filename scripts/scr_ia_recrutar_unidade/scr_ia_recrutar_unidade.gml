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
    
    // Unidades terrestres
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
    } else if (_tipo_unidade == obj_blindado_antiaereo) {
        _custo_d = 600;
        _custo_p = 2;
        _custo_m = 300;
        _nome_unidade = "Blindado Anti-Aéreo";
    }
    // ✅ NOVO: Unidades navais (com verificação de existência)
    else if (object_exists(obj_lancha_patrulha) && _tipo_unidade == obj_lancha_patrulha) {
        _custo_d = 50;
        _custo_p = 1;
        _custo_m = 0;
        _nome_unidade = "Lancha Patrulha";
    } else if (object_exists(obj_submarino_base) && _tipo_unidade == obj_submarino_base) {
        _custo_d = 2000;
        _custo_p = 10;
        _custo_m = 1000;
        _nome_unidade = "Submarino";
    } else if (object_exists(obj_Constellation) && _tipo_unidade == obj_Constellation) {
        _custo_d = 2500;
        _custo_p = 12;
        _custo_m = 1200;
        _nome_unidade = "Constellation";
    } else if (object_exists(obj_Independence) && _tipo_unidade == obj_Independence) {
        _custo_d = 5000;
        _custo_p = 20;
        _custo_m = 2500;
        _nome_unidade = "Independence";
    } else if (object_exists(obj_navio_base) && _tipo_unidade == obj_navio_base) {
        _custo_d = 1000;
        _custo_p = 6;
        _custo_m = 500;
        _nome_unidade = "Navio Base";
    }
    // ✅ NOVO: Unidades aéreas (com verificação de existência)
    else if (object_exists(obj_helicoptero_militar) && _tipo_unidade == obj_helicoptero_militar) {
        _custo_d = 600;
        _custo_p = 2;
        _custo_m = 300;
        _nome_unidade = "Helicóptero Militar";
    } else if (object_exists(obj_caca_f5) && _tipo_unidade == obj_caca_f5) {
        _custo_d = 800;
        _custo_p = 3;
        _custo_m = 500;
        _nome_unidade = "Caça F-5";
    } else if (object_exists(obj_f6) && _tipo_unidade == obj_f6) {
        _custo_d = 1500;
        _custo_p = 5;
        _custo_m = 1000;
        _nome_unidade = "F-6";
    } else if (object_exists(obj_f15) && _tipo_unidade == obj_f15) {
        _custo_d = 2000;
        _custo_p = 6;
        _custo_m = 1000;
        _nome_unidade = "F-15";
    } else if (object_exists(obj_c100) && _tipo_unidade == obj_c100) {
        _custo_d = 2500;
        _custo_p = 8;
        _custo_m = 1200;
        _nome_unidade = "C-100";
    } else {
        // Verificar objetos que podem não existir usando asset_get_index
        var _obj_fragata = asset_get_index("obj_fragata");
        if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object && _tipo_unidade == _obj_fragata) {
            _custo_d = 800;
            _custo_p = 5;
            _custo_m = 400;
            _nome_unidade = "Fragata";
        } else {
            var _obj_destroyer = asset_get_index("obj_destroyer");
            if (_obj_destroyer != -1 && asset_get_type(_obj_destroyer) == asset_object && _tipo_unidade == _obj_destroyer) {
                _custo_d = 1500;
                _custo_p = 8;
                _custo_m = 750;
                _nome_unidade = "Destroyer";
            } else {
                var _obj_su35 = asset_get_index("obj_su35");
                if (_obj_su35 != -1 && asset_get_type(_obj_su35) == asset_object && _tipo_unidade == _obj_su35) {
                    _custo_d = 2200;
                    _custo_p = 7;
                    _custo_m = 1100;
                    _nome_unidade = "SU-35";
                }
            }
        }
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
    
    // ✅ MELHORADO: Verificar se é unidade naval, aérea ou terrestre
    var _eh_unidade_naval = false;
    var _eh_unidade_aerea = false;
    
    // Verificar objetos navais que existem
    if (object_exists(obj_lancha_patrulha) && _tipo_unidade == obj_lancha_patrulha) {
        _eh_unidade_naval = true;
    } else if (object_exists(obj_submarino_base) && _tipo_unidade == obj_submarino_base) {
        _eh_unidade_naval = true;
    } else if (object_exists(obj_Constellation) && _tipo_unidade == obj_Constellation) {
        _eh_unidade_naval = true;
    } else if (object_exists(obj_Independence) && _tipo_unidade == obj_Independence) {
        _eh_unidade_naval = true;
    } else if (object_exists(obj_navio_base) && _tipo_unidade == obj_navio_base) {
        _eh_unidade_naval = true;
    } else if (object_exists(obj_navio_transporte) && _tipo_unidade == obj_navio_transporte) {
        _eh_unidade_naval = true;
    }
    // ✅ NOVO: Verificar unidades aéreas
    else if (object_exists(obj_helicoptero_militar) && _tipo_unidade == obj_helicoptero_militar) {
        _eh_unidade_aerea = true;
    } else if (object_exists(obj_caca_f5) && _tipo_unidade == obj_caca_f5) {
        _eh_unidade_aerea = true;
    } else if (object_exists(obj_f6) && _tipo_unidade == obj_f6) {
        _eh_unidade_aerea = true;
    } else if (object_exists(obj_f15) && _tipo_unidade == obj_f15) {
        _eh_unidade_aerea = true;
    } else if (object_exists(obj_c100) && _tipo_unidade == obj_c100) {
        _eh_unidade_aerea = true;
    } else {
        // Verificar objetos que podem não existir
        var _obj_fragata = asset_get_index("obj_fragata");
        if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object && _tipo_unidade == _obj_fragata) {
            _eh_unidade_naval = true;
        } else {
            var _obj_destroyer = asset_get_index("obj_destroyer");
            if (_obj_destroyer != -1 && asset_get_type(_obj_destroyer) == asset_object && _tipo_unidade == _obj_destroyer) {
                _eh_unidade_naval = true;
            } else {
                var _obj_su35 = asset_get_index("obj_su35");
                if (_obj_su35 != -1 && asset_get_type(_obj_su35) == asset_object && _tipo_unidade == _obj_su35) {
                    _eh_unidade_aerea = true;
                }
            }
        }
    }
    
    // Procurar estrutura apropriada (naval, aérea ou terrestre)
    if (_eh_unidade_naval) {
        // Procurar quartel naval
        with (obj_quartel_marinha) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                _quartel_da_ia = id;
                break;
            }
        }
    } else if (_eh_unidade_aerea) {
        // ✅ NOVO: Procurar aeroporto militar
        with (obj_aeroporto_militar) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                _quartel_da_ia = id;
                break;
            }
        }
    } else {
        // Procurar quartel terrestre
        with (obj_quartel) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                _quartel_da_ia = id;
                break;
            }
        }
    }
    
    if (_quartel_da_ia == noone) {
        var _tipo_estrutura = _eh_unidade_naval ? "naval" : (_eh_unidade_aerea ? "aérea" : "terrestre");
        show_debug_message("❌ IA não tem estrutura " + _tipo_estrutura + " disponível (não encontrou estrutura da nação " + string(_nacao_ia) + ")");
        return false;
    }
    
    // ✅ MELHORADO: 4. Adicionar unidades à FILA (quintal/aeroporto)
    with (_quartel_da_ia) {
        // ✅ NOVO: Aeroporto usa fila_producao, quartéis usam fila_recrutamento
        var _fila_usar = noone;
        var _nome_fila = "";
        
        if (_eh_unidade_aerea) {
            // Aeroporto militar usa fila_producao
            if (!variable_instance_exists(id, "fila_producao")) {
                fila_producao = ds_queue_create();
                show_debug_message("⚠️ Fila de produção aérea criada (variável não existia)");
            }
            if (!ds_exists(fila_producao, ds_type_queue)) {
                fila_producao = ds_queue_create();
                show_debug_message("⚠️ Fila de produção aérea recriada (estrutura inválida)");
            }
            _fila_usar = fila_producao;
            _nome_fila = "fila_producao";
        } else {
            // Quartéis usam fila_recrutamento
            if (!variable_instance_exists(id, "fila_recrutamento")) {
                fila_recrutamento = ds_queue_create();
                show_debug_message("⚠️ Fila de recrutamento criada (variável não existia)");
            }
            if (!ds_exists(fila_recrutamento, ds_type_queue)) {
                fila_recrutamento = ds_queue_create();
                show_debug_message("⚠️ Fila de recrutamento recriada (estrutura inválida)");
            }
            _fila_usar = fila_recrutamento;
            _nome_fila = "fila_recrutamento";
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
            show_debug_message("⚠️ IA: Tipo " + _nome_unidade + " não encontrado em unidades_disponiveis, tentando adicionar mesmo assim");
            // Para aeroporto, pode não ter todas as unidades na lista, então usar índice 0 como fallback
            _idx_unidade = 0;
        }
        
        // ✅ ADICIONAR MÚLTIPLAS UNIDADES À FILA
        for (var j = 0; j < _quantidade; j++) {
            ds_queue_enqueue(_fila_usar, _idx_unidade);
        }
        
        show_debug_message("✅ IA adicionou " + string(_quantidade) + "x " + _nome_unidade + " à " + _nome_fila + " (índice " + string(_idx_unidade) + ")");
        show_debug_message("📊 Tamanho da fila: " + string(ds_queue_size(_fila_usar)));
        
        // ✅ FORÇAR INÍCIO DE PRODUÇÃO SE ESTIVER OCIOSO
        if (_eh_unidade_aerea) {
            // Aeroporto usa produzindo
            if (!variable_instance_exists(id, "produzindo") || !produzindo) {
                show_debug_message("🚀 Aeroporto da IA está ocioso - iniciando produção imediatamente!");
                produzindo = true;
                if (variable_instance_exists(id, "timer_producao")) {
                    timer_producao = 0;
                }
            } else {
                show_debug_message("⏸️ Aeroporto da IA já está produzindo - unidade adicionada à fila");
            }
        } else {
            // Quartéis usam esta_treinando
            if (!variable_instance_exists(id, "esta_treinando") || !esta_treinando) {
                show_debug_message("🚀 Quartel da IA está ocioso - iniciando produção imediatamente!");
                esta_treinando = true;
                if (variable_instance_exists(id, "tempo_treinamento_restante")) {
                    tempo_treinamento_restante = 0;
                }
            } else {
                show_debug_message("⏸️ Quartel da IA já está treinando - unidade adicionada à fila");
            }
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
