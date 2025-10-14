// ==========================================
// HEGEMONIA GLOBAL - INFANTARIA
// Limpeza de Memória
// ==========================================

// Destruir a lista de patrulha para evitar vazamentos de memória
ds_list_destroy(rota_de_patrulha);

// Destruir o path se existir
if (path_index != -1) {
    path_end();
}
path_delete(caminho_atual);
