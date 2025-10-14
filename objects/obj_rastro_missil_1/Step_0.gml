/// STEP EVENT - Rastro de Míssil
/// Efeito visual de curta duração

tempo_vida++;

// Fade out gradual
var progresso = tempo_vida / tempo_vida_maximo;
image_alpha = 0.3 * (1.0 - progresso);

// Destruir quando terminar
if (tempo_vida >= tempo_vida_maximo) {
    instance_destroy();
}
