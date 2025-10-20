// Efeito de fumaça
if (irandom(2) == 0) {
    var _fumaca = instance_create_layer(x - lengthdir_x(8, direction), y - lengthdir_y(8, direction), "Efeitos", obj_fumaca_missil);
    if (instance_exists(_fumaca)) {
        _fumaca.image_angle = direction; // Rastro segue a direção do míssil
    }
}

// Se o alvo não existir mais, destruir o míssil
if (!instance_exists(target)) {
    instance_destroy();
    exit;
}

// Aquisição de alvo aérea (prioridade F6 > F5 > helicóptero), caso não tenha vindo setado
if (target == noone) {
    var _alvo_aereo = noone;
    if (instance_exists(obj_f6)) {
        _alvo_aereo = instance_nearest(x, y, obj_f6);
    } else if (instance_exists(obj_caca_f5)) {
        _alvo_aereo = instance_nearest(x, y, obj_caca_f5);
    } else if (instance_exists(obj_helicoptero_militar)) {
        _alvo_aereo = instance_nearest(x, y, obj_helicoptero_militar);
    }
    if (instance_exists(_alvo_aereo)) target = _alvo_aereo;
}

// Guiamento ar-ar rápido
if (instance_exists(target)) {
    var ang = point_direction(x, y, target.x, target.y);
    var _turn = (variable_instance_exists(id, "turn_rate") ? turn_rate : 0.14);
    
    // --- REDIRECIONAMENTO PARA FLARES (C-100) ---
    // Se o alvo é um C-100 e está em modo evasivo, procurar flares
    if (target.object_index == obj_c100 && target.modo_evadindo) {
        var _flare_mais_quente = noone;
        var _maior_calor = 0;
        var _menor_distancia = 999999;
        
        // Procurar flares ativos do C-100
        with (obj_fumaca_missil) {
            if (variable_instance_exists(id, "is_flare") && is_flare && 
                variable_instance_exists(id, "dono") && dono == target.id &&
                variable_instance_exists(id, "heat") && heat > _maior_calor) {
                
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= 120) { // Raio de atração dos flares
                    _flare_mais_quente = id;
                    _maior_calor = heat;
                    _menor_distancia = _dist;
                }
            }
        }
        
        // Se encontrou flare, redirecionar para ele
        if (instance_exists(_flare_mais_quente)) {
            ang = point_direction(x, y, _flare_mais_quente.x, _flare_mais_quente.y);
            show_debug_message("🎯 SkyFury redirecionado para flare do C-100");
        }
    }
    
    direction = lerp(direction, ang, _turn); // curva agressiva
}

// Rotação da imagem para seguir a direção
image_angle = direction;

// Movimento
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// Checagem de impacto por proximidade (não depende de colisão)
if (instance_exists(target)) {
    var _radius = (variable_instance_exists(id, "impact_radius") ? impact_radius : max(12, speed));
    if (point_distance(x, y, target.x, target.y) <= _radius) {
        // Aplicar dano seguro
        var _dano_aplicado = false;
        if (variable_instance_exists(target, "vida")) {
            target.vida -= dano;
            _dano_aplicado = true;
        } else if (variable_instance_exists(target, "hp_atual")) {
            target.hp_atual -= dano;
            _dano_aplicado = true;
        } else if (variable_instance_exists(target, "hp")) {
            target.hp -= dano;
            _dano_aplicado = true;
        }
        if (_dano_aplicado) {
            show_debug_message("💥 SkyFury impactou alvo aéreo. Dano: " + string(dano));
        }
        if (object_exists(obj_explosao_ar)) {
            instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
        }
        instance_destroy();
        exit;
    }
}
