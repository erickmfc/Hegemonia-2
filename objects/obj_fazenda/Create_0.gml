/// @description Inicialização da Fazenda - Sistema Simplificado
// =============================================
// HEGEMONIA GLOBAL - FAZENDA SIMPLIFICADA
// Sistema de Economia de Larga Escala
// =============================================

// === CUSTO E PRODUÇÃO ===
custo_fazenda = 2500000; // $2.500.000 CG por fazenda
producao_base = 50; // 50 unidades de Alimento por ciclo (mês)
producao_final = 0; // Produção final

// === CICLO DE PRODUÇÃO ===
// Ciclo de 1 mês (30 dias × 60 segundos = 1800 segundos = 30 minutos)
// ✅ CORREÇÃO GM1024: Usar game_get_speed em vez de room_speed
alarm[0] = game_get_speed(gamespeed_fps) * 1800; // 30 minutos

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Fazendas só em terreno de campo

// ✅ NOVO: Triplicar produção se for da IA
if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
    // ✅ IA produz 3x mais
    producao_base = producao_base * 3;
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🌾 Fazenda da IA - Produção triplicada: " + string(producao_base));
    }
}

// === DEBUG ===
show_debug_message("🌾 Fazenda criada - Custo: $" + string(custo_fazenda) + " CG");
show_debug_message("🌾 Produção base: " + string(producao_base) + " Alimento/ciclo");
show_debug_message("🌾 Próximo ciclo em: " + string(alarm[0] / game_get_speed(gamespeed_fps)) + " segundos");