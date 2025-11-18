// ===============================================
// HEGEMONIA GLOBAL - CLASSIFICAÇÃO DE PODER DE UNIDADES
// Sistema de Tier para Priorização de Recrutamento
// ===============================================

// === ENUM PARA CLASSIFICAÇÃO DE UNIDADES ===
enum TierUnidade {
    S_RONALD_REAGAN,      // Porta-aviões (poder naval supremo)
    S_INDEPENDENCE,       // Cruzador pesado (destruidor de armadas)
    S_CONSTELLATION,      // Fragata avançada (versátil)
    S_F15,                // Caça de elite (superioridade aérea)
    S_BLINDADO_ANTIAEREO, // Defesa aérea pesada (2 armas)
    
    A_F6,                 // Caça (interceptor)
    A_HELICOPTERO,        // Helicóptero (ataque)
    A_TANQUE,             // Blindado (força terrestre)
    A_SUBMARINO,          // Submarino (ataque naval furtivo)
    
    B_SOLDADO_ANTIAEREO,  // Defesa básica
    B_LANCHA_PATRULHA,    // Patrulha naval
    B_CACA_F5,            // Caça básico
    
    C_INFANTARIA          // Última opção
}

/// @function classificar_poder_unidade(_obj_tipo)
/// @description Classifica uma unidade por seu tipo em um tier de poder
/// @param {object} _obj_tipo - Tipo de objeto da unidade
/// @returns {enum} Tier de poder da unidade

function classificar_poder_unidade(_obj_tipo) {
    if (_obj_tipo == obj_RonaldReagan)         return TierUnidade.S_RONALD_REAGAN;
    if (_obj_tipo == obj_Independence)         return TierUnidade.S_INDEPENDENCE;
    if (_obj_tipo == obj_Constellation)        return TierUnidade.S_CONSTELLATION;
    if (_obj_tipo == obj_f15)                  return TierUnidade.S_F15;
    if (_obj_tipo == obj_blindado_antiaereo)   return TierUnidade.S_BLINDADO_ANTIAEREO;
    
    if (_obj_tipo == obj_f6)                   return TierUnidade.A_F6;
    if (_obj_tipo == obj_helicoptero_militar)  return TierUnidade.A_HELICOPTERO;
    if (_obj_tipo == obj_tanque)               return TierUnidade.A_TANQUE;
    if (_obj_tipo == obj_submarino_base)       return TierUnidade.A_SUBMARINO;
    
    if (_obj_tipo == obj_soldado_antiaereo)    return TierUnidade.B_SOLDADO_ANTIAEREO;
    if (_obj_tipo == obj_lancha_patrulha)      return TierUnidade.B_LANCHA_PATRULHA;
    if (_obj_tipo == obj_caca_f5)              return TierUnidade.B_CACA_F5;
    
    if (_obj_tipo == obj_infantaria)           return TierUnidade.C_INFANTARIA;
    
    return TierUnidade.C_INFANTARIA;
}

/// @function obter_valor_poder(_tier)
/// @description Retorna o valor de poder de um tier
/// @param {enum} _tier - Tier da unidade
/// @returns {real} Valor de poder (0-1000)

function obter_valor_poder(_tier) {
    switch(_tier) {
        case TierUnidade.S_RONALD_REAGAN:      return 1000;
        case TierUnidade.S_INDEPENDENCE:       return 900;
        case TierUnidade.S_CONSTELLATION:      return 850;
        case TierUnidade.S_F15:                return 800;
        case TierUnidade.S_BLINDADO_ANTIAEREO: return 750;
        case TierUnidade.A_F6:                 return 600;
        case TierUnidade.A_HELICOPTERO:        return 550;
        case TierUnidade.A_TANQUE:             return 500;
        case TierUnidade.A_SUBMARINO:          return 450;
        case TierUnidade.B_SOLDADO_ANTIAEREO:  return 250;
        case TierUnidade.B_LANCHA_PATRULHA:    return 200;
        case TierUnidade.B_CACA_F5:            return 150;
        case TierUnidade.C_INFANTARIA:         return 50;
        default:                               return 0;
    }
}

/// @function obter_nome_tier(_tier)
/// @description Retorna nome legível do tier
/// @param {enum} _tier - Tier da unidade
/// @returns {string} Nome do tier

function obter_nome_tier(_tier) {
    switch(_tier) {
        case TierUnidade.S_RONALD_REAGAN:      return "S - Porta-Aviões";
        case TierUnidade.S_INDEPENDENCE:       return "S - Cruzador";
        case TierUnidade.S_CONSTELLATION:      return "S - Fragata";
        case TierUnidade.S_F15:                return "S - F-15";
        case TierUnidade.S_BLINDADO_ANTIAEREO: return "S - Defesa Aérea";
        case TierUnidade.A_F6:                 return "A - F-6";
        case TierUnidade.A_HELICOPTERO:        return "A - Helicóptero";
        case TierUnidade.A_TANQUE:             return "A - Tanque";
        case TierUnidade.A_SUBMARINO:          return "A - Submarino";
        case TierUnidade.B_SOLDADO_ANTIAEREO:  return "B - Soldado AA";
        case TierUnidade.B_LANCHA_PATRULHA:    return "B - Lancha";
        case TierUnidade.B_CACA_F5:            return "B - F-5";
        case TierUnidade.C_INFANTARIA:         return "C - Infantaria";
        default:                               return "Desconhecido";
    }
}

/// @function eh_tier_elite(_tier)
/// @description Verifica se um tier é elite (S ou A)
/// @param {enum} _tier - Tier da unidade
/// @returns {bool} True se é elite

function eh_tier_elite(_tier) {
    return (_tier >= TierUnidade.S_RONALD_REAGAN && _tier <= TierUnidade.S_BLINDADO_ANTIAEREO) ||
           (_tier >= TierUnidade.A_F6 && _tier <= TierUnidade.A_SUBMARINO);
}

/// @function debug_listar_unidades_por_tier()
/// @description Exibe debug list de todas as unidades por tier

function debug_listar_unidades_por_tier() {
    show_debug_message("=== CLASSIFICAÇÃO DE PODER DE UNIDADES ===");
    show_debug_message("TIER S (Elite - Prioridade Máxima):");
    show_debug_message("  • obj_RonaldReagan (1000) - Porta-Aviões");
    show_debug_message("  • obj_Independence (900) - Cruzador");
    show_debug_message("  • obj_Constellation (850) - Fragata");
    show_debug_message("  • obj_f15 (800) - Caça Elite");
    show_debug_message("  • obj_blindado_antiaereo (750) - Defesa Aérea");
    show_debug_message("TIER A (Avançado - Alta Prioridade):");
    show_debug_message("  • obj_f6 (600) - Caça");
    show_debug_message("  • obj_helicoptero_militar (550) - Helicóptero");
    show_debug_message("  • obj_tanque (500) - Tanque");
    show_debug_message("  • obj_submarino_base (450) - Submarino");
    show_debug_message("TIER B (Intermediário - Média Prioridade):");
    show_debug_message("  • obj_soldado_antiaereo (250) - Soldado AA");
    show_debug_message("  • obj_lancha_patrulha (200) - Lancha");
    show_debug_message("  • obj_caca_f5 (150) - F-5");
    show_debug_message("TIER C (Básico - Baixa Prioridade):");
    show_debug_message("  • obj_infantaria (50) - Infantaria");
}

