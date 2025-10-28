// Função para definir volume
function set_volume(vol) {
    video_volume = clamp(vol, 0.0, 1.0);
    if (video_loaded && !video_error) {
        video_set_volume(video_handle, video_volume);
    }
    show_debug_message("Volume: " + string(video_volume * 100) + "%");
}
