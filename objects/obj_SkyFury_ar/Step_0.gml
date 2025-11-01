// === Step Event - SkyFury (guiamento ar-ar) ===

// ✅ CORREÇÃO: Efeito de fumaça REDUZIDO (só a cada 10 frames)
// Reduzido para evitar "rastro" excessivo quando usado por soldado anti-aéreo
if (!variable_instance_exists(id, "contador_fumaca")) contador_fumaca = 0;
contador_fumaca++;
if (contador_fumaca >= 10 && irandom(3) == 0) { // Apenas 1 em 3 vezes, a cada 10 frames
    contador_fumaca = 0; // Resetar contador
    
    var _fumaca = instance_create_layer(x - lengthdir_x(8, direction), y - lengthdir_y(8, direction), "Efeitos", obj_fumaca_missil);
    if (instance_exists(_fumaca)) {
        _fumaca.image_angle = direction;
        _fumaca.image_alpha = 0.4; // ✅ Mais transparente para reduzir visibilidade do rastro
    }
}

// Se o alvo não existe mais, explodir e retornar ao pool
if (!instance_exists(target)) {
    if (object_exists(obj_explosao_ar)) {
        var _expl = instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
        if (instance_exists(_expl)) {
            _expl.image_blend = make_color_rgb(255,150,0);
            _expl.image_xscale = 1.2;
            _expl.image_yscale = 1.2;
        }
    }
    scr_return_projectile_to_pool(id);
    exit;
}

// Aquisição de alvo automática (prioridade: F6 > F5 > Helicóptero)
if (target == noone) {
    var _alvo_aereo = noone;
    if (instance_exists(obj_f6)) _alvo_aereo = instance_nearest(x, y, obj_f6);
    else if (instance_exists(obj_caca_f5)) _alvo_aereo = instance_nearest(x, y, obj_caca_f5);
    else if (instance_exists(obj_helicoptero_militar)) _alvo_aereo = instance_nearest(x, y, obj_helicoptero_militar);
    if (instance_exists(_alvo_aereo)) target = _alvo_aereo;
}

// Guiamento e interceptação
if (instance_exists(target)) {
    var _dist = point_distance(x, y, target.x, target.y);
    var _max_track = (variable_instance_exists(id, "distancia_maxima_rastreamento") ? distancia_maxima_rastreamento : 600);

    // Predição simples de posição do alvo
    var _time_to_intercept = (_dist > 0) ? (_dist / max(1, speed)) : 0;
    var _pred_x = target.x;
    var _pred_y = target.y;
    if (variable_instance_exists(target, "velocidade_atual") && target.velocidade_atual > 0) {
        _pred_x += lengthdir_x(target.velocidade_atual * _time_to_intercept, target.direction);
        _pred_y += lengthdir_y(target.velocidade_atual * _time_to_intercept, target.direction);
    }

    var _ang = point_direction(x, y, _pred_x, _pred_y);
    var _turn = (variable_instance_exists(id, "turn_rate") ? turn_rate : 0.18);

    if (_dist <= _max_track) {
        // Redirecionamento para flares do C-100 (se houver)
        if (target.object_index == obj_c100 && variable_instance_exists(target, "modo_evadindo") && target.modo_evadindo) {
            var _best_flare = noone;
            var _best_heat = -999;
            with (obj_fumaca_missil) {
                if (variable_instance_exists(id, "is_flare") && is_flare && variable_instance_exists(id, "dono") && dono == other.id && variable_instance_exists(id, "heat")) {
                    if (heat > _best_heat) {
                        _best_heat = heat;
                        _best_flare = id;
                    }
                }
            }
            if (instance_exists(_best_flare)) {
                _ang = point_direction(x, y, _best_flare.x, _best_flare.y);
            }
        }

        // Aplicar curva suave/agressiva para interceptação
        direction = lerp(direction, _ang, _turn);
    }
}

// Atualizar rotação e mover
image_angle = direction;
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// Impacto por proximidade (97% de acerto)
if (instance_exists(target)) {
    var _radius = (variable_instance_exists(id, "impact_radius") ? impact_radius : max(35, speed));
    if (point_distance(x, y, target.x, target.y) <= _radius) {
        var _hit = false;
        if (variable_instance_exists(target, "vida")) { target.vida -= dano; _hit = true; }
        else if (variable_instance_exists(target, "hp_atual")) { target.hp_atual -= dano; _hit = true; }
        else if (variable_instance_exists(target, "hp")) { target.hp -= dano; _hit = true; }

        if (_hit) {
            if (object_exists(obj_explosao_ar)) instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
            scr_return_projectile_to_pool(id);
            exit;
        }
    }
}

// Timer de vida - usando variáveis já declaradas no Create event
timer_vida_atual--;
if (timer_vida_atual <= 0) {
    if (object_exists(obj_explosao_ar)) instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
    scr_return_projectile_to_pool(id);
}
