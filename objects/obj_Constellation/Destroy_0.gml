/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
/// @description Limpeza de memória

// Libera ds_list
if (ds_exists(pontos_patrulha, ds_type_list)) {
    ds_list_destroy(pontos_patrulha);
    show_debug_message("Constellation destruído - Memória liberada");
}
