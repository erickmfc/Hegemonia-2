/// @description Pré-aquecer pools criando objetos antecipadamente
function scr_pre_warm_pools() {
    var _pool_mgr = instance_find(obj_projectile_pool_manager, 0);
    if (!instance_exists(_pool_mgr)) return;
    
    var _pre_warm_count = _pool_mgr.pre_warm_pool_size;
    
    // Pré-criar projéteis de cada tipo
    for (var i = 0; i < _pre_warm_count; i++) {
        var _tiro = noone; // ✅ CORREÇÃO: Declarar antes dos ifs para estar no escopo correto
        
        // Tiro simples
        if (object_exists(obj_tiro_simples)) {
            _tiro = instance_create_layer(-1000, -1000, "Instances", obj_tiro_simples);
            if (instance_exists(_tiro)) {
                _tiro.pooled = false;
                _tiro.visible = false;
                instance_deactivate_object(_tiro);
                ds_list_add(_pool_mgr.pool_tiro_simples, _tiro);
                _pool_mgr.objetos_no_pool++;
            }
        }
        
        // Tiro infantaria
        if (object_exists(obj_tiro_infantaria)) {
            _tiro = instance_create_layer(-1000, -1000, "Instances", obj_tiro_infantaria);
            if (instance_exists(_tiro)) {
                _tiro.pooled = false;
                _tiro.visible = false;
                instance_deactivate_object(_tiro);
                ds_list_add(_pool_mgr.pool_tiro_infantaria, _tiro);
                _pool_mgr.objetos_no_pool++;
            }
        }
        
        // Tiro tanque (verificação segura - objeto pode não estar registrado ainda)
        var _obj_tiro_tanque = asset_get_index("obj_tiro_tanque");
        if (_obj_tiro_tanque != -1 && asset_get_type(_obj_tiro_tanque) == asset_object) {
            _tiro = instance_create_layer(-1000, -1000, "Instances", _obj_tiro_tanque);
            if (instance_exists(_tiro)) {
                _tiro.pooled = false;
                _tiro.visible = false;
                instance_deactivate_object(_tiro);
                ds_list_add(_pool_mgr.pool_tiro_tanque, _tiro);
                _pool_mgr.objetos_no_pool++;
            }
        }
        
        // Tiro canhão (verificação segura - objeto pode não estar registrado ainda)
        var _obj_tiro_canhao = asset_get_index("obj_tiro_canhao");
        if (_obj_tiro_canhao != -1 && asset_get_type(_obj_tiro_canhao) == asset_object) {
            _tiro = instance_create_layer(-1000, -1000, "Instances", _obj_tiro_canhao);
            if (instance_exists(_tiro)) {
                _tiro.pooled = false;
                _tiro.visible = false;
                instance_deactivate_object(_tiro);
                ds_list_add(_pool_mgr.pool_tiro_canhao, _tiro);
                _pool_mgr.objetos_no_pool++;
            }
        }
        
        // Projétil naval (verificação segura)
        var _obj_projetil_naval = asset_get_index("obj_projetil_naval");
        if (_obj_projetil_naval != -1 && asset_get_type(_obj_projetil_naval) == asset_object) {
            _tiro = instance_create_layer(-1000, -1000, "Instances", _obj_projetil_naval);
            if (instance_exists(_tiro)) {
                _tiro.pooled = false;
                _tiro.visible = false;
                instance_deactivate_object(_tiro);
                ds_list_add(_pool_mgr.pool_projetil_naval, _tiro);
                _pool_mgr.objetos_no_pool++;
            }
        }
        
        // SkyFury (míssil ar-ar) (verificação segura)
        var _obj_skyfury = asset_get_index("obj_SkyFury_ar");
        if (_obj_skyfury != -1 && asset_get_type(_obj_skyfury) == asset_object) {
            _tiro = instance_create_layer(-1000, -1000, "Instances", _obj_skyfury);
            if (instance_exists(_tiro)) {
                _tiro.pooled = false;
                _tiro.visible = false;
                instance_deactivate_object(_tiro);
                ds_list_add(_pool_mgr.pool_skyfury, _tiro);
                _pool_mgr.objetos_no_pool++;
            }
        }
        
        // Ironclad (míssil terra-terra) (verificação segura)
        var _obj_ironclad = asset_get_index("obj_Ironclad_terra");
        if (_obj_ironclad != -1 && asset_get_type(_obj_ironclad) == asset_object) {
            _tiro = instance_create_layer(-1000, -1000, "Instances", _obj_ironclad);
            if (instance_exists(_tiro)) {
                _tiro.pooled = false;
                _tiro.visible = false;
                instance_deactivate_object(_tiro);
                ds_list_add(_pool_mgr.pool_ironclad, _tiro);
                _pool_mgr.objetos_no_pool++;
            }
        }
    }
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🔥 Pools pré-aquecidos: " + string(_pre_warm_count) + " objetos de cada tipo");
        show_debug_message("📊 Total de objetos no pool: " + string(_pool_mgr.objetos_no_pool));
    }
}
