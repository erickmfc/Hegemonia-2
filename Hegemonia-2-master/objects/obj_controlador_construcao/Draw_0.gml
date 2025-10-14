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
    } else if (global.construindo_agora == asset_get_index("obj_quartel_marinha")) {
        _sprite_fantasma = Spr_marinha; // ✅ SPRITE CORRETO DO QUARTEL DE MARINHA
    } else if (global.construindo_agora == asset_get_index("obj_aeroporto_militar")) {
        _sprite_fantasma = aeroporto; // ✅ SPRITE ORIGINAL DO AEROPORTO (350x350) - TESTE
    }
    
    // Verifica se o sprite foi definido corretamente
    if (_sprite_fantasma != -1 && sprite_exists(_sprite_fantasma)) {
        
        // Escala específica para aeroporto (ajustada para tamanho normal)
        var _escala = 1.0;
        if (global.construindo_agora == asset_get_index("obj_aeroporto_militar")) {
            _escala = 2.7; // ✅ ESCALA REDUZIDA 10% PARA SPRITE PEQUENO (64x64 -> 172x172)
        }
        
        // Desenha o sprite com 50% de transparência para dar o efeito de "fantasma"
        draw_sprite_ext(_sprite_fantasma, 0, grid_x, grid_y, _escala, _escala, 0, c_white, 0.5);
    } else {
        // DEBUG: Mostrar informações sobre o sprite que não foi encontrado
        show_debug_message("❌ FANTASMA NÃO DESENHADO:");
        show_debug_message("Sprite ID: " + string(_sprite_fantasma));
        show_debug_message("Sprite existe: " + string(sprite_exists(_sprite_fantasma)));
        show_debug_message("Construindo agora: " + string(global.construindo_agora));
        show_debug_message("Asset index aeroporto: " + string(asset_get_index("obj_aeroporto_militar")));
    }
}
