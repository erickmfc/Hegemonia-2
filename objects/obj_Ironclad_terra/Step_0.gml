// Efeito de fumaça
if (irandom(2) == 0)
    instance_create_layer(x - lengthdir_x(10, direction), y - lengthdir_y(10, direction), "Efeitos", obj_fumaca_missil);

// Busca alvo terrestre
if (instance_exists(obj_veiculo_inimigo)) {
    if (target == noone) target = instance_nearest(x, y, obj_veiculo_inimigo);
    if (instance_exists(target)) {
        var ang = point_direction(x, y, target.x, target.y);
        direction = lerp(direction, ang, 0.03); // Movimentação mais pesada
    }
}

// Movimento + gravidade
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction) + gravity;
