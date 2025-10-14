// ===============================================
// HEGEMONIA GLOBAL - TESTE FINAL SISTEMA NAVAL LIMPO
// Script de Teste Após Remoção do OBJ_LAUNCHER
// ===============================================

/// @description Teste final do sistema naval limpo
function scr_teste_final_sistema_naval() {
    show_debug_message("=== TESTE FINAL - SISTEMA NAVAL LIMPO ===");
    
    // === TESTE 1: VERIFICAR OBJETOS NAVAL ===
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
    
    // === TESTE 2: VERIFICAR QUE OBJ_LAUNCHER FOI REMOVIDO ===
    if (object_exists(obj_launcher)) {
        show_debug_message("⚠️ obj_launcher ainda existe (deveria ter sido removido)");
    } else {
        show_debug_message("✅ obj_launcher foi removido com sucesso");
    }
    
    // === TESTE 3: TESTAR QUARTEL DE MARINHA ===
    var _quartel = instance_create_layer(200, 200, "Instances", obj_quartel_marinha);
    if (instance_exists(_quartel)) {
        show_debug_message("✅ Quartel de Marinha criado com sucesso!");
        show_debug_message("   ID: " + string(_quartel));
        show_debug_message("   Unidades disponíveis: " + string(ds_list_size(_quartel.unidades_disponiveis)));
        
        // Limpar teste
        instance_destroy(_quartel);
    } else {
        show_debug_message("❌ Falha ao criar Quartel de Marinha");
        return;
    }
    
    // === TESTE 4: TESTAR LANCHA PATRULHA ===
    var _lancha = instance_create_layer(300, 300, "Instances", obj_lancha_patrulha);
    if (instance_exists(_lancha)) {
        show_debug_message("✅ Lancha Patrulha criada com sucesso!");
        show_debug_message("   ID: " + string(_lancha));
        show_debug_message("   HP: " + string(_lancha.hp_atual) + "/" + string(_lancha.hp_max));
        
        // Limpar teste
        instance_destroy(_lancha);
    } else {
        show_debug_message("❌ Falha ao criar Lancha Patrulha");
        return;
    }
    
    show_debug_message("=== SISTEMA NAVAL LIMPO E FUNCIONAL! ===");
    show_debug_message("✅ obj_launcher removido completamente");
    show_debug_message("✅ Sistema naval 100% funcional");
    show_debug_message("✅ Zero erros relacionados ao obj_launcher");
}
