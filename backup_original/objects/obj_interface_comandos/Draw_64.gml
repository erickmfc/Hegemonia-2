// ==========================================
// HEGEMONIA GLOBAL - INTERFACE DE COMANDOS
// Draw Event - Interface Visual
// ==========================================

// Só desenha se o menu estiver visível
if (!menu_visivel) {
    show_debug_message("MENU NÃO VISÍVEL - menu_visivel: " + string(menu_visivel));
    exit;
}

show_debug_message("DESENHANDO MENU - Posição: (" + string(posicao_x) + ", " + string(posicao_y) + ")");

// === DESENHAR FUNDO DO MENU ===
draw_set_color(cor_fundo);
draw_set_alpha(0.9);
draw_roundrect_ext(posicao_x, posicao_y, posicao_x + largura_menu, posicao_y + altura_menu, 10, 10, false);
draw_set_alpha(1);

// === DESENHAR BORDA DO MENU ===
draw_set_color(cor_borda);
draw_set_alpha(0.7);
draw_roundrect_ext(posicao_x, posicao_y, posicao_x + largura_menu, posicao_y + altura_menu, 10, 10, true);
draw_set_alpha(1);

// === DESENHAR BOTÃO PATRULHAR ===
var cor_botao_patrulhar = cor_botao;
if (botao_patrulhar.hover) cor_botao_patrulhar = cor_botao_hover;
if (botao_patrulhar.ativo) cor_botao_patrulhar = make_color_rgb(100, 150, 100);

draw_set_color(cor_botao_patrulhar);
draw_set_alpha(0.8);
draw_roundrect_ext(botao_patrulhar.x, botao_patrulhar.y, 
                   botao_patrulhar.x + botao_patrulhar.largura, 
                   botao_patrulhar.y + botao_patrulhar.altura, 8, 8, false);
draw_set_alpha(1);

// Ícone de escudo para PATRULHAR
draw_set_color(cor_texto);
draw_set_alpha(0.8);
draw_circle(botao_patrulhar.x + 25, botao_patrulhar.y + 22, 8, false);
draw_set_alpha(1);

// Texto do botão PATRULHAR
var cor_texto_patrulhar = cor_texto;
if (botao_patrulhar.ativo) cor_texto_patrulhar = cor_texto_ativo;

draw_set_color(cor_texto_patrulhar);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(botao_patrulhar.x + botao_patrulhar.largura/2, 
          botao_patrulhar.y + botao_patrulhar.altura/2, 
          botao_patrulhar.texto);

// === DESENHAR BOTÃO SEGUIR ===
var cor_botao_seguir = cor_botao;
if (botao_seguir.hover) cor_botao_seguir = cor_botao_hover;
if (botao_seguir.ativo) cor_botao_seguir = make_color_rgb(100, 100, 150);

draw_set_color(cor_botao_seguir);
draw_set_alpha(0.8);
draw_roundrect_ext(botao_seguir.x, botao_seguir.y, 
                   botao_seguir.x + botao_seguir.largura, 
                   botao_seguir.y + botao_seguir.altura, 8, 8, false);
draw_set_alpha(1);

// Ícone de seta para SEGUIR
draw_set_color(cor_texto);
draw_set_alpha(0.8);
draw_arrow(botao_seguir.x + 15, botao_seguir.y + 22, 
           botao_seguir.x + 35, botao_seguir.y + 22, 3);
draw_set_alpha(1);

// Texto do botão SEGUIR
var cor_texto_seguir = cor_texto;
if (botao_seguir.ativo) cor_texto_seguir = cor_texto_ativo;

draw_set_color(cor_texto_seguir);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(botao_seguir.x + botao_seguir.largura/2, 
          botao_seguir.y + botao_seguir.altura/2, 
          botao_seguir.texto);

// === RESETAR CONFIGURAÇÕES ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
