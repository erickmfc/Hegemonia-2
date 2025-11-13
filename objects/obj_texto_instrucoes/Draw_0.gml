/// @description Draw - Desenhar instruções do jogo com scroll funcional

// === CONFIGURAR FONTE ===
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1); // Fonte padrão
}

// === DIMENSÕES E POSICIONAMENTO ===
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Menu ocupa 85% da tela
var _menu_w = _gui_w * 0.85;
var _menu_h = _gui_h * 0.85;
var _menu_x = (_gui_w - _menu_w) / 2;
var _menu_y = (_gui_h - _menu_h) / 2;

// === OVERLAY DE FUNDO ===
draw_set_alpha(0.92);
draw_set_color(make_color_rgb(5, 10, 20));
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1.0);

// === FUNDO PRINCIPAL ===
// Sombra
draw_set_color(c_black);
draw_set_alpha(0.6);
draw_roundrect_ext(_menu_x + 10, _menu_y + 10, _menu_x + _menu_w + 10, _menu_y + _menu_h + 10, 25, 25, false);

// Fundo principal
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(15, 25, 40));
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, 25, 25, false);

// Gradiente superior
draw_set_color(make_color_rgb(30, 50, 80));
draw_set_alpha(0.4);
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + 100, 25, 25, false);
draw_set_alpha(1.0);

// Borda principal
draw_set_color(make_color_rgb(60, 120, 200));
draw_set_alpha(0.8);
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, 25, 25, true);
draw_set_alpha(1.0);

// === HEADER ===
var _header_h = 100;
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal
draw_set_color(make_color_rgb(255, 255, 255));
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}
draw_text_transformed(_menu_x + _menu_w/2, _menu_y + 35, "ENCICLOPEDIA", 2.5, 2.5, 0);

// Subtítulo
draw_set_color(make_color_rgb(150, 200, 255));
draw_text_transformed(_menu_x + _menu_w/2, _menu_y + 75, "Como Jogar Hegemonia Global", 1.105, 1.105, 0);

// === ÁREA DE CONTEÚDO COM SCROLL ===
var _content_x = _menu_x + 40;
var _content_y = _menu_y + _header_h + 20;
var _content_w = _menu_w - 80 - 30; // Espaço para barra de rolagem
var _content_h = _menu_h - _header_h - 40; // Espaço para footer
var _content_bottom = _content_y + _content_h;

// === CALCULAR ALTURA TOTAL DO CONTEÚDO ===
var _line_height = 35;
var _section_spacing = 50;
var _altura_total = 0;

// Calcular altura real do conteúdo
_altura_total += _line_height * 2; // Título
_altura_total += _section_spacing;
_altura_total += _line_height * 1.5; // Seção 1 título
_altura_total += _line_height * 4; // Seção 1 itens
_altura_total += _section_spacing;
_altura_total += _line_height * 1.5; // Seção 2 título
_altura_total += _line_height * 6; // Seção 2 itens
_altura_total += _section_spacing;
_altura_total += _line_height * 1.5; // Seção 3 título
_altura_total += _line_height * 4; // Seção 3 itens
_altura_total += _section_spacing;
_altura_total += _line_height * 1.5; // Seção 4 título
_altura_total += _line_height * 4; // Seção 4 itens
_altura_total += _section_spacing;
_altura_total += _line_height * 1.5; // Seção 5 título
_altura_total += _line_height * 6; // Seção 5 itens
_altura_total += _section_spacing;
_altura_total += _line_height * 1.5; // Seção 6 título
_altura_total += _line_height * 5; // Seção 6 itens
_altura_total += _section_spacing;
_altura_total += _line_height * 1.5; // Seção 7 título
_altura_total += _line_height * 5; // Seção 7 itens
_altura_total += _section_spacing;
_altura_total += _line_height * 1.5; // Seção 8 título
_altura_total += _line_height * 6; // Seção 8 itens
_altura_total += _section_spacing * 2; // Espaço extra no final

// Atualizar variáveis de scroll
if (content_height == 0 || content_height != _altura_total) {
    content_height = _altura_total;
    max_scroll = max(0, content_height - _content_h);
    // Garantir que scroll_y não ultrapasse o máximo
    if (scroll_y > max_scroll) {
        scroll_y = max_scroll;
    }
    // ✅ DEBUG: Verificar valores
    // show_debug_message("Content height: " + string(content_height) + " | Max scroll: " + string(max_scroll) + " | Scroll Y: " + string(scroll_y));
}

