/// @description Definir Destino (Clique Direito - Novo Sistema de Física)
// Sistema de movimento com física de inércia (drift na água)

if (!selecionado) exit;

// Obter coordenadas do mundo (com zoom)
var _coords;
if (variable_global_exists("scr_mouse_to_world")) {
    _coords = scr_mouse_to_world();
} else if (variable_global_exists("global.scr_mouse_to_world")) {
    _coords = global.scr_mouse_to_world();
} else {
    // Fallback: usar coordenadas da câmera
    var cam = view_camera[0];
    if (cam != noone && camera_exists(cam)) {
        _coords = [camera_get_view_x(cam) + mouse_x, camera_get_view_y(cam) + mouse_y];
    } else {
        _coords = [mouse_x, mouse_y];
    }
}

var dest_x = _coords[0];
var dest_y = _coords[1];

// === SALVAR POSIÇÃO DO CLIQUE (para linha visual) ===
// Salvar a posição onde o jogador clicou (destino)
click_x = dest_x;  // Posição X onde o jogador clicou
click_y = dest_y;  // Posição Y onde o jogador clicou

// === NOVO SISTEMA: Definir destino para física de inércia ===
target_x = dest_x;
target_y = dest_y;
is_moving = true;
estado = LanchaState.MOVENDO;
estado_string = "movendo";

// === COMPATIBILIDADE: Manter sistema antigo também ===
destino_x = dest_x;
destino_y = dest_y;
if (variable_instance_exists(id, "ordem_mover")) {
    ordem_mover(dest_x, dest_y);
}

// Efeito visual simples de "comando recebido" (opcional)
// effect_create_below(ef_ring, dest_x, dest_y, 0, c_white);

if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("🚢 Lancha: Destino definido para (" + string(dest_x) + ", " + string(dest_y) + ")");
}
