// Evento Step - Atualização contínua do player de vídeo

// Controle de timer dos controles
if (controls_timer > 0) {
    controls_timer -= 1/60; // Assumindo 60 FPS
    if (controls_timer <= 0) {
        show_controls = false;
    }
}

// Controles de teclado
if (keyboard_check_pressed(key_play_pause)) {
    toggle_play_pause();
}

if (keyboard_check_pressed(key_stop)) {
    stop_video();
}

if (keyboard_check_pressed(key_volume_up)) {
    set_volume(video_volume + 0.1);
}

if (keyboard_check_pressed(key_volume_down)) {
    set_volume(video_volume - 0.1);
}

// Atualizar tempo do vídeo se estiver reproduzindo
if (video_playing && !video_paused && video_loaded) {
    video_current_time = video_get_time(video_handle);
    
    // Verificar se o vídeo terminou
    if (video_duration > 0 && video_current_time >= video_duration) {
        if (video_loop) {
            restart_video();
        } else {
            stop_video();
        }
    }
}

// Mostrar controles quando o mouse se move
if (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right)) {
    show_controls = true;
    controls_timer = controls_show_time;
}
