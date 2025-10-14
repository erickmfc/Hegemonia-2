/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
// ==========================================
// HEGEMONIA GLOBAL - MENU DE AÇÃO
// Menu Tático Universal para Unidades Móveis
// ==========================================

// === PROPRIEDADES DO MENU ===
menu_visivel = false;
posicao_x = 0;
posicao_y = 0;
largura_menu = 220;
altura_menu = 200;
espacamento_botoes = 10;

// === PROPRIEDADES DOS BOTÕES ===
botao_patrulhar = {
    x: 0,
    y: 0,
    largura: 200,
    altura: 50,
    texto: "PATRULHAR",
    ativo: false,
    hover: false
};

botao_seguir = {
    x: 0,
    y: 0,
    largura: 200,
    altura: 50,
    texto: "SEGUIR",
    ativo: false,
    hover: false
};

botao_atacar = {
    x: 0,
    y: 0,
    largura: 200,
    altura: 50,
    texto: "ATACAR",
    ativo: false,
    hover: false
};

// === CORES DO MENU ===
cor_fundo = make_color_rgb(30, 30, 40);
cor_borda = make_color_rgb(60, 60, 80);
cor_botao = make_color_rgb(50, 50, 70);
cor_botao_hover = make_color_rgb(70, 70, 90);
cor_texto = make_color_rgb(220, 220, 240);
cor_texto_ativo = make_color_rgb(255, 255, 255);
cor_botao_ativo_patrulhar = make_color_rgb(80, 120, 80);
cor_botao_ativo_seguir = make_color_rgb(80, 80, 120);
cor_botao_ativo_atacar = make_color_rgb(120, 80, 80);

// === UNIDADE SELECIONADA ===
unidade_atual = noone;
tipo_unidade = ""; // "INFANTARIA", "AVIAO", "NAVIO"

// === ID ESPECÍFICO DA UNIDADE QUE CRIOU ESTE MENU ===
unidade_id_especifica = noone;

// === PASSO 1: O ALVO (O MENU PRECISA SABER QUEM COMANDAR) ===
unidade_alvo = noone; // 'noone' significa que ainda não temos um alvo

show_debug_message("Menu de Ação criado - ID: " + string(id));
