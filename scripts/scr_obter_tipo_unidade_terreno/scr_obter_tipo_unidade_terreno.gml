// ===============================================
// HEGEMONIA GLOBAL - OBTER TIPO DE UNIDADE POR TERRENO
// Centraliza identificação de tipo de unidade
// ===============================================

/// @function scr_obter_tipo_unidade_terreno(_unidade_id)
/// @description Retorna tipo de terreno que a unidade pode usar
/// @param {id} _unidade_id - ID da unidade
/// @returns {string} "terrestre", "naval" ou "aereo"

function scr_obter_tipo_unidade_terreno(_unidade_id) {
    if (!instance_exists(_unidade_id)) return "terrestre"; // Fallback
    
    var _obj_name = object_get_name(_unidade_id.object_index);
    
    // === UNIDADES NAVALS ===
    if (string_pos("lancha", _obj_name) > 0 || 
        string_pos("navio", _obj_name) > 0 || 
        string_pos("submarino", _obj_name) > 0 ||
        string_pos("Constellation", _obj_name) > 0 ||
        string_pos("Independence", _obj_name) > 0 ||
        string_pos("RonaldReagan", _obj_name) > 0 ||
        string_pos("Hendrick", _obj_name) > 0) {
        return "naval";
    }
    
    // === UNIDADES AÉREAS ===
    if (string_pos("f15", _obj_name) > 0 ||
        string_pos("f6", _obj_name) > 0 ||
        string_pos("f5", _obj_name) > 0 ||
        string_pos("su35", _obj_name) > 0 ||
        string_pos("helicoptero", _obj_name) > 0 ||
        string_pos("c100", _obj_name) > 0 ||
        string_pos("caca", _obj_name) > 0) {
        return "aereo";
    }
    
    // === UNIDADES TERRESTRES (padrão) ===
    // Tanques, infantaria, defesa antiaérea, etc.
    return "terrestre";
}

/// @function scr_obter_tipo_unidade_terreno_por_obj(_object_index)
/// @description Retorna tipo de terreno por object_index
/// @param {int} _object_index - Índice do objeto
/// @returns {string} "terrestre", "naval" ou "aereo"

function scr_obter_tipo_unidade_terreno_por_obj(_object_index) {
    if (!object_exists(_object_index)) return "terrestre";
    
    var _obj_name = object_get_name(_object_index);
    
    // === UNIDADES NAVALS ===
    if (string_pos("lancha", _obj_name) > 0 || 
        string_pos("navio", _obj_name) > 0 || 
        string_pos("submarino", _obj_name) > 0 ||
        string_pos("Constellation", _obj_name) > 0 ||
        string_pos("Independence", _obj_name) > 0 ||
        string_pos("RonaldReagan", _obj_name) > 0 ||
        string_pos("Hendrick", _obj_name) > 0) {
        return "naval";
    }
    
    // === UNIDADES AÉREAS ===
    if (string_pos("f15", _obj_name) > 0 ||
        string_pos("f6", _obj_name) > 0 ||
        string_pos("f5", _obj_name) > 0 ||
        string_pos("su35", _obj_name) > 0 ||
        string_pos("helicoptero", _obj_name) > 0 ||
        string_pos("c100", _obj_name) > 0 ||
        string_pos("caca", _obj_name) > 0) {
        return "aereo";
    }
    
    // === UNIDADES TERRESTRES (padrão) ===
    return "terrestre";
}
