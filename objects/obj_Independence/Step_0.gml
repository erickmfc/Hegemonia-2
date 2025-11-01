/// @description Step Event 0 - Sistema Base da Independence
// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE
// Desabilita sistema de mísseis do obj_navio_base
// Independence usa sistema próprio de mísseis múltiplos no Step_1
// ===============================================

// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == LanchaState.ATACANDO);

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO) {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade_movimento, speed_mult);
                if (!still_moving && estado == LanchaState.MOVENDO) {
                    estado = LanchaState.PARADO;
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}

// DESABILITAR sistema de mísseis do obj_navio_base ANTES de herdar
// Isso evita que obj_navio_base dispare mísseis, pois o Step_1.gml gerencia isso de forma múltipla
pode_disparar_missil = false;

// ✅ CORREÇÃO GM2040: Chamar o Step do objeto pai com verificação
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// As variáveis de instância (metralhadora_ativa, metralhadora_timer, etc) 
// já foram inicializadas no Create Event, não precisam ser redeclaradas aqui
