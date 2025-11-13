/// @description Decide qual unidade criar baseado na análise estratégica do exército do jogador
/// @param _ia_id ID da instância da IA
/// @return Estrutura com decisão estratégica (tipo_unidade, quantidade, precisa_resposta)

function scr_ia_decisao_unidade_estrategica(_ia_id) {
    var _ia = _ia_id;
    
    // ==========================================
    // ANALISAR EXÉRCITO DO JOGADOR
    // ==========================================
    var _analise = scr_ia_analisar_exercito_jogador();
    
    // Se não precisa resposta, retornar decisão vazia
    if (!_analise.precisa_resposta) {
        return {
            tipo_unidade: "nenhuma",
            quantidade: 0,
            precisa_resposta: false,
            razao: "Jogador não tem força significativa"
        };
    }
    
    // ==========================================
    // APLICAR MATRIZ DE CONTRAPARTIDA ESTRATÉGICA
    // ==========================================
    var _tipo_unidade = "nenhuma";
    var _quantidade = 0;
    var _razao = "";
    
    // ✅ NOVO: PRIORIDADE MÁXIMA - Jogador tem Aviões
    // Aviões são extremamente perigosos, criar artilharia anti-aérea IMEDIATAMENTE
    if (_analise.total_aereas > 0) {
        // Se tem 1-2 aviões: criar Blindado Anti-Aéreo (mais eficaz)
        if (_analise.total_aereas <= 2) {
            _tipo_unidade = "blindado_antiaereo";
            _quantidade = max(3, ceil(_analise.total_aereas * 2)); // 2x a quantidade de aviões, mínimo 3
            _razao = "🚨 RESPOSTA ANTI-AÉREA URGENTE: Blindados AA contra aviões (" + string(_analise.total_aereas) + " aviões detectados)";
        }
        // Se tem 3+ aviões: criar mix de Blindado AA + Soldado AA
        else {
            _tipo_unidade = "blindado_antiaereo";
            _quantidade = max(4, ceil(_analise.total_aereas * 1.5)); // 1.5x a quantidade, mínimo 4
            _razao = "🚨 RESPOSTA ANTI-AÉREA MASSIVA: Blindados AA contra frota aérea (" + string(_analise.total_aereas) + " aviões detectados)";
        }
    }
    // Caso 1: Jogador tem Infantaria (1-5) → IA cria Tanque
    else if (_analise.maior_ameaca == "infantaria" && _analise.infantaria >= 1 && _analise.infantaria <= 5) {
        _tipo_unidade = "tanque";
        _quantidade = max(2, ceil(_analise.infantaria * 0.6)); // 60% da quantidade do jogador, mínimo 2
        _razao = "Superioridade blindada contra infantaria";
    }
    // Caso 2: Jogador tem Infantaria (6+) → IA cria Blindado Anti-Aéreo
    else if (_analise.maior_ameaca == "infantaria" && _analise.infantaria >= 6) {
        _tipo_unidade = "blindado_antiaereo";
        _quantidade = max(2, ceil(_analise.infantaria * 0.4)); // 40% da quantidade, mínimo 2
        _razao = "Controle de área contra infantaria numerosa";
    }
    // Caso 3: Jogador tem Tanque (1-3) → IA cria Soldado Anti-Aéreo
    else if (_analise.maior_ameaca == "tanque" && _analise.tanque >= 1 && _analise.tanque <= 3) {
        _tipo_unidade = "soldado_antiaereo";
        _quantidade = max(3, ceil(_analise.tanque * 1.5)); // 150% da quantidade, mínimo 3
        _razao = "Contador especializado contra tanques";
    }
    // Caso 4: Jogador tem Tanque (4+) → IA cria Blindado Anti-Aéreo
    else if (_analise.maior_ameaca == "tanque" && _analise.tanque >= 4) {
        _tipo_unidade = "blindado_antiaereo";
        _quantidade = max(2, ceil(_analise.tanque * 0.8)); // 80% da quantidade, mínimo 2
        _razao = "Superioridade múltipla contra tanques numerosos";
    }
    // Caso 5: Jogador tem Soldado Anti-Aéreo → IA cria Tanque
    else if (_analise.maior_ameaca == "soldado_antiaereo" && _analise.soldado_antiaereo > 0) {
        _tipo_unidade = "tanque";
        _quantidade = max(2, ceil(_analise.soldado_antiaereo * 0.7)); // 70% da quantidade, mínimo 2
        _razao = "Força bruta terrestre contra soldados AA";
    }
    // Caso 6: Jogador tem Blindado Anti-Aéreo → IA cria Tanque + Soldado AA
    else if (_analise.maior_ameaca == "blindado_antiaereo" && _analise.blindado_antiaereo > 0) {
        // Criar combinação tática - priorizar tanques
        _tipo_unidade = "tanque";
        _quantidade = max(2, ceil(_analise.blindado_antiaereo * 1.2)); // 120% da quantidade, mínimo 2
        _razao = "Combinação tática: Tanques + Soldados AA contra blindados";
    }
    // Caso 7: Jogador tem mix (vários tipos) → IA cria Blindado Anti-Aéreo
    else if (_analise.total_terrestres > 0) {
        // Verificar se há mix (mais de um tipo com quantidade significativa)
        var _tipos_diferentes = 0;
        if (_analise.infantaria > 0) _tipos_diferentes++;
        if (_analise.tanque > 0) _tipos_diferentes++;
        if (_analise.soldado_antiaereo > 0) _tipos_diferentes++;
        if (_analise.blindado_antiaereo > 0) _tipos_diferentes++;
        
        if (_tipos_diferentes >= 2) {
            _tipo_unidade = "blindado_antiaereo";
            _quantidade = max(2, ceil(_analise.total_terrestres * 0.5)); // 50% do total, mínimo 2
            _razao = "Versatilidade contra composição mista";
        } else {
            // Se não é mix, usar a maior ameaça
            if (_analise.infantaria > 0) {
                _tipo_unidade = "tanque";
                _quantidade = max(2, ceil(_analise.infantaria * 0.6));
                _razao = "Resposta padrão contra infantaria";
            } else if (_analise.tanque > 0) {
                _tipo_unidade = "soldado_antiaereo";
                _quantidade = max(3, ceil(_analise.tanque * 1.5));
                _razao = "Resposta padrão contra tanques";
            }
        }
    }
    
    // ==========================================
    // VALIDAR RECURSOS DISPONÍVEIS
    // ==========================================
    // Verificar se a IA tem recursos suficientes
    var _custo_dinheiro = 0;
    var _custo_minerio = 0;
    var _custo_populacao = 0;
    
    if (_tipo_unidade == "infantaria") {
        _custo_dinheiro = 100;
        _custo_populacao = 1;
    } else if (_tipo_unidade == "tanque") {
        _custo_dinheiro = 500;
        _custo_minerio = 250;
        _custo_populacao = 3;
    } else if (_tipo_unidade == "soldado_antiaereo") {
        _custo_dinheiro = 150;
        _custo_minerio = 50;
        _custo_populacao = 1;
    } else if (_tipo_unidade == "blindado_antiaereo") {
        _custo_dinheiro = 600;
        _custo_minerio = 300;
        _custo_populacao = 2;
    }
    
    var _custo_total_d = _custo_dinheiro * _quantidade;
    var _custo_total_m = _custo_minerio * _quantidade;
    var _custo_total_p = _custo_populacao * _quantidade;
    
    // Verificar recursos globais da IA
    var _dinheiro_ia = global.ia_dinheiro;
    var _minerio_ia = global.ia_minerio;
    var _populacao_ia = global.ia_populacao;
    
    // Ajustar quantidade se não tiver recursos suficientes
    if (_custo_total_d > _dinheiro_ia && _dinheiro_ia > 0) {
        _quantidade = min(_quantidade, floor(_dinheiro_ia / _custo_dinheiro));
    }
    if (_custo_total_m > _minerio_ia && _minerio_ia > 0) {
        _quantidade = min(_quantidade, floor(_minerio_ia / _custo_minerio));
    }
    if (_custo_total_p > _populacao_ia && _populacao_ia > 0) {
        _quantidade = min(_quantidade, floor(_populacao_ia / _custo_populacao));
    }
    
    // Se não tem recursos, não criar
    if (_quantidade <= 0) {
        return {
            tipo_unidade: "nenhuma",
            quantidade: 0,
            precisa_resposta: false,
            razao: "Recursos insuficientes"
        };
    }
    
    // ==========================================
    // RETORNAR DECISÃO ESTRATÉGICA
    // ==========================================
    return {
        tipo_unidade: _tipo_unidade,
        quantidade: _quantidade,
        precisa_resposta: true,
        razao: _razao,
        analise_jogador: _analise
    };
}
