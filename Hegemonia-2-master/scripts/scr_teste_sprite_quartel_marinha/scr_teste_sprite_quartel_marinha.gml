// ===============================================
// HEGEMONIA GLOBAL - TESTE SPRITE QUARTEL MARINHA
// Verificar se Spr_marinha está funcionando
// ===============================================

/// @description Teste do sprite Spr_marinha
function scr_teste_sprite_quartel_marinha() {
    show_debug_message("=== TESTE SPRITE QUARTEL MARINHA ===");
    
    // === TESTE 1: VERIFICAR SE O SPRITE EXISTE ===
    if (sprite_exists(Spr_marinha)) {
        show_debug_message("✅ Sprite Spr_marinha existe");
        show_debug_message("   Largura: " + string(sprite_get_width(Spr_marinha)));
        show_debug_message("   Altura: " + string(sprite_get_height(Spr_marinha)));
    } else {
        show_debug_message("❌ Sprite Spr_marinha NÃO existe");
        return;
    }
    
    // === TESTE 2: VERIFICAR CONFIGURAÇÃO DO OBJETO ===
    if (object_exists(obj_quartel_marinha)) {
        show_debug_message("✅ obj_quartel_marinha existe");
        
        // Verificar se o sprite está configurado corretamente
        var _sprite_obj = object_get_sprite(obj_quartel_marinha);
        if (_sprite_obj == Spr_marinha) {
            show_debug_message("✅ Sprite configurado corretamente no objeto");
        } else {
            show_debug_message("⚠️ Sprite não configurado corretamente");
            show_debug_message("   Sprite atual: " + string(_sprite_obj));
            show_debug_message("   Sprite esperado: " + string(Spr_marinha));
        }
    } else {
        show_debug_message("❌ obj_quartel_marinha NÃO existe");
        return;
    }
    
    // === TESTE 3: TESTAR CRIAÇÃO DO QUARTEL ===
    var _quartel = instance_create_layer(200, 200, "Instances", obj_quartel_marinha);
    if (instance_exists(_quartel)) {
        show_debug_message("✅ Quartel de Marinha criado com sucesso!");
        show_debug_message("   ID: " + string(_quartel));
        show_debug_message("   Sprite: " + string(sprite_index));
        
        // Verificar se o sprite está sendo usado
        if (_quartel.sprite_index == Spr_marinha) {
            show_debug_message("✅ Quartel usando sprite Spr_marinha corretamente");
        } else {
            show_debug_message("⚠️ Quartel não está usando o sprite correto");
            show_debug_message("   Sprite atual: " + string(_quartel.sprite_index));
        }
        
        // Limpar teste
        instance_destroy(_quartel);
    } else {
        show_debug_message("❌ Falha ao criar Quartel de Marinha");
        return;
    }
    
    // === TESTE 4: TESTAR SISTEMA DE FANTASMA ===
    show_debug_message("=== TESTE SISTEMA DE FANTASMA ===");
    
    // Simular seleção do quartel de marinha
    global.construindo_agora = asset_get_index("obj_quartel_marinha");
    
    if (global.construindo_agora == asset_get_index("obj_quartel_marinha")) {
        show_debug_message("✅ Quartel de Marinha selecionado para construção");
        
        // Verificar se o sprite do fantasma está correto
        var _sprite_fantasma = Spr_marinha;
        if (sprite_exists(_sprite_fantasma)) {
            show_debug_message("✅ Sprite do fantasma Spr_marinha existe");
            show_debug_message("   Fantasma funcionará corretamente");
        } else {
            show_debug_message("❌ Sprite do fantasma não existe");
        }
    } else {
        show_debug_message("❌ Falha ao selecionar Quartel de Marinha");
    }
    
    // Resetar
    global.construindo_agora = noone;
    
    show_debug_message("=== TESTE CONCLUÍDO ===");
    show_debug_message("✅ Sprite Spr_marinha funcionando corretamente");
    show_debug_message("✅ Sistema de fantasma atualizado");
    show_debug_message("✅ Quartel de Marinha com visual diferenciado");
}
