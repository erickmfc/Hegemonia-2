// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO MARINHA
// Lógica de Atualização (FASE 2)
// ===============================================

// Verificar se o quartel ainda existe
if (!instance_exists(quartel_referencia)) {
    // Se o quartel foi destruído, destruir este menu também
    global.menu_recrutamento_aberto = false;
    instance_destroy();
    exit;
}

// Verificar se deve fechar o menu (ESC ou clique fora)
if (keyboard_check_pressed(vk_escape)) {
    global.menu_recrutamento_aberto = false;
    instance_destroy();
    exit;
}