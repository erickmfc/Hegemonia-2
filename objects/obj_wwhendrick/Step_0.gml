// ===============================================
// HEGEMONIA GLOBAL - WW-HENDRICK
// Step Event - Sistema limpo baseado no Submarino Base
// ===============================================

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == LanchaState.ATACANDO);

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        exit;
    }
    lod_level = current_lod;
}

// ✅ USAR SISTEMA DO PAI (obj_submarino_base que herda de obj_navio_base)
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === EFEITO DE BOLHAS (Rastro submarino) ===
if (estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO || 
    (estado == LanchaState.ATACANDO && point_distance(x, y, destino_x, destino_y) > 5)) {
    
    if (!variable_instance_exists(id, "timer_bolhas")) {
        timer_bolhas = 0;
    }
    timer_bolhas++;
    
    // Criar bolhas ocasionalmente
    if (timer_bolhas >= 5) {
        timer_bolhas = 0;
        
        // Bolhas atrás do submarino
        var _angulo_tras = image_angle + 180;
        var _dist = 30;
        var _pos_x = x + lengthdir_x(_dist, _angulo_tras);
        var _pos_y = y + lengthdir_y(_dist, _angulo_tras);
        
        // Criar efeito visual de bolha (usando espuma como placeholder)
        if (object_exists(obj_WTrail4)) {
            var _bolha = instance_create_layer(_pos_x, _pos_y, "Instances", obj_WTrail4);
            if (instance_exists(_bolha)) {
                _bolha.timer_duracao = 60;
                _bolha.image_xscale = 0.5 + random(0.3);
                _bolha.image_yscale = 0.5 + random(0.3);
                _bolha.image_alpha = 0.3;
                _bolha.image_blend = make_color_rgb(150, 200, 255); // Azul água
                _bolha.depth = depth + 1;
            }
        }
    }
}
