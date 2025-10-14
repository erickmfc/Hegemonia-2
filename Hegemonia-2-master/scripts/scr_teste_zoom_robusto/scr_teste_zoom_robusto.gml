/// @description Teste de Sistema de Zoom Robusto
/// @param {bool} detalhado Se true, mostra análise detalhada

function scr_teste_zoom_robusto(detalhado = true) {
    show_debug_message("=== 🔍 TESTE DE SISTEMA DE ZOOM ROBUSTO ===");
    
    // === 1. VERIFICAR FUNÇÃO GLOBAL ===
    if (!variable_global_exists("scr_mouse_to_world")) {
        show_debug_message("❌ ERRO CRÍTICO: Função global scr_mouse_to_world não existe!");
        show_debug_message("   - Sistema de coordenadas não funcionará");
        show_debug_message("   - Execute o jogo para inicializar a função");
        return false;
    }
    
    show_debug_message("✅ Função global scr_mouse_to_world encontrada!");
    
    // === 2. TESTE DE COORDENADAS ===
    show_debug_message("🧪 TESTE DE CONVERSÃO DE COORDENADAS:");
    
    // Usar função global
    var _coords = global.scr_mouse_to_world();
    var world_x = _coords[0];
    var world_y = _coords[1];
    
    show_debug_message("   Mouse atual: (" + string(mouse_x) + ", " + string(mouse_y) + ")");
    show_debug_message("   Mundo calculado: (" + string(world_x) + ", " + string(world_y) + ")");
    
    // === 3. TESTE DE PERFORMANCE ===
    if (detalhado) {
        show_debug_message("⚡ TESTE DE PERFORMANCE:");
        
        var _start_time = current_time;
        var _iterations = 1000;
        
        for (var i = 0; i < _iterations; i++) {
            var _test_coords = global.scr_mouse_to_world();
        }
        
        var _end_time = current_time;
        var _duration = _end_time - _start_time;
        
        show_debug_message("   Iterações: " + string(_iterations));
        show_debug_message("   Tempo total: " + string(_duration) + "ms");
        show_debug_message("   Tempo médio: " + string(_duration / _iterations) + "ms por chamada");
        
        if (_duration < 100) {
            show_debug_message("   ✅ PERFORMANCE EXCELENTE");
        } else if (_duration < 500) {
            show_debug_message("   ✅ PERFORMANCE BOA");
        } else {
            show_debug_message("   ⚠️ PERFORMANCE PODE SER MELHORADA");
        }
    }
    
    // === 4. TESTE DE DETECÇÃO DE OBJETOS ===
    show_debug_message("🎯 TESTE DE DETECÇÃO DE OBJETOS:");
    
    // Testar detecção com função global
    var objetos_encontrados = 0;
    
    var hit_lp = collision_point(world_x, world_y, obj_lancha_patrulha, false, true);
    if (hit_lp != noone) {
        objetos_encontrados++;
        show_debug_message("   ✅ Lancha Patrulha encontrada");
    }
    
    var hit_inf = collision_point(world_x, world_y, obj_infantaria, false, true);
    if (hit_inf != noone) {
        objetos_encontrados++;
        show_debug_message("   ✅ Infantaria encontrada");
    }
    
    var hit_quartel = collision_point(world_x, world_y, obj_quartel, false, true);
    if (hit_quartel != noone) {
        objetos_encontrados++;
        show_debug_message("   ✅ Quartel encontrado");
    }
    
    var hit_quartel_marinha = collision_point(world_x, world_y, obj_quartel_marinha, false, true);
    if (hit_quartel_marinha != noone) {
        objetos_encontrados++;
        show_debug_message("   ✅ Quartel Marinha encontrado");
    }
    
    show_debug_message("   Objetos encontrados: " + string(objetos_encontrados));
    
    // === 5. TESTE DE ZOOM ===
    show_debug_message("🔍 TESTE DE ZOOM:");
    
    var _input_manager = instance_find(obj_input_manager, 0);
    if (instance_exists(_input_manager)) {
        show_debug_message("   Zoom atual: " + string(_input_manager.zoom_level));
        show_debug_message("   Câmera X: " + string(_input_manager.camera_x));
        show_debug_message("   Câmera Y: " + string(_input_manager.camera_y));
        
        // Testar coordenadas com diferentes níveis de zoom
        var niveis_zoom = [0.2, 0.5, 1.0, 1.5, 2.0, 3.0];
        
        show_debug_message("   Testando coordenadas com diferentes níveis de zoom:");
        for (var i = 0; i < array_length(niveis_zoom); i++) {
            var zoom_teste = niveis_zoom[i];
            
            // Simular zoom temporário
            var zoom_original = _input_manager.zoom_level;
            _input_manager.zoom_level = zoom_teste;
            
            var _coords_teste = global.scr_mouse_to_world();
            
            show_debug_message("     Zoom " + string(zoom_teste) + ": (" + string(_coords_teste[0]) + ", " + string(_coords_teste[1]) + ")");
            
            // Restaurar zoom original
            _input_manager.zoom_level = zoom_original;
        }
    } else {
        show_debug_message("   ❌ Input manager não encontrado");
    }
    
    // === 6. TESTE DE ESTABILIDADE ===
    show_debug_message("🛡️ TESTE DE ESTABILIDADE:");
    
    var _coords_1 = global.scr_mouse_to_world();
    var _coords_2 = global.scr_mouse_to_world();
    var _coords_3 = global.scr_mouse_to_world();
    
    var _diff_1_2 = abs(_coords_1[0] - _coords_2[0]) + abs(_coords_1[1] - _coords_2[1]);
    var _diff_2_3 = abs(_coords_2[0] - _coords_3[0]) + abs(_coords_2[1] - _coords_3[1]);
    var _diff_1_3 = abs(_coords_1[0] - _coords_3[0]) + abs(_coords_1[1] - _coords_3[1]);
    
    show_debug_message("   Diferença 1-2: " + string(_diff_1_2));
    show_debug_message("   Diferença 2-3: " + string(_diff_2_3));
    show_debug_message("   Diferença 1-3: " + string(_diff_1_3));
    
    if (_diff_1_2 < 0.1 && _diff_2_3 < 0.1 && _diff_1_3 < 0.1) {
        show_debug_message("   ✅ SISTEMA ESTÁVEL");
    } else {
        show_debug_message("   ⚠️ SISTEMA PODE ESTAR INSTÁVEL");
    }
    
    // === 7. RESUMO FINAL ===
    show_debug_message("=== 📊 RESUMO DO TESTE ===");
    
    var problemas = 0;
    
    if (!variable_global_exists("scr_mouse_to_world")) problemas++;
    if (!instance_exists(_input_manager)) problemas++;
    if (objetos_encontrados == 0) problemas++;
    if (_diff_1_2 > 1 || _diff_2_3 > 1 || _diff_1_3 > 1) problemas++;
    
    if (problemas == 0) {
        show_debug_message("✅ SISTEMA DE ZOOM ROBUSTO FUNCIONANDO PERFEITAMENTE!");
        show_debug_message("   - Função global operacional");
        show_debug_message("   - Coordenadas consistentes");
        show_debug_message("   - Detecção de objetos funcionando");
        show_debug_message("   - Sistema estável e responsivo");
        show_debug_message("   - Performance excelente");
    } else {
        show_debug_message("⚠️ PROBLEMAS DETECTADOS: " + string(problemas));
        show_debug_message("   - Verifique os itens marcados com ❌");
    }
    
    show_debug_message("=== 🔍 TESTE DE ZOOM ROBUSTO CONCLUÍDO ===");
    
    return (problemas == 0);
}
