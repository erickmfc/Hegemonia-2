/// @description Limita tamanho do cache removendo entradas mais antigas
function scr_limit_cache_size() {
    
    var _cache_mgr = instance_find(obj_enemy_search_cache_manager, 0);
    if (!instance_exists(_cache_mgr)) return;
    
    var _max_size = _cache_mgr.max_cache_size;
    var _current_size = _cache_mgr.cache_entries;
    
    if (_current_size <= _max_size) return; // Não precisa limpar
    
    var _remover = _current_size - _max_size;
    
    // Obter todas as chaves e ordenar por timestamp (mais antigas primeiro)
    var _keys = ds_map_keys_to_array(_cache_mgr.cache_map);
    var _entries = [];
    
    for (var i = 0; i < array_length(_keys); i++) {
        var _key = _keys[i];
        var _entry = _cache_mgr.cache_map[? _key];
        _entries[i] = {
            key: _key,
            timestamp: _entry.timestamp
        };
    }
    
    // Ordenar por timestamp (mais antigas primeiro)
    array_sort(_entries, function(a, b) {
        return a.timestamp - b.timestamp;
    });
    
    // Remover as mais antigas
    var _removidos = 0;
    for (var i = 0; i < min(_remover, array_length(_entries)); i++) {
        ds_map_delete(_cache_mgr.cache_map, _entries[i].key);
        _cache_mgr.cache_entries--;
        _removidos++;
    }
    
    if (_removidos > 0 && variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("📉 Cache limitado: " + string(_removidos) + " entradas antigas removidas");
    }
}
