// =========================================================
// HEGEMONIA GLOBAL - DIAGNÓSTICO DO FANTASMA DE CONSTRUÇÃO
// Script para identificar problemas no sistema de construção
// =========================================================

function scr_diagnostico_fantasma_construcao() {
    show_debug_message("=== DIAGNÓSTICO DO FANTASMA DE CONSTRUÇÃO ===");
    
    // 1. Verificar variáveis globais
    show_debug_message("1. VARIÁVEIS GLOBAIS:");
    show_debug_message("   global.modo_construcao: " + string(global.modo_construcao));
    show_debug_message("   global.construindo_agora: " + string(global.construindo_agora));
    show_debug_message("   global.tile_size: " + string(global.tile_size));
    
    // 2. Verificar se objetos existem
    show_debug_message("2. OBJETOS:");
    show_debug_message("   obj_controlador_construcao existe: " + string(object_exists(obj_controlador_construcao)));
    show_debug_message("   obj_menu_construcao existe: " + string(object_exists(obj_menu_construcao)));
    show_debug_message("   obj_quartel existe: " + string(object_exists(obj_quartel)));
    
    // 3. Verificar instâncias ativas
    show_debug_message("3. INSTÂNCIAS ATIVAS:");
    var _controlador = instance_find(obj_controlador_construcao, 0);
    if (instance_exists(_controlador)) {
        show_debug_message("   Controlador de construção: ID " + string(_controlador) + " | Visível: " + string(_controlador.visible));
        show_debug_message("   grid_x: " + string(_controlador.grid_x) + " | grid_y: " + string(_controlador.grid_y));
    } else {
        show_debug_message("   ❌ Controlador de construção: NÃO ENCONTRADO");
    }
    
    var _menu = instance_find(obj_menu_construcao, 0);
    if (instance_exists(_menu)) {
        show_debug_message("   Menu de construção: ID " + string(_menu) + " | Visível: " + string(_menu.visible));
    } else {
        show_debug_message("   ❌ Menu de construção: NÃO ENCONTRADO");
    }
    
    // 4. Verificar sprites
    show_debug_message("4. SPRITES:");
    show_debug_message("   spr_quartel existe: " + string(sprite_exists(spr_quartel)));
    show_debug_message("   spr_casa existe: " + string(sprite_exists(spr_casa)));
    show_debug_message("   spr_banco existe: " + string(sprite_exists(spr_banco)));
    
    // 5. Verificar asset indexes
    show_debug_message("5. ASSET INDEXES:");
    show_debug_message("   obj_quartel index: " + string(asset_get_index("obj_quartel")));
    show_debug_message("   obj_casa index: " + string(asset_get_index("obj_casa")));
    show_debug_message("   obj_banco index: " + string(asset_get_index("obj_banco")));
    
    // 6. Teste de ativação manual
    show_debug_message("6. TESTE DE ATIVAÇÃO:");
    show_debug_message("   Tentando ativar modo de construção...");
    global.modo_construcao = true;
    global.construindo_agora = asset_get_index("obj_quartel");
    show_debug_message("   Estado após ativação:");
    show_debug_message("   global.modo_construcao: " + string(global.modo_construcao));
    show_debug_message("   global.construindo_agora: " + string(global.construindo_agora));
    
    // 7. Verificar função de coordenadas
    show_debug_message("7. FUNÇÃO DE COORDENADAS:");
    if (function_exists("scr_mouse_to_world")) {
        var _coords = scr_mouse_to_world();
        show_debug_message("   scr_mouse_to_world(): (" + string(_coords[0]) + ", " + string(_coords[1]) + ")");
    } else {
        show_debug_message("   ❌ scr_mouse_to_world não existe");
    }
    
    show_debug_message("=== FIM DO DIAGNÓSTICO ===");
}
