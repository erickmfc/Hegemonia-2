// Função para desenhar controles
function draw_controls() {
    var controls_y = video_y + video_height - 50;
    var button_width = 60;
    var button_height = 30;
    var spacing = 10;
    
    // Botão Play/Pause
    var play_x = video_x + 20;
    var play_text = video_playing && !video_paused ? "PAUSE" : "PLAY";
    
    draw_set_color(c_blue);
    draw_rectangle(play_x, controls_y, play_x + button_width, controls_y + button_height, false);
    draw_set_color(c_white);
    draw_text(play_x + button_width/2, controls_y + button_height/2, play_text);
    
    // Botão Stop
    var stop_x = play_x + button_width + spacing;
    draw_set_color(c_red);
    draw_rectangle(stop_x, controls_y, stop_x + button_width, controls_y + button_height, false);
    draw_set_color(c_white);
    draw_text(stop_x + button_width/2, controls_y + button_height/2, "STOP");
    
    // Instruções
    var inst_x = stop_x + button_width + spacing;
    draw_set_color(c_white);
    draw_text(inst_x, controls_y + 5, "ESPAÇO: Play/Pause | ESC: Stop");
    draw_text(inst_x, controls_y + 20, "+/-: Volume");
}
