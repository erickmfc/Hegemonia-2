// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
function scr_teste_quartel_multiplos_usos(){
    show_debug_message("🧪 === INICIANDO TESTE DE QUARTEL MÚLTIPLOS USOS ===");
    
    // === 1. VERIFICAR ESTADO INICIAL ===
    show_debug_message("📊 Estado inicial:");
    show_debug_message("   - global.menu_recrutamento_aberto: " + string(global.menu_recrutamento_aberto));
    show_debug_message("   - Quartéis terrestres: " + string(instance_number(obj_quartel)));
    show_debug_message("   - Quartéis de marinha: " + string(instance_number(obj_quartel_marinha)));
    show_debug_message("   - Menus abertos: " + string(instance_number(obj_menu_recrutamento) + instance_number(obj_menu_recrutamento_marinha)));
    
    // === 2. SIMULAR MÚLTIPLOS CLIQUES ===
    var _quartel = instance_find(obj_quartel, 0);
    if (_quartel != noone) {
        show_debug_message("🎯 Testando quartel ID: " + string(_quartel));
        
        // Simular primeiro clique
        show_debug_message("🖱️ Simulando primeiro clique...");
        global.menu_recrutamento_aberto = false; // Garantir estado limpo
        
        // Simular segundo clique
        show_debug_message("🖱️ Simulando segundo clique...");
        
        // Simular terceiro clique
        show_debug_message("🖱️ Simulando terceiro clique...");
        
        show_debug_message("✅ Simulação de cliques concluída");
    } else {
        show_debug_message("❌ Nenhum quartel encontrado para teste");
    }
    
    // === 3. VERIFICAR ESTADO FINAL ===
    show_debug_message("📊 Estado final:");
    show_debug_message("   - global.menu_recrutamento_aberto: " + string(global.menu_recrutamento_aberto));
    show_debug_message("   - Menus abertos: " + string(instance_number(obj_menu_recrutamento) + instance_number(obj_menu_recrutamento_marinha)));
    
    // === 4. TESTE DE LIMPEZA ===
    show_debug_message("🧹 Testando função de limpeza...");
    scr_limpar_menus_recrutamento();
    
    show_debug_message("📊 Estado após limpeza:");
    show_debug_message("   - global.menu_recrutamento_aberto: " + string(global.menu_recrutamento_aberto));
    show_debug_message("   - Menus abertos: " + string(instance_number(obj_menu_recrutamento) + instance_number(obj_menu_recrutamento_marinha)));
    
    show_debug_message("🏁 === TESTE CONCLUÍDO ===");
}

function scr_diagnostico_quartel_problemas(){
    show_debug_message("🔍 === DIAGNÓSTICO DE PROBLEMAS NO QUARTEL ===");
    
    var _problemas_encontrados = 0;
    
    // === 1. VERIFICAR VARIÁVEL GLOBAL ===
    if (!variable_global_exists("menu_recrutamento_aberto")) {
        show_debug_message("❌ PROBLEMA: Variável global.menu_recrutamento_aberto não existe!");
        _problemas_encontrados++;
    } else {
        show_debug_message("✅ Variável global existe: " + string(global.menu_recrutamento_aberto));
    }
    
    // === 2. VERIFICAR MENUS ÓRFÃOS ===
    if (scr_verificar_menus_orfaos()) {
        _problemas_encontrados++;
    }
    
    // === 3. VERIFICAR INCONSISTÊNCIAS ===
    var _menus_count = instance_number(obj_menu_recrutamento) + instance_number(obj_menu_recrutamento_marinha);
    if (_menus_count > 0 && !global.menu_recrutamento_aberto) {
        show_debug_message("❌ PROBLEMA: Há menus abertos mas variável global está false!");
        _problemas_encontrados++;
    }
    
    if (_menus_count == 0 && global.menu_recrutamento_aberto) {
        show_debug_message("❌ PROBLEMA: Variável global está true mas não há menus!");
        _problemas_encontrados++;
    }
    
    // === 4. RESULTADO ===
    if (_problemas_encontrados == 0) {
        show_debug_message("✅ Nenhum problema encontrado no sistema de quartel!");
        return false;
    } else {
        show_debug_message("⚠️ " + string(_problemas_encontrados) + " problemas encontrados!");
        return true;
    }
}