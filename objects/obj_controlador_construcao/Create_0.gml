// =========================================================
// HEGEMONIA GLOBAL - CONTROLADOR DE CONSTRUÇÃO
// Fase 4: Posicionamento Tático no Grid (A Imagem "Fantasma")
// =========================================================

// Evento Create de obj_controlador_construcao

// Usar o tamanho global do tile
tile_size = global.tile_size; // Sincronizar com global.tile_size

// Variáveis que vão guardar a posição do fantasma, alinhada ao grid.
grid_x = 0;
grid_y = 0;

// Variável que guardará o ID da unidade selecionada pelo jogador
global.unidade_selecionada = noone; // 'noone' é uma palavra-chave do GameMaker que significa 'nada'

show_debug_message("Controlador de Construção inicializado - Fase 4 com tile_size: " + string(tile_size));
