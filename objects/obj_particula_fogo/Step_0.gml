// ===============================================
// HEGEMONIA GLOBAL - STEP EVENT: PARTÍCULA DE FOGO
// Animação da Partícula de Fogo
// ===============================================

tempo_vida++;

// === MOVIMENTO ===
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// === DECAIMENTO ===
speed *= velocidade_decaimento;
image_alpha -= 0.03;

// === DESTRUIÇÃO ===
if (tempo_vida >= tempo_vida_maximo || image_alpha <= 0) {
    instance_destroy();
}
