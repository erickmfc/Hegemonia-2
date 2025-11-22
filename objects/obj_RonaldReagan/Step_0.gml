/// @description Ronald Reagan - Step Event
// ===============================================
// HEGEMONIA GLOBAL - RONALD REAGAN
// Herda de obj_navio_base + Funções de transporte
// ===============================================

// ✅ HERDAR LÓGICA DO PAI (navegação, combate, patrulha)
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === ATUALIZAR POSIÇÃO DAS UNIDADES EMBARCADAS (SEGUIR O NAVIO) ===
// ✅ CORREÇÃO: Aviões, veículos e soldados devem seguir o navio quando embarcados
if (variable_instance_exists(id, "avioes_embarcados")) {
    for (var i = 0; i < ds_list_size(avioes_embarcados); i++) {
        var _aeronave_id = avioes_embarcados[| i];
        if (instance_exists(_aeronave_id)) {
            // Atualizar posição para seguir o navio
            _aeronave_id.x = x;
            _aeronave_id.y = y;
            // Garantir que está invisível
            _aeronave_id.visible = false;
        }
    }
}

if (variable_instance_exists(id, "unidades_embarcadas")) {
    for (var i = 0; i < ds_list_size(unidades_embarcadas); i++) {
        var _veiculo_id = unidades_embarcadas[| i];
        if (instance_exists(_veiculo_id)) {
            // Atualizar posição para seguir o navio
            _veiculo_id.x = x;
            _veiculo_id.y = y;
            // Garantir que está invisível
            _veiculo_id.visible = false;
        }
    }
}

if (variable_instance_exists(id, "soldados_embarcados")) {
    for (var i = 0; i < ds_list_size(soldados_embarcados); i++) {
        var _soldado_id = soldados_embarcados[| i];
        if (instance_exists(_soldado_id)) {
            // Atualizar posição para seguir o navio
            _soldado_id.x = x;
            _soldado_id.y = y;
            // Garantir que está invisível
            _soldado_id.visible = false;
        }
    }
}

// === SISTEMA DE DESEMBARQUE AUTOMÁTICO ===
if (desembarque_ativo) {
    if (desembarque_timer > 0) {
        desembarque_timer--;
    } else {
        desembarcar_proxima();
        desembarque_timer = desembarque_intervalo;
    }
}

// === FUNÇÕES DE TRANSPORTE (DEFINIDAS AQUI) ===

// Verificar se unidade pode embarcar
function eh_embarcavel(_unidade) {
    if (!instance_exists(_unidade)) return false;
    if (_unidade.id == id) return false;
    if (!variable_instance_exists(_unidade, "nacao_proprietaria")) return false;
    if (_unidade.nacao_proprietaria != nacao_proprietaria) return false;
    
    // Aeronaves
    if (object_is_ancestor(_unidade.object_index, obj_caca_f5) || 
        object_is_ancestor(_unidade.object_index, obj_f15) ||
        object_is_ancestor(_unidade.object_index, obj_f6) ||
        object_is_ancestor(_unidade.object_index, obj_helicoptero_militar)) return true;
    
    // Terrestre
    if (object_is_ancestor(_unidade.object_index, obj_infantaria)) return true;
    if (object_is_ancestor(_unidade.object_index, obj_tanque)) return true;
    if (object_is_ancestor(_unidade.object_index, obj_soldado_antiaereo)) return true;
    if (object_is_ancestor(_unidade.object_index, obj_blindado_antiaereo)) return true;
    
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object && _unidade.object_index == _obj_abrams) return true;
    
    // ✅ NOVO: Adicionar Gepard
    var _obj_gepard = asset_get_index("obj_Gepard_Anti_Aereo");
    if (_obj_gepard == -1) {
        _obj_gepard = asset_get_index("obj_gepard"); // Fallback para nome alternativo
    }
    if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object && _unidade.object_index == _obj_gepard) return true;
    
    return false;
}

// Retornar tipo de unidade
function tipo_unidade(_unidade) {
    if (!instance_exists(_unidade)) return "desconhecido";
    var _nome = object_get_name(_unidade.object_index);
    if (_nome == "obj_caca_f5" || _nome == "obj_f15" || _nome == "obj_f6" || _nome == "obj_helicoptero_militar" || _nome == "obj_c100" || _nome == "obj_caca_f35" || _nome == "obj_su35") return "aereo";
    if (_nome == "obj_infantaria" || _nome == "obj_soldado_antiaereo") return "soldado";
    if (_nome == "obj_tanque" || _nome == "obj_blindado_antiaereo" || _nome == "obj_M1A_Abrams" || _nome == "obj_Gepard_Anti_Aereo" || _nome == "obj_gepard") return "unidade"; // ✅ NOVO: Gepard pode embarcar
    return "desconhecido";
}

