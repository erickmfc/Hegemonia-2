// ==========================================
// HEGEMONIA GLOBAL - INTERFACE DE COMANDOS
// Menu Tático para Unidades Móveis
// ==========================================

// === PROPRIEDADES DO MENU ===
menu_visivel = false;
posicao_x = 0;
posicao_y = 0;
largura_menu = 200;
altura_menu = 120;
espacamento_botoes = 10;

// === PROPRIEDADES DOS BOTÕES ===
botao_patrulhar = {
    x: 0,
    y: 0,
    largura: 180,
    altura: 45,
    texto: "PATRULHAR",
    ativo: false,
    hover: false
};

botao_seguir = {
    x: 0,
    y: 0,
    largura: 180,
    altura: 45,
    texto: "SEGUIR",
    ativo: false,
    hover: false
};

// === CORES DO MENU ===
cor_fundo = make_color_rgb(40, 40, 40);
cor_borda = make_color_rgb(80, 80, 80);
cor_botao = make_color_rgb(60, 60, 60);
cor_botao_hover = make_color_rgb(80, 80, 80);
cor_texto = make_color_rgb(200, 200, 200);
cor_texto_ativo = make_color_rgb(255, 255, 255);

// === UNIDADE SELECIONADA ===
unidade_atual = noone;
tipo_unidade = ""; // "INFANTARIA", "AVIAO", "NAVIO"

show_debug_message("Interface de Comandos criada - ID: " + string(id));
