/// @description Clique esquerdo - Definição de Patrulha

if (!variable_instance_exists(id, "selecionado") || !selecionado) exit;

if (variable_instance_exists(id, "estado") && estado == LanchaState.DEFININDO_PATRULHA) {
    
    var _coords = global.scr_mouse_to_world();
    var px = _coords[0];
    var py = _coords[1];
    
    if (variable_instance_exists(id, "func_adicionar_ponto")) {
        func_adicionar_ponto(px, py);
    }
    show_debug_message("📍 Ponto de patrulha adicionado: (" + string(px) + ", " + string(py) + ")");
}