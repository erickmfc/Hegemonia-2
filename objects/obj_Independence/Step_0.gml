// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE
// Step Event - Sistema limpo baseado na Lancha
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

// ✅ USAR SISTEMA DO PAI (obj_navio_base que já tem navegação da Lancha)
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// ✅ DECREMENTAR TIMERS DE MÍSSEIS MÚLTIPLOS (Hash, Sky, Lit)
if (variable_instance_exists(id, "timer_sky") && timer_sky > 0) timer_sky--;
if (variable_instance_exists(id, "timer_hash") && timer_hash > 0) timer_hash--;
if (variable_instance_exists(id, "timer_lit") && timer_lit > 0) timer_lit--;

// === EFEITO DE ESPUMA DO MAR (Rastro de água) ===
if (estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO || 
    (estado == LanchaState.ATACANDO && point_distance(x, y, destino_x, destino_y) > 5)) {
    
    if (!variable_instance_exists(id, "timer_espuma")) {
        timer_espuma = 0;
    }
    timer_espuma++;
    
    if (timer_espuma >= 3) {
        timer_espuma = 0;
        var _angulo_popa = image_angle + 180;
        
        // Rastro no meio
        if (object_exists(obj_WTrail4)) {
            var _espuma = instance_create_layer(x, y, "Instances", obj_WTrail4);
            if (instance_exists(_espuma)) {
                _espuma.timer_duracao = 90;
                _espuma.image_xscale = 1.0 + random(0.4);
                _espuma.image_yscale = 1.0 + random(0.4);
                _espuma.image_alpha = 0.2;
                _espuma.depth = depth + 1;
                _espuma.image_angle = image_angle; // ✅ Rastro sempre virado para a proa
            }
        }
        
        // Rastro na popa
        if (object_exists(obj_WbTrail1)) {
            var _dist_popa = 136;
            var _pos_x = x + lengthdir_x(_dist_popa, _angulo_popa);
            var _pos_y = y + lengthdir_y(_dist_popa, _angulo_popa);
            var _trail = instance_create_layer(_pos_x, _pos_y, "Instances", obj_WbTrail1);
            if (instance_exists(_trail)) {
                _trail.timer_duracao = 90;
                _trail.image_xscale = 2.4;
                _trail.image_yscale = 2.4;
                _trail.image_alpha = 0.2;
                _trail.depth = depth + 1;
                _trail.image_angle = image_angle; // ✅ Rastro sempre virado para a proa
            }
        }
    }
}
