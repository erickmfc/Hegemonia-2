/// @description Diagnóstico do sistema visual da lancha patrulha
/// Verificar por que nada está sendo mostrado

function scr_diagnostico_visual_lancha() {
    show_debug_message("🔍 === DIAGNÓSTICO DO SISTEMA VISUAL DA LANCHA ===");
    
    // 1. Verificar se existe lancha
    var _lancha_count = instance_number(obj_lancha_patrulha);
    show_debug_message("1. Lanchas no jogo: " + string(_lancha_count));
    
    if (_lancha_count == 0) {
        show_debug_message("❌ PROBLEMA: Nenhuma lancha encontrada!");
        show_debug_message("💡 SOLUÇÃO: Construa uma lancha patrulha primeiro");
        return false;
    }
    
    // 2. Verificar primeira lancha
    var _lancha = instance_find(obj_lancha_patrulha, 0);
    show_debug_message("2. Primeira lancha ID: " + string(_lancha));
    
    // 3. Verificar se está selecionada
    show_debug_message("3. Lancha selecionada: " + string(_lancha.selecionado));
    
    if (!_lancha.selecionado) {
        show_debug_message("❌ PROBLEMA: Lancha não está selecionada!");
        show_debug_message("💡 SOLUÇÃO: Clique na lancha para selecioná-la");
        
        // Selecionar automaticamente para teste
        _lancha.selecionado = true;
        show_debug_message("✅ Lancha selecionada automaticamente para teste");
    }
    
    // 4. Verificar variáveis importantes
    show_debug_message("4. Variáveis da lancha:");
    show_debug_message("   - Estado: " + string(_lancha.estado));
    show_debug_message("   - HP: " + string(_lancha.hp_atual) + "/" + string(_lancha.hp_max));
    show_debug_message("   - Modo ataque: " + string(_lancha.modo_ataque));
    show_debug_message("   - Pontos patrulha: " + string(ds_list_size(_lancha.pontos_patrulha)));
    show_debug_message("   - Índice patrulha: " + string(_lancha.indice_patrulha_atual));
    
    // 5. Verificar se eventos existem
    show_debug_message("5. Verificando eventos:");
    
    var _draw_exists = file_exists("objects/" + object_get_name(obj_lancha_patrulha) + "/Draw_0.gml");
    var _drawgui_exists = file_exists("objects/" + object_get_name(obj_lancha_patrulha) + "/DrawGUI_0.gml");
    
    show_debug_message("   - Draw Event existe: " + string(_draw_exists));
    show_debug_message("   - Draw GUI Event existe: " + string(_drawgui_exists));
    
    if (!_draw_exists) {
        show_debug_message("❌ PROBLEMA: Draw Event não existe!");
    }
    
    if (!_drawgui_exists) {
        show_debug_message("❌ PROBLEMA: Draw GUI Event não existe!");
    }
    
    // 6. Verificar fonte
    show_debug_message("6. Verificando fonte:");
    var _fonte_existe = asset_exists(fnt_ui_main);
    show_debug_message("   - fnt_ui_main existe: " + string(_fonte_existe));
    
    if (!_fonte_existe) {
        show_debug_message("❌ PROBLEMA: Fonte fnt_ui_main não existe!");
    }
    
    // 7. Teste de desenho simples
    show_debug_message("7. Testando desenho simples...");
    
    // Forçar alguns valores para teste
    _lancha.estado = "movendo";
    _lancha.destino_x = _lancha.x + 100;
    _lancha.destino_y = _lancha.y + 100;
    
    show_debug_message("✅ Estado alterado para 'movendo' com destino (" + string(_lancha.destino_x) + ", " + string(_lancha.destino_y) + ")");
    
    // 8. Adicionar pontos de patrulha para teste
    if (ds_list_size(_lancha.pontos_patrulha) == 0) {
        show_debug_message("8. Adicionando pontos de patrulha para teste...");
        ds_list_add(_lancha.pontos_patrulha, [_lancha.x + 50, _lancha.y + 50]);
        ds_list_add(_lancha.pontos_patrulha, [_lancha.x + 100, _lancha.y + 100]);
        ds_list_add(_lancha.pontos_patrulha, [_lancha.x + 50, _lancha.y + 150]);
        show_debug_message("✅ Pontos de patrulha adicionados: " + string(ds_list_size(_lancha.pontos_patrulha)));
    }
    
    show_debug_message("🔍 === FIM DO DIAGNÓSTICO ===");
    show_debug_message("💡 Se ainda não aparecer nada:");
    show_debug_message("   1. Verifique se a lancha está selecionada");
    show_debug_message("   2. Verifique se os eventos Draw e DrawGUI existem");
    show_debug_message("   3. Verifique se a fonte fnt_ui_main existe");
    show_debug_message("   4. Execute o jogo e teste visualmente");
    
    return true;
}
