/// @description Menu Principal - Inicia música de fundo
// Tocar música do menu em loop infinito
var _sound_index = asset_get_index("iniciar");

if (_sound_index != -1) {
    audio_play_sound(iniciar, 1, true); // true = loop infinito
    show_debug_message("🎵 Música do menu iniciada");
} else {
    show_debug_message("⚠️ Erro: Música 'iniciar' não encontrada!");
}
