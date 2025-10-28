// Função para reiniciar vídeo
function restart_video() {
    if (video_loaded && !video_error) {
        video_seek(video_handle, 0);
        video_play(video_handle);
    }
    video_current_time = 0;
    video_playing = true;
    video_paused = false;
    show_debug_message("Vídeo reiniciado");
}
