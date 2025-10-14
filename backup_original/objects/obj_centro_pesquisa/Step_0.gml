// Evento Step - obj_centro_pesquisa
// Processar pesquisas em andamento

if (ds_list_size(global.pesquisas_ativas) > 0) {
    for (var i = ds_list_size(global.pesquisas_ativas) - 1; i >= 0; i--) {
        var recurso = ds_list_find_value(global.pesquisas_ativas, i);
        var tempo_restante = global.pesquisas_tempo_restante[? recurso];
        
        // Reduzir tempo
        tempo_restante -= 1/60; // 60 FPS
        ds_map_replace(global.pesquisas_tempo_restante, recurso, tempo_restante);
        
        // Verificar se pesquisa foi concluída
        if (tempo_restante <= 0) {
            // Completar pesquisa
            ds_map_replace(global.nacao_recursos, recurso, RESOURCE_STATUS.RESEARCHED);
            ds_list_delete(global.pesquisas_ativas, i);
            ds_map_delete(global.pesquisas_tempo_restante, recurso);
            global.slots_pesquisa_usados--;
            
            show_debug_message("Pesquisa concluída: " + recurso);
        }
    }
}

// Fechar menu com ESC
if (global.menu_pesquisa_aberto && keyboard_check_pressed(vk_escape)) {
    global.menu_pesquisa_aberto = false;
}