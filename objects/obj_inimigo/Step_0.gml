// ================================================
// HEGEMONIA GLOBAL - OBJETO: INIMIGO
// Step Event - Sistema Simples e Funcional
// ================================================

// === MOVIMENTO BÁSICO ===
// Inimigo fica parado esperando ser atacado
// (Movimento removido para teste)

// === VERIFICAÇÃO DE DESTRUIÇÃO ===
// Se morrer → destrói
if (vida <= 0) {
    // =============================================
    // DESTROY - Invalidar cache quando inimigo é destruído
    // =============================================
    // Invalidar cache relacionado a este inimigo
    scr_invalidate_enemy_cache(id);
    
    instance_destroy();
}
