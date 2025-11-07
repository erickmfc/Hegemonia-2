/// @description Teste completo da lancha patrulha
function scr_teste_lancha_patrulha() {
    // =========================================================
    // HEGEMONIA GLOBAL - SCRIPT DE TESTE PARA LANCHA PATRULHA
    // =========================================================

    // Script principal de teste da lancha patrulha
    show_debug_message("🧪 === TESTE COMPLETO DA LANCHA PATRULHA ===");
    
    // 1. Verificar se há lanchas no jogo
    var _lancha = instance_find(obj_lancha_patrulha, 0);
    if (_lancha == noone) {
        show_debug_message("❌ PROBLEMA: Nenhuma lancha encontrada no jogo!");
        return false;
    }
    
    show_debug_message("✅ Lancha encontrada: ID " + string(_lancha));
    
    // 2. Verificar variáveis da lancha
    show_debug_message("🔍 Verificando variáveis da lancha:");
    show_debug_message("  - estado: " + string(_lancha.estado));
    show_debug_message("  - selecionado: " + string(_lancha.selecionado));
    show_debug_message("  - Tem pontos_patrulha: " + string(variable_instance_exists(_lancha, "pontos_patrulha")));
    show_debug_message("  - Tem indice_patrulha_atual: " + string(variable_instance_exists(_lancha, "indice_patrulha_atual")));
    
    // 3. Forçar seleção da lancha
    show_debug_message("🎯 Forçando seleção da lancha...");
    _lancha.selecionado = true;
    global.unidade_selecionada = _lancha;
    
    show_debug_message("✅ Lancha selecionada:");
    show_debug_message("  - selecionado: " + string(_lancha.selecionado));
    show_debug_message("  - global.unidade_selecionada: " + string(global.unidade_selecionada));
    
    // 4. Verificar se Input Manager reconhece
    show_debug_message("🔍 Verificando reconhecimento pelo Input Manager:");
    show_debug_message("  - instance_exists(global.unidade_selecionada): " + string(instance_exists(global.unidade_selecionada)));
    show_debug_message("  - variable_instance_exists(global.unidade_selecionada, 'pontos_patrulha'): " + string(variable_instance_exists(global.unidade_selecionada, "pontos_patrulha")));
    
    // 5. Simular tecla K
    show_debug_message("🎯 Simulando tecla K...");
    if (variable_instance_exists(global.unidade_selecionada, "pontos_patrulha")) {
        global.definindo_patrulha_unidade = global.unidade_selecionada;
        ds_list_clear(global.definindo_patrulha_unidade.pontos_patrulha);
        show_debug_message("✅ Modo patrulha ativado!");
        show_debug_message("  - global.definindo_patrulha_unidade: " + string(global.definindo_patrulha_unidade));
    } else {
        show_debug_message("❌ Falha ao ativar modo patrulha!");
    }
    
    show_debug_message("🧪 === TESTE CONCLUÍDO ===");
    return true;

    // Script de teste de seleção da lancha
    show_debug_message("🔍 === TESTE DE SELEÇÃO DA LANCHA ===");
    
    var _lancha = instance_find(obj_lancha_patrulha, 0);
    if (_lancha == noone) {
        show_debug_message("❌ Nenhuma lancha encontrada");
        return false;
    }
    
    show_debug_message("✅ Lancha encontrada: " + string(_lancha));
    
    // Simular clique na lancha
    show_debug_message("🖱️ Simulando clique na lancha...");
    
    // Desselecionar todas as unidades
    with (obj_lancha_patrulha) { selecionado = false; }
    
    // Selecionar a lancha
    _lancha.selecionado = true;
    global.unidade_selecionada = _lancha;
    
    show_debug_message("✅ Lancha selecionada:");
    show_debug_message("  - ID: " + string(_lancha));
    show_debug_message("  - selecionado: " + string(_lancha.selecionado));
    show_debug_message("  - global.unidade_selecionada: " + string(global.unidade_selecionada));
    show_debug_message("  - Tipo: " + string(object_get_name(_lancha.object_index)));
    
    return true;
}
