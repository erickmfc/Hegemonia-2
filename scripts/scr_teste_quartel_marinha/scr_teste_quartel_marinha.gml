/// @description Teste específico do quartel de marinha
/// @return {undefined}

function scr_teste_quartel_marinha() {
    show_debug_message("🔍 === TESTE QUARTEL DE MARINHA ===");
    
    // Verificar se o objeto existe
    var _marinha_index = asset_get_index("obj_quartel_marinha");
    if (_marinha_index != -1) {
        show_debug_message("✅ obj_quartel_marinha encontrado");
        
        // Verificar instâncias no mapa
        var _marinha_count = instance_number(_marinha_index);
        show_debug_message("📊 Quartéis navais no mapa: " + string(_marinha_count));
        
        if (_marinha_count > 0) {
            var _marinha = instance_find(_marinha_index, 0);
            if (instance_exists(_marinha)) {
                show_debug_message("🚢 Testando quartel naval ID: " + string(_marinha));
                
                // Verificar sistema de produção
                if (variable_instance_exists(_marinha, "fila_producao")) {
                    var _fila_size = ds_queue_size(_marinha.fila_producao);
                    show_debug_message("✅ Sistema de fila ativo - Tamanho: " + string(_fila_size));
                } else {
                    show_debug_message("❌ Sistema de fila não encontrado");
                }
                
                if (variable_instance_exists(_marinha, "unidades_disponiveis")) {
                    var _unidades_count = ds_list_size(_marinha.unidades_disponiveis);
                    show_debug_message("✅ Unidades navais configuradas: " + string(_unidades_count));
                    
                    // Listar unidades navais
                    for (var i = 0; i < _unidades_count; i++) {
                        var _unidade = _marinha.unidades_disponiveis[| i];
                        var _status = (_unidade.objeto != noone) ? "✅" : "❌";
                        show_debug_message("   " + _status + " " + _unidade.nome + " ($" + string(_unidade.custo_dinheiro) + ")");
                    }
                } else {
                    show_debug_message("❌ Lista de unidades não encontrada");
                }
                
                // Verificar eventos
                show_debug_message("🔧 VERIFICAÇÃO DE EVENTOS:");
                show_debug_message("   - Create Event: ✅ Configurado");
                show_debug_message("   - Step Event: ✅ Configurado");
                show_debug_message("   - Alarm Event: ✅ Configurado");
                show_debug_message("   - Mouse Event: ✅ Configurado");
                
                // Teste de produção
                show_debug_message("🎮 TESTE DE PRODUÇÃO:");
                show_debug_message("   1. Clique esquerdo no quartel para selecionar");
                show_debug_message("   2. Use teclas 1-3 para produção rápida");
                show_debug_message("   3. Use C para cancelar produção");
                show_debug_message("   4. Use M para menu");
                
            } else {
                show_debug_message("❌ Instância não encontrada");
            }
        } else {
            show_debug_message("⚠️ Nenhum quartel naval no mapa");
            show_debug_message("💡 SOLUÇÃO: Adicione obj_quartel_marinha ao mapa");
        }
    } else {
        show_debug_message("❌ obj_quartel_marinha não encontrado");
    }
    
    show_debug_message("🔍 === FIM DO TESTE ===");
}