// Embarcar unidade
function embarcar_unidade(_unidade) {
    var _tipo = tipo_unidade(_unidade);
    switch (_tipo) {
        case "aereo":
            if (avioes_count >= avioes_max) return false;
            break;
        case "unidade":
            if (unidades_count >= unidades_max) return false;
            break;
        case "soldado":
            if (soldados_count >= soldados_max) return false;
            break;
        default:
            return false;
    }
    
    var _lista;
    if (_tipo == "soldado") {
        _lista = soldados_embarcados;
    } else if (_tipo == "unidade") {
        _lista = unidades_embarcadas;
    } else {
        _lista = avioes_embarcados;
    }
    
    if (ds_list_find_index(_lista, _unidade.id) != -1) return false;
    
    ds_list_add(_lista, _unidade.id);
    if (_tipo == "aereo") avioes_count++;
    else if (_tipo == "unidade") unidades_count++;
    else soldados_count++;
    
    _unidade.visible = false;
    return true;
}

// Desembarcar próxima unidade
function desembarcar_proxima() {
    if (ds_queue_size(desembarque_fila) == 0) {
        desembarque_ativo = false;
        return;
    }
    
    var _unidade_id = ds_queue_dequeue(desembarque_fila);
    if (!instance_exists(_unidade_id)) return;
    
    var _unidade = _unidade_id;
    var _tipo = tipo_unidade(_unidade);
    
    if (_tipo == "aereo" && ds_exists(avioes_embarcados, ds_type_list)) {
        var _idx = ds_list_find_index(avioes_embarcados, _unidade_id);
        if (_idx >= 0) ds_list_delete(avioes_embarcados, _idx);
        avioes_count--;
    } else if (_tipo == "soldado" && ds_exists(soldados_embarcados, ds_type_list)) {
        var _idx = ds_list_find_index(soldados_embarcados, _unidade_id);
        if (_idx >= 0) ds_list_delete(soldados_embarcados, _idx);
        soldados_count--;
    } else if (_tipo == "unidade" && ds_exists(unidades_embarcadas, ds_type_list)) {
        var _idx = ds_list_find_index(unidades_embarcadas, _unidade_id);
        if (_idx >= 0) ds_list_delete(unidades_embarcadas, _idx);
        unidades_count--;
    }
    
    var _dist = 100;
    var _angulo = image_angle + 90;
    _unidade.x = x + lengthdir_x(_dist, _angulo);
    _unidade.y = y + lengthdir_y(_dist, _angulo);
    _unidade.visible = true;
    
    if (_tipo == "aereo" && variable_instance_exists(_unidade, "velocidade_atual")) {
        _unidade.velocidade_atual = 5;
        _unidade.image_angle = image_angle;
    }
}

// === FUNÇÕES PADRONIZADAS ===

function funcao_embarcar_unidade(_unidade_id) {
    return embarcar_unidade(_unidade_id);
}

function funcao_embarcar_aeronave(_aeronave_id) {
    return embarcar_unidade(_aeronave_id);
}

function funcao_embarcar_veiculo(_veiculo_id) {
    return embarcar_unidade(_veiculo_id);
}

function funcao_desembarcar_soldado() {
    if (soldados_count <= 0) return false;
    var _id = ds_list_find_value(soldados_embarcados, 0);
    if (instance_exists(_id)) {
        var _dist = 80;
        var _angulo = image_angle + desembarque_offset_angulo;
        _id.x = x + lengthdir_x(_dist, _angulo);
        _id.y = y + lengthdir_y(_dist, _angulo);
        _id.visible = true;
        ds_list_delete(soldados_embarcados, 0);
        soldados_count--;
        desembarque_offset_angulo += 30;
        if (desembarque_offset_angulo >= 360) desembarque_offset_angulo = 0;
    }
    return true;
}

function funcao_desembarcar_aeronave() {
    if (avioes_count <= 0) return false;
    var _id = ds_list_find_value(avioes_embarcados, 0);
    if (instance_exists(_id)) {
        var _dist = 100;
        var _angulo = image_angle + desembarque_offset_angulo;
        _id.x = x + lengthdir_x(_dist, _angulo);
        _id.y = y + lengthdir_y(_dist, _angulo);
        _id.visible = true;
        ds_list_delete(avioes_embarcados, 0);
        avioes_count--;
        desembarque_offset_angulo += 30;
        if (desembarque_offset_angulo >= 360) desembarque_offset_angulo = 0;
    }
    return true;
}

function funcao_desembarcar_veiculo() {
    if (unidades_count <= 0) return false;
    var _id = ds_list_find_value(unidades_embarcadas, 0);
    if (instance_exists(_id)) {
        var _dist = 90;
        var _angulo = image_angle + desembarque_offset_angulo;
        _id.x = x + lengthdir_x(_dist, _angulo);
        _id.y = y + lengthdir_y(_dist, _angulo);
        _id.visible = true;
        ds_list_delete(unidades_embarcadas, 0);
        unidades_count--;
        desembarque_offset_angulo += 30;
        if (desembarque_offset_angulo >= 360) desembarque_offset_angulo = 0;
    }
    return true;
}
