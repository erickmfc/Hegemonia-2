// =============================================
// SISTEMA DE CACHE DE BUSCA DE INIMIGOS
// Gerencia cache para otimizar buscas repetidas
// =============================================

// === MAPA DE CACHE ===
cache_map = ds_map_create();

// === CONFIGURAÇÕES ===
cache_enabled = true; // Habilitar/desabilitar cache
max_cache_size = 200; // Máximo de entradas no cache
cache_entries = 0; // Contador atual

// === ESTATÍSTICAS ===
cache_hits = 0; // Número de vezes que cache foi útil
cache_misses = 0; // Número de vezes que cache não tinha resultado
cache_invalidated = 0; // Número de entradas invalidadas

// === TIMERS ===
cleanup_timer = 0;
cleanup_interval = 300; // Limpar cache expirado a cada 5 segundos (300 frames a 60fps)

// Debug
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("✅ Sistema de Cache de Busca de Inimigos ativado");
    show_debug_message("📋 Cache máximo: " + string(max_cache_size) + " entradas");
}
