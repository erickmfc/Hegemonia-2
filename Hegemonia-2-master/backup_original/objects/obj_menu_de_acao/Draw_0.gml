// ==========================================
// HEGEMONIA GLOBAL - MENU DE AÇÃO
// Draw Event - Interface Visual Moderna
// ==========================================

// Só desenha se o menu estiver visível
show_debug_message("DEBUG DRAW: menu_visivel = " + string(menu_visivel));
if (!menu_visivel) exit;

// === DESENHAR FUNDO DO MENU ===
draw_set_color(cor_fundo);
draw_set_alpha(0.95);
draw_roundrect_ext(posicao_x, posicao_y, posicao_x + largura_menu, posicao_y + altura_menu, 15, 15, false);
draw_set_alpha(1);

// === DESENHAR BORDA DO MENU ===
draw_set_color(cor_borda);
draw_set_alpha(0.8);
draw_roundrect_ext(posicao_x, posicao_y, posicao_x + largura_menu, posicao_y + altura_menu, 15, 15, true);
draw_set_alpha(1);

// === DESENHAR TÍTULO ===
draw_set_color(cor_texto);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(posicao_x + largura_menu/2, posicao_y - 25, "MENU DE AÇÃO - " + tipo_unidade);

// === DESENHAR BOTÃO PATRULHAR ===
var cor_botao_patrulhar = cor_botao;
if (botao_patrulhar.hover) cor_botao_patrulhar = cor_botao_hover;
if (botao_patrulhar.ativo) cor_botao_patrulhar = cor_botao_ativo_patrulhar;

draw_set_color(cor_botao_patrulhar);
draw_set_alpha(0.9);
draw_roundrect_ext(botao_patrulhar.x, botao_patrulhar.y, 
                   botao_patrulhar.x + botao_patrulhar.largura, 
                   botao_patrulhar.y + botao_patrulhar.altura, 10, 10, false);
draw_set_alpha(1);

// Ícone de escudo para PATRULHAR
draw_set_color(cor_texto);
draw_set_alpha(0.9);
draw_circle(botao_patrulhar.x + 30, botao_patrulhar.y + 25, 10, false);
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
if (botao_seguir.ativo) cor_botao_seguir = cor_botao_ativo_seguir;

draw_set_color(cor_botao_seguir);
draw_set_alpha(0.9);
draw_roundrect_ext(botao_seguir.x, botao_seguir.y, 
                   botao_seguir.x + botao_seguir.largura, 
                   botao_seguir.y + botao_seguir.altura, 10, 10, false);
draw_set_alpha(1);

// Ícone de seta para SEGUIR
draw_set_color(cor_texto);
draw_set_alpha(0.9);
draw_arrow(botao_seguir.x + 20, botao_seguir.y + 25, 
           botao_seguir.x + 40, botao_seguir.y + 25, 4);
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

// === DESENHAR BOTÃO ATACAR ===
var cor_botao_atacar = cor_botao;
if (botao_atacar.hover) cor_botao_atacar = cor_botao_hover;
if (botao_atacar.ativo) cor_botao_atacar = cor_botao_ativo_atacar;

draw_set_color(cor_botao_atacar);
draw_set_alpha(0.9);
draw_roundrect_ext(botao_atacar.x, botao_atacar.y, 
                   botao_atacar.x + botao_atacar.largura, 
                   botao_atacar.y + botao_atacar.altura, 10, 10, false);
draw_set_alpha(1);

// Ícone de espada para ATACAR
draw_set_color(cor_texto);
draw_set_alpha(0.9);
draw_line(botao_atacar.x + 20, botao_atacar.y + 20, 
          botao_atacar.x + 40, botao_atacar.y + 40);
draw_line(botao_atacar.x + 40, botao_atacar.y + 20, 
          botao_atacar.x + 20, botao_atacar.y + 40);
draw_set_alpha(1);

// Texto do botão ATACAR
var cor_texto_atacar = cor_texto;
if (botao_atacar.ativo) cor_texto_atacar = cor_texto_ativo;

draw_set_color(cor_texto_atacar);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(botao_atacar.x + botao_atacar.largura/2, 
           botao_atacar.y + botao_atacar.altura/2, 
           botao_atacar.texto);

// === RESETAR CONFIGURAÇÕES ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
