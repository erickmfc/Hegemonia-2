/// @description Converte coordenadas do mouse da tela para coordenadas do mundo considerando zoom
/// @return Array [world_x, world_y] - Coordenadas no mundo do jogo

// =========================================================================
// SCRIPT DE CONVERSÃO DE COORDENADAS UNIVERSAL (COM ZOOM E QUALQUER MAPA)
// =========================================================================

// --- PASSO 1: Obter as coordenadas do mouse na TELA (GUI) ---
// Esta é a posição X e Y do cursor na janela do jogo.
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

// --- PASSO 2: Obter as informações da CÂMERA atual ---
// Pegamos a referência da câmera que está ativa na primeira viewport
var _cam = view_camera[0];

// Onde a câmera está posicionada dentro do MUNDO do jogo
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);

// O tamanho da "lente" da câmera (quanto do MUNDO ela está enxergando)
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);

// --- PASSO 3: Calcular o nível de ZOOM atual ---
// Comparamos o tamanho da lente da câmera com o tamanho da tela para saber o zoom.
var _zoom_level_x = _cam_w / display_get_gui_width();
var _zoom_level_y = _cam_h / display_get_gui_height();

// --- PASSO 4: A CONVERSÃO MÁGICA ---
// Traduzimos a posição do mouse na TELA para a sua posição real no MUNDO do jogo.
var _mouse_world_x = _cam_x + (_mouse_gui_x * _zoom_level_x);
var _mouse_world_y = _cam_y + (_mouse_gui_y * _zoom_level_y);

// --- PASSO 5: Retornar as coordenadas CORRETAS ---
return [_mouse_world_x, _mouse_world_y];
