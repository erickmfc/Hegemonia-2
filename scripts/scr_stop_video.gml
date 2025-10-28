// Função para parar vídeo
function stop_video() {
    if (video_loaded && !video_error) {
        video_pause(video_handle);
        video_seek(video_handle, 0);
    }
    video_playing = false;
    video_paused = false;
    video_current_time = 0;
    show_debug_message("Vídeo parado");
}
