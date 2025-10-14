// =========================================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA MOUSE EVENT (56)
// Sistema de Seleção da Lancha
// =========================================================

// --- VERIFICAÇÃO DE SEGURANÇA ---
if (!variable_instance_exists(id, "selecionado")) {
    selecionado = false;
}

// --- LÓGICA DE SELEÇÃO ---
if (mouse_check_button_pressed(mb_left)) {
    // Deseleciona todas as outras lanchas primeiro
    with (obj_lancha_patrulha) {
        if (id != other.id) {
            selecionado = false;
        }
    }
    
    // Seleciona esta lancha
    selecionado = true;
    global.unidade_selecionada = id;
    
    show_debug_message("🚢 Lancha Patrulha selecionada - ID: " + string(id));
    show_debug_message("📍 Posição: (" + string(x) + ", " + string(y) + ")");
    show_debug_message("⚔️ Modo: " + (modo_ataque ? "ATAQUE" : "PASSIVO"));
    show_debug_message("🔄 Estado: " + estado);
    
    // Feedback visual de seleção
    if (variable_instance_exists(id, "hp_atual")) {
        show_debug_message("❤️ HP: " + string(hp_atual) + "/" + string(hp_max));
    }
    
    // Informações de patrulha se existir
    if (variable_instance_exists(id, "pontos_patrulha") && ds_list_size(pontos_patrulha) > 0) {
        show_debug_message("🔄 Patrulha: " + string(ds_list_size(pontos_patrulha)) + " pontos definidos");
    }
}
