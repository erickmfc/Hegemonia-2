/// @description Limpeza de memória

// Libera ds_list
if (ds_exists(pontos_patrulha, ds_type_list)) {
    ds_list_destroy(pontos_patrulha);
    show_debug_message("Lancha destruída - Memória liberada");
}
