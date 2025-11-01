/// @description Módulo de Decisão da IA - ESTRATÉGIA AGRESSIVA
/// @param _ia_id ID da instância da IA
/// @return Acao a ser tomada

function scr_ia_decisao_economia(_ia_id) {
    var _ia = _ia_id;
    
    // ==========================================
    // ANÁLISE DO ESTADO ATUAL
    // ==========================================
    
    // 1. Contar estruturas econômicas
    var _num_fazendas = 0;
    var _num_minas = 0;
    
    with (obj_fazenda) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_fazendas++;
        }
    }
    
    with (obj_mina) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _num_minas++;
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
    
    // 3. Contar TODAS as unidades militares (terrestre + naval + aéreo)
    var _total_unidades = 0;
    var _unidades_terrestres = 0;
    var _unidades_navais = 0;
    var _unidades_aereas = 0;
    
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _total_unidades++;
            _unidades_terrestres++;
        }
    }
    
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _total_unidades++;
            _unidades_terrestres++;
        }
    }
    
    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _total_unidades++;
            _unidades_terrestres++;
        }
    }
    
    with (obj_blindado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
            _total_unidades++;
            _unidades_terrestres++;
        }
    }
    
    // Contar navios (apenas objetos que existem)
    var _tipos_navais = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base];
    
    // Verificar se obj_fragata existe antes de adicionar
    var _obj_fragata = asset_get_index("obj_fragata");
    if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object) {
        array_push(_tipos_navais, _obj_fragata);
    }
    
    for (var i = 0; i < array_length(_tipos_navais); i++) {
        if (object_exists(_tipos_navais[i])) {
            with (_tipos_navais[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    _total_unidades++;
                    _unidades_navais++;
                }
            }
        }
    }
    
    // Contar aeronaves
    var _tipos_aereos = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_f15];
    for (var i = 0; i < array_length(_tipos_aereos); i++) {
        if (object_exists(_tipos_aereos[i])) {
            with (_tipos_aereos[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _ia.nacao_proprietaria) {
                    _total_unidades++;
                    _unidades_aereas++;
                }
            }
        }
    }
    
    // 4. Detectar TODOS os tipos de inimigos (terrestre + naval + aéreo)
    var _inimigos_terrestres = 0;
    var _inimigos_navais = 0;
    var _inimigos_aereos = 0;
    var _total_inimigos = 0;
    
    // Inimigos terrestres
    var _tipos_inimigos_terra = [obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo];
    for (var i = 0; i < array_length(_tipos_inimigos_terra); i++) {
        if (object_exists(_tipos_inimigos_terra[i])) {
            with (_tipos_inimigos_terra[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                    var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                    if (_dist <= _ia.raio_expansao * 1.5) { // Alcance aumentado
                        _inimigos_terrestres++;
                        _total_inimigos++;
                    }
                }
            }
        }
    }
    
    // Inimigos navais (apenas objetos que existem)
    var _tipos_inimigos_naval = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_Constellation, obj_Independence, obj_RonaldReagan];
    
    // ✅ CORREÇÃO: Reutilizar _obj_fragata já declarado acima
    // Verificar se obj_fragata existe antes de adicionar
    if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object) {
        array_push(_tipos_inimigos_naval, _obj_fragata);
    }
    
    for (var i = 0; i < array_length(_tipos_inimigos_naval); i++) {
        if (object_exists(_tipos_inimigos_naval[i])) {
            with (_tipos_inimigos_naval[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                    var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                    if (_dist <= _ia.raio_expansao * 2.0) { // Alcance naval ainda maior
                        _inimigos_navais++;
                        _total_inimigos++;
                    }
                }
            }
        }
    }
    
    // Inimigos aéreos
    var _tipos_inimigos_aereo = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_f15, obj_c100];
    for (var i = 0; i < array_length(_tipos_inimigos_aereo); i++) {
        if (object_exists(_tipos_inimigos_aereo[i])) {
            with (_tipos_inimigos_aereo[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                    var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                    if (_dist <= _ia.raio_expansao * 1.8) {
                        _inimigos_aereos++;
                        _total_inimigos++;
                    }
                }
            }
        }
    }
    
    // ==========================================
    // AVALIAÇÃO DE RECURSOS
    // ==========================================
    
    var _dinheiro_suficiente = global.ia_dinheiro >= 600; // REDUZIDO de 800
    var _minerio_suficiente = global.ia_minerio >= 300; // REDUZIDO de 400
    var _recursos_criticos = global.ia_dinheiro < 200 || global.ia_minerio < 150; // Mais leniente
    
    // ==========================================
    // ✅ PRIORIDADE MÁXIMA: DEFENDER quando atacada
    // ==========================================
    
    var _dados_ataque = scr_ia_detectar_ataque(_ia);
    
    if (_dados_ataque.sendo_atacada) {
        scr_ia_defender(_ia, _dados_ataque);
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("🛡️ IA EM GUERRA! Tipo: " + _dados_ataque.tipo_guerra + " | Contra-atacando...");
        }
        return "defender";
    }
    
    // ==========================================
    // ✅ NOVO: DETECTAR AMEAÇA DO JOGADOR (10+ unidades)
    // ==========================================
    
    // ✅ CORREÇÃO: Calcular ameaça diretamente (sem depender de função externa)
    // Contar unidades do jogador manualmente para evitar erros de função não encontrada
    var _total_unidades_jogador = 0;
    
    // Contar unidades terrestres
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) _total_unidades_jogador++;
    }
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) _total_unidades_jogador++;
    }
    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) _total_unidades_jogador++;
    }
    with (obj_blindado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) _total_unidades_jogador++;
    }
    
    // Contar unidades navais
    var _tipos_navais = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_Constellation, obj_Independence, obj_RonaldReagan];
    var _obj_fragata_check = asset_get_index("obj_fragata");
    if (_obj_fragata_check != -1 && asset_get_type(_obj_fragata_check) == asset_object) {
        array_push(_tipos_navais, _obj_fragata_check);
    }
    for (var i = 0; i < array_length(_tipos_navais); i++) {
        if (!object_exists(_tipos_navais[i])) continue;
        with (_tipos_navais[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) _total_unidades_jogador++;
        }
    }
    
    // Contar unidades aéreas
    var _tipos_aereos = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_f15, obj_c100];
    for (var i = 0; i < array_length(_tipos_aereos); i++) {
        if (!object_exists(_tipos_aereos[i])) continue;
        with (_tipos_aereos[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) _total_unidades_jogador++;
        }
    }
    
    // Criar struct de avaliação baseado na contagem
    var _avaliacao_ameaca = {
        nivel_ameaca: "baixo",
        total_unidades_jogador: _total_unidades_jogador,
        unidades_terrestres: 0,
        unidades_navais: 0,
        unidades_aereas: 0,
        precisa_preparar: false,
        alerta_critico: false
    };
    
    // Avaliar nível de ameaça
    if (_total_unidades_jogador >= 20) {
        _avaliacao_ameaca.nivel_ameaca = "critico";
        _avaliacao_ameaca.precisa_preparar = true;
        _avaliacao_ameaca.alerta_critico = true;
    } else if (_total_unidades_jogador >= 15) {
        _avaliacao_ameaca.nivel_ameaca = "alto";
        _avaliacao_ameaca.precisa_preparar = true;
        _avaliacao_ameaca.alerta_critico = true;
    } else if (_total_unidades_jogador >= 10) {
        _avaliacao_ameaca.nivel_ameaca = "medio_alto";
        _avaliacao_ameaca.precisa_preparar = true;
    } else if (_total_unidades_jogador >= 5) {
        _avaliacao_ameaca.nivel_ameaca = "medio";
        _avaliacao_ameaca.precisa_preparar = false;
    }
    
    // Se jogador tem 10+ unidades, IA deve se preparar!
    if (_avaliacao_ameaca.precisa_preparar) {
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("⚠️ ALERTA! Jogador tem " + string(_avaliacao_ameaca.total_unidades_jogador) + " unidades! Nível: " + _avaliacao_ameaca.nivel_ameaca);
        }
        
        // Prioridade máxima: construir estruturas militares e recrutar
        if (_num_quartel < 2 && _dinheiro_suficiente && _minerio_suficiente) {
            // Precisa de mais quartéis para produzir unidades
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("🏗️ URGENTE: Construindo quartel para defesa!");
            }
            return "construir_militar";
        }
        
        // Prioridade alta: recrutar unidades (mesmo se já tiver algumas)
        if (_num_quartel >= 1 && _total_unidades < (_avaliacao_ameaca.total_unidades_jogador * 0.8)) {
            // Tentar ter pelo menos 80% das unidades do jogador
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("⚔️ URGENTE: Recrutando unidades defensivas! (" + string(_total_unidades) + "/" + string(_avaliacao_ameaca.total_unidades_jogador) + ")");
            }
            return "recrutar_unidades";
        }
        
        // Se nível crítico (15+ unidades), construir naval e aéreo também
        if (_avaliacao_ameaca.alerta_critico) {
            if (_avaliacao_ameaca.unidades_navais > _unidades_navais && _num_quartel_marinha < 1 && _dinheiro_suficiente && _minerio_suficiente) {
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🌊 ALERTA CRÍTICO: Construindo defesa naval!");
                }
                return "construir_naval";
            }
            
            if (_avaliacao_ameaca.unidades_aereas > _unidades_aereas && _num_aeroporto < 1 && _dinheiro_suficiente && _minerio_suficiente) {
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("✈️ ALERTA CRÍTICO: Construindo defesa aérea!");
                }
                return "construir_aereo";
            }
        }
    }
    
    // ==========================================
    // ✅ NOVA LÓGICA: PRIORIZAR ATAQUE
    // ==========================================
    
    var _decisao = "expandir";
    var _prioridade = 0;
    
    // ✅ PRIORIDADE 1: ATAQUE ULTRA AGRESSIVO - Atacar com só 2 unidades!
    if (_total_inimigos > 0 && _total_unidades >= 2) { // REDUZIDO de 3 para 2 - ATAQUE MAIS RÁPIDO
        _decisao = "atacar";
        _prioridade = 10;
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("⚔️ PRIORIDADE ATAQUE: " + string(_total_inimigos) + " inimigos detectados, " + string(_total_unidades) + " unidades prontas!");
        }
    }
    // ✅ PRIORIDADE 2: ATAQUE PREVENTIVO - Procurar inimigos mais longe
    else if (_total_unidades >= 3 && _total_inimigos == 0) { // REDUZIDO de 8 para 3
        // Expandir raio de busca e atacar se encontrar
        var _raio_estendido = _ia.raio_expansao * 2.5; // AUMENTADO de 2.0 para 2.5
        var _inimigo_distante = noone;
        var _menor_dist = 999999;
        
        // Procurar inimigo mais distante
        var _tipos_busca = [obj_infantaria, obj_tanque, obj_lancha_patrulha, obj_navio_base, obj_helicoptero_militar];
        for (var i = 0; i < array_length(_tipos_busca); i++) {
            if (object_exists(_tipos_busca[i])) {
                with (_tipos_busca[i]) {
                    if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                        var _dist = point_distance(x, y, _ia.base_x, _ia.base_y);
                        if (_dist <= _raio_estendido && _dist < _menor_dist) {
                            _menor_dist = _dist;
                            _inimigo_distante = id;
                        }
                    }
                }
            }
        }
        
        if (instance_exists(_inimigo_distante)) {
            _decisao = "atacar";
            _prioridade = 9;
        } else {
            // Não encontrou, recrutar mais unidades
            _decisao = "recrutar_unidades";
            _prioridade = 8;
        }
    }
    // ✅ PRIORIDADE 3: CRÍTICO - Sem recursos básicos (só se realmente crítico)
    else if (_recursos_criticos && _num_fazendas < 1) { // REDUZIDO de 2 para 1
        _decisao = "construir_economia";
        _prioridade = 7;
    }
    // ✅ PRIORIDADE 4: MILITAR PRIMEIRO - Construir quartel ANTES de economia
    else if (_num_quartel < 1 && _dinheiro_suficiente && _minerio_suficiente) {
        _decisao = "construir_militar";
        _prioridade = 6;
    }
    // ✅ PRIORIDADE 5: RECRUTAR AGRESSIVO - Produzir mais unidades
    else if (_total_unidades < 8 && _num_quartel >= 1) { // REDUZIDO de 10 para 8
        _decisao = "recrutar_unidades";
        _prioridade = 5;
    }
    // ✅ PRIORIDADE 6: INFRAESTRUTURA NAVAL - Mais cedo
    else if (_num_quartel_marinha < 1 && _unidades_terrestres >= 4 && _dinheiro_suficiente && _minerio_suficiente) { // REDUZIDO de 8 para 4
        _decisao = "construir_naval";
        _prioridade = 4;
    }
    // ✅ PRIORIDADE 7: INFRAESTRUTURA AÉREA - Mais cedo
    else if (_num_aeroporto < 1 && _total_unidades >= 6 && _dinheiro_suficiente && _minerio_suficiente) { // REDUZIDO de 12 para 6
        _decisao = "construir_aereo";
        _prioridade = 3;
    }
    // ✅ PRIORIDADE 8: EXPANDIR ECONOMIA - Só se recursos muito baixos
    else if (global.ia_dinheiro < 400 && _num_fazendas < 2) { // REDUZIDO de 500 e 3
        _decisao = "expandir_economia";
        _prioridade = 2;
    }
    // ✅ PRIORIDADE 9: RECRUTAR CONTINUAMENTE - Sempre manter força militar
    else if (_total_unidades < 15 && _num_quartel >= 1) {
        _decisao = "recrutar_unidades";
        _prioridade = 1;
    }
    // ✅ PRIORIDADE 10: PADRÃO - Se não há o que fazer, procurar inimigos
    else {
        _decisao = "atacar"; // Mudado de "expandir" para "atacar"
        _prioridade = 0;
    }
    
    // ==========================================
    // DEBUG E LOG
    // ==========================================
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🤖 IA DECISÃO [" + string(_prioridade) + "]: " + _decisao);
        show_debug_message("  📊 Fazendas: " + string(_num_fazendas) + " | Minas: " + string(_num_minas));
        show_debug_message("  🎖️ Quartéis: " + string(_num_quartel) + " | Naval: " + string(_num_quartel_marinha) + " | Aéreo: " + string(_num_aeroporto));
        show_debug_message("  ⚔️ Unidades: " + string(_total_unidades) + " (Terra: " + string(_unidades_terrestres) + ", Naval: " + string(_unidades_navais) + ", Aéreo: " + string(_unidades_aereas) + ")");
        show_debug_message("  👹 Inimigos: " + string(_total_inimigos) + " (Terra: " + string(_inimigos_terrestres) + ", Naval: " + string(_inimigos_navais) + ", Aéreo: " + string(_inimigos_aereos) + ")");
        show_debug_message("  💰 Recursos: $" + string(global.ia_dinheiro) + " | Minério: " + string(global.ia_minerio));
    }
    
    return _decisao;
}
