// ===============================================
// HEGEMONIA GLOBAL - STEP EVENT: PARTÍCULA DE TERRA
// Animação da Partícula de Terra
// ===============================================

tempo_vida++;

// === MOVIMENTO ===
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// === DECAIMENTO ===
speed *= velocidade_decaimento;
image_alpha -= 0.025;

// === DESTRUIÇÃO ===
if (tempo_vida >= tempo_vida_maximo || image_alpha <= 0) {
    instance_destroy();
}
