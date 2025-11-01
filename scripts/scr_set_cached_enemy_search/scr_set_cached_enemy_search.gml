/// @description Armazena resultado de busca no cache
/// @param {real} _x Posição X
/// @param {real} _y Posição Y
/// @param {real} _raio Raio de busca
/// @param {real} _nacao Nação
/// @param {Id.Instance} _enemy_id ID do inimigo encontrado (ou noone)

function scr_set_cached_enemy_search(_x, _y, _raio, _nacao, _enemy_id) {
    
    // Verificar se cache manager existe
    var _cache_mgr = instance_find(obj_enemy_search_cache_manager, 0);
    if (!instance_exists(_cache_mgr) || !_cache_mgr.cache_enabled) {
        return; // Cache desabilitado
    }
    
    // Não cachear se não encontrou inimigo (para evitar cache de "não encontrado")
    if (_enemy_id == noone || !instance_exists(_enemy_id)) {
        return;
    }
    
    // Verificar tamanho máximo do cache
    if (_cache_mgr.cache_entries >= _cache_mgr.max_cache_size) {
        // Cache cheio - limpar entradas antigas
        scr_cleanup_expired_cache();
        
        // Se ainda estiver cheio, remover entrada mais antiga
        if (_cache_mgr.cache_entries >= _cache_mgr.max_cache_size) {
            scr_limit_cache_size();
        }
    }
    
    // Gerar chave do cache
    var _cache_key = scr_get_cache_key(_x, _y, _raio, _nacao);
    
    // Criar entrada do cache
    var _cache_entry = {
        enemy_id: _enemy_id,
        timestamp: current_time,
        x: _x,
        y: _y,
        raio: _raio,
        nacao: _nacao
    };
    
    // Se já existe, substituir
    if (ds_map_exists(_cache_mgr.cache_map, _cache_key)) {
        ds_map_replace(_cache_mgr.cache_map, _cache_key, _cache_entry);
    } else {
        // Nova entrada
        ds_map_add(_cache_mgr.cache_map, _cache_key, _cache_entry);
        _cache_mgr.cache_entries++;
    }
    
    _cache_mgr.cache_misses++;
}
