// ===============================================
// HEGEMONIA GLOBAL - OBJETO CARREGAMENTO
// Draw GUI - Elementos sempre visíveis
// ===============================================

// Título do jogo (sempre visível mesmo com zoom)
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(-1); // Usar fonte padrão

var titulo_y = 150;
// Usar draw_text_transformed para aumentar o tamanho do texto
draw_text_transformed(room_width / 2, titulo_y, "HEGEMONIA GLOBAL", 2.0, 2.0, 0);
