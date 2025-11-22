// ===============================================
// PILAR PIRATA - LIMPEZA
// ===============================================

// Destruir lista de navios vinculados
if (ds_exists(navios_vinculados, ds_type_list)) {
    ds_list_destroy(navios_vinculados);
}

