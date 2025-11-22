/// @description Clique direito - Movimento
// English: Right click - Movement
// Português: Clique direito - Movimento

if (!selecionado) exit;

// English: Get world coordinates from mouse position
// Português: Obter coordenadas do mundo a partir da posição do mouse
var _coords = global.scr_mouse_to_world();
var dest_x = _coords[0];
var dest_y = _coords[1];

// ✅ VALIDAÇÃO: Verificar se destino é água ANTES de mover
if (!scr_unidade_pode_terreno(id, dest_x, dest_y)) {
    // Destino é terra - encontrar água próxima
    var _agua_proxima = scr_encontrar_agua_proxima(dest_x, dest_y, 500);
    if (_agua_proxima != noone && is_array(_agua_proxima) && array_length(_agua_proxima) >= 2) {
        dest_x = _agua_proxima[0];
        dest_y = _agua_proxima[1];
        show_debug_message("⚠️ " + nome_unidade + ": Destino ajustado para água próxima");
    } else {
        show_debug_message("❌ " + nome_unidade + ": Não há água próxima ao destino!");
        exit; // Não mover
    }
}

// English: Move to clicked position
// Português: Mover para posição clicada
ordem_mover(dest_x, dest_y);

show_debug_message("🚢 Movendo para: " + string(dest_x) + ", " + string(dest_y));