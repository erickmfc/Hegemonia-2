// =========================================================
// HEGEMONIA GLOBAL - TESTE MANUAL DO FANTASMA
// Script para testar o fantasma de construção manualmente
// =========================================================

function scr_teste_fantasma_manual() {
    show_debug_message("=== TESTE MANUAL DO FANTASMA DE CONSTRUÇÃO ===");
    
    // 1. Ativar modo de construção
    global.modo_construcao = true;
    global.construindo_agora = asset_get_index("obj_quartel");
    
    show_debug_message("✅ Modo de construção ativado");
    show_debug_message("✅ Quartel selecionado para construção");
    show_debug_message("✅ Fantasma deve aparecer agora");
    
    // 2. Verificar se o controlador existe
    var _controlador = instance_find(obj_controlador_construcao, 0);
    if (instance_exists(_controlador)) {
        show_debug_message("✅ Controlador encontrado: ID " + string(_controlador));
        show_debug_message("✅ Controlador visível: " + string(_controlador.visible));
        
        // 3. Definir posição inicial do fantasma
        _controlador.grid_x = 100;
        _controlador.grid_y = 100;
        show_debug_message("✅ Posição do fantasma definida: (100, 100)");
    } else {
        show_debug_message("❌ Controlador não encontrado!");
    }
    
    // 4. Verificar sprite
    if (sprite_exists(spr_quartel)) {
        show_debug_message("✅ Sprite do quartel existe");
    } else {
        show_debug_message("❌ Sprite do quartel não existe!");
    }
    
    show_debug_message("=== INSTRUÇÕES ===");
    show_debug_message("1. Mova o mouse para ver o fantasma do quartel");
    show_debug_message("2. Clique esquerdo para construir");
    show_debug_message("3. Clique direito para cancelar");
    show_debug_message("=== FIM DO TESTE ===");
}
