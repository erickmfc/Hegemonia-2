// =========================================================
// HEGEMONIA GLOBAL - CONTROLE DE MOVIMENTO SIMPLIFICADO
// EVENTO DESATIVADO PARA EVITAR CONFLITOS
// Toda a lógica de movimento foi centralizada no Step_0.gml
exit;

// Sistema otimizado para evitar conflitos com navios
// =========================================================

if (mouse_check_button_pressed(mb_right)) {
    show_debug_message("=== CLIQUE DIREITO DETECTADO ===");
    show_debug_message("Posição do mouse: (" + string(mouse_x) + ", " + string(mouse_y) + ")");
    
    // ✅ CORREÇÃO: Usar função global para coordenadas (mais estável)
    var _coords = global.scr_mouse_to_world();
    var world_x = _coords[0];
    var world_y = _coords[1];
    
    show_debug_message("🎯 COORDENADAS COM ZOOM - Mouse: (" + string(mouse_x) + ", " + string(mouse_y) + ") | Mundo: (" + string(world_x) + ", " + string(world_y) + ")");
    
    // Verificar se há unidade selecionada
    var unidade_selecionada = noone;
    
    // Procurar unidade selecionada
    with (obj_infantaria) {
        if (selecionado) unidade_selecionada = id;
    }
    with (obj_soldado_antiaereo) {
        if (selecionado) unidade_selecionada = id;
    }
    with (obj_tanque) {
        if (selecionado) unidade_selecionada = id;
    }
    with (obj_blindado_antiaereo) {
        if (selecionado) unidade_selecionada = id;
    }
    with (obj_lancha_patrulha) {
        if (selecionado) unidade_selecionada = id;
    }
    with (obj_Constellation) {
        if (selecionado) unidade_selecionada = id;
    }
    
    if (unidade_selecionada != noone) {
        show_debug_message("Unidade selecionada: ID " + string(unidade_selecionada));
        
        // ✅ CORREÇÃO: Aplicar movimento apenas para unidades terrestres
        if (unidade_selecionada.object_index != obj_lancha_patrulha && unidade_selecionada.object_index != obj_Constellation) {
            with (unidade_selecionada) {
                estado = "movendo";
                
                // ✅ CORREÇÃO: Usar coordenadas do mundo
                var world_x_local = camera_get_view_x(view_camera[0]) + mouse_x;
                var world_y_local = camera_get_view_y(view_camera[0]) + mouse_y;
                
                destino_x = world_x_local;
                destino_y = world_y_local;
                
                show_debug_message("Unidade terrestre movendo para: (" + string(world_x_local) + ", " + string(world_y_local) + ")");
            }
        } else {
            show_debug_message("🚢 NAVIO DETECTADO - Executando movimento próprio");
            
            // ✅ CORREÇÃO: Executar movimento do navio diretamente (Lancha ou Constellation)
            with (unidade_selecionada) {
                // ✅ CORREÇÃO CRÍTICA: Usar coordenadas já calculadas com zoom
                destino_x = world_x;
                destino_y = world_y;
                estado = "movendo";
                movendo = true;
                
                var _nome_navio = (object_index == obj_lancha_patrulha) ? "Lancha Patrulha" : "Constellation";
                show_debug_message("🚢 " + _nome_navio + " movendo para: (" + string(destino_x) + ", " + string(destino_y) + ")");
                show_debug_message("🚢 Estado: " + string(estado) + " | Movendo: " + string(movendo));
            }
        }
    } else {
        show_debug_message("Nenhuma unidade selecionada para mover.");
    }
}
