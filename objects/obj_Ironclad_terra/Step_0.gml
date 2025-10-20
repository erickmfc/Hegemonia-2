// Efeito de fumaça
if (irandom(2) == 0) {
    var _fumaca = instance_create_layer(x - lengthdir_x(10, direction), y - lengthdir_y(10, direction), "Efeitos", obj_fumaca_missil);
    if (instance_exists(_fumaca)) {
        _fumaca.image_angle = direction; // Rastro segue a direção do míssil
    }
}

// Se o alvo não existir mais, destruir o míssil
if (!instance_exists(target)) {
    instance_destroy();
    exit;
}

// Aquisição/Manutenção de alvo (fallback se não veio setado)
if (target == noone && instance_exists(obj_inimigo)) {
    target = instance_nearest(x, y, obj_inimigo);
}

// Detectar se o alvo está parado para garantir 100% de acerto
var alvo_parado = false;
if (instance_exists(target)) {
    if (variable_instance_exists(id, "last_tx")) {
        if (last_tx == target.x && last_ty == target.y) {
            still_frames += 1;
        } else {
            still_frames = 0;
        }
        last_tx = target.x;
        last_ty = target.y;
        alvo_parado = (still_frames >= 6); // ~0.1s a 60fps
    }
}

// Guiamento pesado com ajustes dinâmicos
if (instance_exists(target)) {
    var ang = point_direction(x, y, target.x, target.y);
    var _turn_base = (variable_instance_exists(id, "turn_rate") ? turn_rate : 0.06);
    var _turn = alvo_parado ? max(_turn_base, 0.10) : _turn_base; // curva mais forte se parado
    direction = lerp(direction, ang, _turn);
}

// Rotação da imagem para seguir a direção
image_angle = direction;

// Movimento + gravidade (reduz gravidade se alvo estiver parado para alinhar melhor)
var _grav = alvo_parado ? gravity * 0.5 : gravity;
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction) + _grav;

// Checagem de impacto por proximidade
if (instance_exists(target)) {
    var _radius_base = (variable_instance_exists(id, "impact_radius") ? impact_radius : max(12, speed));
    var _radius = alvo_parado ? max(_radius_base, 22) : _radius_base; // facilita 100% em alvo parado
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
            show_debug_message("💥 Ironclad impactou alvo. Dano: " + string(dano));
        }
        if (object_exists(obj_explosao_terra)) {
            instance_create_layer(x, y, "Efeitos", obj_explosao_terra);
        }
        instance_destroy();
        exit;
    }
}
