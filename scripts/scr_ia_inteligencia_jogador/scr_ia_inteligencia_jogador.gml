// ===============================================
// HEGEMONIA GLOBAL - INTELIGÊNCIA DO JOGADOR
// Sistema de análise do comportamento e estratégia do jogador
// ===============================================

/// @function scr_ia_inteligencia_jogador()
/// @description Analisa comportamento e estratégia do jogador
/// @returns {struct} Estrutura com análise do jogador

function scr_ia_inteligencia_jogador() {
    var _analise = {
        estrategia: "desconhecida",
        forca_total: 0,
        pontos_fracos: [],
        pontos_fortes: [],
        tendencia_agressiva: 0,
        tendencia_defensiva: 0,
        recursos_estimados: 0
    };
    
    // === ANÁLISE DO EXÉRCITO ===
    var _exercito = scr_ia_analisar_exercito_jogador();
    _analise.forca_total = _exercito.forca_total;
    
    // === DETERMINAR ESTRATÉGIA ===
    if (_exercito.total_aereas > _exercito.total_terrestres * 0.7) {
        _analise.estrategia = "aerea";
        array_push(_analise.pontos_fortes, "Superioridade aérea");
        array_push(_analise.pontos_fracos, "Vulnerável a defesa antiaérea");
    } else if (_exercito.total_navais > 3) {
        _analise.estrategia = "naval";
        array_push(_analise.pontos_fortes, "Poder naval");
        array_push(_analise.pontos_fracos, "Vulnerável a submarinos e aviões");
    } else if (_exercito.total_terrestres > _exercito.total_aereas * 2) {
        _analise.estrategia = "terrestre";
        array_push(_analise.pontos_fortes, "Força terrestre");
        array_push(_analise.pontos_fracos, "Vulnerável a ataques aéreos");
    } else {
        _analise.estrategia = "balanceada";
        array_push(_analise.pontos_fortes, "Exército balanceado");
    }
    
    // === TENDÊNCIA AGRESSIVA/DEFENSIVA ===
    // Se tem muitas unidades, provavelmente é agressivo
    if (_exercito.total_geral > 10) {
        _analise.tendencia_agressiva = 70;
        _analise.tendencia_defensiva = 30;
    } else if (_exercito.total_geral < 5) {
        _analise.tendencia_agressiva = 30;
        _analise.tendencia_defensiva = 70;
    } else {
        _analise.tendencia_agressiva = 50;
        _analise.tendencia_defensiva = 50;
    }
    
    // === ESTIMAR RECURSOS ===
    // Baseado no tamanho do exército
    _analise.recursos_estimados = _exercito.total_geral * 10000;
    
    return _analise;
}

/// @function scr_ia_prever_acao_jogador(_analise)
/// @description Preve ação provável do jogador baseado na análise
/// @param {struct} _analise - Análise do jogador
/// @returns {string} Ação prevista ("ataque", "defesa", "expansao")

function scr_ia_prever_acao_jogador(_analise) {
    if (_analise.tendencia_agressiva > 60) {
        return "ataque";
    } else if (_analise.tendencia_defensiva > 60) {
        return "defesa";
    } else {
        return "expansao";
    }
}

/// @function scr_ia_recomendar_contra_estrategia(_analise)
/// @description Recomenda contra-estratégia baseada na análise
/// @param {struct} _analise - Análise do jogador
/// @returns {string} Contra-estratégia recomendada

function scr_ia_recomendar_contra_estrategia(_analise) {
    switch(_analise.estrategia) {
        case "aerea":
            return "defesa_antiaerea"; // Construir defesa antiaérea
        case "naval":
            return "submarinos_avioes"; // Submarinos e aviões
        case "terrestre":
            return "avioes_bombardeio"; // Aviões para bombardeio
        default:
            return "balanceado"; // Estratégia balanceada
    }
}
