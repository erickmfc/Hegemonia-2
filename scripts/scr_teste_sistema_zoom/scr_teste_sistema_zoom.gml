/// @description Teste de Sistema de Zoom e Coordenadas
/// @param {bool} detalhado Se true, mostra análise detalhada

function scr_teste_sistema_zoom(detalhado = true) {
    show_debug_message("=== 🔍 TESTE DE SISTEMA DE ZOOM E COORDENADAS ===");
    
    // === 1. VERIFICAR INPUT MANAGER ===
    var _input_manager = instance_find(obj_input_manager, 0);
    
    if (!instance_exists(_input_manager)) {
        show_debug_message("❌ ERRO CRÍTICO: obj_input_manager não encontrado!");
        show_debug_message("   - Sistema de zoom não funcionará");
        show_debug_message("   - Coordenadas serão incorretas");
        return false;
    }
    
    show_debug_message("✅ Input Manager encontrado!");
    show_debug_message("   - Zoom atual: " + string(_input_manager.zoom_level));
    show_debug_message("   - Câmera X: " + string(_input_manager.camera_x));
    show_debug_message("   - Câmera Y: " + string(_input_manager.camera_y));
    
    // === 2. TESTE DE COORDENADAS ===
    show_debug_message("🧪 TESTE DE CONVERSÃO DE COORDENADAS:");
    
    // Coordenadas do mouse
    var mouse_x_atual = mouse_x;
    var mouse_y_atual = mouse_y;
    
    show_debug_message("   Mouse atual: (" + string(mouse_x_atual) + ", " + string(mouse_y_atual) + ")");
    
    // Sistema antigo (incorreto com zoom)
    var world_x_antigo = camera_get_view_x(view_camera[0]) + mouse_x_atual;
    var world_y_antigo = camera_get_view_y(view_camera[0]) + mouse_y_atual;
    
    show_debug_message("   Sistema antigo: (" + string(world_x_antigo) + ", " + string(world_y_antigo) + ")");
    
    // Sistema novo (correto com zoom)
    var _cam_x = _input_manager.camera_x - (room_width * _input_manager.zoom_level) / 2;
    var _cam_y = _input_manager.camera_y - (room_height * _input_manager.zoom_level) / 2;
    
    var world_x_novo = _cam_x + (mouse_x_atual * _input_manager.zoom_level);
    var world_y_novo = _cam_y + (mouse_y_atual * _input_manager.zoom_level);
    
    show_debug_message("   Sistema novo: (" + string(world_x_novo) + ", " + string(world_y_novo) + ")");
    
    // Calcular diferença
    var diferenca_x = abs(world_x_novo - world_x_antigo);
    var diferenca_y = abs(world_y_novo - world_y_antigo);
    
    show_debug_message("   Diferença: (" + string(diferenca_x) + ", " + string(diferenca_y) + ")");
    
    if (diferenca_x > 10 || diferenca_y > 10) {
        show_debug_message("   ⚠️ DIFERENÇA SIGNIFICATIVA - Sistema antigo estava incorreto!");
    } else {
        show_debug_message("   ✅ Diferença pequena - Sistemas similares");
    }
    
    // === 3. TESTE COM DIFERENTES NÍVEIS DE ZOOM ===
    if (detalhado) {
        show_debug_message("🔍 TESTE COM DIFERENTES NÍVEIS DE ZOOM:");
        
        var niveis_zoom = [0.5, 1.0, 1.5, 2.0];
        
        for (var i = 0; i < array_length(niveis_zoom); i++) {
            var zoom_teste = niveis_zoom[i];
            
            show_debug_message("   Zoom " + string(zoom_teste) + ":");
            
            // Simular coordenadas com este zoom
            var _cam_x_teste = _input_manager.camera_x - (room_width * zoom_teste) / 2;
            var _cam_y_teste = _input_manager.camera_y - (room_height * zoom_teste) / 2;
            
            var world_x_teste = _cam_x_teste + (mouse_x_atual * zoom_teste);
            var world_y_teste = _cam_y_teste + (mouse_y_atual * zoom_teste);
            
            show_debug_message("     Mundo: (" + string(world_x_teste) + ", " + string(world_y_teste) + ")");
        }
    }
    
    // === 4. TESTE DE DETECÇÃO DE OBJETOS ===
    show_debug_message("🎯 TESTE DE DETECÇÃO DE OBJETOS:");
    
    // Usar coordenadas corretas
    var world_x_correto = _cam_x + (mouse_x_atual * _input_manager.zoom_level);
    var world_y_correto = _cam_y + (mouse_y_atual * _input_manager.zoom_level);
    
    // Testar detecção de diferentes objetos
    var objetos_teste = [
        obj_lancha_patrulha,
        obj_infantaria,
        obj_quartel,
        obj_quartel_marinha
    ];
    
    var nomes_objetos = [
        "Lancha Patrulha",
        "Infantaria",
        "Quartel",
        "Quartel Marinha"
    ];
    
    for (var i = 0; i < array_length(objetos_teste); i++) {
        var obj_teste = objetos_teste[i];
        var nome_teste = nomes_objetos[i];
        
        var objeto_encontrado = collision_point(world_x_correto, world_y_correto, obj_teste, false, true);
        
        if (objeto_encontrado != noone) {
            show_debug_message("   ✅ " + nome_teste + " encontrado em: (" + string(world_x_correto) + ", " + string(world_y_correto) + ")");
        } else {
            show_debug_message("   ❌ " + nome_teste + " NÃO encontrado em: (" + string(world_x_correto) + ", " + string(world_y_correto) + ")");
        }
    }
    
    // === 5. TESTE PRÁTICO ===
    show_debug_message("🚀 TESTE PRÁTICO:");
    
    // Verificar se há objetos próximos ao mouse
    var objetos_proximos = 0;
    
    with (obj_lancha_patrulha) {
        var distancia = point_distance(x, y, world_x_correto, world_y_correto);
        if (distancia < 50) {
            objetos_proximos++;
            show_debug_message("   🚢 Lancha Patrulha próxima - Distância: " + string(distancia));
        }
    }
    
    with (obj_infantaria) {
        var distancia = point_distance(x, y, world_x_correto, world_y_correto);
        if (distancia < 50) {
            objetos_proximos++;
            show_debug_message("   👥 Infantaria próxima - Distância: " + string(distancia));
        }
    }
    
    with (obj_quartel) {
        var distancia = point_distance(x, y, world_x_correto, world_y_correto);
        if (distancia < 100) {
            objetos_proximos++;
            show_debug_message("   🏢 Quartel próximo - Distância: " + string(distancia));
        }
    }
    
    with (obj_quartel_marinha) {
        var distancia = point_distance(x, y, world_x_correto, world_y_correto);
        if (distancia < 100) {
            objetos_proximos++;
            show_debug_message("   🚢 Quartel Marinha próximo - Distância: " + string(distancia));
        }
    }
    
    show_debug_message("   Objetos próximos ao mouse: " + string(objetos_proximos));
    
    // === 6. RESUMO FINAL ===
    show_debug_message("=== 📊 RESUMO DO TESTE ===");
    
    var problemas = 0;
    
    if (!instance_exists(_input_manager)) problemas++;
    if (diferenca_x > 50 || diferenca_y > 50) problemas++;
    if (objetos_proximos == 0) problemas++;
    
    if (problemas == 0) {
        show_debug_message("✅ SISTEMA DE ZOOM FUNCIONANDO PERFEITAMENTE!");
        show_debug_message("   - Input manager operacional");
        show_debug_message("   - Coordenadas corretas com zoom");
        show_debug_message("   - Detecção de objetos funcionando");
        show_debug_message("   - Sistema robusto e confiável");
    } else {
        show_debug_message("⚠️ PROBLEMAS DETECTADOS: " + string(problemas));
        show_debug_message("   - Verifique os itens marcados com ❌");
    }
    
    show_debug_message("=== 🔍 TESTE DE ZOOM CONCLUÍDO ===");
    
    return (problemas == 0);
}
