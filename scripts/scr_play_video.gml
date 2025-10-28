// Função para reproduzir vídeo
function play_video() {
    if (video_loaded && !video_error) {
        video_playing = true;
        video_paused = false;
        video_play(video_handle);
        show_debug_message("Vídeo iniciado");
    } else {
        show_debug_message("Erro: Vídeo não carregado");
    }
}
