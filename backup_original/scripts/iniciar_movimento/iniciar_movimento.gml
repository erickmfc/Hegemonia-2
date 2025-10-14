/// @description Inicia movimento para coordenadas específicas
/// @param dest_x Coordenada X de destino
/// @param dest_y Coordenada Y de destino

destino_x = dest_x;
destino_y = dest_y;

// Limpar path anterior se existir
if (path != noone) {
    path_delete(path);
    path = noone;
}

patrolling = false; // Cancela a patrulha
image_angle = point_direction(x, y, destino_x, destino_y);

if (global.debug_enabled) {
    show_debug_message("Unidade: Iniciando movimento para (" + string(destino_x) + ", " + string(destino_y) + ")");
}

