// =========================================================
// HEGEMONIA GLOBAL - CONTROLE DE CONSTRUÇÃO
// Fase 4: Desenho do Fantasma
// =========================================================

// Novamente, só desenha se tivermos um edifício selecionado.
if (global.construindo_agora != noone) {
    
    // Pega o sprite do objeto que foi selecionado (Casa, Banco, etc.)
    // Corrigido: usar asset verificado para evitar erro GM1041
    var _sprite_fantasma = -1;
    
    if (global.construindo_agora == asset_get_index("obj_casa")) {
        _sprite_fantasma = spr_casa;
    } else if (global.construindo_agora == asset_get_index("obj_banco")) {
        _sprite_fantasma = spr_banco;
    } else if (global.construindo_agora == asset_get_index("obj_quartel")) {
        _sprite_fantasma = spr_quartel;
    }
    
    // Verifica se o sprite foi definido corretamente
    if (_sprite_fantasma != -1 && sprite_exists(_sprite_fantasma)) {
        
        // Desenha o sprite com 50% de transparência para dar o efeito de "fantasma"
        draw_sprite_ext(_sprite_fantasma, 0, grid_x, grid_y, 1, 1, 0, c_white, 0.5);
    }
}