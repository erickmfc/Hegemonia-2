// ===============================================
// HEGEMONIA GLOBAL - TESTE SIMPLES DO QUARTEL DA MARINHA
// Script de Teste Rápido
// ===============================================

/// @description Teste simples do quartel da marinha
function scr_teste_simples_quartel_marinha() {
    show_debug_message("=== TESTE SIMPLES DO QUARTEL DA MARINHA ===");
    
    // Verificar objetos
    if (object_exists(obj_quartel_marinha)) {
        show_debug_message("✅ obj_quartel_marinha existe");
    } else {
        show_debug_message("❌ obj_quartel_marinha NÃO existe");
        return;
    }
    
    if (object_exists(obj_menu_recrutamento_marinha)) {
        show_debug_message("✅ obj_menu_recrutamento_marinha existe");
    } else {
        show_debug_message("❌ obj_menu_recrutamento_marinha NÃO existe");
        return;
    }
    
    if (object_exists(obj_lancha_patrulha)) {
        show_debug_message("✅ obj_lancha_patrulha existe");
    } else {
        show_debug_message("❌ obj_lancha_patrulha NÃO existe");
        return;
    }
    
    // Verificar scripts
    if (script_exists(scr_selecionar_quartel)) {
        show_debug_message("✅ scr_selecionar_quartel existe");
    } else {
        show_debug_message("❌ scr_selecionar_quartel NÃO existe");
    }
    
    if (script_exists(scr_logica_quartel_comum)) {
        show_debug_message("✅ scr_logica_quartel_comum existe");
    } else {
        show_debug_message("❌ scr_logica_quartel_comum NÃO existe");
    }
    
    // Teste de criação
    var _quartel = instance_create_layer(300, 300, "Instances", obj_quartel_marinha);
    if (instance_exists(_quartel)) {
        show_debug_message("✅ Quartel da marinha criado com sucesso!");
        show_debug_message("   ID: " + string(_quartel));
        show_debug_message("   Unidades disponíveis: " + string(ds_list_size(_quartel.unidades_disponiveis)));
        
        // Limpar teste
        instance_destroy(_quartel);
        show_debug_message("✅ Teste concluído com sucesso!");
    } else {
        show_debug_message("❌ Falha ao criar quartel da marinha");
    }
}
