// ===============================================
// HEGEMONIA GLOBAL - SCRIPT: LANÇAR MÍSSEIS
// DESABILITADO - Objetos SkyFury_ar e Ironclad_terra foram removidos
// ===============================================

/*
/// @description Lançar míssil ar-ar (SkyFury)
/// @param alvo_aereo Unidade aérea alvo
/// @param dono Quem está lançando
function lancar_missil_ar_ar(alvo_aereo, dono) {
    if (!instance_exists(alvo_aereo) || !instance_exists(dono)) {
        show_debug_message("❌ Erro: Alvo ou dono não existe");
        return noone;
    }
    
    var _missil = instance_create_layer(dono.x, dono.y, "Projetis", SkyFury_ar);
    if (instance_exists(_missil)) {
        _missil.alvo = alvo_aereo;
        _missil.dono = dono;
        _missil.image_angle = point_direction(dono.x, dono.y, alvo_aereo.x, alvo_aereo.y);
        
        show_debug_message("🚁 SkyFury AR lançado contra alvo aéreo!");
        return _missil;
    }
    
    return noone;
}

/// @description Lançar míssil ar-terra (Ironclad)
/// @param alvo_terrestre Unidade terrestre alvo
/// @param dono Quem está lançando
function lancar_missil_ar_terra(alvo_terrestre, dono) {
    if (!instance_exists(alvo_terrestre) || !instance_exists(dono)) {
        show_debug_message("❌ Erro: Alvo ou dono não existe");
        return noone;
    }
    
    var _missil = instance_create_layer(dono.x, dono.y, "Projetis", Ironclad_terra);
    if (instance_exists(_missil)) {
        _missil.alvo = alvo_terrestre;
        _missil.dono = dono;
        _missil.image_angle = point_direction(dono.x, dono.y, alvo_terrestre.x, alvo_terrestre.y);
        
        show_debug_message("🛡️ Ironclad TERRA lançado contra alvo terrestre!");
        return _missil;
    }
    
    return noone;
}

/// @description Lançar míssil automático baseado no tipo de alvo
/// @param alvo Unidade alvo
/// @param dono Quem está lançando
function lancar_missil_automatico(alvo, dono) {
    if (!instance_exists(alvo) || !instance_exists(dono)) {
        show_debug_message("❌ Erro: Alvo ou dono não existe");
        return noone;
    }
    
    // Determinar tipo de alvo
    var _tipo_alvo = "";
    if (alvo.object_index == obj_helicoptero_militar || alvo.object_index == obj_caca_f5) {
        _tipo_alvo = "aereo";
    } else if (alvo.object_index == obj_inimigo || alvo.object_index == obj_lancha_patrulha) {
        _tipo_alvo = "terrestre";
    } else {
        _tipo_alvo = "terrestre"; // Padrão
    }
    
    // Lançar míssil apropriado
    if (_tipo_alvo == "aereo") {
        return lancar_missil_ar_ar(alvo, dono);
    } else {
        return lancar_missil_ar_terra(alvo, dono);
    }
}
*/
