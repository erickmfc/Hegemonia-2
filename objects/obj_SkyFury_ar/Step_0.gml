// Efeito de fumaça
if (irandom(2) == 0)
    instance_create_layer(x - lengthdir_x(8, direction), y - lengthdir_y(8, direction), "Efeitos", obj_fumaca_missil);

// Busca alvo aéreo
if (instance_exists(obj_aviao_inimigo)) {
    if (target == noone) target = instance_nearest(x, y, obj_aviao_inimigo);
    if (instance_exists(target)) {
        var ang = point_direction(x, y, target.x, target.y);
        direction = lerp(direction, ang, 0.05); // Suave
    }
}

// Movimento
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);
