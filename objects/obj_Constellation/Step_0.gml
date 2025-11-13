// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION
// Step Event - Herda 100% da lógica do obj_navio_base
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

// ✅ CORREÇÃO GM2040: Chamar o Step do objeto pai com verificação
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// ✅ EFEITO DE ESPUMA DO MAR (Rastro de água) - Constellation
// Adicionar após herdar para garantir que o movimento já foi processado
if (estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO || (estado == LanchaState.ATACANDO && point_distance(x, y, destino_x, destino_y) > 5)) {
    if (!variable_instance_exists(id, "timer_espuma")) {
        timer_espuma = 0;
    }
    timer_espuma++;
    if (timer_espuma >= 3) {
        timer_espuma = 0;
        var _distancia_popa = 20;
        var _angulo_popa = image_angle + 180;
        var _layer_navio = layer_get_name(layer);
        
        // obj_WTrail4 no MEIO do navio
        if (object_exists(obj_WTrail4)) {
            var _pos_espuma_x = x;
            var _pos_espuma_y = y;
            var _espuma = noone;
            if (layer_exists(_layer_navio)) {
                _espuma = instance_create_layer(_pos_espuma_x, _pos_espuma_y, _layer_navio, obj_WTrail4);
            }
            if (!instance_exists(_espuma) && layer_exists("Instances")) {
                _espuma = instance_create_layer(_pos_espuma_x, _pos_espuma_y, "Instances", obj_WTrail4);
            }
            if (instance_exists(_espuma)) {
                _espuma.timer_duracao = 90;
                _espuma.timer_atual = 0;
                if (_espuma.sprite_index == -1) {
                    _espuma.sprite_index = asset_get_index("WTrail4");
                }
                _espuma.image_xscale = 1.0 + random(0.4);
                _espuma.image_yscale = 1.0 + random(0.4);
                _espuma.image_blend = c_white;
                _espuma.visible = true;
                _espuma.image_alpha = 0.2;
                if (variable_instance_exists(id, "depth")) {
                    _espuma.depth = depth + 1;
                } else {
                    _espuma.depth = -100;
                }
                _espuma.image_angle = image_angle + random_range(-5, 5);
            }
        }
        
        // ✅ obj_WbTrail1 no FINAL do navio (popa) - Constellation: sprite 290px, origem 145px, distância ~136px
        if (object_exists(obj_WbTrail1)) {
            var _distancia_final = 136; // 290px * 0.47 ≈ 136px (proporção baseada na lancha patrulha)
            var _pos_popa_x = x + lengthdir_x(_distancia_final, _angulo_popa);
            var _pos_popa_y = y + lengthdir_y(_distancia_final, _angulo_popa);
            var _trail_popa = noone;
            if (layer_exists(_layer_navio)) {
                _trail_popa = instance_create_layer(_pos_popa_x, _pos_popa_y, _layer_navio, obj_WbTrail1);
            }
            if (!instance_exists(_trail_popa) && layer_exists("Instances")) {
                _trail_popa = instance_create_layer(_pos_popa_x, _pos_popa_y, "Instances", obj_WbTrail1);
            }
            if (instance_exists(_trail_popa)) {
                _trail_popa.timer_duracao = 90;
                _trail_popa.timer_atual = 0;
                _trail_popa.image_xscale = 3.0 * 0.8; // 80% do tamanho
                _trail_popa.image_yscale = 3.0 * 0.8;
                _trail_popa.image_alpha = 0.2; // Mesma transparência do trail4
                _trail_popa.image_blend = c_white;
                _trail_popa.visible = true;
                if (variable_instance_exists(id, "depth")) {
                    _trail_popa.depth = depth + 1;
                } else {
                    _trail_popa.depth = -100;
                }
                _trail_popa.image_angle = image_angle + random_range(-5, 5);
            }
        }
    }
}

// As variáveis de instância (ultima_acao, cor_feedback, feedback_timer) 
// já foram inicializadas no Create Event, não precisam ser redeclaradas aqui