/// @description Toggle Música - Pausa/Despausa
// Alternar estado da música
musica_tocando = !musica_tocando;

if (musica_tocando) {
    // RETOMAR música
    var _sound_index = asset_get_index("iniciar");
    if (_sound_index != -1) {
        audio_play_sound(iniciar, 1, true); // true = loop
        show_debug_message("🎵 Música RETOMADA");
    }
} else {
    // PAUSAR música
    audio_stop_sound(iniciar);
    show_debug_message("🔇 Música PAUSADA");
}
