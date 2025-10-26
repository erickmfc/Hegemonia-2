/// @description Clique direito - Movimento
// English: Right click - Movement
// Português: Clique direito - Movimento

if (!selecionado) exit;

// English: Get world coordinates from mouse position
// Português: Obter coordenadas do mundo a partir da posição do mouse
var _coords = global.scr_mouse_to_world();
var dest_x = _coords[0];
var dest_y = _coords[1];

// English: Move to clicked position
// Português: Mover para posição clicada
ordem_mover(dest_x, dest_y);

show_debug_message("🚢 Movendo para: " + string(dest_x) + ", " + string(dest_y));