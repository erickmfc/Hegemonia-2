// ===============================================
// NAVIO DE CARGA - DESTRUIÇÃO
// ===============================================

// Limpar rota
if (ds_exists(rota_waypoints, ds_type_list)) {
    ds_list_destroy(rota_waypoints);
}

show_debug_message("🚢 Navio de Carga destruído");

