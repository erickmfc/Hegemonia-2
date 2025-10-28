// Função para alternar play/pause
function toggle_play_pause() {
    if (video_loaded && !video_error) {
        if (video_playing) {
            if (video_paused) {
                video_paused = false;
                video_play(video_handle);
                show_debug_message("Vídeo retomado");
            } else {
                video_paused = true;
                video_pause(video_handle);
                show_debug_message("Vídeo pausado");
            }
        } else {
            play_video();
        }
    } else {
        show_debug_message("Erro: Vídeo não carregado");
    }
}
