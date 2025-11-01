// =============================================
// DESTROY - Limpar todos os pools
// =============================================

// Destruir todos os objetos nos pools antes de destruir as lists
var pools_to_clean = [
    pool_tiro_simples,
    pool_tiro_infantaria,
    pool_tiro_tanque,
    pool_tiro_canhao,
    pool_projetil_naval,
    pool_skyfury,
    pool_ironclad,
    pool_missil_aereo
];

for (var p = 0; p < array_length(pools_to_clean); p++) {
    var _pool = pools_to_clean[p];
    if (ds_exists(_pool, ds_type_list)) {
        // Destruir todos os objetos no pool
        for (var i = ds_list_size(_pool) - 1; i >= 0; i--) {
            var _obj_id = _pool[| i];
            if (instance_exists(_obj_id)) {
                instance_destroy(_obj_id);
            }
        }
        // Destruir a list
        ds_list_destroy(_pool);
    }
}

if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("🧹 Projectile Pool Manager destruído - pools limpos");
}
