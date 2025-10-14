// =========================================================
// HEGEMONIA GLOBAL - CONTROLE DE CONSTRUÇÃO (VERSÃO CORRIGIDA)
// Sistema de Fantasma com Posição Precisa
// =========================================================

// CANCELAMENTO COM CLIQUE DIREITO
if (mouse_check_button_pressed(mb_right) && global.construindo_agora != noone) {
    global.construindo_agora = noone;
    show_debug_message("[CONSTRUÇÃO] Fantasma cancelado com clique direito");
    exit; // Sair imediatamente após cancelamento
}

// Só executa a lógica se estivermos em modo de construção.
if (global.construindo_agora != noone) {
    
    // USA A FUNÇÃO GLOBAL PARA OBTER COORDENADAS PRECISAS DO MOUSE NO MUNDO
    var _coords = global.scr_mouse_to_world();
    var _world_mouse_x = _coords[0];
    var _world_mouse_y = _coords[1];
    
    // CALCULA A POSIÇÃO NO GRID MAIS PRÓXIMO
    var tile_size = 32; // Defina o tamanho do seu tile/grid aqui
    grid_x = floor(_world_mouse_x / tile_size) * tile_size;
    grid_y = floor(_world_mouse_y / tile_size) * tile_size;
    
    // A posição do fantasma é atualizada instantaneamente para 'grid_x' e 'grid_y'
    // no evento Draw deste mesmo objeto.
}
