// =========================================================
// EXEMPLO DE USO DAS FUNÇÕES DA LANCHA
// Script demonstrativo de como usar as funções externas
// =========================================================

function scr_exemplo_uso_lancha() {
    show_debug_message("🚢 EXEMPLO DE USO DAS FUNÇÕES DA LANCHA");
    show_debug_message("=======================================");
    
    // Encontrar uma lancha para testar
    var _lancha = instance_nearest(0, 0, obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        show_debug_message("✅ Lancha encontrada: " + string(_lancha));
        
        // Exemplo 1: Adicionar pontos de patrulha
        show_debug_message("📍 Adicionando pontos de patrulha...");
        scr_adicionar_ponto_patrulha_lancha(_lancha, 100, 100);
        scr_adicionar_ponto_patrulha_lancha(_lancha, 200, 150);
        scr_adicionar_ponto_patrulha_lancha(_lancha, 150, 200);
        
        // Exemplo 2: Iniciar patrulha
        show_debug_message("🔄 Iniciando patrulha...");
        scr_iniciar_patrulha_lancha(_lancha);
        
        // Exemplo 3: Ordem de movimento
        show_debug_message("🚢 Enviando ordem de movimento...");
        scr_ordem_mover_lancha(_lancha, 300, 300);
        
        // Exemplo 4: Limpar patrulha
        show_debug_message("🗑️ Limpando patrulha...");
        scr_limpar_patrulha_lancha(_lancha);
        
    } else {
        show_debug_message("❌ Nenhuma lancha encontrada para teste");
    }
    
    show_debug_message("=======================================");
    show_debug_message("🏁 Exemplo concluído");
}

// =========================================================
// FUNÇÃO PARA TESTAR TODAS AS FUNÇÕES DA LANCHA
// =========================================================

function scr_teste_funcoes_lancha() {
    show_debug_message("🧪 TESTE DAS FUNÇÕES DA LANCHA");
    show_debug_message("==============================");
    
    // Teste 1: Verificar se as funções existem
    if (function_exists(scr_ordem_mover_lancha)) {
        show_debug_message("✅ scr_ordem_mover_lancha existe");
    } else {
        show_debug_message("❌ scr_ordem_mover_lancha NÃO existe");
    }
    
    if (function_exists(scr_iniciar_patrulha_lancha)) {
        show_debug_message("✅ scr_iniciar_patrulha_lancha existe");
    } else {
        show_debug_message("❌ scr_iniciar_patrulha_lancha NÃO existe");
    }
    
    if (function_exists(scr_adicionar_ponto_patrulha_lancha)) {
        show_debug_message("✅ scr_adicionar_ponto_patrulha_lancha existe");
    } else {
        show_debug_message("❌ scr_adicionar_ponto_patrulha_lancha NÃO existe");
    }
    
    if (function_exists(scr_limpar_patrulha_lancha)) {
        show_debug_message("✅ scr_limpar_patrulha_lancha existe");
    } else {
        show_debug_message("❌ scr_limpar_patrulha_lancha NÃO existe");
    }
    
    show_debug_message("==============================");
    show_debug_message("🏁 Teste das funções concluído");
}
