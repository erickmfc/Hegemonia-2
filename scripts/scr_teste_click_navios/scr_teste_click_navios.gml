/// @description Teste específico do sistema de click nos navios
/// @function scr_teste_click_navios

show_debug_message("=== TESTE: SISTEMA DE CLICK NOS NAVIOS ===");

// 1. Verificar se há navios
var navios = instance_number(obj_lancha_patrulha);
if (navios == 0) {
    show_debug_message("❌ Nenhum navio encontrado! Criando navio de teste...");
    
    // Criar navio de teste
    var navio_teste = instance_create_layer(400, 300, "rm_mapa_principal", obj_lancha_patrulha);
    if (navio_teste != noone) {
        show_debug_message("✅ Navio de teste criado com ID: " + string(navio_teste));
    } else {
        show_debug_message("❌ Falha ao criar navio de teste!");
        exit;
    }
}

// 2. Simular clique em cada navio
with (obj_lancha_patrulha) {
    show_debug_message("🚢 Testando navio ID: " + string(id));
    show_debug_message("   - Posição: (" + string(x) + ", " + string(y) + ")");
    show_debug_message("   - Selecionado antes: " + string(variable_instance_exists(id, "selecionado") ? selecionado : "N/A"));
    
    // Simular clique
    var mouse_world_x = camera_get_view_x(view_camera[0]) + x;
    var mouse_world_y = camera_get_view_y(view_camera[0]) + y;
    
    // Testar collision_point
    var resultado = collision_point(mouse_world_x, mouse_world_y, obj_lancha_patrulha, false, true);
    if (resultado == id) {
        show_debug_message("✅ Collision_point funcionando para este navio");
        
        // Simular seleção
        selecionado = true;
        show_debug_message("✅ Navio selecionado!");
    } else {
        show_debug_message("❌ Collision_point NÃO funcionando para este navio");
        show_debug_message("   - Resultado esperado: " + string(id));
        show_debug_message("   - Resultado obtido: " + string(resultado));
    }
}

// 3. Verificar se obj_controlador_unidades está funcionando
var controlador = instance_first(obj_controlador_unidades);
if (controlador != noone) {
    show_debug_message("🎮 Controlador encontrado: " + string(controlador));
    
    // Verificar se tem eventos Step
    show_debug_message("   - Step_0 existe: " + string(event_exists(ev_step, ev_step_normal)));
    show_debug_message("   - Step_1 existe: " + string(event_exists(ev_step, ev_step_begin)));
} else {
    show_debug_message("❌ Controlador de unidades não encontrado!");
}

show_debug_message("=== FIM DO TESTE ===");
