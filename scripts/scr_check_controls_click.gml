// Função para verificar clique nos controles
function check_controls_click() {
    var controls_y = video_y + video_height - 50;
    var button_width = 60;
    var button_height = 30;
    var spacing = 10;
    
    if (mouse_x >= video_x + 20 && mouse_x <= video_x + 20 + button_width &&
        mouse_y >= controls_y && mouse_y <= controls_y + button_height) {
        toggle_play_pause();
        return true;
    }
    
    if (mouse_x >= video_x + 20 + button_width + spacing && 
        mouse_x <= video_x + 20 + button_width + spacing + button_width &&
        mouse_y >= controls_y && mouse_y <= controls_y + button_height) {
        stop_video();
        return true;
    }
    
    return false;
}
