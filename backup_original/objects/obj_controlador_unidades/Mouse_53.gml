// =========================================================
// HEGEMONIA GLOBAL - CONTROLE DE UNIDADES
// Bloco 5, Fase 1: Lógica de Seleção
// =========================================================

// Evento Global Left Pressed de obj_controlador_unidades

show_debug_message("=== CLIQUE ESQUERDO DETECTADO ===");
show_debug_message("Posição do mouse: (" + string(mouse_x) + ", " + string(mouse_y) + ")");

var _instancia_clicada = instance_position(mouse_x, mouse_y, obj_infantaria);

if (_instancia_clicada != noone) {
    show_debug_message("Unidade encontrada: ID " + string(_instancia_clicada));
    global.unidade_selecionada = _instancia_clicada;
    show_debug_message("Unidade selecionada: ID " + string(global.unidade_selecionada));
} else {
    show_debug_message("Nenhuma unidade encontrada na posição do clique");
    global.unidade_selecionada = noone;
}