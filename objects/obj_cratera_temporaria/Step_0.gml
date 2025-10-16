// ===============================================
// HEGEMONIA GLOBAL - STEP EVENT: CRATERA TEMPORÁRIA
// Animação da Cratera Temporária
// ===============================================

tempo_vida++;

// === DECAIMENTO DE ALPHA ===
image_alpha -= alpha_decaimento;

// === DESTRUIÇÃO ===
if (tempo_vida >= tempo_vida_maximo || image_alpha <= 0) {
    instance_destroy();
}
