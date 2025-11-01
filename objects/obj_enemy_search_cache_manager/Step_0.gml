// =============================================
// SISTEMA DE LIMPEZA AUTOMÁTICA DO CACHE
// Remove entradas expiradas periodicamente
// =============================================

if (!cache_enabled) exit;

// Limpeza periódica
cleanup_timer--;
if (cleanup_timer <= 0) {
    cleanup_timer = cleanup_interval;
    scr_cleanup_expired_cache();
    
    // Se ainda estiver muito grande, limitar tamanho
    if (cache_entries > max_cache_size * 0.9) {
        scr_limit_cache_size();
    }
}
