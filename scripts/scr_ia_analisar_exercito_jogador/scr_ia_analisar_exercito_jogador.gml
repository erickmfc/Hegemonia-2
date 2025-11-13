/// @description Analisa o exército do jogador e retorna análise estratégica detalhada
/// @return Estrutura com contagem e análise do exército do jogador

function scr_ia_analisar_exercito_jogador() {
    var _nacao_jogador = 1; // Jogador sempre é nação 1
    
    // ==========================================
    // CONTAGEM DE UNIDADES TERRESTRES
    // ==========================================
    var _infantaria = 0;
    var _tanque = 0;
    var _soldado_antiaereo = 0;
    var _blindado_antiaereo = 0;
    
    // Contar Infantaria
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
            _infantaria++;
        }
    }
    
    // Contar Tanques
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
            _tanque++;
        }
    }
    
    // Contar Soldados Anti-Aéreos
    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
            _soldado_antiaereo++;
        }
    }
    
    // Contar Blindados Anti-Aéreos
    with (obj_blindado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
            _blindado_antiaereo++;
        }
    }
    
    // ==========================================
    // CONTAGEM DE UNIDADES NAVAIS E AÉREAS
    // ==========================================
    var _total_navais = 0;
    var _total_aereas = 0;
    
    // Contar unidades navais
    var _tipos_navais = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_navio_transporte];
    for (var i = 0; i < array_length(_tipos_navais); i++) {
        if (object_exists(_tipos_navais[i])) {
            with (_tipos_navais[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                    _total_navais++;
                }
            }
        }
    }
    
    // Contar unidades aéreas
    var _tipos_aereos = [obj_caca_f5, obj_f15, obj_helicoptero_militar, obj_c100];
    var _obj_f6 = asset_get_index("obj_f6");
    if (_obj_f6 != -1 && asset_get_type(_obj_f6) == asset_object) {
        array_push(_tipos_aereos, _obj_f6);
    }
    var _obj_su35 = asset_get_index("obj_su35");
    if (_obj_su35 != -1 && asset_get_type(_obj_su35) == asset_object) {
        array_push(_tipos_aereos, _obj_su35);
    }
    
    for (var i = 0; i < array_length(_tipos_aereos); i++) {
        if (object_exists(_tipos_aereos[i])) {
            with (_tipos_aereos[i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                    _total_aereas++;
                }
            }
        }
    }
    
    // ✅ NOVO: Priorizar ameaça aérea se houver aviões
    // Aviões são muito perigosos e precisam de resposta imediata
    
    // ==========================================
    // CÁLCULO DE FORÇA TOTAL (PONTUAÇÃO PONDERADA)
    // ==========================================
    var _forca_total = 0;
    _forca_total += _infantaria * 1;           // Infantaria = 1 ponto
    _forca_total += _soldado_antiaereo * 2;    // Soldado AA = 2 pontos
    _forca_total += _tanque * 5;               // Tanque = 5 pontos
    _forca_total += _blindado_antiaereo * 8;   // Blindado AA = 8 pontos
    _forca_total += _total_navais * 3;         // Naval = 3 pontos
    _forca_total += _total_aereas * 4;         // Aéreo = 4 pontos
    
    // ==========================================
    // IDENTIFICAR MAIOR AMEAÇA
    // ==========================================
    var _maior_ameaca = "nenhuma";
    var _maior_quantidade = 0;
    
    // ✅ NOVO: PRIORIDADE MÁXIMA PARA AMEAÇA AÉREA
    // Se o jogador tem aviões, essa é a maior ameaça (independente de quantidade)
    if (_total_aereas > 0) {
        _maior_ameaca = "aereo";
        _maior_quantidade = _total_aereas;
        // Forçar resposta mesmo com poucos aviões
        _forca_total += _total_aereas * 10; // Multiplicador alto para aviões
    } else {
        // Se não tem aviões, usar lógica normal
        if (_infantaria > _maior_quantidade) {
            _maior_quantidade = _infantaria;
            _maior_ameaca = "infantaria";
        }
        if (_tanque > _maior_quantidade) {
            _maior_quantidade = _tanque;
            _maior_ameaca = "tanque";
        }
        if (_soldado_antiaereo > _maior_quantidade) {
            _maior_quantidade = _soldado_antiaereo;
            _maior_ameaca = "soldado_antiaereo";
        }
        if (_blindado_antiaereo > _maior_quantidade) {
            _maior_quantidade = _blindado_antiaereo;
            _maior_ameaca = "blindado_antiaereo";
        }
    }
    
    // ==========================================
    // DETERMINAR SE PRECISA RESPOSTA
    // ==========================================
    var _total_terrestres = _infantaria + _tanque + _soldado_antiaereo + _blindado_antiaereo;
    var _total_geral = _total_terrestres + _total_navais + _total_aereas;
    // ✅ CORREÇÃO: Se tem aviões, SEMPRE precisa resposta (mesmo que força seja baixa)
    var _precisa_resposta = (_total_aereas > 0) || (_total_terrestres > 0 && _forca_total > 3);
    
    // ==========================================
    // RETORNAR ESTRUTURA DE ANÁLISE
    // ==========================================
    var _analise = {
        // Unidades terrestres
        infantaria: _infantaria,
        tanque: _tanque,
        soldado_antiaereo: _soldado_antiaereo,
        blindado_antiaereo: _blindado_antiaereo,
        
        // Totais
        total_terrestres: _total_terrestres,
        total_navais: _total_navais,
        total_aereas: _total_aereas,
        total_geral: _total_geral,
        
        // Análise estratégica
        forca_total: _forca_total,
        maior_ameaca: _maior_ameaca,
        maior_quantidade: _maior_quantidade,
        precisa_resposta: _precisa_resposta
    };
    
    return _analise;
}
