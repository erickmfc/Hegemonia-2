// Evento Mouse Left Pressed - Controles do player de vídeo

// Verificar se o clique foi na área do player
if (mouse_x >= video_x && mouse_x <= video_x + video_width &&
    mouse_y >= video_y && mouse_y <= video_y + video_height) {
    
    // Mostrar controles
    show_controls = true;
    controls_timer = controls_show_time;
    
    // Verificar clique nos controles
    if (check_controls_click()) {
        // Controle foi clicado, função já foi executada
        return;
    }
    
    // Se clicou na área do vídeo, alternar play/pause
    if (mouse_y < video_y + video_height - 60) {
        toggle_play_pause();
    }
}
