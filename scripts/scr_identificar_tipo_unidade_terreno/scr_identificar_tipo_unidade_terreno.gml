// ===============================================
// HEGEMONIA GLOBAL - IDENTIFICAÇÃO DE TIPO DE UNIDADE POR TERRENO
// Função centralizada para identificar terrenos permitidos baseado no tipo de unidade
// ===============================================

/// @function scr_identificar_tipo_unidade_terreno(_unidade_id)
/// @description Identifica os terrenos permitidos para uma unidade baseado no seu tipo
/// @param {id} _unidade_id - ID da unidade
/// @returns {array} Array de enums TERRAIN permitidos para a unidade

function scr_identificar_tipo_unidade_terreno(_unidade_id) {
    if (!instance_exists(_unidade_id)) {
        return []; // Retornar array vazio se unidade não existe
    }
    
    // Se unidade já tem terrenos_permitidos definidos, usar esses
    if (variable_instance_exists(_unidade_id, "terrenos_permitidos")) {
        return _unidade_id.terrenos_permitidos;
    }
    
    // Identificar tipo baseado no nome do objeto
    var _obj_name = object_get_name(_unidade_id.object_index);
    var _terrenos_permitidos = [];
    
    // ✅ NAVIOS E SUBMARINOS: Só água
    if (string_pos("lancha", _obj_name) > 0 || 
        string_pos("navio", _obj_name) > 0 || 
        string_pos("submarino", _obj_name) > 0 ||
        string_pos("Constellation", _obj_name) > 0 ||
        string_pos("Independence", _obj_name) > 0 ||
        string_pos("RonaldReagan", _obj_name) > 0 ||
        string_pos("Hendrick", _obj_name) > 0 ||
        string_pos("fragata", _obj_name) > 0 ||
        string_pos("destroyer", _obj_name) > 0) {
        _terrenos_permitidos = [TERRAIN.AGUA];
    }
    // ✅ AVIÕES E HELICÓPTEROS: Podem voar sobre qualquer terreno, mas só pousam em terra
    else if (string_pos("c100", _obj_name) > 0 ||
             string_pos("f15", _obj_name) > 0 ||
             string_pos("f22", _obj_name) > 0 ||
             string_pos("f5", _obj_name) > 0 ||
             string_pos("f6", _obj_name) > 0 ||
             string_pos("aviao", _obj_name) > 0 ||
             string_pos("helicoptero", _obj_name) > 0 ||
             string_pos("SkyFury", _obj_name) > 0 ||
             string_pos("su35", _obj_name) > 0 ||
             string_pos("raptor", _obj_name) > 0) {
        // Aviões podem pousar em terra (não em água)
        _terrenos_permitidos = [TERRAIN.CAMPO, TERRAIN.FLORESTA, TERRAIN.DESERTO];
    }
    // ✅ TANQUES E BLINDADOS: Terra e deserto (não floresta)
    else if (string_pos("tanque", _obj_name) > 0 || 
             string_pos("M1A", _obj_name) > 0 ||
             string_pos("blindado", _obj_name) > 0 ||
             string_pos("Gepard", _obj_name) > 0) {
        _terrenos_permitidos = [TERRAIN.CAMPO, TERRAIN.DESERTO];
    }
    // ✅ OUTRAS UNIDADES TERRESTRES: Terra, deserto, floresta
    else {
        _terrenos_permitidos = [TERRAIN.CAMPO, TERRAIN.FLORESTA, TERRAIN.DESERTO];
    }
    
    return _terrenos_permitidos;
}

/// @function scr_unidade_eh_naval(_unidade_id)
/// @description Verifica se unidade é naval
/// @param {id} _unidade_id - ID da unidade
/// @returns {bool} True se é naval

function scr_unidade_eh_naval(_unidade_id) {
    if (!instance_exists(_unidade_id)) return false;
    
    var _terrenos = scr_identificar_tipo_unidade_terreno(_unidade_id);
    return (array_length(_terrenos) == 1 && _terrenos[0] == TERRAIN.AGUA);
}

/// @function scr_unidade_eh_terrestre(_unidade_id)
/// @description Verifica se unidade é terrestre
/// @param {id} _unidade_id - ID da unidade
/// @returns {bool} True se é terrestre

function scr_unidade_eh_terrestre(_unidade_id) {
    if (!instance_exists(_unidade_id)) return false;
    
    var _terrenos = scr_identificar_tipo_unidade_terreno(_unidade_id);
    // Terrestres não podem estar apenas em água
    for (var i = 0; i < array_length(_terrenos); i++) {
        if (_terrenos[i] != TERRAIN.AGUA) {
            return true; // Tem pelo menos um terreno que não é água
        }
    }
    return false;
}

