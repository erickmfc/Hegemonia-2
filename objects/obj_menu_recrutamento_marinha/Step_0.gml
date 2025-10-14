// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO NAVAL
// Sistema Simplificado
// ===============================================

// ✅ DEBUG: Verificar se Step está executando (apenas uma vez)
if (!variable_instance_exists(id, "debug_step_executado")) {
    show_debug_message("🔄 STEP EVENT EXECUTANDO - Menu ID: " + string(id));
    debug_step_executado = true;
}

// Verificar se o quartel ainda existe
if (meu_quartel_id == noone || !instance_exists(meu_quartel_id)) {
    instance_destroy();
    exit;
}

// Fechar menu com Escape
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
}