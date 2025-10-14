// ==========================================
// HEGEMONIA GLOBAL - INFANTARIA
// Destroy Event - Limpeza de Memória
// ==========================================

// === LIMPAR DATA STRUCTURES ===
if (variable_instance_exists(id, "rota_de_patrulha")) {
    if (ds_exists(rota_de_patrulha, ds_type_list)) {
        ds_list_destroy(rota_de_patrulha);
    }
}

if (variable_instance_exists(id, "caminho_atual")) {
    if (path_exists(caminho_atual)) {
        path_delete(caminho_atual);
    }
}

// === LIMPAR REFERÊNCIAS ===
alvo = noone;
alvo_atual = noone;
unidade_seguindo = noone;
capturando_estrutura = noone;