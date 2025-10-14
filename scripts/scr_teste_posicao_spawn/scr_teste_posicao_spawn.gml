// ===============================================
// HEGEMONIA GLOBAL - TESTE DE POSIÇÃO DE SPAWN
// Script para testar a nova posição de spawn dos navios
// ===============================================

/// @description Teste da nova posição de spawn
function scr_teste_posicao_spawn() {
    show_debug_message("=== TESTE DE POSIÇÃO DE SPAWN ===");
    
    // Encontrar quartel
    var _quartel = instance_position(200, 200, obj_quartel_marinha);
    if (_quartel == noone) {
        _quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
        show_debug_message("✅ Quartel criado: " + string(_quartel));
    } else {
        show_debug_message("✅ Quartel encontrado: " + string(_quartel));
    }
    
    if (instance_exists(_quartel)) {
        show_debug_message("📍 Quartel posição: (" + string(_quartel.x) + ", " + string(_quartel.y) + ")");
        
        // Calcular nova posição de spawn
        var _spawn_x = _quartel.x + 150;  // ✅ AUMENTADO de 80 para 150 - ainda mais afastado
        var _spawn_y = _quartel.y + 150;  // ✅ AUMENTADO de 80 para 150 - ainda mais afastado
        
        show_debug_message("📍 Nova posição de spawn: (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
        show_debug_message("📏 Distância do quartel: " + string(point_distance(_quartel.x, _quartel.y, _spawn_x, _spawn_y)) + " pixels");
        
        // Criar navio de teste na nova posição
        var _navio_teste = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", obj_lancha_patrulha);
        
        if (instance_exists(_navio_teste)) {
            show_debug_message("✅ Navio criado na nova posição!");
            show_debug_message("📍 Navio posição: (" + string(_navio_teste.x) + ", " + string(_navio_teste.y) + ")");
            show_debug_message("📏 Distância real: " + string(point_distance(_quartel.x, _quartel.y, _navio_teste.x, _navio_teste.y)) + " pixels");
            
            // Destruir navio de teste após 3 segundos
            _navio_teste.alarm[0] = 180; // 3 segundos
            show_debug_message("⏰ Navio de teste será destruído em 3 segundos");
            
        } else {
            show_debug_message("❌ Falha ao criar navio na nova posição");
        }
    }
}

/// @description Comparar posições antiga vs nova
function scr_comparar_posicoes() {
    show_debug_message("=== COMPARAÇÃO DE POSIÇÕES ===");
    
    // Encontrar quartel
    var _quartel = instance_position(200, 200, obj_quartel_marinha);
    if (_quartel == noone) {
        _quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    }
    
    if (instance_exists(_quartel)) {
        show_debug_message("📍 Quartel posição: (" + string(_quartel.x) + ", " + string(_quartel.y) + ")");
        
        // Posição antiga (50 pixels)
        var _pos_antiga_x = _quartel.x + 50;
        var _pos_antiga_y = _quartel.y + 50;
        var _dist_antiga = point_distance(_quartel.x, _quartel.y, _pos_antiga_x, _pos_antiga_y);
        
        // Posição nova (80 pixels)
        var _pos_nova_x = _quartel.x + 80;
        var _pos_nova_y = _quartel.y + 80;
        var _dist_nova = point_distance(_quartel.x, _quartel.y, _pos_nova_x, _pos_nova_y);
        
        show_debug_message("🔍 POSIÇÃO ANTIGA:");
        show_debug_message("  Coordenadas: (" + string(_pos_antiga_x) + ", " + string(_pos_antiga_y) + ")");
        show_debug_message("  Distância: " + string(_dist_antiga) + " pixels");
        
        show_debug_message("🔍 POSIÇÃO NOVA:");
        show_debug_message("  Coordenadas: (" + string(_pos_nova_x) + ", " + string(_pos_nova_y) + ")");
        show_debug_message("  Distância: " + string(_dist_nova) + " pixels");
        
        show_debug_message("📊 DIFERENÇA:");
        show_debug_message("  Mais afastado por: " + string(_dist_nova - _dist_antiga) + " pixels");
        show_debug_message("  Percentual de aumento: " + string(round((_dist_nova / _dist_antiga - 1) * 100)) + "%");
    }
}

/// @description Teste de produção com nova posição
function scr_teste_producao_nova_posicao() {
    show_debug_message("=== TESTE DE PRODUÇÃO COM NOVA POSIÇÃO ===");
    
    // Encontrar quartel
    var _quartel = instance_position(200, 200, obj_quartel_marinha);
    if (_quartel == noone) {
        _quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    }
    
    if (instance_exists(_quartel)) {
        // Inicializar recursos
        if (!variable_global_exists("dinheiro")) {
            global.dinheiro = 10000;
        }
        
        // Simular compra
        if (ds_list_size(_quartel.unidades_disponiveis) > 0) {
            var _unidade_data = _quartel.unidades_disponiveis[| 0];
            
            show_debug_message("🚀 Iniciando produção com nova posição...");
            show_debug_message("📍 Quartel: (" + string(_quartel.x) + ", " + string(_quartel.y) + ")");
            show_debug_message("📍 Navio aparecerá em: (" + string(_quartel.x + 80) + ", " + string(_quartel.y + 80) + ")");
            
            // Adicionar à fila
            ds_queue_enqueue(_quartel.fila_producao, _unidade_data);
            
            // Configurar Alarm event
            _quartel.produzindo = true;
            _quartel.alarm[0] = _unidade_data.tempo_treino;
            
            show_debug_message("✅ Produção iniciada!");
            show_debug_message("⏰ Navio aparecerá em " + string(_unidade_data.tempo_treino / 60) + " segundos");
            show_debug_message("📍 Posição: 80 pixels mais afastado do quartel");
        }
    }
}
