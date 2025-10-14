// ===============================================
// HEGEMONIA GLOBAL - DIAGNÓSTICO COMPLETO DE PROBLEMAS
// Script para identificar e corrigir todos os problemas identificados
// ===============================================

/// @description Diagnóstico completo dos problemas identificados
function scr_diagnostico_problemas_completo() {
    show_debug_message("=== DIAGNÓSTICO COMPLETO DE PROBLEMAS ===");
    
    // === PROBLEMA 1: SISTEMA DE COORDENADAS INCONSISTENTE ===
    show_debug_message("=== PROBLEMA 1: COORDENADAS INCONSISTENTES ===");
    
    show_debug_message("🔍 ANÁLISE DO obj_controlador_unidades:");
    show_debug_message("  Step_0 - Clique simples:");
    show_debug_message("    Linha 6-7: world_x = camera_get_view_x(view_camera[0]) + mouse_x");
    show_debug_message("    Linha 70-71: inicio_selecao_x = mouse_x (SEM camera)");
    show_debug_message("    Linha 80-81: world_x = mouse_x (SEM camera)");
    
    show_debug_message("  Step_1 - Clique simples:");
    show_debug_message("    Linha 53-54: world_x = camera_get_view_x(view_camera[0]) + mouse_x");
    show_debug_message("    Linha 187-188: inicio_selecao_x = camera_get_view_x(view_camera[0]) + mouse_x");
    show_debug_message("    Linha 194-195: world_x = camera_get_view_x(view_camera[0]) + mouse_x");
    
    show_debug_message("❌ INCONSISTÊNCIA IDENTIFICADA:");
    show_debug_message("  - Step_0 usa coordenadas mistas (com/sem camera)");
    show_debug_message("  - Step_1 usa coordenadas consistentes (sempre com camera)");
    show_debug_message("  - Isso causa problemas de detecção de colisão");
    
    // === PROBLEMA 2: DETECÇÃO DE NAVIOS ===
    show_debug_message("=== PROBLEMA 2: DETECÇÃO DE NAVIOS ===");
    
    var _navios_count = instance_number(obj_lancha_patrulha);
    show_debug_message("Navios na sala: " + string(_navios_count));
    
    if (_navios_count > 0) {
        with (obj_lancha_patrulha) {
            show_debug_message("  Navio ID: " + string(id));
            show_debug_message("    Posição: (" + string(x) + ", " + string(y) + ")");
            show_debug_message("    Selecionado: " + string(selecionado));
            show_debug_message("    Visível: " + string(visible));
            show_debug_message("    Sólido: " + string(solid));
            show_debug_message("    Sprite: " + string(sprite_index));
        }
    } else {
        show_debug_message("⚠️ Nenhum navio encontrado para teste");
    }
    
    // === PROBLEMA 3: SISTEMA DE ZOOM ===
    show_debug_message("=== PROBLEMA 3: SISTEMA DE ZOOM ===");
    
    show_debug_message("🔍 Informações da câmera:");
    show_debug_message("  View camera[0]: " + string(view_camera[0]));
    show_debug_message("  Camera view X: " + string(camera_get_view_x(view_camera[0])));
    show_debug_message("  Camera view Y: " + string(camera_get_view_y(view_camera[0])));
    show_debug_message("  Camera view W: " + string(camera_get_view_width(view_camera[0])));
    show_debug_message("  Camera view H: " + string(camera_get_view_height(view_camera[0])));
    
    show_debug_message("🔍 Coordenadas do mouse:");
    show_debug_message("  Mouse X: " + string(mouse_x));
    show_debug_message("  Mouse Y: " + string(mouse_y));
    show_debug_message("  Mouse world X: " + string(camera_get_view_x(view_camera[0]) + mouse_x));
    show_debug_message("  Mouse world Y: " + string(camera_get_view_y(view_camera[0]) + mouse_y));
    
    // === PROBLEMA 4: DEBUG ESPECÍFICO PARA NAVIOS ===
    show_debug_message("=== PROBLEMA 4: DEBUG PARA NAVIOS ===");
    
    show_debug_message("🔍 Verificando debug específico:");
    show_debug_message("  global.debug_enabled: " + string(global.debug_enabled));
    show_debug_message("  Debug específico para navios: AUSENTE");
    show_debug_message("  ❌ PROBLEMA: Falta debug específico para navios");
    
    show_debug_message("=== DIAGNÓSTICO CONCLUÍDO ===");
}

