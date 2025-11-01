// ===============================================
// HEGEMONIA GLOBAL - OBJETO CARREGAMENTO
// Desenho da Barra de Carregamento
// ===============================================

// Limpar tela com cor escura
draw_clear(c_black);

// Desenhar fundo da tela (opcional - gradiente escuro)
draw_set_color(make_color_rgb(64, 64, 64)); // Cinza escuro
draw_set_alpha(0.3);
draw_rectangle(0, 0, room_width, room_height, false);

// ===== TEXTO "CARREGANDO" =====
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(-1);
draw_text(room_width / 2, pos_y - 80, texto_carregamento);

// ===== BARRA DE PROGRESSO =====
var barra_x = pos_x - largura_barra / 2;
var barra_y = pos_y - altura_barra / 2;

// Fundo da barra (preto)
draw_set_color(cor_fundo);
draw_set_alpha(0.8);
draw_rectangle(barra_x, barra_y, barra_x + largura_barra, barra_y + altura_barra, false);

// Barra de progresso (azul animada)
var largura_preenchida = largura_barra * progresso;

// Efeito de gradiente na barra (opcional)
if (largura_preenchida > 0) {
    // Cor varia de azul escuro para azul claro conforme progresso
    // Usar RGB diretamente: azul = (0, 0, 255)
    var intensidade = 0.7 + (0.3 * progresso);
    var r_val = 0;
    var g_val = 0;
    var b_val = floor(255 * intensidade);
    
    var cor_progresso = make_color_rgb(r_val, g_val, b_val);
    
    draw_set_color(cor_progresso);
    draw_set_alpha(0.9);
    draw_rectangle(barra_x, barra_y, barra_x + largura_preenchida, barra_y + altura_barra, false);
    
    // Efeito de brilho animado (opcional)
    var brilho_x = barra_x + largura_preenchida - 10;
    if (brilho_x > barra_x) {
        draw_set_color(c_white);
        draw_set_alpha(0.5 + 0.3 * sin(current_time * 0.01));
        draw_rectangle(brilho_x, barra_y, barra_x + largura_preenchida, barra_y + altura_barra, false);
    }
}

// Borda da barra (branco)
draw_set_color(cor_borda);
draw_set_alpha(1.0);
draw_rectangle(barra_x, barra_y, barra_x + largura_barra, barra_y + altura_barra, true);

// ===== PERCENTUAL DE CARREGAMENTO =====
var percentual_texto = string(floor(progresso * 100)) + "%";
draw_set_color(c_white);
draw_set_alpha(1.0);
draw_text(pos_x, barra_y + altura_barra + 20, percentual_texto);

// ===== TEXTO ADICIONAL (opcional) =====
var tempo_restante = max(0, tempo_total - tempo_atual);
draw_set_color(make_color_rgb(128, 128, 128)); // Cinza
draw_set_alpha(0.7);
draw_text(pos_x, barra_y + altura_barra + 45, "Aguarde...");

// Resetar configurações de desenho
draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
