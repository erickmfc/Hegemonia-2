// =========================================================
// TESTE DAS CORREÇÕES DA FONTE HEGEMONIA MAIN
// Verifica se as correções estão funcionando corretamente
// =========================================================

function scr_teste_correcoes_fonte_hegemonia() {
    show_debug_message("🔧 TESTE DAS CORREÇÕES DA FONTE HEGEMONIA MAIN");
    show_debug_message("=============================================");
    
    // Teste 1: Verificar se a fonte hegemonia_main existe
    if (font_exists(hegemonia_main)) {
        show_debug_message("✅ Fonte hegemonia_main encontrada e funcional");
        
        // Teste 2: Aplicar a fonte diretamente
        try {
            draw_set_font(hegemonia_main);
            show_debug_message("✅ draw_set_font(hegemonia_main) funcionando");
        } catch (e) {
            show_debug_message("❌ Erro ao aplicar fonte: " + string(e));
        }
        
        // Teste 3: Verificar função string_repeat
        try {
            var _teste_repeat = string_repeat("─", 5);
            if (_teste_repeat == "─────") {
                show_debug_message("✅ string_repeat() funcionando corretamente");
            } else {
                show_debug_message("⚠️ string_repeat() retornou: " + _teste_repeat);
            }
        } catch (e) {
            show_debug_message("❌ Erro na função string_repeat: " + string(e));
        }
        
        // Teste 4: Testar desenho de texto com a fonte
        try {
            draw_set_font(hegemonia_main);
            draw_set_color(c_white);
            draw_text(100, 100, "Teste da Fonte Hegemonia Main");
            show_debug_message("✅ Texto desenhado com sucesso usando hegemonia_main");
        } catch (e) {
            show_debug_message("❌ Erro ao desenhar texto: " + string(e));
        }
        
    } else {
        show_debug_message("❌ Fonte hegemonia_main NÃO encontrada");
        show_debug_message("💡 Verifique se a fonte foi criada corretamente no projeto");
    }
    
    // Teste 5: Verificar se há outras fontes disponíveis
    show_debug_message("📋 Fontes disponíveis no projeto:");
    if (font_exists(fnt_ui_main)) {
        show_debug_message("   ✅ fnt_ui_main");
    } else {
        show_debug_message("   ❌ fnt_ui_main");
    }
    
    show_debug_message("=============================================");
    show_debug_message("🏁 Teste das correções concluído");
}

// =========================================================
// FUNÇÃO PARA TESTAR PAINEL COMPLETO DA LANCHA
// =========================================================

function scr_teste_painel_lancha_completo() {
    show_debug_message("🚢 TESTE DO PAINEL COMPLETO DA LANCHA");
    show_debug_message("====================================");
    
    // Encontrar uma lancha para testar
    var _lancha = instance_nearest(0, 0, obj_lancha_patrulha);
    
    if (instance_exists(_lancha)) {
        show_debug_message("✅ Lancha encontrada: " + string(_lancha));
        
        // Simular seleção da lancha
        with (_lancha) {
            selecionado = true;
            show_debug_message("✅ Lancha selecionada para teste");
        }
        
        // Testar se o painel será desenhado
        show_debug_message("✅ Painel da lancha deve aparecer na tela");
        show_debug_message("💡 Verifique se o painel está sendo desenhado corretamente");
        
    } else {
        show_debug_message("❌ Nenhuma lancha encontrada para teste");
        show_debug_message("💡 Crie uma lancha primeiro para testar o painel");
    }
    
    show_debug_message("====================================");
    show_debug_message("🏁 Teste do painel concluído");
}
