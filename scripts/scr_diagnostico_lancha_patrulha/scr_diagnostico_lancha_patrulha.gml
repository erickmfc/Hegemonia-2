// =========================================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA v6.0
// Script de Diagnóstico e Correção
// =========================================================

function scr_diagnostico_lancha_patrulha() {
    show_debug_message("🔍 === DIAGNÓSTICO DA LANCHA PATRULHA ===");
    
    var _lancha = instance_find(obj_lancha_patrulha, 0);
    if (_lancha == noone) {
        show_debug_message("❌ PROBLEMA: Nenhuma lancha patrulha encontrada!");
        return false;
    }
    
    show_debug_message("✅ Lancha encontrada: ID " + string(_lancha));
    
    // Verificar variáveis básicas
    if (!variable_instance_exists(_lancha, "estado")) {
        show_debug_message("❌ PROBLEMA: Variável 'estado' não existe!");
        return false;
    }
    
    if (!variable_instance_exists(_lancha, "pontos_patrulha")) {
        show_debug_message("❌ PROBLEMA: Variável 'pontos_patrulha' não existe!");
        return false;
    }
    
    if (!variable_instance_exists(_lancha, "modo_definicao_patrulha")) {
        show_debug_message("❌ PROBLEMA: Variável 'modo_definicao_patrulha' não existe!");
        return false;
    }
    
    // Verificar estado atual
    show_debug_message("📊 Estado atual: " + string(_lancha.estado));
    show_debug_message("📊 Modo combate: " + string(_lancha.modo_combate));
    show_debug_message("📊 Selecionado: " + string(_lancha.selecionado));
    show_debug_message("📊 Modo definição patrulha: " + string(_lancha.modo_definicao_patrulha));
    show_debug_message("📊 Pontos patrulha: " + string(ds_list_size(_lancha.pontos_patrulha)));
    
    // Verificar se a lancha está selecionada
    if (!_lancha.selecionado) {
        show_debug_message("⚠️ AVISO: Lancha não está selecionada!");
        show_debug_message("💡 SOLUÇÃO: Clique esquerdo na lancha para selecioná-la");
        return false;
    }
    
    show_debug_message("✅ Diagnóstico concluído - Lancha funcionando corretamente");
    return true;
}

function scr_teste_patrulha_lancha() {
    show_debug_message("🧪 === TESTE DO SISTEMA DE PATRULHA ===");
    
    var _lancha = instance_find(obj_lancha_patrulha, 0);
    if (_lancha == noone) {
        show_debug_message("❌ Nenhuma lancha encontrada para teste");
        return false;
    }
    
    // Forçar seleção da lancha
    _lancha.selecionado = true;
    _lancha.image_blend = make_color_rgb(255, 255, 0);
    
    show_debug_message("✅ Lancha selecionada para teste");
    
    // Testar ativação do modo patrulha
    show_debug_message("🎯 Testando ativação do modo patrulha...");
    _lancha.modo_definicao_patrulha = true;
    ds_list_clear(_lancha.pontos_patrulha);
    
    show_debug_message("✅ Modo patrulha ativado");
    show_debug_message("💡 INSTRUÇÕES:");
    show_debug_message("   1. Clique esquerdo em vários pontos para criar rota");
    show_debug_message("   2. Clique direito para confirmar e iniciar patrulha");
    show_debug_message("   3. A lancha deve patrulhar automaticamente entre os pontos");
    
    return true;
}

function scr_corrigir_lancha_patrulha() {
    show_debug_message("🔧 === CORREÇÃO DA LANCHA PATRULHA ===");
    
    var _lancha = instance_find(obj_lancha_patrulha, 0);
    if (_lancha == noone) {
        show_debug_message("❌ Nenhuma lancha encontrada para correção");
        return false;
    }
    
    // Garantir que todas as variáveis existem
    if (!variable_instance_exists(_lancha, "estado")) {
        _lancha.estado = "parado";
        show_debug_message("✅ Variável 'estado' criada");
    }
    
    if (!variable_instance_exists(_lancha, "modo_definicao_patrulha")) {
        _lancha.modo_definicao_patrulha = false;
        show_debug_message("✅ Variável 'modo_definicao_patrulha' criada");
    }
    
    if (!variable_instance_exists(_lancha, "pontos_patrulha")) {
        _lancha.pontos_patrulha = ds_list_create();
        show_debug_message("✅ Variável 'pontos_patrulha' criada");
    }
    
    if (!variable_instance_exists(_lancha, "indice_patrulha_atual")) {
        _lancha.indice_patrulha_atual = 0;
        show_debug_message("✅ Variável 'indice_patrulha_atual' criada");
    }
    
    if (!variable_instance_exists(_lancha, "selecionado")) {
        _lancha.selecionado = false;
        show_debug_message("✅ Variável 'selecionado' criada");
    }
    
    show_debug_message("✅ Correção concluída - Lancha pronta para uso");
    return true;
}
