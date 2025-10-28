// Evento Draw - Desenhar interface do player de vídeo

// Desenhar fundo do player
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(video_x, video_y, video_x + video_width, video_y + video_height, false);
draw_set_alpha(1);

// Desenhar borda
draw_set_color(c_white);
draw_set_alpha(0.5);
draw_rectangle(video_x, video_y, video_x + video_width, video_y + video_height, true);
draw_set_alpha(1);

// Desenhar área do vídeo
if (video_loaded && !video_error) {
    // Desenhar o vídeo real
    video_draw();
} else {
    // Desenhar área simulada se vídeo não carregado
    draw_set_color(c_dkgray);
    draw_rectangle(video_x + 10, video_y + 10, video_x + video_width - 10, video_y + video_height - 60, false);
    
    // Mostrar mensagem de erro se houver
    if (video_error) {
        draw_set_color(c_red);
        draw_text(video_x + video_width/2, video_y + video_height/2, "ERRO: " + error_message);
    }
}

// Desenhar texto de status
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Status do vídeo
var status_text = "";
if (video_playing && !video_paused) {
    status_text = "REPRODUZINDO";
    draw_set_color(c_lime);
} else if (video_paused) {
    status_text = "PAUSADO";
    draw_set_color(c_yellow);
} else {
    status_text = "PARADO";
    draw_set_color(c_red);
}

draw_text(video_x + video_width/2, video_y + video_height/2 - 20, status_text);

// Informações do vídeo
draw_set_color(c_white);
var time_text = "Tempo: " + string_format(video_current_time, 1, 2) + "s";
if (video_duration > 0) {
    time_text += " / " + string_format(video_duration, 1, 2) + "s";
}
draw_text(video_x + video_width/2, video_y + video_height/2 + 10, time_text);

// Volume
var volume_text = "Volume: " + string(video_volume * 100) + "%";
draw_text(video_x + video_width/2, video_y + video_height/2 + 30, volume_text);

// Desenhar controles se visíveis
if (show_controls) {
    scr_draw_controls();
}

// Resetar alinhamento
draw_set_halign(fa_left);
draw_set_valign(fa_top);
