// ===============================================
// HEGEMONIA GLOBAL - GAME MANAGER - CLEANUP EVENT
// Limpeza completa de memória e recursos
// ===============================================

show_debug_message("🧹 Iniciando protocolo de limpeza de memória...");

// ✅ LIMPEZA: Destruir mapa de estoque de recursos
if (variable_global_exists("estoque_recursos")) {
    if (ds_exists(global.estoque_recursos, ds_type_map)) {
        ds_map_destroy(global.estoque_recursos);
        show_debug_message("✅ estoque_recursos destruído");
    }
}

// ✅ LIMPEZA: Destruir mapa de status de pesquisas
if (variable_global_exists("nacao_recursos")) {
    if (ds_exists(global.nacao_recursos, ds_type_map)) {
        ds_map_destroy(global.nacao_recursos);
        show_debug_message("✅ nacao_recursos destruído");
    }
}

// ✅ LIMPEZA: Destruir mapa de timers de pesquisa
if (variable_global_exists("research_timers")) {
    if (ds_exists(global.research_timers, ds_type_map)) {
        ds_map_destroy(global.research_timers);
        show_debug_message("✅ research_timers destruído");
    }
}

// ✅ LIMPEZA: Destruir grade de pathfinding
if (variable_global_exists("pathfinding_grid")) {
    if (global.pathfinding_grid != undefined && global.pathfinding_grid != noone) {
        mp_grid_destroy(global.pathfinding_grid);
        show_debug_message("✅ pathfinding_grid destruído");
    }
}

// ✅ LIMPEZA: Destruir grade de pathfinding naval
if (variable_global_exists("navio_path_grid")) {
    if (global.navio_path_grid != undefined && global.navio_path_grid != noone && global.navio_path_grid != -1) {
        mp_grid_destroy(global.navio_path_grid);
        show_debug_message("✅ navio_path_grid destruído");
    }
}

// ✅ LIMPEZA: Destruir spatial grid se existir
if (variable_global_exists("spatial_grid_initialized") && global.spatial_grid_initialized) {
    var _script_destroy = asset_get_index("scr_destroy_spatial_grid");
    if (_script_destroy != -1) {
        scr_destroy_spatial_grid();
        show_debug_message("✅ spatial_grid destruído");
    }
}

// NOTA: Não precisamos destruir 'global.map_grid' porque ele é um ARRAY,
// e o GameMaker lida com a memória de arrays automaticamente.

show_debug_message("✅ Protocolo de limpeza concluído!");
