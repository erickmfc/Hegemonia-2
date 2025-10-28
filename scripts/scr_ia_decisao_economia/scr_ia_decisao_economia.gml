/// @description Módulo de Decisão Econômica da IA - REVISADO
/// @param _ia_id ID da instância da IA
/// @return Acao a ser tomada ("construir_economia", "construir_militar", "recrutar_unidades", "atacar", "expandir")

function scr_ia_decisao_economia(_ia_id) {
    var _ia = _ia_id;
    
    // ==========================================
    // ANÁLISE ECONÔMICA
    // ==========================================
    
    // 1. Contar estruturas econômicas existentes
    var _num_fazendas = 0;
    var _num_minas = 0;
    var _num_bancos = 0;
    
    with (obj_fazenda) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_fazendas++;
        }
    }
    
    // Contar minas (existem várias variações de mina)
    with (obj_mina) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_minas++;
        }
    }
    with (obj_mina_ouro) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_minas++;
        }
    }
    with (obj_mina_aluminio) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_minas++;
        }
    }
    with (obj_mina_cobre) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_minas++;
        }
    }
    
    with (obj_banco) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_bancos++;
        }
    }
    
    // 2. Contar estruturas militares
    var _num_quartel = 0;
    var _num_quartel_marinha = 0;
    var _num_aeroporto = 0;
    
    with (obj_quartel) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_quartel++;
        }
    }
    
    with (obj_quartel_marinha) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_quartel_marinha++;
        }
    }
    
    with (obj_aeroporto_militar) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_aeroporto++;
        }
    }
    
    // 3. Contar unidades militares
    var _num_infantaria = 0;
    var _num_tanque = 0;
    var _num_blindado = 0;
    var _total_unidades = 0;
    
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_infantaria++;
            _total_unidades++;
        }
    }
    
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_tanque++;
            _total_unidades++;
        }
    }
    
    with (obj_blindado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria")) {
            if (nacao_proprietaria == _ia.nacao_proprietaria) {
                _num_blindado++;
                _total_unidades++;
            }
        }
    }
    
    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _total_unidades++;
        }
    }
    
    // 4. Detectar inimigos próximos
    var _num_inimigos_proximos = 0;
    var _distancia_media_inimigos = 999999;
    
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
            if (_dist <= _ia.raio_expansao) {
                _num_inimigos_proximos++;
                if (_dist < _distancia_media_inimigos) {
                    _distancia_media_inimigos = _dist;
                }
            }
        }
    }
    
    // ==========================================
    // AVALIAÇÃO DE RECURSOS
    // ==========================================
    
    var _dinheiro_suficiente = global.ia_dinheiro >= 1000;
    var _minerio_suficiente = global.ia_minerio >= 500;
    var _recursos_criticos = global.ia_dinheiro < 500 || global.ia_minerio < 250;
    
    // ==========================================
    // SISTEMA DE DECISÃO POR PRIORIDADES
    // ==========================================
    
    var _decisao = "expandir";
    var _prioridade = 0;
    
    // PRIORIDADE 1: CRÍTICO - Sem recursos básicos
    if (_recursos_criticos && _num_fazendas < 3) {
        _decisao = "construir_economia";
        _prioridade = 10;
    }
    // PRIORIDADE 2: ECONÔMICO - Falta de infraestrutura econômica
    else if (_num_fazendas < 2) {
        _decisao = "construir_economia";
        _prioridade = 9;
    }
    // PRIORIDADE 3: ECONÔMICO - Falta de minas
    else if (_num_minas < 1 && _dinheiro_suficiente) {
        _decisao = "construir_mina";
        _prioridade = 8;
    }
    // PRIORIDADE 4: MILITAR - Falta de quartel
    else if (_num_quartel < 1 && _dinheiro_suficiente && _minerio_suficiente) {
        _decisao = "construir_militar";
        _prioridade = 7;
    }
    // PRIORIDADE 5: MILITAR - Falta de infraestrutura naval
    else if (_num_quartel_marinha < 1 && _dinheiro_suficiente && _minerio_suficiente) {
        _decisao = "construir_naval";
        _prioridade = 6;
    }
    // PRIORIDADE 6: MILITAR - Falta de aeroporto
    else if (_num_aeroporto < 1 && _dinheiro_suficiente && _minerio_suficiente) {
        _decisao = "construir_aereo";
        _prioridade = 5;
    }
    // PRIORIDADE 7: MILITAR - Recrutar unidades
    else if (_total_unidades < 15 && _num_quartel >= 1) {
        _decisao = "recrutar_unidades";
        _prioridade = 4;
    }
    // PRIORIDADE 8: EXPANSÃO - Expandir infraestrutura econômica
    else if (_num_fazendas < 5 && _dinheiro_suficiente) {
        _decisao = "expandir_economia";
        _prioridade = 3;
    }
    // PRIORIDADE 9: ATAQUE - Inimigos próximos
    else if (_num_inimigos_proximos > 0 && _total_unidades >= 5) {
        _decisao = "atacar";
        _prioridade = 2;
    }
    // PRIORIDADE 10: PADRÃO - Manter expansão
    else {
        _decisao = "expandir";
        _prioridade = 1;
    }
    
    // ==========================================
    // DEBUG E LOG
    // ==========================================
    
    show_debug_message("🤖 IA DECISÃO [" + string(_prioridade) + "]: " + _decisao);
    show_debug_message("  📊 Fazendas: " + string(_num_fazendas) + " | Minhas: " + string(_num_minas) + " | Bancos: " + string(_num_bancos));
    show_debug_message("  🎖️ Quartéis: " + string(_num_quartel) + " | Naval: " + string(_num_quartel_marinha) + " | Aéreo: " + string(_num_aeroporto));
    show_debug_message("  ⚔️ Unidades: " + string(_total_unidades) + " (Inf: " + string(_num_infantaria) + ", Tnk: " + string(_num_tanque) + ")");
    show_debug_message("  💰 Recursos: $" + string(global.ia_dinheiro) + " | Minério: " + string(global.ia_minerio));
    show_debug_message("  👹 Inimigos próximos: " + string(_num_inimigos_proximos));
    
    return _decisao;
}
