// Funções de Embarque/Desembarque do Navio Transporte

/// Função para embarcar unidade (infantaria/soldados)
funcao_embarcar_unidade = function(unidade_id) {
    if (soldados_count >= soldados_max) return false;
    if (!instance_exists(unidade_id)) return false;
    
    ds_list_add(soldados_embarcados, unidade_id);
    soldados_count++;
    
    unidade_id.visible = false;
    
    show_debug_message("👥 Soldado embarcou! (" + string(soldados_count) + "/" + string(soldados_max) + ")");
    return true;
}

/// Função para embarcar aeronave
funcao_embarcar_aeronave = function(aeronave_id) {
    if (avioes_count >= avioes_max) return false;
    if (!instance_exists(aeronave_id)) return false;
    
    ds_list_add(avioes_embarcados, aeronave_id);
    avioes_count++;
    
    aeronave_id.visible = false;
    
    show_debug_message("✈️ Aeronave embarcou! (" + string(avioes_count) + "/" + string(avioes_max) + ")");
    return true;
}

/// Função para embarcar veículo
funcao_embarcar_veiculo = function(veiculo_id) {
    if (unidades_count >= unidades_max) return false;
    if (!instance_exists(veiculo_id)) return false;
    
    ds_list_add(unidades_embarcadas, veiculo_id);
    unidades_count++;
    
    veiculo_id.visible = false;
    
    show_debug_message("🚛 Veículo embarcou! (" + string(unidades_count) + "/" + string(unidades_max) + ")");
    return true;
}

/// Função para desembarcar soldado
funcao_desembarcar_soldado = function() {
    if (soldados_count <= 0) return false;
    
    var _soldado_id = ds_list_find_value(soldados_embarcados, 0);
    ds_list_delete(soldados_embarcados, 0);
    soldados_count--;
    
    if (instance_exists(_soldado_id)) {
        var _dist = 80;
        var _angulo = image_angle + desembarque_offset_angulo;
        
        _soldado_id.x = x + lengthdir_x(_dist, _angulo);
        _soldado_id.y = y + lengthdir_y(_dist, _angulo);
        _soldado_id.visible = true;
        
        desembarque_offset_angulo += 30;
        if (desembarque_offset_angulo >= 360) desembarque_offset_angulo = 0;
        
        show_debug_message("👥 Soldado desembarcou!");
    }
    return true;
}

/// Função para desembarcar aeronave
funcao_desembarcar_aeronave = function() {
    if (avioes_count <= 0) return false;
    
    var _aeronave_id = ds_list_find_value(avioes_embarcados, 0);
    ds_list_delete(avioes_embarcados, 0);
    avioes_count--;
    
    if (instance_exists(_aeronave_id)) {
        var _dist = 100;
        var _angulo = image_angle + desembarque_offset_angulo;
        
        _aeronave_id.x = x + lengthdir_x(_dist, _angulo);
        _aeronave_id.y = y + lengthdir_y(_dist, _angulo);
        _aeronave_id.visible = true;
        
        desembarque_offset_angulo += 30;
        if (desembarque_offset_angulo >= 360) desembarque_offset_angulo = 0;
        
        show_debug_message("✈️ Aeronave desembarcou!");
    }
    return true;
}

/// Função para desembarcar veículo
funcao_desembarcar_veiculo = function() {
    if (unidades_count <= 0) return false;
    
    var _veiculo_id = ds_list_find_value(unidades_embarcadas, 0);
    ds_list_delete(unidades_embarcadas, 0);
    unidades_count--;
    
    if (instance_exists(_veiculo_id)) {
        var _dist = 90;
        var _angulo = image_angle + desembarque_offset_angulo;
        
        _veiculo_id.x = x + lengthdir_x(_dist, _angulo);
        _veiculo_id.y = y + lengthdir_y(_dist, _angulo);
        _veiculo_id.visible = true;
        
        desembarque_offset_angulo += 30;
        if (desembarque_offset_angulo >= 360) desembarque_offset_angulo = 0;
        
        show_debug_message("🚛 Veículo desembarcou!");
    }
    return true;
}

