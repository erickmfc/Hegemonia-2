// Movimento simples para teste: seguir destino
var dx = destino_x - x;
var dy = destino_y - y;
var dist = point_distance(x, y, destino_x, destino_y);
if (dist > 2) {
    var dir = point_direction(x, y, destino_x, destino_y);
    x += lengthdir_x(velocidade, dir);
    y += lengthdir_y(velocidade, dir);
    image_angle = dir;
}

// Comportamento de ataque básico se "atira"
if (atira) {
    // _cd já declarado no Create event
    _cd = max(0, _cd - 1);
    // ✅ CORREÇÃO: obj_inimigo removido - buscar apenas obj_infantaria
    var alvo = instance_nearest(x, y, obj_infantaria);
    if (instance_exists(alvo) && point_distance(x, y, alvo.x, alvo.y) <= alcance_ataque) {
        if (_cd <= 0) {
            var b = scr_get_projectile_from_pool(obj_tiro_infantaria, x, y, layer);
            if (instance_exists(b)) {
                b.direction = point_direction(x, y, alvo.x, alvo.y);
                b.speed = 10;
                b.dano = dano_ataque;
                b.image_blend = c_aqua;
                if (variable_instance_exists(b, "timer_vida")) {
                    b.timer_vida = 120;
                }
                _cd = atq_rate;
            }
        }
    }
}
