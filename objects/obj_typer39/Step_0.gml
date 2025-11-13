// ===============================================
// HEGEMONIA GLOBAL - OBJ_TYPER39
// Step Event - Guiamento Anti-Aéreo (Baseado no SkyFury)
// ===============================================

// === EFEITO DE FUMACA REMOVIDO ===
// ✅ CORREÇÃO: Rastro removido completamente - míssil sem rastro de fogo
// (Código removido para eliminar o rastro)

// === VERIFICAÇÃO DE ALVO ===
// Usar target (como SkyFury) ou alvo (compatibilidade)
var _alvo_atual = (target != noone && instance_exists(target)) ? target : alvo;

if (_alvo_atual == noone || !instance_exists(_alvo_atual)) {
    // Alvo não existe mais, retornar ao pool (SEM EXPLOSÃO)
    scr_return_projectile_to_pool(id);
    exit;
}

// === GUIAMENTO E INTERCEPTAÇÃO (baseado no SkyFury) ===
var _dist = point_distance(x, y, _alvo_atual.x, _alvo_atual.y);
var _max_track = 1600; // Alcance máximo de rastreamento

// Predição de posição do alvo
var _time_to_intercept = (_dist > 0) ? (_dist / max(1, speed)) : 0;
var _pred_x = _alvo_atual.x;
var _pred_y = _alvo_atual.y;

// Se o alvo tem velocidade, prever posição futura
if (variable_instance_exists(_alvo_atual, "velocidade_atual") && _alvo_atual.velocidade_atual > 0) {
    var _dir_alvo = 0;
    if (variable_instance_exists(_alvo_atual, "direction")) {
        _dir_alvo = _alvo_atual.direction;
    } else if (variable_instance_exists(_alvo_atual, "image_angle")) {
        _dir_alvo = _alvo_atual.image_angle;
    }
    _pred_x += lengthdir_x(_alvo_atual.velocidade_atual * _time_to_intercept, _dir_alvo);
    _pred_y += lengthdir_y(_alvo_atual.velocidade_atual * _time_to_intercept, _dir_alvo);
}

// Calcular direção para posição predita
var _ang = point_direction(x, y, _pred_x, _pred_y);
var _turn = (variable_instance_exists(id, "turn_rate") ? turn_rate : 0.25);

if (_dist <= _max_track) {
    // ✅ CORREÇÃO: Usar lerp como SkyFury para curva suave
    if (!variable_instance_exists(id, "direction") || direction == 0) {
        direction = _ang;
    } else {
        direction = lerp(direction, _ang, _turn);
    }
}

// Atualizar rotação e mover
image_angle = direction;
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// === IMPACTO POR PROXIMIDADE ===
if (instance_exists(_alvo_atual)) {
    var _radius = (variable_instance_exists(id, "impact_radius") ? impact_radius : 50);
    if (point_distance(x, y, _alvo_atual.x, _alvo_atual.y) <= _radius) {
        var _hit = false;
        if (variable_instance_exists(_alvo_atual, "vida")) { 
            _alvo_atual.vida -= dano; 
            _hit = true; 
        } else if (variable_instance_exists(_alvo_atual, "hp_atual")) { 
            _alvo_atual.hp_atual -= dano; 
            _hit = true; 
        } else if (variable_instance_exists(_alvo_atual, "hp")) { 
            _alvo_atual.hp -= dano; 
            _hit = true; 
        }

        if (_hit) {
            // ✅ EXPLOSÃO REMOVIDA: Míssil apenas aplica dano e desaparece
            // ✅ CRÍTICO: Desativar e destruir imediatamente após acertar
            visible = false;
            image_alpha = 0;
            speed = 0;
            hspeed = 0;
            vspeed = 0;
            
            // ✅ CRÍTICO: Tentar retornar ao pool primeiro, se falhar, destruir diretamente
            var _pool_mgr = instance_find(obj_projectile_pool_manager, 0);
            if (instance_exists(_pool_mgr) && _pool_mgr.pool_enabled) {
                instance_deactivate_object(id);
                scr_return_projectile_to_pool(id);
            } else {
                // Pool não disponível - destruir diretamente
                instance_destroy(id);
            }
            exit;
        }
    }
}

// === TIMER DE VIDA ===
if (!variable_instance_exists(id, "timer_vida_atual")) {
    timer_vida_atual = timer_vida_maximo;
}
timer_vida_atual--;
if (timer_vida_atual <= 0) {
    // ✅ EXPLOSÃO REMOVIDA: Míssil apenas desaparece quando timer expira
    scr_return_projectile_to_pool(id);
}
