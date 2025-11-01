// =============================================
// SISTEMA DE LIMPEZA AUTOMÁTICA DO POOL
// Remove objetos inativos antigos do pool
// =============================================

if (!pool_enabled) exit;

// Limpeza automática periódica
auto_cleanup_timer--;
if (auto_cleanup_timer <= 0) {
    auto_cleanup_timer = auto_cleanup_interval;
    
    // Limpar pools de objetos inativos há muito tempo
    scr_cleanup_projectile_pools();
}
