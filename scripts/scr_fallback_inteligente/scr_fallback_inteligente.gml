/// @function scr_fallback_inteligente(_objeto, _funcao_original, _parametros)
/// @description Sistema de fallback inteligente para funções que podem falhar
/// @param {Asset.GMObject} _objeto Objeto que está tentando executar a função
/// @param {String} _funcao_original Nome da função original que falhou
/// @param {Array} _parametros Array com os parâmetros da função original
/// @return {undefined}

function scr_fallback_inteligente(_objeto, _funcao_original, _parametros) {
    // ===============================================
    // HEGEMONIA GLOBAL - SISTEMA DE FALLBACK INTELIGENTE
    // Sistema de recuperação automática para funções que falham
    // ===============================================
    
    show_debug_message("🔄 Fallback inteligente ativado para: " + _funcao_original);
    
    // Tentar função alternativa baseada no tipo de objeto
    switch (_objeto.object_index) {
        case obj_caca_f5:
            scr_fallback_f5(_funcao_original, _parametros);
            break;
            
        case obj_helicoptero_militar:
            scr_fallback_helicoptero(_funcao_original, _parametros);
            break;
            
        case obj_lancha_patrulha:
            scr_fallback_naval(_funcao_original, _parametros);
            break;
            
        default:
            scr_fallback_generico(_funcao_original, _parametros);
            break;
    }
}

/// @function scr_fallback_f5(_funcao, _parametros)
/// @description Fallback específico para F-5
/// @param {String} _funcao Nome da função que falhou
/// @param {Array} _parametros Parâmetros da função
/// @return {undefined}

function scr_fallback_f5(_funcao, _parametros) {
    show_debug_message("✈️ Fallback F-5 para função: " + _funcao);
    
    switch (_funcao) {
        case "scr_mover_aviao":
            // Fallback para movimento do F-5
            var _dist = point_distance(x, y, destino_x, destino_y);
            if (_dist > 8) {
                var _dir_alvo = point_direction(x, y, destino_x, destino_y);
                var _diff_ang = angle_difference(_dir_alvo, image_angle);
                image_angle += clamp(_diff_ang, -velocidade_rotacao, velocidade_rotacao);
                velocidade_atual = min(velocidade_maxima, velocidade_atual + aceleracao);
            } else {
                velocidade_atual = max(0, velocidade_atual - desaceleracao);
            }
            x += lengthdir_x(velocidade_atual, image_angle);
            y += lengthdir_y(velocidade_atual, image_angle);
            break;
            
        case "scr_combate_aereo":
            // Fallback para combate
            // ✅ CORREÇÃO: obj_inimigo removido - buscar obj_infantaria inimiga
            if (modo_ataque && altura_voo > 0) {
                var _alvo = noone;
                var _dist_min = 999999;
                with (obj_infantaria) {
                    if (variable_instance_exists(self, "nacao_proprietaria") && nacao_proprietaria != other.nacao_proprietaria) {
                        var _dist_alvo = point_distance(other.x, other.y, x, y);
                        if (_dist_alvo < _dist_min && _dist_alvo <= other.radar_alcance) {
                            _dist_min = _dist_alvo;
                            _alvo = id;
                        }
                    }
                }
                if (instance_exists(_alvo) && point_distance(x, y, _alvo.x, _alvo.y) <= radar_alcance) {
                    var _missil = instance_create_layer(x, y, "Instances", obj_tiro_simples);
                    if (instance_exists(_missil)) {
                        _missil.alvo = _alvo;
                        _missil.dono = id;
                        _missil.dano = 40;
                    }
                }
            }
            break;
            
        default:
            show_debug_message("❌ Fallback F-5 não encontrado para: " + _funcao);
            break;
    }
}

/// @function scr_fallback_helicoptero(_funcao, _parametros)
/// @description Fallback específico para Helicóptero
/// @param {String} _funcao Nome da função que falhou
/// @param {Array} _parametros Parâmetros da função
/// @return {undefined}

function scr_fallback_helicoptero(_funcao, _parametros) {
    show_debug_message("🚁 Fallback Helicóptero para função: " + _funcao);
    
    switch (_funcao) {
        case "scr_mover_helicoptero":
            // Fallback para movimento do helicóptero
            var _dist = point_distance(x, y, destino_x, destino_y);
            if (_dist > 10) {
                var _dir_alvo = point_direction(x, y, destino_x, destino_y);
                var _diff_ang = angle_difference(_dir_alvo, image_angle);
                image_angle += clamp(_diff_ang, -2.0, 2.0);
                velocidade_atual = min(3.0, velocidade_atual + 0.08);
            } else {
                velocidade_atual = max(0, velocidade_atual - 0.1);
            }
            x += lengthdir_x(velocidade_atual, image_angle);
            y += lengthdir_y(velocidade_atual, image_angle);
            break;
            
        default:
            show_debug_message("❌ Fallback Helicóptero não encontrado para: " + _funcao);
            break;
    }
}

/// @function scr_fallback_naval(_funcao, _parametros)
/// @description Fallback específico para unidades navais
/// @param {String} _funcao Nome da função que falhou
/// @param {Array} _parametros Parâmetros da função
/// @return {undefined}

function scr_fallback_naval(_funcao, _parametros) {
    show_debug_message("🚢 Fallback Naval para função: " + _funcao);
    
    switch (_funcao) {
        case "scr_mover_naval":
            // Fallback para movimento naval
            var _dist = point_distance(x, y, destino_x, destino_y);
            if (_dist > 15) {
                var _dir_alvo = point_direction(x, y, destino_x, destino_y);
                var _diff_ang = angle_difference(_dir_alvo, image_angle);
                image_angle += clamp(_diff_ang, -1.5, 1.5);
                velocidade_atual = min(2.5, velocidade_atual + 0.06);
            } else {
                velocidade_atual = max(0, velocidade_atual - 0.08);
            }
            x += lengthdir_x(velocidade_atual, image_angle);
            y += lengthdir_y(velocidade_atual, image_angle);
            break;
            
        default:
            show_debug_message("❌ Fallback Naval não encontrado para: " + _funcao);
            break;
    }
}

/// @function scr_fallback_generico(_funcao, _parametros)
/// @description Fallback genérico para qualquer objeto
/// @param {String} _funcao Nome da função que falhou
/// @param {Array} _parametros Parâmetros da função
/// @return {undefined}

function scr_fallback_generico(_funcao, _parametros) {
    show_debug_message("🔧 Fallback Genérico para função: " + _funcao);
    
    // Fallback genérico - apenas log do erro
    show_debug_message("⚠️ Função não encontrada: " + _funcao);
    show_debug_message("📋 Parâmetros: " + string(_parametros));
    
    // Tentar recuperação básica
    if (variable_instance_exists(id, "estado")) {
        estado = "parado";
        show_debug_message("🔄 Estado resetado para 'parado'");
    }
}