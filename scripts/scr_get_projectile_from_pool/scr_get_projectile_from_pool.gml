/// @description Obtém projétil do pool ou cria novo
/// @param {Asset.GMObject} obj_type Tipo do projétil (obj_tiro_simples, etc.)
/// @param {real} x Posição X
/// @param {real} y Posição Y
/// @param {string} layer_name Nome da layer (opcional)
/// @return {Id.Instance} ID da instância do projétil

function scr_get_projectile_from_pool(obj_type, x, y, layer_name = "Instances") {
    
    // Verificar se pool manager existe
    var _pool_mgr = instance_find(obj_projectile_pool_manager, 0);
    if (!instance_exists(_pool_mgr) || !_pool_mgr.pool_enabled) {
        // Pool não disponível - criar normalmente
        return instance_create_layer(x, y, layer_name, obj_type);
    }
    
    // Obter pool correto baseado no tipo
    var _pool = noone;
    var _pool_key = "";
    
    // ✅ CORREÇÃO: Obter índices de objetos de forma segura para evitar erros
    var _obj_tiro_canhao = asset_get_index("obj_tiro_canhao");
    var _obj_projetil_naval = asset_get_index("obj_projetil_naval");
    
    // Determinar qual pool usar (verificação segura para objetos opcionais)
    if (obj_type == obj_tiro_simples) {
        _pool = _pool_mgr.pool_tiro_simples;
        _pool_key = "tiro_simples";
    } else if (obj_type == obj_tiro_infantaria) {
        _pool = _pool_mgr.pool_tiro_infantaria;
        _pool_key = "tiro_infantaria";
    } else if (_obj_tiro_canhao != -1 && asset_get_type(_obj_tiro_canhao) == asset_object && obj_type == _obj_tiro_canhao) {
        // ✅ CORREÇÃO: Verificação segura para obj_tiro_canhao
        _pool = _pool_mgr.pool_tiro_canhao;
        _pool_key = "tiro_canhao";
    } else if (_obj_projetil_naval != -1 && asset_get_type(_obj_projetil_naval) == asset_object && obj_type == _obj_projetil_naval) {
        // ✅ CORREÇÃO: Verificação segura para obj_projetil_naval
        _pool = _pool_mgr.pool_projetil_naval;
        _pool_key = "projetil_naval";
    } else if (obj_type == obj_SkyFury_ar) {
        _pool = _pool_mgr.pool_skyfury;
        _pool_key = "skyfury";
    } else if (obj_type == obj_Ironclad_terra) {
        _pool = _pool_mgr.pool_ironclad;
        _pool_key = "ironclad";
    } else {
        // ✅ CORREÇÃO: Verificar objetos opcionais (obj_tiro_tanque, obj_tiro_blindado)
        var _obj_tiro_tanque = asset_get_index("obj_tiro_tanque");
        var _obj_tiro_blindado = asset_get_index("obj_tiro_blindado");
        
        if (_obj_tiro_tanque != -1 && asset_get_type(_obj_tiro_tanque) == asset_object && obj_type == _obj_tiro_tanque) {
            _pool = _pool_mgr.pool_tiro_tanque;
            _pool_key = "tiro_tanque";
        } else if (_obj_tiro_blindado != -1 && asset_get_type(_obj_tiro_blindado) == asset_object && obj_type == _obj_tiro_blindado) {
            _pool = _pool_mgr.pool_tiro_tanque; // Usar pool_tiro_tanque também para blindado
            _pool_key = "tiro_blindado";
        } else {
            // Tipo não suportado - criar normalmente
            return instance_create_layer(x, y, layer_name, obj_type);
        }
    }
    
    // Procurar objeto disponível no pool
    var _projetil = noone;
    var _found_index = -1;
    
    for (var i = 0; i < ds_list_size(_pool); i++) {
        var _obj_id = _pool[| i];
        // ✅ CORREÇÃO GM1045: Verificar se é instância válida
        if (instance_exists(_obj_id) && variable_instance_exists(_obj_id, "pooled") && !_obj_id.pooled) {
            _projetil = _obj_id;
            _found_index = i;
            break;
        }
    }
    
    if (instance_exists(_projetil)) {
        // === REUTILIZAR PROJÉTIL DO POOL ===
        
        // Remover do pool
        ds_list_delete(_pool, _found_index);
        _pool_mgr.objetos_no_pool--;
        
        // Reativar projétil
        _projetil.x = x;
        _projetil.y = y;
        _projetil.pooled = true; // Marcar como em uso
        _projetil.visible = true;
        
        // Reativar instância (se estava desativada)
        instance_activate_object(_projetil);
        
        // Resetar propriedades importantes
        if (variable_instance_exists(_projetil, "timer_vida")) {
            _projetil.timer_vida = 300; // Resetar timer
        }
        if (variable_instance_exists(_projetil, "tempo_vida")) {
            _projetil.tempo_vida = 0; // Resetar tempo
        }
        
        _pool_mgr.objetos_reutilizados++;
        
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("♻️ Projétil " + _pool_key + " reutilizado do pool");
        }
        
        return _projetil;
    } else {
        // === CRIAR NOVO PROJÉTIL ===
        var _novo_proj = instance_create_layer(x, y, layer_name, obj_type);
        
        if (instance_exists(_novo_proj)) {
            // Marcar como pooled (para usar no sistema)
            if (!variable_instance_exists(_novo_proj, "pooled")) {
                _novo_proj.pooled = false; // Será marcado como true quando retornar ao pool
            }
            
            _pool_mgr.objetos_criados++;
            
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("✨ Novo projétil " + _pool_key + " criado");
            }
        }
        
        return _novo_proj;
    }
}
