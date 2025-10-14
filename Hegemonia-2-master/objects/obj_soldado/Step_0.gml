// ================================================
// HEGEMONIA GLOBAL - OBJETO: SOLDADO
// Step Event - IA do Soldado
// ================================================

// === REDUZ COOLDOWN ===
if (atq_cooldown > 0) atq_cooldown--;

// === PROCURAR INIMIGOS SE NÃO TEM ALVO ===
if (alvo == noone || !instance_exists(alvo)) {
    var inst = instance_nearest(x, y, obj_inimigo_soldado);
    if (inst != noone) {
        if (point_distance(x, y, inst.x, inst.y) < alcance_visao) {
            alvo = inst;
        }
    }
}

// === SE TEM ALVO VÁLIDO ===
if (alvo != noone && instance_exists(alvo)) {
    var dist = point_distance(x, y, alvo.x, alvo.y);

    // Dentro do alcance → ataca
    if (dist <= alcance_tiro) {
        if (atq_cooldown <= 0) {
            var b = instance_create_layer(x, y, "Bullets", obj_bala);
            b.direction = point_direction(x, y, alvo.x, alvo.y);
            b.speed = 8;
            b.dano = dano;
            atq_cooldown = game_get_speed(gamespeed_fps); // 1 tiro por segundo
        }
    }
    // Fora do alcance → anda até o inimigo
    else {
        mp_potential_step(alvo.x, alvo.y, velocidade, false);
    }
}
