/// @description Exemplo de uso da IA avançada com todas as novas funcionalidades
/// @description Este script demonstra como inicializar e usar a IA revisada

function exemplo_ia_avancada() {
    
    // === EXEMPLO 1: INICIALIZAR IA COM AGRESSIVIDADE ALTA ===
    
    // Suponha que você tenha uma estrutura de IA existente
    var _ia = {
        nome: "IA_Inimiga_Principal",
        base_x: 1000,
        base_y: 1000,
        unidades: {
            infantaria: [obj_soldado_rifle, obj_soldado_rifle, obj_soldado_rocket],
            tanques: [obj_tanque_batalha, obj_tanque_batalha],
            antiaereo: [obj_blindado_antiaereo],
            navios: [obj_destroyer, obj_lancha_patrulha],
            aeronaves: [obj_caca, obj_helicoptero_ataque]
        }
    };
    
    // Inicializar com agressividade alta (70%)
    _ia = scr_ia_inicializar_avancada(_ia, 0.7);
    
    show_debug_message("=== IA INICIALIZADA ===");
    show_debug_message("Nome: " + _ia.nome);
    show_debug_message("Agressividade: " + string(_ia.agressividade * 100) + "%");
    
    // === EXEMPLO 2: EXECUTAR ATAQUE COM NOVA IA ===
    
    show_debug_message("\n=== EXECUTANDO ATAQUE ===");
    
    // Chamar o script de ataque principal (já modificado)
    scr_ia_atacar(_ia);
    
    // === EXEMPLO 3: VERIFICAR RELATÓRIO DE DESEMPENHO ===
    
    var _relatorio = scr_ia_relatorio_completo(_ia);
    
    show_debug_message("\n=== RELATÓRIO DA IA ===");
    show_debug_message("Força Total: " + string(_relatorio.forca_total));
    show_debug_message("Estratégia Ativa: " + _relatorio.estrategia_ativa);
    show_debug_message("Eficiência: " + string(_relatorio.eficiencia_geral * 100) + "%");
    show_debug_message("Alvos Críticos Encontrados: " + string(_relatorio.alvos_criticos));
    show_debug_message("Força Inimiga Estimada: " + string(_relatorio.forca_inimiga));
    
    // === EXEMPLO 4: TESTAR SISTEMA DE RECONHECIMENTO ===
    
    show_debug_message("\n=== TESTE DE RECONHECIMENTO ===");
    
    // Forçar ativação do reconhecimento
    _ia.reconhecimento.ativo = true;
    scr_ia_reconhecimento();
    
    show_debug_message("Reconhecimento ativado!");
    show_debug_message("Pontos explorados: " + string(array_length(_ia.reconhecimento.pontos_explorados)));
    
    // === EXEMPLO 5: ATUALIZAR IA (CHAMAR NO STEP DO JOGO) ===
    
    // Esta função deve ser chamada regularmente (ex: no evento Step)
    scr_ia_atualizar_avancada(_ia);
    
    // === EXEMPLO 6: EXECUTAR TESTE COMPLETO ===
    
    show_debug_message("\n=== TESTE COMPLETO DA IA ===");
    scr_teste_ia_completo(_ia, true);
    
    // === EXEMPLO 7: DIFERENTES NÍVEIS DE AGRESSIVIDADE ===
    
    show_debug_message("\n=== COMPARAÇÃO DE AGRESSIVIDADE ===");
    
    // IA Defensiva (30% agressividade)
    var _ia_defensiva = scr_ia_inicializar_avancada(_ia, 0.3);
    show_debug_message("IA Defensiva - Estratégia: " + _ia_defensiva.estrategias.ativa);
    
    // IA Equilibrada (50% agressividade)
    var _ia_equilibrada = scr_ia_inicializar_avancada(_ia, 0.5);
    show_debug_message("IA Equilibrada - Estratégia: " + _ia_equilibrada.estrategias.ativa);
    
    // IA Agressiva (80% agressividade)
    var _ia_agressiva = scr_ia_inicializar_avancada(_ia, 0.8);
    show_debug_message("IA Agressiva - Estratégia: " + _ia_agressiva.estrategias.ativa);
    
    // === EXEMPLO 8: MONITORAR MUDANÇAS DE ESTRATÉGIA ===
    
    show_debug_message("\n=== MONITORAMENTO DE ESTRATÉGIAS ===");
    
    // Simular mudança de estratégia baseada na força inimiga
    var _analise = scr_ia_analisar_alvos(_ia);
    
    if (_analise.forca_inimiga > _relatorio.forca_total * 2) {
        show_debug_message("⚠️ Inimigo muito forte! Mudando para estratégia defensiva");
        _ia.estrategias.ativa = "defesa_reforcos";
    } else if (_analise.forca_inimiga < _relatorio.forca_total * 0.5) {
        show_debug_message("✅ Inimigo fraco! Mudando para ataque total");
        _ia.estrategias.ativa = "ataque_total";
    } else if (array_length(_analise.alvos_criticos) > 3) {
        show_debug_message("🎯 Muitos alvos críticos! Mudando para foco em estruturas");
        _ia.estrategias.ativa = "foco_estruturas";
    }
    
    show_debug_message("Nova estratégia: " + _ia.estrategias.ativa);
    
    return _ia;
}

/// @description Função auxiliar para criar uma IA rapidamente para testes
function criar_ia_rapida(_nome, _x, _y, _agressividade = 0.7) {
    
    var _ia = {
        nome: _nome,
        base_x: _x,
        base_y: _y,
        unidades: {
            infantaria: [],
            tanques: [],
            antiaereo: [],
            navios: [],
            aeronaves: []
        }
    };
    
    // Adicionar algumas unidades básicas
    repeat(5) {
        array_push(_ia.unidades.infantaria, instance_create_layer(_x + random_range(-100, 100), _y + random_range(-100, 100), "Units", obj_soldado_rifle));
    }
    
    repeat(2) {
        array_push(_ia.unidades.tanques, instance_create_layer(_x + random_range(-150, 150), _y + random_range(-150, 150), "Units", obj_tanque_batalha));
    }
    
    array_push(_ia.unidades.antiaereo, instance_create_layer(_x + random_range(-80, 80), _y + random_range(-80, 80), "Units", obj_blindado_antiaereo));
    
    // Inicializar IA avançada
    _ia = scr_ia_inicializar_avancada(_ia, _agressividade);
    
    return _ia;
}