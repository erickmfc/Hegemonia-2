/// @description Para todo movimento e patrulha

patrolling = false;
if (path != noone) {
    path_delete(path);
    path = noone;
}

if (global.debug_enabled) {
    show_debug_message("Unidade: Movimento parado");
}

