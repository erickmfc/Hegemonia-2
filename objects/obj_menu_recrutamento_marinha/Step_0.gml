// ===============================================
// HEGEMONIA GLOBAL - MENU NAVAL MODERNO
// Atualização de Animações
// ===============================================

// Verificar se quartel ainda existe
if (meu_quartel_id == noone || !instance_exists(meu_quartel_id)) {
    instance_destroy();
    exit;
}

// Fechar menu com Escape
if (keyboard_check_pressed(vk_escape)) {
    if (instance_exists(meu_quartel_id)) {
        meu_quartel_id.menu_recrutamento = noone;
    }
    instance_destroy();
    exit;
}

// Incrementar timer de animação
animation_timer++;

// Incrementar contador de frames desde abertura do menu
menu_aberto_frames++;