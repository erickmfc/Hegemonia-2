// ===============================================
// HEGEMONIA GLOBAL - ESTRATÉGIA ADAPTATIVA
// Sistema de estratégias que se adaptam ao comportamento do jogador
// ===============================================

/// @function scr_ia_estrategia_adaptativa(_presidente_id)
/// @description Determina estratégia adaptativa baseada no estado do jogo
/// @param {id} _presidente_id - ID do presidente
/// @returns {string} Estratégia recomendada

function scr_ia_estrategia_adaptativa(_presidente_id) {
    if (!instance_exists(_presidente_id)) return "defensiva";
    
    // === ANÁLISE DO JOGADOR ===
    var _script_inteligencia = asset_get_index("scr_ia_inteligencia_jogador");
    var _analise_jogador = {};
    if (_script_inteligencia != -1) {
        _analise_jogador = scr_ia_inteligencia_jogador();
    }
    
    // === ANÁLISE DO EXÉRCITO DO JOGADOR ===
    var _exercito_jogador = scr_ia_analisar_exercito_jogador();
    
    // === ANÁLISE DO EXÉRCITO DA IA ===
    var _script_contar = asset_get_index("scr_ia_selecionar_melhor_unidade");
    var _exercito_ia = {};
    if (_script_contar != -1) {
        _exercito_ia = scr_ia_contar_unidades_ia();
    }
    
    // === DETERMINAR ESTRATÉGIA ===
    
    // Se jogador tem muitos aviões → estratégia antiaérea
    if (_exercito_jogador.total_aereas > _exercito_jogador.total_terrestres * 0.5) {
        return "antiaerea";
    }
    
    // Se jogador tem muitos navios → estratégia antinaval
    if (_exercito_jogador.total_navais > 3) {
        return "antinaval";
    }
    
    // Se jogador tem muitos tanques → estratégia aérea
    if (_exercito_jogador.total_terrestres > _exercito_jogador.total_aereas * 2) {
        return "aerea";
    }
    
    // Se IA está em desvantagem → estratégia defensiva
    if (_exercito_ia.total < _exercito_jogador.total_geral * 0.5) {
        return "defensiva";
    }
    
    // Se IA está em vantagem → estratégia ofensiva
    if (_exercito_ia.total > _exercito_jogador.total_geral * 1.5) {
        return "ofensiva";
    }
    
    // Padrão: estratégia balanceada
    return "balanceada";
}

/// @function scr_ia_aplicar_estrategia(_presidente_id, _estrategia)
/// @description Aplica uma estratégia específica
/// @param {id} _presidente_id - ID do presidente
/// @param {string} _estrategia - Nome da estratégia

function scr_ia_aplicar_estrategia(_presidente_id, _estrategia) {
    if (!instance_exists(_presidente_id)) return;
    
    switch(_estrategia) {
        case "antiaerea":
            // Priorizar defesa antiaérea
            // (lógica será implementada no sistema de recrutamento)
            break;
        case "antinaval":
            // Priorizar submarinos e aviões
            break;
        case "aerea":
            // Priorizar aviões
            break;
        case "defensiva":
            // Priorizar defesa
            break;
        case "ofensiva":
            // Priorizar ataque
            break;
        default:
            // Balanceada: manter proporção
            break;
    }
}

/// @function scr_ia_avaliar_necessidade_mudanca_estrategia(_presidente_id)
/// @description Avalia se precisa mudar de estratégia
/// @param {id} _presidente_id - ID do presidente
/// @returns {bool} True se precisa mudar estratégia

function scr_ia_avaliar_necessidade_mudanca_estrategia(_presidente_id) {
    if (!instance_exists(_presidente_id)) return false;
    
    // Verificar se estratégia atual ainda é eficaz
    var _estrategia_atual = "balanceada";
    if (variable_instance_exists(_presidente_id, "estrategia_atual")) {
        _estrategia_atual = _presidente_id.estrategia_atual;
    }
    
    var _estrategia_recomendada = scr_ia_estrategia_adaptativa(_presidente_id);
    
    // Se estratégia recomendada é diferente, precisa mudar
    return (_estrategia_atual != _estrategia_recomendada);
}
