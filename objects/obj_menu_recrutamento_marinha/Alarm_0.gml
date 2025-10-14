// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO NAVAL
// Sistema de Alarmes
// ===============================================

// Sistema de alarmes para o menu naval
// Por enquanto, apenas limpa o menu se necessário
if (meu_quartel_id != noone && !instance_exists(meu_quartel_id)) {
    // Quartel foi destruído, fechar menu
    instance_destroy();
    show_debug_message("Menu de Recrutamento Naval fechado - Quartel destruído");
}