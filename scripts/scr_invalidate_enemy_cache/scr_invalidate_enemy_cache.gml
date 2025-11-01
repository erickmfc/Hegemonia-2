/// @description Invalida cache relacionado a um inimigo específico ou posição
/// @param {Id.Instance} _enemy_id ID do inimigo (opcional - se noone, invalida por posição)
/// @param {real} _x Posição X (opcional)
/// @param {real} _y Posição Y (opcional)

function scr_invalidate_enemy_cache(_enemy_id = noone, _x = 0, _y = 0) {
    
    var _cache_mgr = instance_find(obj_enemy_search_cache_manager, 0);
    if (!instance_exists(_cache_mgr)) return;
    
    var _invalidados = 0;
    var _keys = ds_map_keys_to_array(_cache_mgr.cache_map);
    
    if (_enemy_id != noone && instance_exists(_enemy_id)) {
        // Invalidar por ID do inimigo
        for (var i = 0; i < array_length(_keys); i++) {
            var _key = _keys[i];
            var _entry = _cache_mgr.cache_map[? _key];
            
            if (_entry.enemy_id == _enemy_id) {
                ds_map_delete(_cache_mgr.cache_map, _key);
                _cache_mgr.cache_entries--;
                _invalidados++;
            }
        }
    } else if (_x != 0 || _y != 0) {
        // Invalidar por posição (raio de 100 pixels)
        for (var i = 0; i < array_length(_keys); i++) {
            var _key = _keys[i];
            var _entry = _cache_mgr.cache_map[? _key];
            
            var _dist = point_distance(_entry.x, _entry.y, _x, _y);
            if (_dist <= 100) {
                ds_map_delete(_cache_mgr.cache_map, _key);
                _cache_mgr.cache_entries--;
                _invalidados++;
            }
        }
    }
    
    _cache_mgr.cache_invalidated += _invalidados;
    
    if (_invalidados > 0 && variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🔄 Cache invalidado: " + string(_invalidados) + " entradas");
    }
}
