/// @description Retorna projétil ao pool ao invés de destruir
/// @param {Id.Instance} proj_id ID da instância do projétil

function scr_return_projectile_to_pool(proj_id) {
    
    // ✅ CORREÇÃO GM1041: Verificar se proj_id é uma instância válida
    if (!instance_exists(proj_id)) return;
    
    // Verificar se pool manager existe
    var _pool_mgr = instance_find(obj_projectile_pool_manager, 0);
    if (!instance_exists(_pool_mgr) || !_pool_mgr.pool_enabled) {
        // Pool não disponível - destruir normalmente
        instance_destroy(proj_id);
        return;
    }
    
    // Verificar se já está no pool
    if (variable_instance_exists(proj_id, "pooled") && !proj_id.pooled) {
        return; // Já está no pool
    }
    
    // Obter tipo do objeto e pool correspondente
    var obj_type = proj_id.object_index;
    var _pool = noone;
    var _pool_key = "";
    
    // ✅ CORREÇÃO: Obter índices de objetos de forma segura para evitar erros
    var _obj_tiro_canhao = asset_get_index("obj_tiro_canhao");
    var _obj_projetil_naval = asset_get_index("obj_projetil_naval");
    
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
            // Tipo não suportado - destruir normalmente
            instance_destroy(proj_id);
            return;
        }
    }
    
    // Verificar tamanho do pool (não exceder máximo)
    if (ds_list_size(_pool) >= _pool_mgr.max_pool_size) {
        // Pool cheio - destruir ao invés de adicionar
        instance_destroy(proj_id);
        return;
    }
    
    // === ADICIONAR AO POOL ===
    
    // Resetar propriedades
    proj_id.x = -1000; // Mover para fora da tela
    proj_id.y = -1000;
    proj_id.visible = false;
    proj_id.pooled = false; // Disponível no pool
    proj_id.alvo = noone;
    proj_id.dono = noone;
    
    // Resetar variáveis se existirem
    if (variable_instance_exists(proj_id, "timer_vida")) {
        proj_id.timer_vida = 0;
    }
    if (variable_instance_exists(proj_id, "tempo_vida")) {
        proj_id.tempo_vida = 0;
    }
    if (variable_instance_exists(proj_id, "speed")) {
        proj_id.speed = 0;
    }
    
    // Desativar instância (economia de processamento)
    instance_deactivate_object(proj_id);
    
    // Adicionar ao pool
    ds_list_add(_pool, proj_id);
    _pool_mgr.objetos_no_pool++;
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("💾 Projétil " + _pool_key + " retornado ao pool");
    }
}
