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

show_debug_message("🚢 Enums navais globais inicializados!");