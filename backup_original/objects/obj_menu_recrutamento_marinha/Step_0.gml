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
var _fechar_menu = false;

// 1. Fechar com a tecla ESC
if (keyboard_check_pressed(vk_escape)) {
    _fechar_menu = true;
}

// 2. Fechar com clique fora do menu (se o menu estiver visível)
if (mouse_check_button_pressed(mb_left) && !position_meeting(mouse_x, mouse_y, id)) {
    _fechar_menu = true;
}

if (_fechar_menu) {
    global.menu_recrutamento_aberto = false;
    instance_destroy();
    exit;
}