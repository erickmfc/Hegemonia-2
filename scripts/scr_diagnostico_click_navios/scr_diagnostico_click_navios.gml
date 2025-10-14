/// @description Diagnóstico completo do sistema de click nos navios
/// @function scr_diagnostico_click_navios

show_debug_message("=== DIAGNÓSTICO: SISTEMA DE CLICK NOS NAVIOS ===");

// 1. Verificar se existem navios na sala
var navios_existentes = instance_number(obj_lancha_patrulha);
show_debug_message("🚢 Navios na sala: " + string(navios_existentes));

if (navios_existentes > 0) {
    // 2. Verificar posições dos navios
    with (obj_lancha_patrulha) {
        show_debug_message("   - Navio ID " + string(id) + " em (" + string(x) + ", " + string(y) + ")");
        show_debug_message("   - Selecionado: " + string(variable_instance_exists(id, "selecionado") ? selecionado : "N/A"));
    }
    
    // 3. Testar detecção de colisão
    var mouse_world_x = camera_get_view_x(view_camera[0]) + mouse_x;
    var mouse_world_y = camera_get_view_y(view_camera[0]) + mouse_y;
    
    show_debug_message("🖱️ Mouse atual: (" + string(mouse_x) + ", " + string(mouse_y) + ")");
    show_debug_message("🌍 Mouse mundo: (" + string(mouse_world_x) + ", " + string(mouse_world_y) + ")");
    
    // 4. Testar collision_point
    var navio_clicado = collision_point(mouse_world_x, mouse_world_y, obj_lancha_patrulha, false, true);
    if (navio_clicado != noone) {
        show_debug_message("✅ Collision_point detectou navio ID: " + string(navio_clicado));
    } else {
        show_debug_message("❌ Collision_point NÃO detectou navio");
    }
    
    // 5. Testar collision_point com coordenadas diretas do mouse
    var navio_clicado_direto = collision_point(mouse_x, mouse_y, obj_lancha_patrulha, false, true);
    if (navio_clicado_direto != noone) {
        show_debug_message("✅ Collision_point (direto) detectou navio ID: " + string(navio_clicado_direto));
    } else {
        show_debug_message("❌ Collision_point (direto) NÃO detectou navio");
    }
    
    // 6. Verificar se obj_controlador_unidades existe
    var controlador = instance_exists(obj_controlador_unidades);
    show_debug_message("🎮 Controlador de unidades existe: " + string(controlador));
    
    if (controlador) {
        var controlador_id = instance_first(obj_controlador_unidades);
        show_debug_message("🎮 Controlador ID: " + string(controlador_id));
    }
    
} else {
    show_debug_message("❌ NENHUM NAVIO ENCONTRADO NA SALA!");
    show_debug_message("💡 Dica: Crie um navio primeiro usando o quartel de marinha");
}

// 7. Verificar sistema de coordenadas
show_debug_message("📐 Sistema de coordenadas:");
show_debug_message("   - Camera view X: " + string(camera_get_view_x(view_camera[0])));
show_debug_message("   - Camera view Y: " + string(camera_get_view_y(view_camera[0])));
show_debug_message("   - Camera zoom: " + string(camera_get_view_width(view_camera[0]) / camera_get_view_width(view_camera[0])));

show_debug_message("=== FIM DO DIAGNÓSTICO ===");
