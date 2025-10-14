// =========================================================
// DIAGNÓSTICO COMPLETO DA LANCHA
// Identifica todos os problemas possíveis
// =========================================================

function scr_diagnostico_completo_lancha() {
    show_debug_message("🔍 DIAGNÓSTICO COMPLETO DA LANCHA");
    show_debug_message("=================================");
    
    // 1. Verificar se existem lanchas
    var _lanchas = instance_number(obj_lancha_patrulha);
    show_debug_message("📊 Total de lanchas no jogo: " + string(_lanchas));
    
    if (_lanchas == 0) {
        show_debug_message("❌ PROBLEMA: Nenhuma lancha encontrada!");
        show_debug_message("💡 SOLUÇÃO: Execute scr_criar_lancha_teste() primeiro");
        return;
    }
    
    // 2. Verificar cada lancha
    with (obj_lancha_patrulha) {
        show_debug_message("🚢 LANCHA ID: " + string(id));
        show_debug_message("   📍 Posição: (" + string(x) + ", " + string(y) + ")");
        
        // Verificar variável selecionado
        if (variable_instance_exists(id, "selecionado")) {
            show_debug_message("   ✅ Variável 'selecionado' existe: " + string(selecionado));
        } else {
            show_debug_message("   ❌ PROBLEMA: Variável 'selecionado' NÃO existe!");
        }
        
        // Verificar outras variáveis essenciais
        var _vars_essenciais = ["estado", "modo_ataque", "hp_atual", "hp_max", "velocidade_atual", "velocidade_maxima"];
        for (var i = 0; i < array_length(_vars_essenciais); i++) {
            var _var = _vars_essenciais[i];
            if (variable_instance_exists(id, _var)) {
                show_debug_message("   ✅ Variável '" + _var + "' existe: " + string(variable_instance_get(id, _var)));
            } else {
                show_debug_message("   ❌ PROBLEMA: Variável '" + _var + "' NÃO existe!");
            }
        }
        
        // Verificar eventos
        show_debug_message("   📋 Eventos da lancha:");
        if (event_exists(ev_draw_gui)) {
            show_debug_message("     ✅ Draw GUI Event existe");
        } else {
            show_debug_message("     ❌ PROBLEMA: Draw GUI Event NÃO existe!");
        }
        
        if (event_exists(ev_draw)) {
            show_debug_message("     ✅ Draw Event existe");
        } else {
            show_debug_message("     ❌ PROBLEMA: Draw Event NÃO existe!");
        }
        
        if (event_exists(ev_mouse)) {
            show_debug_message("     ✅ Mouse Event existe");
        } else {
            show_debug_message("     ❌ PROBLEMA: Mouse Event NÃO existe!");
        }
        
        show_debug_message("   ---");
    }
    
    // 3. Verificar fonte
    show_debug_message("🔤 VERIFICAÇÃO DA FONTE:");
    if (font_exists(hegemonia_main)) {
        show_debug_message("   ✅ Fonte 'hegemonia_main' existe");
    } else {
        show_debug_message("   ❌ PROBLEMA: Fonte 'hegemonia_main' NÃO existe!");
        show_debug_message("   💡 SOLUÇÃO: Use fonte padrão (-1)");
    }
    
    // 4. Verificar display
    show_debug_message("🖥️ VERIFICAÇÃO DO DISPLAY:");
    show_debug_message("   📏 Altura GUI: " + string(display_get_gui_height()));
    show_debug_message("   📏 Largura GUI: " + string(display_get_gui_width()));
    
    // 5. Teste de seleção forçada
    show_debug_message("🔧 TESTE DE SELEÇÃO FORÇADA:");
    var _lancha_teste = instance_nearest(0, 0, obj_lancha_patrulha);
    if (instance_exists(_lancha_teste)) {
        with (_lancha_teste) {
            selecionado = true;
            show_debug_message("   ✅ Lancha " + string(id) + " FORÇADA a ser selecionada");
            show_debug_message("   💡 Interface deve aparecer agora!");
        }
    }
    
    show_debug_message("=================================");
    show_debug_message("🏁 Diagnóstico concluído");
}

// =========================================================
// FUNÇÃO PARA TESTAR DESENHO MANUAL
// =========================================================

function scr_teste_desenho_manual() {
    show_debug_message("🎨 TESTE DE DESENHO MANUAL");
    show_debug_message("=========================");
    
    // Criar um objeto temporário para testar desenho
    var _obj_teste = instance_create_layer(100, 100, "Instances", obj_lancha_patrulha);
    
    if (instance_exists(_obj_teste)) {
        with (_obj_teste) {
            selecionado = true;
            estado = "parado";
            modo_ataque = false;
            hp_atual = 300;
            hp_max = 300;
            velocidade_atual = 0;
            velocidade_maxima = 3.5;
            
            show_debug_message("✅ Objeto de teste criado e configurado");
            show_debug_message("✅ Interface deve aparecer na tela!");
        }
        
        // Aguardar alguns frames e depois destruir
        alarm[0] = 300; // 5 segundos
        show_debug_message("⏰ Objeto será destruído em 5 segundos");
        
    } else {
        show_debug_message("❌ Erro ao criar objeto de teste");
    }
    
    show_debug_message("=========================");
    show_debug_message("🏁 Teste de desenho concluído");
}
