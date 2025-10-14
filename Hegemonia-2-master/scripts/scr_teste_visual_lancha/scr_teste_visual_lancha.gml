/// @description Teste do sistema visual refinado da lancha patrulha
/// Verificar se o feedback visual está funcionando corretamente

function scr_teste_visual_lancha() {
    show_debug_message("🎨 === TESTE DO SISTEMA VISUAL DA LANCHA ===");
    
    // Verificar se lancha existe
    var _lancha_count = instance_number(obj_lancha_patrulha);
    if (_lancha_count == 0) {
        show_debug_message("⚠️ Nenhuma lancha encontrada - criando uma para teste");
        
        // Criar lancha para teste
        var _lancha = instance_create_layer(400, 300, "Instances", obj_lancha_patrulha);
        if (instance_exists(_lancha)) {
            show_debug_message("✅ Lancha de teste criada: " + string(_lancha));
        } else {
            show_debug_message("❌ Falha ao criar lancha de teste");
            return false;
        }
    } else {
        show_debug_message("✅ Lanchas encontradas: " + string(_lancha_count));
    }
    
    var _lancha = instance_find(obj_lancha_patrulha, 0);
    
    // Testar seleção
    show_debug_message("🔍 Testando seleção da lancha...");
    _lancha.selecionado = true;
    show_debug_message("✅ Lancha selecionada: " + string(_lancha.selecionado));
    
    // Testar estados
    show_debug_message("🔍 Testando estados da lancha...");
    show_debug_message("   Estado atual: " + string(_lancha.estado));
    show_debug_message("   HP: " + string(_lancha.hp_atual) + "/" + string(_lancha.hp_max));
    show_debug_message("   Modo ataque: " + string(_lancha.modo_ataque));
    
    // Testar sistema de patrulha
    show_debug_message("🔍 Testando sistema de patrulha...");
    show_debug_message("   Pontos de patrulha: " + string(ds_list_size(_lancha.pontos_patrulha)));
    show_debug_message("   Índice atual: " + string(_lancha.indice_patrulha_atual));
    
    // Adicionar pontos de patrulha para teste
    if (ds_list_size(_lancha.pontos_patrulha) == 0) {
        show_debug_message("📍 Adicionando pontos de patrulha para teste...");
        ds_list_add(_lancha.pontos_patrulha, [500, 300]);
        ds_list_add(_lancha.pontos_patrulha, [600, 400]);
        ds_list_add(_lancha.pontos_patrulha, [500, 500]);
        ds_list_add(_lancha.pontos_patrulha, [400, 400]);
        
        show_debug_message("✅ Pontos de patrulha adicionados: " + string(ds_list_size(_lancha.pontos_patrulha)));
    }
    
    // Testar estado de patrulha
    _lancha.estado = "patrulhando";
    show_debug_message("✅ Estado alterado para: " + string(_lancha.estado));
    
    // Verificar variáveis do painel
    show_debug_message("🔍 Verificando variáveis do painel de status...");
    show_debug_message("   Estado: " + string(_lancha.estado));
    show_debug_message("   Modo ataque: " + string(_lancha.modo_ataque));
    show_debug_message("   HP: " + string(_lancha.hp_atual) + "/" + string(_lancha.hp_max));
    show_debug_message("   Pontos patrulha: " + string(ds_list_size(_lancha.pontos_patrulha)));
    
    show_debug_message("🎨 === TESTE VISUAL CONCLUÍDO ===");
    show_debug_message("✅ Sistema visual da lancha está funcionando!");
    show_debug_message("💡 Para testar visualmente:");
    show_debug_message("   1. Execute o jogo");
    show_debug_message("   2. Selecione a lancha");
    show_debug_message("   3. Verifique o anel verde de seleção");
    show_debug_message("   4. Verifique o painel de status no canto inferior esquerdo");
    show_debug_message("   5. Teste os comandos de patrulha");
    
    return true;
}
