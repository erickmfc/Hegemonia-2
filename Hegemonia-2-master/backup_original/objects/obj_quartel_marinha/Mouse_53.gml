// ===============================================
// HEGEMONIA GLOBAL - QUARTEL MARINHA: MENU DE RECRUTAMENTO
// Bloco 4, Fase 3: Interface de Recrutamento Naval (ATUALIZADA)
// ===============================================

// Evento Left Pressed de obj_quartel_marinha
// Verificar se o clique foi realmente no sprite do quartel marinha
if (mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
    if (!global.menu_recrutamento_aberto && !global.modo_construcao && global.construindo_agora == noone) {
        // Verificar se o quartel marinha está completamente construído antes de abrir o menu
        // Como o quartel marinha já foi criado como instância, ele está completo
        
        // === VALIDAÇÃO REAL DE ÁGUA USANDO TILES ===
        var _tem_agua_proxima = false;
        var _check_radius = 3; // Raio de verificação em tiles (3 tiles = 96 pixels)
        
        // Obter a camada de água
        var camada_agua = layer_tilemap_get_id(layer_get_id("camada_agua"));
        
        if (camada_agua != -1) {
            // Converter posição do quartel para coordenadas de tile
            var _quartel_tile_x = floor(x / global.tile_size);
            var _quartel_tile_y = floor(y / global.tile_size);
            
            // Verificar se há água nas proximidades
            for (var _check_x = _quartel_tile_x - _check_radius; _check_x <= _quartel_tile_x + _check_radius; _check_x++) {
                for (var _check_y = _quartel_tile_y - _check_radius; _check_y <= _quartel_tile_y + _check_radius; _check_y++) {
                    // Verificar se o tile está dentro dos limites do mapa
                    if (_check_x >= 0 && _check_x < global.map_width && 
                        _check_y >= 0 && _check_y < global.map_height) {
                        
                        // Verificar se há um tile de água nesta posição
                        if (tilemap_get(camada_agua, _check_x, _check_y) > 0) {
                            _tem_agua_proxima = true;
                            break;
                        }
                    }
                }
                if (_tem_agua_proxima) break;
            }
            
            show_debug_message("Validação de água: Quartel em (" + string(_quartel_tile_x) + ", " + string(_quartel_tile_y) + ") - Água próxima: " + string(_tem_agua_proxima));
        } else {
            show_debug_message("AVISO: Camada de água não encontrada, permitindo construção");
            _tem_agua_proxima = true; // Fallback se não encontrar a camada
        }
        
        if (_tem_agua_proxima) {
            // Criar menu de recrutamento naval (igual ao quartel terrestre)
            var menu = instance_create_layer(x, y + 64, "Instances", obj_menu_recrutamento_marinha);
            // Definir a referência ao quartel dentro do escopo do menu
            with (menu) {
                quartel_referencia = other.id;
            }
            global.menu_recrutamento_aberto = true;
            
            show_debug_message("=== MENU DE RECRUTAMENTO NAVAL CRIADO ===");
            show_debug_message("Menu ID: " + string(menu));
            show_debug_message("Quartel Marinha ID: " + string(id));
            show_debug_message("Posição do menu: (" + string(menu.x) + ", " + string(menu.y) + ")");
        } else {
            show_debug_message("❌ ERRO: Quartel Marinha deve ser construído próximo à água!");
            show_debug_message("Construa o quartel marinha em uma área com água nas proximidades.");
        }
    } else {
        if (global.menu_recrutamento_aberto) {
            show_debug_message("Menu de recrutamento já está aberto.");
        } else if (global.modo_construcao) {
            show_debug_message("Não é possível abrir menu durante construção.");
        } else if (global.construindo_agora != noone) {
            show_debug_message("Não é possível abrir menu enquanto outra construção está em andamento.");
        }
    }
}
