/// @description Limpa objetos inativos antigos dos pools
/// Remove objetos que não são mais válidos

function scr_cleanup_projectile_pools() {
    
    var _pool_mgr = instance_find(obj_projectile_pool_manager, 0);
    if (!instance_exists(_pool_mgr)) return;
    
    var pools_to_clean = [
        _pool_mgr.pool_tiro_simples,
        _pool_mgr.pool_tiro_infantaria,
        _pool_mgr.pool_tiro_tanque,
        _pool_mgr.pool_tiro_canhao,
        _pool_mgr.pool_projetil_naval,
        _pool_mgr.pool_skyfury,
        _pool_mgr.pool_ironclad
    ];
    
    var cleaned_count = 0;
    
    for (var p = 0; p < array_length(pools_to_clean); p++) {
        var _pool = pools_to_clean[p];
        
        // Limpar de trás para frente (evitar problemas de índices)
        for (var i = ds_list_size(_pool) - 1; i >= 0; i--) {
            var _obj_id = _pool[| i];
            
            // Verificar se objeto ainda existe
            if (!instance_exists(_obj_id)) {
                ds_list_delete(_pool, i);
                _pool_mgr.objetos_no_pool--;
                cleaned_count++;
            }
        }
    }
    
    if (cleaned_count > 0 && variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🧹 Limpeza de pool: " + string(cleaned_count) + " objetos inválidos removidos");
    }
}
