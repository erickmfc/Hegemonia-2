/// @description Step - Avião Morto
// Decrementar tempo restante
tempo_restante--;

// Verificar se deve iniciar fade out
if (tempo_restante <= fade_out_frames && !fade_out_iniciado) {
    fade_out_iniciado = true;
}

// Aplicar fade out gradual
if (fade_out_iniciado) {
    var _progresso = 1.0 - (tempo_restante / fade_out_frames);
    image_alpha = 1.0 - _progresso;
}

// Destruir quando tempo acabar
if (tempo_restante <= 0) {
    instance_destroy();
}

