/// @description Inicia patrulha entre posição atual e ponto específico
/// @param ponto_x Coordenada X do ponto de patrulha
/// @param ponto_y Coordenada Y do ponto de patrulha

ds_list_clear(patrol_points);
ds_list_add(patrol_points, [x, y]); // ponto atual
ds_list_add(patrol_points, [ponto_x, ponto_y]); // ponto de destino
patrol_index = 0;
patrolling = true;

// Limpar path anterior
if (path != noone) {
    path_delete(path);
    path = noone;
}

if (global.debug_enabled) {
    show_debug_message("Unidade: Iniciando patrulha entre (" + string(x) + ", " + string(y) + ") e (" + string(ponto_x) + ", " + string(ponto_y) + ")");
}

