// ===============================================
// HEGEMONIA GLOBAL - STEP EVENT: PARTÍCULA DE FOGO
// Animação da Partícula de Fogo (OTIMIZADO)
// ===============================================

// ✅ OTIMIZAÇÃO: Destruir partículas em zoom muito afastado
var _lod_level = scr_get_lod_level();
if (_lod_level == 0) {
    // Zoom muito afastado - destruir partículas pequenas imediatamente
    instance_destroy();
    exit;
}

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
