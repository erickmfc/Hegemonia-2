/// @description Diagnosticar problemas de construção
/// @param {string} tipo Tipo de construção a diagnosticar

function scr_diagnosticar_construcao(tipo) {
    
    show_debug_message("🔍 === DIAGNÓSTICO DE CONSTRUÇÃO ===");
    show_debug_message("🔍 Tipo: " + tipo);
    
    // === VERIFICAR VARIÁVEIS GLOBAIS ===
    show_debug_message("🔍 VARIÁVEIS GLOBAIS:");
    show_debug_message("   global.construindo_agora: " + string(global.construindo_agora));
    show_debug_message("   global.modo_construcao: " + string(global.modo_construcao));
    show_debug_message("   global.dinheiro: $" + string(global.dinheiro));
    show_debug_message("   global.tile_size: " + string(global.tile_size));
    
    // === VERIFICAR OBJETOS ===
    show_debug_message("🔍 VERIFICAÇÃO DE OBJETOS:");
    show_debug_message("   obj_quartel existe: " + string(object_exists(obj_quartel)));
    show_debug_message("   asset_get_index('obj_quartel'): " + string(asset_get_index("obj_quartel")));
    
    // === VERIFICAR SPRITES ===
    show_debug_message("🔍 VERIFICAÇÃO DE SPRITES:");
    show_debug_message("   spr_quartel existe: " + string(sprite_exists(spr_quartel)));
    show_debug_message("   asset_get_index('spr_quartel'): " + string(asset_get_index("spr_quartel")));
    
    // === VERIFICAR GERENCIADORES ===
    show_debug_message("🔍 VERIFICAÇÃO DE GERENCIADORES:");
    show_debug_message("   obj_input_manager existe: " + string(instance_exists(obj_input_manager)));
    show_debug_message("   obj_controlador_construcao existe: " + string(instance_exists(obj_controlador_construcao)));
    
    // === VERIFICAR MENU DE CONSTRUÇÃO ===
    show_debug_message("🔍 VERIFICAÇÃO DE MENU:");
    show_debug_message("   obj_menu_construcao existe: " + string(instance_exists(obj_menu_construcao)));
    
    // === TESTE DE CRIAÇÃO ===
    if (tipo == "teste") {
        show_debug_message("🔍 TESTE DE CRIAÇÃO:");
        var _test_obj = instance_create_layer(100, 100, "Instances", obj_quartel);
        if (instance_exists(_test_obj)) {
            show_debug_message("   ✅ Criação de teste bem-sucedida: " + string(_test_obj));
            instance_destroy(_test_obj);
        } else {
            show_debug_message("   ❌ Falha na criação de teste");
        }
    }
    
    // === VERIFICAR COORDENADAS ===
    show_debug_message("🔍 VERIFICAÇÃO DE COORDENADAS:");
    show_debug_message("   mouse_x: " + string(mouse_x));
    show_debug_message("   mouse_y: " + string(mouse_y));
    show_debug_message("   camera_x: " + string(camera_x));
    show_debug_message("   camera_y: " + string(camera_y));
    
    // === VERIFICAR ZOOM ===
    show_debug_message("🔍 VERIFICAÇÃO DE ZOOM:");
    show_debug_message("   zoom_level: " + string(zoom_level));
    show_debug_message("   room_width: " + string(room_width));
    show_debug_message("   room_height: " + string(room_height));
    
    show_debug_message("🔍 === DIAGNÓSTICO CONCLUÍDO ===");
}
