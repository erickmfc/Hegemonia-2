/// @description Obter objeto do pool ou criar novo
/// @param {real} obj_type Tipo do objeto
/// @param {real} x Posição X
/// @param {real} y Posição Y
/// @return {real} ID do objeto

function scr_obter_objeto_pool(obj_type, x, y) {
    
    var _pool_manager = instance_find(obj_object_pool, 0);
    if (!instance_exists(_pool_manager)) {
        return scr_criar_objeto_seguro(obj_type, x, y, "Instances");
    }
    
    // === VERIFICAR POOL ===
    var _pool = _pool_manager.pool_projeteis; // Assumindo projéteis
    var _obj_disponivel = noone;
    
    // Procurar objeto disponível no pool
    for (var i = 0; i < ds_list_size(_pool); i++) {
        var _obj_id = _pool[| i];
        if (instance_exists(_obj_id) && !_obj_id.ativo) {
            _obj_disponivel = _obj_id;
            ds_list_delete(_pool, i);
            break;
        }
    }
    
    if (instance_exists(_obj_disponivel)) {
        // === REUTILIZAR OBJETO ===
        _obj_disponivel.x = x;
        _obj_disponivel.y = y;
        _obj_disponivel.ativo = true;
        _obj_disponivel.visible = true;
        _obj_disponivel.solid = true;
        
        _pool_manager.objetos_reutilizados++;
        show_debug_message("♻️ Objeto reutilizado do pool - ID: " + string(_obj_disponivel));
        
        return _obj_disponivel;
    } else {
        // === CRIAR NOVO OBJETO ===
        var _novo_obj = scr_criar_objeto_seguro(obj_type, x, y, "Instances");
        if (instance_exists(_novo_obj)) {
            _novo_obj.ativo = true;
            _pool_manager.objetos_criados++;
        }
        return _novo_obj;
    }
}
