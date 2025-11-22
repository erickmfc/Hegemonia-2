/// @description Create - Avião Morto (sprite no chão por alguns segundos)
// ✅ NOVO: Duração configurável (padrão: 3-5 segundos, pode ser sobrescrito)
if (!variable_instance_exists(id, "tempo_vida")) {
    tempo_vida = 4.0; // 4 segundos (padrão - "alguns poucos segundos")
}
tempo_restante = tempo_vida * game_get_speed(gamespeed_fps); // Converter para frames

// ✅ NOVO: Efeito de fade out gradual nos últimos segundos
fade_out_iniciado = false;
fade_out_tempo = 1.0; // Último 1 segundo com fade out
fade_out_frames = fade_out_tempo * game_get_speed(gamespeed_fps);

// Alpha inicial
image_alpha = 1.0;

// ✅ NOVO: Garantir que o sprite fique no chão (sem altitude)
if (variable_instance_exists(id, "altitude_voo")) {
    altitude_voo = 0;
}
if (variable_instance_exists(id, "altura_voo")) {
    altura_voo = 0;
}
