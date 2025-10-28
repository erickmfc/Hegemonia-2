// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
function scr_draw_controls() {
    // Desenhar controles básicos do player de vídeo
    // As variáveis são acessadas do objeto que chama (obj_video_player)
    var _controls_y = self.video_y + self.video_height - 50;
    
    // Fundo dos controles
    draw_set_color(c_black);
    draw_set_alpha(self.controls_alpha);
    draw_rectangle(self.video_x, _controls_y, self.video_x + self.video_width, self.video_y + self.video_height, false);
    draw_set_alpha(1);
    
    // Texto dos controles
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(self.video_x + self.video_width/2, _controls_y + 15, "ESPAÇO: Play/Pause | ESC: Parar | +/-: Volume");
    draw_set_halign(fa_left);
}
