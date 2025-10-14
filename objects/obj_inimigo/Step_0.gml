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
    instance_destroy();
}
