// ===============================================
// HEGEMONIA GLOBAL - ENUMS NAVAL GLOBAIS
// Enums centralizados para todos os navios
// ===============================================

// === ENUMS DE ESTADO NAVAL ===
enum LanchaState {
    PARADO,
    MOVENDO,
    ATACANDO,
    PATRULHANDO,
    DEFININDO_PATRULHA
}

// === ENUMS DE MODO DE COMBATE ===
enum LanchaMode {
    ATAQUE,
    PASSIVO
}

// === ENUMS DE TIPO DE ALVO ===
enum TipoAlvo {
    NAVAL,
    AEREO,
    TERRESTRE
}

// === ENUMS DE TIPO DE MÍSSIL ===
enum TipoMissil {
    AR,
    TERRA,
    AUTO
}

// === ENUMS DE ESTADO DE TRANSPORTE (NAVIO TRANSPORTE) ===
enum NavioTransporteEstado {
    PARADO,           // Navio parado
    NAVEGANDO,        // Navio se movendo
    PATRULHANDO,      // Navio patrulhando
    EMBARQUE_ATIVO,   // 🚚 Recebendo unidades
    EMBARQUE_OFF,     // ✅ Cheio ou desativado
    DESEMBARCANDO,    // 📦 Liberando unidades
    ATACANDO          // ⚔️ Ataque
}

// === ENUMS DE GERAÇÕES DE CAÇAS ===
enum FighterGeneration {
    GEN_2,      // 2ª Geração (anos 60-70) - F-5, F-6
    GEN_3,      // 3ª Geração (anos 70-80)
    GEN_4,      // 4ª Geração (anos 80-90) - F-15
    GEN_4_PLUS, // 4.5ª Geração (anos 90-2000) - SU-35
    GEN_5       // 5ª Geração (anos 2000+) - F-35 (STEALTH)
}

show_debug_message("🚢 Enums navais globais inicializados!");
show_debug_message("✈️ Enums de gerações de caças inicializados!");