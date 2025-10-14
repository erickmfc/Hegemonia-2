/// @description Teste de verificação do objeto obj_fragata
/// @return {undefined}

function scr_teste_obj_fragata() {
    show_debug_message("🔍 === TESTE OBJETO FRAGATA ===");
    
    // Verificar se o objeto existe no projeto
    var _obj_index = asset_get_index("obj_fragata");
    if (_obj_index != -1) {
        show_debug_message("✅ obj_fragata encontrado no projeto - Index: " + string(_obj_index));
        
        // Verificar se há instâncias no mapa
        var _count = instance_number(_obj_index);
        show_debug_message("📊 Instâncias de obj_fragata no mapa: " + string(_count));
        
        if (_count > 0) {
            // Testar primeira instância
            var _instancia = instance_find(_obj_index, 0);
            if (instance_exists(_instancia)) {
                show_debug_message("✅ Primeira instância encontrada - ID: " + string(_instancia));
                show_debug_message("📍 Posição: (" + string(_instancia.x) + ", " + string(_instancia.y) + ")");
                
                // Verificar variáveis básicas
                if (variable_instance_exists(_instancia, "selecionado")) {
                    show_debug_message("✅ Variável 'selecionado' existe");
                } else {
                    show_debug_message("❌ Variável 'selecionado' não existe");
                }
                
                if (variable_instance_exists(_instancia, "pontos_patrulha")) {
                    show_debug_message("✅ Variável 'pontos_patrulha' existe");
                } else {
                    show_debug_message("❌ Variável 'pontos_patrulha' não existe");
                }
            } else {
                show_debug_message("❌ Instância não encontrada");
            }
        } else {
            show_debug_message("⚠️ Nenhuma instância de obj_fragata no mapa");
            show_debug_message("💡 SOLUÇÃO: Adicione obj_fragata ao mapa para testar");
        }
    } else {
        show_debug_message("❌ obj_fragata NÃO encontrado no projeto");
        show_debug_message("💡 SOLUÇÃO: Verifique se o objeto existe e está configurado corretamente");
    }
    
    show_debug_message("🔍 === FIM DO TESTE ===");
}