// === APLICAR CLIPPING (CORTAR CONTEÚDO FORA DA ÁREA VISÍVEL) ===
// ✅ TEMPORÁRIO: Desabilitar clipping para debug - verificar se conteúdo aparece
// gpu_set_scissor(true, _content_x, _content_y, _content_w, _content_h);

// === DESENHAR CONTEÚDO COM SCROLL ===
// ✅ CORREÇÃO: Garantir que o conteúdo comece na posição correta
var _draw_y = _content_y - scroll_y; // Aplicar offset de scroll
// Garantir que não comece muito acima (scroll negativo não deve empurrar para baixo)
if (scroll_y < 0) scroll_y = 0;
var _start_x = _content_x;

// Configurar fonte e alinhamento
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);

// SEÇÃO 1: CONTROLES BÁSICOS
draw_set_color(make_color_rgb(100, 255, 150));
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}
draw_text_transformed(_start_x, _draw_y, "CONTROLES BASICOS", 1.4, 1.4, 0);
_draw_y += _line_height * 1.5;

draw_set_color(c_white);
draw_text_transformed(_start_x + 30, _draw_y, "• Clique Esquerdo: Selecionar unidade", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Duplo Clique: Selecionar todas as unidades da mesma categoria", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Clique Direito: Mover unidade ou confirmar patrulha", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Arrastar Mouse: Seleção múltipla por área", 1.2, 1.2, 0);
_draw_y += _section_spacing;

// SEÇÃO 2: TECLAS DE COMANDO
draw_set_color(make_color_rgb(100, 255, 150));
draw_text_transformed(_start_x, _draw_y, "TECLAS DE COMANDO", 1.4, 1.4, 0);
_draw_y += _line_height * 1.5;

draw_set_color(c_white);
draw_text_transformed(_start_x + 30, _draw_y, "• C: Ativar/Desativar modo de construção", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• B: Abrir menu de pesquisa", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• K: Ativar modo de patrulha (com unidades selecionadas)", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• P: Modo Passivo (unidades não atacam automaticamente)", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• O: Modo Ataque (unidades atacam inimigos automaticamente)", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• L: Parar unidade (cancela movimento e patrulha)", 1.2, 1.2, 0);
_draw_y += _section_spacing;

// SEÇÃO 3: CONSTRUÇÃO
draw_set_color(make_color_rgb(100, 255, 150));
draw_text_transformed(_start_x, _draw_y, "CONSTRUCAO", 1.4, 1.4, 0);
_draw_y += _line_height * 1.5;

draw_set_color(c_white);
draw_text_transformed(_start_x + 30, _draw_y, "1. Pressione C para abrir o menu de construção", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "2. Escolha o tipo de construção (Casa, Banco, Quartel, etc.)", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "3. Clique no mapa para construir", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "4. Verifique se tem recursos suficientes antes de construir", 1.2, 1.2, 0);
_draw_y += _section_spacing;

// SEÇÃO 4: RECRUTAMENTO DE UNIDADES
draw_set_color(make_color_rgb(100, 255, 150));
draw_text_transformed(_start_x, _draw_y, "RECRUTAMENTO DE UNIDADES", 1.4, 1.4, 0);
_draw_y += _line_height * 1.5;

draw_set_color(c_white);
draw_text_transformed(_start_x + 30, _draw_y, "• Quartel: Recruta Infantaria, Tanques, Soldados Anti-Aéreos, Blindados Anti-Aéreos", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Quartel Marinha: Recruta unidades navais (Lancha Patrulha, Navios, etc.)", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Aeroporto Militar: Recruta unidades aéreas (F-5, F-15, Helicópteros, etc.)", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Clique no edifício para abrir o menu de recrutamento", 1.2, 1.2, 0);
_draw_y += _section_spacing;

// SEÇÃO 5: CONTROLE DE UNIDADES
draw_set_color(make_color_rgb(100, 255, 150));
draw_text_transformed(_start_x, _draw_y, "CONTROLE DE UNIDADES", 1.4, 1.4, 0);
_draw_y += _line_height * 1.5;

draw_set_color(c_white);
draw_text_transformed(_start_x + 30, _draw_y, "• Selecione unidades e pressione K para ativar patrulha", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Clique esquerdo para adicionar pontos de patrulha", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Clique direito para iniciar a patrulha", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Unidades da mesma categoria patrulham juntas", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Use P para modo passivo (unidades não atacam)", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Use O para modo ataque (unidades atacam automaticamente)", 1.2, 1.2, 0);
_draw_y += _section_spacing;

// SEÇÃO 6: NAVIO TRANSPORTE
draw_set_color(make_color_rgb(100, 255, 150));
draw_text_transformed(_start_x, _draw_y, "NAVIO TRANSPORTE", 1.4, 1.4, 0);
_draw_y += _line_height * 1.5;

draw_set_color(c_white);
draw_text_transformed(_start_x + 30, _draw_y, "• Pressione P com o navio selecionado para ativar embarque/desembarque", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Unidades próximas embarcam automaticamente", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Pressione PP para fechar portas (embarcado)", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Pressione PPP para desembarcar unidades", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• J: Abre menu de carga do navio", 1.2, 1.2, 0);
_draw_y += _section_spacing;

// SEÇÃO 7: RECURSOS
draw_set_color(make_color_rgb(100, 255, 150));
draw_text_transformed(_start_x, _draw_y, "RECURSOS", 1.4, 1.4, 0);
_draw_y += _line_height * 1.5;

draw_set_color(c_white);
draw_text_transformed(_start_x + 30, _draw_y, "• Dinheiro: Ganho por Banco e estruturas econômicas", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Minério: Extraído de minas no mapa", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Petróleo: Extraído de poços de petróleo", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• População: Aumenta com Casas construídas", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Alimento: Produzido por Fazendas", 1.2, 1.2, 0);
_draw_y += _section_spacing;

// SEÇÃO 8: DICAS ESTRATÉGICAS
draw_set_color(make_color_rgb(100, 255, 150));
draw_text_transformed(_start_x, _draw_y, "DICAS ESTRATEGICAS", 1.4, 1.4, 0);
_draw_y += _line_height * 1.5;

draw_set_color(c_white);
draw_text_transformed(_start_x + 30, _draw_y, "• Construa Casas primeiro para aumentar população", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Construa Banco para gerar dinheiro", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Use unidades anti-aéreas contra aviões inimigos", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Tanques são eficazes contra infantaria", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Mantenha unidades em patrulha para defender território", 1.2, 1.2, 0);
_draw_y += _line_height;
draw_text_transformed(_start_x + 30, _draw_y, "• Use modo passivo (P) para evitar ataques indesejados", 1.2, 1.2, 0);
_draw_y += _section_spacing * 2; // Espaço extra no final

// === DESABILITAR CLIPPING ANTES DE DESENHAR BARRA E BOTÃO ===
// gpu_set_scissor(false);

// === BARRA DE ROLAGEM ===
if (max_scroll > 0) {
    var _scrollbar_x = _menu_x + _menu_w - 35;
    var _scrollbar_y = _content_y;
    var _scrollbar_w = 15;
    var _scrollbar_h = _content_h;
    
    // Fundo da barra
    draw_set_color(make_color_rgb(30, 40, 60));
    draw_set_alpha(0.8);
    draw_rectangle(_scrollbar_x, _scrollbar_y, _scrollbar_x + _scrollbar_w, _scrollbar_y + _scrollbar_h, false);
    
    // Calcular tamanho e posição do indicador (thumb)
    var _thumb_h = max(30, _scrollbar_h * (_content_h / content_height));
    var _scroll_ratio = (max_scroll > 0) ? (scroll_y / max_scroll) : 0;
    var _thumb_y = _scrollbar_y + (_scrollbar_h - _thumb_h) * _scroll_ratio;
    
    // Indicador (thumb) da barra
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    var _thumb_hover = (_mouse_gui_x >= _scrollbar_x && _mouse_gui_x <= _scrollbar_x + _scrollbar_w &&
                        _mouse_gui_y >= _thumb_y && _mouse_gui_y <= _thumb_y + _thumb_h);
    
    if (_thumb_hover || arrastando_scrollbar) {
        draw_set_color(make_color_rgb(100, 160, 240)); // Mais claro quando hover
    } else {
        draw_set_color(make_color_rgb(80, 140, 220)); // Cor normal
    }
    draw_set_alpha(1.0);
    draw_rectangle(_scrollbar_x + 2, _thumb_y, _scrollbar_x + _scrollbar_w - 2, _thumb_y + _thumb_h, false);
    
    // Borda do indicador
    draw_set_color(make_color_rgb(120, 180, 255));
    draw_rectangle(_scrollbar_x + 2, _thumb_y, _scrollbar_x + _scrollbar_w - 2, _thumb_y + _thumb_h, true);
}
