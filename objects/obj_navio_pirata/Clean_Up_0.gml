// ===============================================
// NAVIO PIRATA TIPO 1 - LIMPEZA
// ===============================================

// Destruir lista de pilares
if (ds_exists(pilares_patrulha, ds_type_list)) {
    ds_list_destroy(pilares_patrulha);
}

// Herdar limpeza da classe pai
event_inherited();

