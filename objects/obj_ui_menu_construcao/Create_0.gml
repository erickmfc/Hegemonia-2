// =========================================================
// HEGEMONIA GLOBAL - MENU DE CONSTRUÇÃO REDESENHADO
// Design Futurista Inspirado em Interface de Sci-Fi
// =========================================================

// === SISTEMA DE ESTADOS ===
menu_estado = 0; // 0 = Fechado, 1 = Abrindo, 2 = Aberto, 3 = Fechando
menu_aberto = false;
timer_animacao = 0;
duracao_animacao = 0.4; // Animação mais suave

// === POSICIONAMENTO DO MENU ===
menu_largura = 340;
menu_altura = display_get_gui_height() * 1.2; // Aumentado em 20%
menu_pos_x_fechado = -menu_largura;
menu_pos_x_aberto = 0;
menu_pos_y = 0;
menu_pos_x_atual = menu_pos_x_fechado;

// === CONFIGURAÇÕES DE BOTÕES ===
botao_largura = 300;
botao_altura = 75;
botao_espacamento = 12;
botao_start_y = 160;
botao_selecionado = -1;

// === LISTA DE BOTÕES ===
lista_botoes = array_create(0);

function criar_dados_botao(_nome, _icone_tipo, _descricao, _objeto_construir, _custo_dinheiro, _custo_recursos = {}) {
    var _dados = {
        nome: _nome,
        icone_tipo: _icone_tipo,
        descricao: _descricao,
        objeto_construir: _objeto_construir,
        custo_dinheiro: _custo_dinheiro,
        custo_recursos: _custo_recursos,
        hover: false,
        selecionado: false,
        scale_anim: 1.0,
        glow_anim: 0.0
    };
    return _dados;
}

// === INICIALIZAR BOTÕES ===
var _botao_casa = criar_dados_botao(
    "CASA",
    "casa",
    "Habitação",
    asset_get_index("obj_casa"),
    1000,
    {}
);
array_push(lista_botoes, _botao_casa);

var _botao_banco = criar_dados_botao(
    "BANCO",
    "banco",
    "Geração de Renda",
    asset_get_index("obj_banco"),
    2500,
    {}
);
array_push(lista_botoes, _botao_banco);

var _botao_fazenda = criar_dados_botao(
    "FAZENDA",
    "fazenda",
    "Produção de Alimentos",
    asset_get_index("obj_fazenda"),
    2500000,
    {}
);
array_push(lista_botoes, _botao_fazenda);

var _botao_quartel = criar_dados_botao(
    "QUARTEL",
    "quartel",
    "Recrutamento Terrestre",
    asset_get_index("obj_quartel"),
    800,
    {minerio: 150}
);
array_push(lista_botoes, _botao_quartel);

var _botao_aeroporto = criar_dados_botao(
    "AEROPORTO MILITAR",
    "aeroporto",
    "Recrutamento Aéreo",
    asset_get_index("obj_aeroporto_militar"),
    1000,
    {}
);
array_push(lista_botoes, _botao_aeroporto);

// === VARIÁVEIS DE ANIMAÇÃO ===
glow_time = 0;
glow_speed = 0.08;

// === CONFIGURAÇÕES VISUAIS ===
cor_fundo_principal = make_color_rgb(15, 20, 30);
cor_fundo_header = make_color_rgb(25, 35, 50);
cor_borda_principal = make_color_rgb(100, 180, 255);
cor_borda_secundaria = make_color_rgb(50, 120, 200);
cor_botao_normal = make_color_rgb(30, 40, 55);
cor_botao_hover = make_color_rgb(45, 70, 100);
cor_botao_ativo = make_color_rgb(80, 150, 255);
cor_texto_titulo = make_color_rgb(180, 220, 255);
cor_texto_normal = make_color_rgb(220, 230, 240);
cor_texto_descricao = make_color_rgb(140, 160, 180);
cor_custo = make_color_rgb(255, 200, 100);
cor_acento = make_color_rgb(100, 200, 255);

// === DEBUG ===
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("✅ Menu Redesenhado inicializado com " + string(array_length(lista_botoes)) + " botões");
}
