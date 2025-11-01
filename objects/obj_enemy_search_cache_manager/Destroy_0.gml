// =============================================
// DESTROY - Limpar cache completamente
// =============================================

if (ds_exists(cache_map, ds_type_map)) {
    ds_map_clear(cache_map);
    ds_map_destroy(cache_map);
}

if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("🗑️ Cache de busca de inimigos destruído");
}
