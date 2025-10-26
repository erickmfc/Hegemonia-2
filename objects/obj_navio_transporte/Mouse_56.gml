// =========================================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA MOUSE EVENT
// Detecção direta de clique para debug
// =========================================================

// Debug: Mostrar informações quando clicado
show_debug_message("🖱️ CLIQUE DETECTADO na Lancha Patrulha!");
show_debug_message("📍 Posição da lancha: (" + string(x) + ", " + string(y) + ")");
show_debug_message("🎯 Estado de seleção atual: " + string(selecionado));

// Alternar seleção para teste
selecionado = !selecionado;
show_debug_message("🔄 Seleção alterada para: " + string(selecionado));

// Definir como unidade selecionada globalmente
global.unidade_selecionada = id;
show_debug_message("✅ Lancha Patrulha definida como unidade selecionada global");
