// =========================================================
// HEGEMONIA GLOBAL - CONTROLADOR DE CONSTRUÇÃO
// Fase 4: Posicionamento Tático no Grid (A Imagem "Fantasma")
// =========================================================

// Evento Create de obj_controlador_construcao

// Defina aqui o tamanho do seu tile.
// Se cada quadrado do seu grid tem 32x32 pixels, use 32. Se for 64x64, use 64.
tile_size = 32; // Usando 32 para alinhar com global.tile_size

// Variáveis que vão guardar a posição do fantasma, alinhada ao grid.
grid_x = 0;
grid_y = 0;

// Variável que guardará o ID da unidade selecionada pelo jogador
global.unidade_selecionada = noone; // 'noone' é uma palavra-chave do GameMaker que significa 'nada'

show_debug_message("Controlador de Construção inicializado - Fase 4 com tile_size: " + string(tile_size));