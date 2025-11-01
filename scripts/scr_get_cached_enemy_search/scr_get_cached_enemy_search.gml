/// @description Obtém resultado de busca de cache se disponível e válido
/// @param {real} _x Posição X
/// @param {real} _y Posição Y
/// @param {real} _raio Raio de busca
/// @param {real} _nacao Nação
/// @return {Id.Instance} ID do inimigo ou noone se não encontrado/no cache

function scr_get_cached_enemy_search(_x, _y, _raio, _nacao) {
    
    // Verificar se cache manager existe
    var _cache_mgr = instance_find(obj_enemy_search_cache_manager, 0);
    if (!instance_exists(_cache_mgr) || !_cache_mgr.cache_enabled) {
        return noone; // Cache desabilitado - não usar
    }
    
    // Gerar chave do cache
    var _cache_key = scr_get_cache_key(_x, _y, _raio, _nacao);
    
    // Verificar se existe no cache
    if (!ds_map_exists(_cache_mgr.cache_map, _cache_key)) {
        return noone; // Não está no cache
    }
    
    // Obter entrada do cache
    var _cache_entry = _cache_mgr.cache_map[? _cache_key];
    
    // Verificar se está expirado (mais de 0.5 segundos)
    var _tempo_atual = current_time;
    var _tempo_decorrido = (_tempo_atual - _cache_entry.timestamp) / 1000000; // Converter para segundos
    
    if (_tempo_decorrido > 0.5) { // Cache expirado (0.5 segundos)
        // Remover entrada expirada
        ds_map_delete(_cache_mgr.cache_map, _cache_key);
        _cache_mgr.cache_entries--;
        return noone;
    }
    
    // Verificar se o inimigo ainda existe e ainda é inimigo
    var _inimigo_cached = _cache_entry.enemy_id;
    
    if (!instance_exists(_inimigo_cached)) {
        // Inimigo foi destruído - remover do cache
        ds_map_delete(_cache_mgr.cache_map, _cache_key);
        _cache_mgr.cache_entries--;
        _cache_mgr.cache_invalidated++;
        return noone;
    }
    
    // Verificar se ainda está no alcance (posição pode ter mudado)
    var _dist = point_distance(_x, _y, _inimigo_cached.x, _inimigo_cached.y);
    if (_dist > _raio) {
        // Fora do alcance - remover do cache
        ds_map_delete(_cache_mgr.cache_map, _cache_key);
        _cache_mgr.cache_entries--;
        return noone;
    }
    
    // Verificar se ainda é inimigo (nacao_proprietaria pode ter mudado)
    if (variable_instance_exists(_inimigo_cached, "nacao_proprietaria")) {
        if (_inimigo_cached.nacao_proprietaria == _nacao) {
            // Não é mais inimigo - remover do cache
            ds_map_delete(_cache_mgr.cache_map, _cache_key);
            _cache_mgr.cache_entries--;
            return noone;
        }
    }
    
    // ✅ Cache HIT - Retornar inimigo do cache
    _cache_mgr.cache_hits++;
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled && (_cache_mgr.cache_hits mod 100 == 0)) {
        show_debug_message("✅ Cache HIT! Entradas: " + string(_cache_mgr.cache_entries) + " | Hits: " + string(_cache_mgr.cache_hits));
    }
    
    return _inimigo_cached;
}
