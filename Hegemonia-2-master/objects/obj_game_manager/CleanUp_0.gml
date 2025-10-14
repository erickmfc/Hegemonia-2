// Evento Clean Up CORRIGIDO para obj_game_manager

// O evento Clean Up é executado quando o jogo fecha.
// É nossa responsabilidade limpar manualmente as estruturas de dados (DS) que criamos.

show_debug_message("Iniciando protocolo de limpeza de memória...");

// Research system variables removed - no cleanup needed

// Verifica se o mapa de estoque de recursos existe e o destrói.
if (ds_exists(global.estoque_recursos, ds_type_map)) {
    ds_map_destroy(global.estoque_recursos);
}

// Limpa a grade de pathfinding se ela existir
if (global.pathfinding_grid != undefined) {
    mp_grid_destroy(global.pathfinding_grid);
}

// NOTA: Não precisamos destruir 'global.map_grid' porque ele é um ARRAY,
// e o GameMaker lida com a memória de arrays automaticamente.
