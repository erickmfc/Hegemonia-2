// ===============================================
// HEGEMONIA GLOBAL - ENUMS DEFESA PRESIDENTE
// Enums centralizados para sistema de defesa do presidente
// ===============================================

// === ENUMS DE ESTADO DE ALERTA ===
enum EstadoAlerta {
    NORMAL,        // 10% unidades em defesa
    ALERTA,        // 30% unidades em defesa
    CRITICO,       // 70% unidades em defesa
    EMERGENCIA     // 100% unidades em defesa
}

// === ENUMS DE ZONAS DE AMEAÇA ===
enum ZonaAmeaca {
    CRITICA,       // 0-500px
    ALERTA,        // 500-1500px
    MONITORAMENTO  // 1500-3000px
}

show_debug_message("🛡️ Enums de defesa do presidente inicializados!");

