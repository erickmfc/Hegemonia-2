// ===============================================
// NAVIO PIRATA TIPO 2 - LIMPEZA
// ===============================================

if (ds_exists(pilares_patrulha, ds_type_list)) {
    ds_list_destroy(pilares_patrulha);
}

event_inherited();

