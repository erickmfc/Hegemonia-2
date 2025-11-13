/// @description Create - Avião Morto
// Duração em segundos antes de desaparecer
tempo_vida = 10.0; // 10 segundos
tempo_restante = tempo_vida * game_get_speed(gamespeed_fps); // Converter para frames

// Opcional: Efeito de fade out gradual
fade_out_iniciado = false;
fade_out_tempo = 2.0; // Últimos 2 segundos com fade out
fade_out_frames = fade_out_tempo * game_get_speed(gamespeed_fps);

// Alpha inicial
image_alpha = 1.0;
