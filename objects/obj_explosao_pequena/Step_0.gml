/// STEP EVENT - Explosão Pequena
/// Efeito visual de curta duração

tempo_vida++;

// Animar escala
var progresso = tempo_vida / tempo_vida_maximo;
image_scale = escala_inicial + (escala_final - escala_inicial) * progresso;

// Animar alpha (fade out)
image_alpha = 1.0 - progresso;

// Destruir quando terminar
if (tempo_vida >= tempo_vida_maximo) {
    instance_destroy();
}
