// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO AÉREO
// Evento Step - Lógica Essencial
// ===============================================

// Medida de segurança: se o aeroporto que abriu o menu for destruído, o menu se fecha.
if (id_do_aeroporto == noone || !instance_exists(id_do_aeroporto)) {
    show_debug_message("❌ Aeroporto destruído - fechando menu aéreo");
    instance_destroy();
    exit;
}

// Verificar se deve fechar o menu automaticamente após produção
if (id_do_aeroporto.produzindo && ds_queue_empty(id_do_aeroporto.fila_producao)) {
    show_debug_message("✅ Produção concluída - menu aéreo pode ser fechado");
    // Não fechar automaticamente - deixar o jogador decidir
}

// Verificar tecla ESC para fechar
if (keyboard_check_pressed(vk_escape)) {
    show_debug_message("❌ Menu aéreo fechado com ESC");
    instance_destroy();
}