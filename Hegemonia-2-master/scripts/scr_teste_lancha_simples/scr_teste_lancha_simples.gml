/// @description Teste simplificado do sistema visual da lancha
/// Verificar se os elementos visuais estão funcionando

function scr_teste_lancha_simples() {
    show_debug_message("🚢 === TESTE SIMPLES DA LANCHA ===");
    
    // Verificar se existe lancha
    var _lancha_count = instance_number(obj_lancha_patrulha);
    show_debug_message("Lanchas encontradas: " + string(_lancha_count));
    
    if (_lancha_count == 0) {
        show_debug_message("❌ Nenhuma lancha encontrada!");
        show_debug_message("💡 Construa uma lancha patrulha primeiro");
        return false;
    }
    
    var _lancha = instance_find(obj_lancha_patrulha, 0);
    
    // Selecionar lancha
    _lancha.selecionado = true;
    show_debug_message("✅ Lancha selecionada: " + string(_lancha));
    
    // Verificar variáveis básicas
    show_debug_message("Estado: " + string(_lancha.estado));
    show_debug_message("HP: " + string(_lancha.hp_atual) + "/" + string(_lancha.hp_max));
    show_debug_message("Modo ataque: " + string(_lancha.modo_ataque));
    
    // Adicionar pontos de patrulha se não existirem
    if (ds_list_size(_lancha.pontos_patrulha) == 0) {
        ds_list_add(_lancha.pontos_patrulha, [_lancha.x + 50, _lancha.y + 50]);
        ds_list_add(_lancha.pontos_patrulha, [_lancha.x + 100, _lancha.y + 100]);
        show_debug_message("✅ Pontos de patrulha adicionados");
    }
    
    // Testar estado de movimento
    _lancha.estado = "movendo";
    _lancha.destino_x = _lancha.x + 100;
    _lancha.destino_y = _lancha.y + 100;
    
    show_debug_message("✅ Estado alterado para 'movendo'");
    show_debug_message("🎯 Destino: (" + string(_lancha.destino_x) + ", " + string(_lancha.destino_y) + ")");
    
    show_debug_message("🚢 === TESTE CONCLUÍDO ===");
    show_debug_message("💡 Agora deve aparecer:");
    show_debug_message("   - Círculo verde ao redor da lancha");
    show_debug_message("   - Linha verde para o destino");
    show_debug_message("   - Painel preto no canto inferior esquerdo");
    
    return true;
}
