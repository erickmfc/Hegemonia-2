// ===============================================
// HEGEMONIA GLOBAL - MENU AÉREO MODERNO
// Sistema de Animações e Controles - STEP EVENT
// ===============================================

// Incrementar contador de frames
menu_aberto_frames++;

// Incrementar timer de animação
animation_timer++;

// Atualizar animações dos cards
for (var i = 0; i < array_length(card_animations); i++) {
    // Animações já são atualizadas no Draw Event via lerp
}

// === TECLA ESC PARA FECHAR ===
if (keyboard_check_pressed(vk_escape)) {
    show_debug_message("🔴 ESC pressionado - Fechando menu aéreo");
    if (instance_exists(id_do_aeroporto)) {
        id_do_aeroporto.menu_recrutamento = noone;
    }
    instance_destroy();
}

// === VERIFICAR SE AEROPORTO AINDA EXISTE ===
if (id_do_aeroporto == noone || !instance_exists(id_do_aeroporto)) {
    show_debug_message("⚠️ Aeroporto não existe mais - Destruindo menu");
    instance_destroy();
}
