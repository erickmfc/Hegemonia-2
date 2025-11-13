// ===============================================
// HEGEMONIA GLOBAL - ENUMS PLANOS ESTRATÉGICOS
// Sistema de planos para IA do Presidente
// ===============================================

// === ENUMS DE PLANOS ===
enum PlanoEstrategico {
    NENHUM,          // Sem plano ativo
    DEFESA,          // Plano de defesa (guerra)
    ECONOMIA,        // Plano de economia
    TREINAMENTO      // Plano de treinamento/desenvolvimento
}

// === ENUMS DE ESTADO DE GUERRA ===
enum EstadoGuerra {
    PAZ,             // Sem guerra
    ALERTA,          // Ameaça detectada
    GUERRA_ATIVA,    // Em combate ativo
    GUERRA_TOTAL     // Guerra em múltiplas frentes
}

// === ENUMS DE FASE DO PLANO DE DEFESA ===
enum FasePlanoDefesa {
    DETECCAO,        // Detectar ameaças
    PREPARACAO,      // Preparar defesas
    DEFESA_ATIVA,    // Defender posições
    CONTRA_ATAQUE,   // Contra-atacar
    CONSOLIDACAO     // Consolidar vitória
}

show_debug_message("📋 Enums de planos estratégicos inicializados!");
