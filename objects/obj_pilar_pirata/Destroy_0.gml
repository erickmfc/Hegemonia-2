// ===============================================
// PILAR PIRATA - DESTRUIÇÃO
// ===============================================

// Limpar lista de navios vinculados
if (ds_exists(navios_vinculados, ds_type_list)) {
    ds_list_destroy(navios_vinculados);
}

show_debug_message("🏴‍☠️ Pilar Pirata destruído em (" + string(x) + ", " + string(y) + ")");
