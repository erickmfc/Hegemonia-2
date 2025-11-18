// =========================================================
// HEGEMONIA GLOBAL - MENU DE RECURSOS SUSPENSO
// Design com Glow Neon - Recolhível e Expandível
// =========================================================

// === SISTEMA DE ESTADOS ===
// 0 = Fechado (recolhido), 1 = Abrindo, 2 = Aberto, 3 = Fechando
menu_estado = 2; // ✅ INICIAR EXPANDIDO para mostrar recursos imediatamente
timer_animacao = 0;
duracao_animacao = 0.5;

// === POSICIONAMENTO ===
// ✅ REDUZIDO EM 20% (multiplicado por 0.8)
menu_pos_x = 30;              // Posição X (canto superior direito)
menu_pos_y = 30;              // Posição Y
menu_largura_expandido = 304; // 380 * 0.8 = 304
menu_altura_expandido = 416;  // 520 * 0.8 = 416
menu_altura_recolhido = 40;  // 50 * 0.8 = 40
menu_pos_y_atual = menu_pos_y;
menu_altura_atual = menu_altura_expandido; // ✅ INICIAR COM ALTURA EXPANDIDA

// === SETA DE TOGGLE ===
seta_angulo = 180;           // ✅ INICIAR COM SETA PARA CIMA (menu expandido)
seta_animando = false;

// === DADOS DE RECURSOS ===
lista_recursos = array_create(0);

function criar_recurso(_nome, _icone, _valor, _cor, _eh_numero = true) {
    var _recurso = {
        nome: _nome,
        icone: _icone,           // Emoji ou caractere
        valor: _valor,
        valor_display: _valor,   // Para animação
        cor: _cor,
        eh_numero: _eh_numero,
        animando: false,
        valor_anterior: _valor
    };
    return _recurso;
}

// === INICIALIZAR RECURSOS ===
// Dinheiro
var _recurso_dinheiro = criar_recurso("Dinheiro", "$", 50000, make_color_rgb(255, 200, 100));
array_push(lista_recursos, _recurso_dinheiro);

// População - ✅ CORRIGIDO: Substituído emoji por caractere
var _recurso_populacao = criar_recurso("Población", "P", 2000, make_color_rgb(100, 200, 255));
array_push(lista_recursos, _recurso_populacao);

// Turistas - ✅ CORRIGIDO: Substituído emoji por caractere
var _recurso_turistas = criar_recurso("Turistas", "T", 150, make_color_rgb(255, 150, 100));
array_push(lista_recursos, _recurso_turistas);

// Alimento (Foida) - ✅ CORRIGIDO: Substituído emoji por caractere
var _recurso_foida = criar_recurso("Foida", "F", 1200, make_color_rgb(200, 150, 100));
array_push(lista_recursos, _recurso_foida);

// Energia - ✅ CORRIGIDO: Substituído emoji por caractere
var _recurso_energia = criar_recurso("Energia", "E", 850, make_color_rgb(255, 220, 80));
array_push(lista_recursos, _recurso_energia);

// Petróleo - ✅ CORRIGIDO: Substituído emoji por caractere
var _recurso_petrolo = criar_recurso("Petórlo", "O", 1000, make_color_rgb(150, 100, 200));
array_push(lista_recursos, _recurso_petrolo);

// Militar - ✅ CORRIGIDO: Substituído emoji por caractere
var _recurso_militar = criar_recurso("Militar", "M", 45, make_color_rgb(255, 100, 100));
array_push(lista_recursos, _recurso_militar);

// Polaridade - ✅ CORRIGIDO: Substituído emoji por caractere
var _recurso_polaridade = criar_recurso("Polaridade", "+", 15, make_color_rgb(100, 255, 100), false);
array_push(lista_recursos, _recurso_polaridade);

// Status - ✅ CORRIGIDO: Substituído emoji por caractere
var _recurso_status = criar_recurso("Status", "S", "PAZ", make_color_rgb(100, 255, 100), false);
array_push(lista_recursos, _recurso_status);

// === CONFIGURAÇÕES VISUAIS ===
// Neon cyan
cor_borda_neon = make_color_rgb(100, 220, 255);
cor_borda_interna = make_color_rgb(150, 240, 255);
cor_fundo = make_color_rgb(20, 25, 40);
cor_fundo_item = make_color_rgb(25, 35, 55);
cor_fundo_header = make_color_rgb(30, 40, 60);
cor_texto_titulo = make_color_rgb(200, 240, 255);
cor_texto_normal = make_color_rgb(180, 200, 220);
cor_linha = make_color_rgb(100, 180, 255);

// === VARIÁVEIS DE ANIMAÇÃO ===
// ✅ REMOVIDO: Efeito de piscar (glow fixo)
glow_intensity = 0.5; // ✅ FIXO: Sem animação de piscar
glow_speed = 0; // ✅ DESABILITADO: Não anima mais
hover_item = -1;

// === GARANTIR VISIBILIDADE ===
visible = true; // ✅ Garantir que objeto está visível
menu_visible = true; // ✅ Variável para controlar visibilidade com tecla B

// === DEBUG ===
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("✅ Menu de Recursos Suspenso inicializado");
    show_debug_message("   Posição: (" + string(menu_pos_x) + ", " + string(menu_pos_y) + ")");
    show_debug_message("   Recursos configurados: " + string(array_length(lista_recursos)));
}
