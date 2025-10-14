/// @description Limpeza ao destruir o objeto
if (ds_exists(patrulha, ds_type_list)) {
    ds_list_destroy(patrulha);
}
