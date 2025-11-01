/// @description Remove entradas expiradas do cache
function scr_cleanup_expired_cache() {
    
    var _cache_mgr = instance_find(obj_enemy_search_cache_manager, 0);
    if (!instance_exists(_cache_mgr)) return;
    
    var _cache_max_age = 1.0; // 1 segundo
    var _tempo_atual = current_time;
    var _removidos = 0;
    
    // Obter todas as chaves do cache
    var _keys = ds_map_keys_to_array(_cache_mgr.cache_map);
    
    for (var i = 0; i < array_length(_keys); i++) {
        var _key = _keys[i];
        var _entry = _cache_mgr.cache_map[? _key];
        
        // Verificar se expirou
        var _tempo_decorrido = (_tempo_atual - _entry.timestamp) / 1000000; // Segundos
        
        if (_tempo_decorrido > _cache_max_age) {
            // Verificar se inimigo ainda existe
            if (!instance_exists(_entry.enemy_id)) {
                ds_map_delete(_cache_mgr.cache_map, _key);
                _cache_mgr.cache_entries--;
                _removidos++;
                continue;
            }
            
            // Remover entradas muito antigas mesmo que válidas
            if (_tempo_decorrido > _cache_max_age * 2) {
                ds_map_delete(_cache_mgr.cache_map, _key);
                _cache_mgr.cache_entries--;
                _removidos++;
            }
        }
    }
    
    if (_removidos > 0 && variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🧹 Cache limpo: " + string(_removidos) + " entradas expiradas removidas");
    }
}