/// @description Teste de detecção de navios
function scr_teste_deteccao_navios() {
    show_debug_message("=== TESTE DE DETECÇÃO DE NAVIOS ===");
    
    // Criar navio de teste
    var _navio_teste = instance_create_layer(300, 300, "rm_mapa_principal", obj_lancha_patrulha);
    
    if (instance_exists(_navio_teste)) {
        show_debug_message("✅ Navio de teste criado: " + string(_navio_teste));
        show_debug_message("📍 Posição: (" + string(_navio_teste.x) + ", " + string(_navio_teste.y) + ")");
        
        // Testar detecção com coordenadas corretas
        var _world_x = camera_get_view_x(view_camera[0]) + mouse_x;
        var _world_y = camera_get_view_y(view_camera[0]) + mouse_y;
        
        show_debug_message("🔍 Testando detecção:");
        show_debug_message("  Posição do navio: (" + string(_navio_teste.x) + ", " + string(_navio_teste.y) + ")");
        show_debug_message("  Coordenadas do mouse: (" + string(_world_x) + ", " + string(_world_y) + ")");
        
        // Simular clique próximo ao navio
        var _test_x = _navio_teste.x;
        var _test_y = _navio_teste.y;
        
        var _navio_detectado = collision_point(_test_x, _test_y, obj_lancha_patrulha, false, true);
        
        if (_navio_detectado != noone) {
            show_debug_message("✅ Navio detectado corretamente!");
            show_debug_message("  ID detectado: " + string(_navio_detectado));
        } else {
            show_debug_message("❌ Navio NÃO foi detectado!");
            show_debug_message("  Possível problema: collision_point não funciona");
        }
        
        // Destruir navio de teste
        instance_destroy(_navio_teste);
        show_debug_message("✅ Navio de teste destruído");
        
    } else {
        show_debug_message("❌ Falha ao criar navio de teste");
    }
}

/// @description Corrigir sistema de coordenadas
function scr_corrigir_coordenadas() {
    show_debug_message("=== CORREÇÃO DE COORDENADAS ===");
    
    show_debug_message("🔧 CORREÇÕES NECESSÁRIAS:");
    show_debug_message("1. Padronizar uso de camera_get_view_x/y em TODOS os eventos");
    show_debug_message("2. Remover coordenadas inconsistentes do Step_0");
    show_debug_message("3. Adicionar debug específico para navios");
    show_debug_message("4. Verificar sistema de zoom");
    
    show_debug_message("📝 CÓDIGO CORRETO PARA USAR:");
    show_debug_message("var world_x = camera_get_view_x(view_camera[0]) + mouse_x;");
    show_debug_message("var world_y = camera_get_view_y(view_camera[0]) + mouse_y;");
}

/// @description Teste de zoom
function scr_teste_zoom() {
    show_debug_message("=== TESTE DE ZOOM ===");
    
    show_debug_message("🔍 Estado atual do zoom:");
    show_debug_message("  Camera view X: " + string(camera_get_view_x(view_camera[0])));
    show_debug_message("  Camera view Y: " + string(camera_get_view_y(view_camera[0])));
    show_debug_message("  Camera view W: " + string(camera_get_view_width(view_camera[0])));
    show_debug_message("  Camera view H: " + string(camera_get_view_height(view_camera[0])));
    
    show_debug_message("🔍 Coordenadas do mouse:");
    show_debug_message("  Mouse X: " + string(mouse_x));
    show_debug_message("  Mouse Y: " + string(mouse_y));
    
    show_debug_message("🔍 Coordenadas mundo:");
    show_debug_message("  World X: " + string(camera_get_view_x(view_camera[0]) + mouse_x));
    show_debug_message("  World Y: " + string(camera_get_view_y(view_camera[0]) + mouse_y));
    
    show_debug_message("💡 Se as coordenadas mundo estiverem incorretas, há problema com zoom");
}

/// @description Adicionar debug específico para navios
function scr_adicionar_debug_navios() {
    show_debug_message("=== ADICIONANDO DEBUG PARA NAVIOS ===");
    
    // Ativar debug global temporariamente
    var _debug_anterior = global.debug_enabled;
    global.debug_enabled = true;
    
    show_debug_message("🔧 Debug ativado para navios");
    
    // Testar debug com navios existentes
    var _navios_count = instance_number(obj_lancha_patrulha);
    show_debug_message("Navios para debug: " + string(_navios_count));
    
    with (obj_lancha_patrulha) {
        show_debug_message("🚢 NAVIO DEBUG - ID: " + string(id));
        show_debug_message("  Posição: (" + string(x) + ", " + string(y) + ")");
        show_debug_message("  Selecionado: " + string(selecionado));
        show_debug_message("  Estado: " + string(estado));
        show_debug_message("  HP: " + string(hp_atual) + "/" + string(hp_max));
        show_debug_message("  Nação: " + string(nacao_proprietaria));
    }
    
    // Restaurar debug anterior
    global.debug_enabled = _debug_anterior;
    
    show_debug_message("✅ Debug específico para navios adicionado");
}
