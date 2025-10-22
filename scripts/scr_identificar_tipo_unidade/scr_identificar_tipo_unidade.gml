/// @description Identificar tipo de unidade (terrestre/aérea/naval)
/// @param {real} unidade_id ID da unidade
/// @return {string} Tipo da unidade: "terrestre", "aerea", "naval"
function scr_identificar_tipo_unidade(unidade_id) {
    if (!instance_exists(unidade_id)) {
        return "desconhecido";
    }
    
    // === UNIDADES TERRESTRES ===
    var _unidades_terrestres = [
        obj_infantaria,
        obj_soldado_antiaereo,
        obj_tanque,
        obj_blindado_antiaereo
    ];
    
    // === UNIDADES AÉREAS ===
    var _unidades_aereas = [
        obj_caca_f5,
        obj_helicoptero_militar
    ];
    
    // === UNIDADES NAVAIS ===
    var _unidades_navais = [
        obj_lancha_patrulha,
        obj_Constellation
    ];
    
    // Verificar se é unidade terrestre
    for (var i = 0; i < array_length(_unidades_terrestres); i++) {
        if (unidade_id.object_index == _unidades_terrestres[i]) {
            return "terrestre";
        }
    }
    
    // Verificar se é unidade aérea
    for (var i = 0; i < array_length(_unidades_aereas); i++) {
        if (unidade_id.object_index == _unidades_aereas[i]) {
            return "aerea";
        }
    }
    
    // Verificar se é unidade naval
    for (var i = 0; i < array_length(_unidades_navais); i++) {
        if (unidade_id.object_index == _unidades_navais[i]) {
            return "naval";
        }
    }
    
    return "desconhecido";
}

/// @description Verificar se unidade deve respeitar colisão com edifícios
/// @param {real} unidade_id ID da unidade
/// @return {bool} true se deve respeitar colisão
function scr_unidade_deve_respeitar_colisao_edificios(unidade_id) {
    var _tipo = scr_identificar_tipo_unidade(unidade_id);
    
    // Apenas unidades terrestres respeitam colisão com edifícios
    return (_tipo == "terrestre");
}

/// @description Verificar se unidade pode voar sobre edifícios
/// @param {real} unidade_id ID da unidade
/// @return {bool} true se pode voar sobre edifícios
function scr_unidade_pode_voar_sobre_edificios(unidade_id) {
    var _tipo = scr_identificar_tipo_unidade(unidade_id);
    
    // Unidades aéreas podem voar sobre edifícios
    return (_tipo == "aerea");
}

/// @description Verificar se unidade é naval
/// @param {real} unidade_id ID da unidade
/// @return {bool} true se é unidade naval
function scr_unidade_e_naval(unidade_id) {
    var _tipo = scr_identificar_tipo_unidade(unidade_id);
    
    return (_tipo == "naval");
}
