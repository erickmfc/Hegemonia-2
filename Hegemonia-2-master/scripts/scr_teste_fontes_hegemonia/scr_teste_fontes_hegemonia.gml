// =========================================================
// TESTE DO SISTEMA DE FONTES HEGEMONIA
// Verifica se as fontes estão funcionando corretamente
// =========================================================

function scr_teste_fontes_hegemonia() {
    show_debug_message("🧪 TESTE DO SISTEMA DE FONTES HEGEMONIA");
    show_debug_message("=====================================");
    
    // Teste 1: Verificar se hegemonia_main existe
    if (font_exists(hegemonia_main)) {
        show_debug_message("✅ hegemonia_main encontrada e funcional");
    } else {
        show_debug_message("❌ hegemonia_main NÃO encontrada");
    }
    
    // Teste 2: Verificar se fnt_ui_main existe
    if (font_exists(fnt_ui_main)) {
        show_debug_message("✅ fnt_ui_main encontrada e funcional");
    } else {
        show_debug_message("❌ fnt_ui_main NÃO encontrada");
    }
    
    // Teste 3: Verificar função específica da hegemonia_main
    var _fonte_hegemonia_aplicada = scr_aplicar_fonte_hegemonia_main();
    if (_fonte_hegemonia_aplicada) {
        show_debug_message("✅ Função scr_aplicar_fonte_hegemonia_main() funcionando");
    } else {
        show_debug_message("⚠️ Usando fallback para outras fontes");
    }
    
    // Teste 4: Verificar função geral de aplicação de fonte
    var _fonte_aplicada = scr_aplicar_fonte_hegemonia();
    if (_fonte_aplicada) {
        show_debug_message("✅ Função scr_aplicar_fonte_hegemonia() funcionando");
    } else {
        show_debug_message("⚠️ Usando fallback para fonte padrão");
    }
    
    // Teste 5: Verificar função de desenho específica
    try {
        scr_desenhar_texto_hegemonia_main(100, 100, "Teste Hegemonia Main", c_lime);
        show_debug_message("✅ Função scr_desenhar_texto_hegemonia_main() funcionando");
    } catch (e) {
        show_debug_message("❌ Erro na função scr_desenhar_texto_hegemonia_main(): " + string(e));
    }
    
    // Teste 6: Verificar função de desenho geral
    try {
        scr_desenhar_texto_hegemonia(200, 100, "Teste Hegemonia Geral", c_aqua);
        show_debug_message("✅ Função scr_desenhar_texto_hegemonia() funcionando");
    } catch (e) {
        show_debug_message("❌ Erro na função scr_desenhar_texto_hegemonia(): " + string(e));
    }
    
    show_debug_message("=====================================");
    show_debug_message("🏁 Teste de fontes concluído");
}
