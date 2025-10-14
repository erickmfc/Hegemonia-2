/// @description Teste completo do sistema de quartéis unificado
/// @return {undefined}

function scr_teste_quartel_unificado() {
    show_debug_message("🔍 === TESTE SISTEMA QUARTÉIS UNIFICADO ===");
    
    // Verificar objetos base
    var _quartel_base_index = asset_get_index("obj_quartel_base");
    var _quartel_index = asset_get_index("obj_quartel");
    var _quartel_marinha_index = asset_get_index("obj_quartel_marinha");
    
    if (_quartel_base_index != -1) {
        show_debug_message("✅ obj_quartel_base encontrado");
    } else {
        show_debug_message("❌ obj_quartel_base não encontrado");
    }
    
    if (_quartel_index != -1) {
        show_debug_message("✅ obj_quartel encontrado");
    } else {
        show_debug_message("❌ obj_quartel não encontrado");
    }
    
    if (_quartel_marinha_index != -1) {
        show_debug_message("✅ obj_quartel_marinha encontrado");
    } else {
        show_debug_message("❌ obj_quartel_marinha não encontrado");
    }
    
    // Verificar scripts
    var _scripts = [
        "scr_verificar_recursos_unificados",
        "scr_deduzir_recursos_unificados", 
        "scr_criar_unidade_segura",
        "scr_adicionar_fila_producao"
    ];
    
    for (var i = 0; i < array_length(_scripts); i++) {
        var _script_index = asset_get_index(_scripts[i]);
        if (_script_index != -1) {
            show_debug_message("✅ " + _scripts[i] + " encontrado");
        } else {
            show_debug_message("❌ " + _scripts[i] + " não encontrado");
        }
    }
    
    // Verificar instâncias no mapa
    var _quartel_count = instance_number(_quartel_index);
    var _marinha_count = instance_number(_quartel_marinha_index);
    
    show_debug_message("📊 Quartéis terrestres no mapa: " + string(_quartel_count));
    show_debug_message("📊 Quartéis navais no mapa: " + string(_marinha_count));
    
    // Testar primeira instância de quartel
    if (_quartel_count > 0) {
        var _quartel = instance_find(_quartel_index, 0);
        if (instance_exists(_quartel)) {
            show_debug_message("✅ Testando quartel terrestre ID: " + string(_quartel));
            
            // Verificar variáveis do sistema unificado
            if (variable_instance_exists(_quartel, "fila_producao")) {
                show_debug_message("✅ Sistema de fila de produção ativo");
            } else {
                show_debug_message("❌ Sistema de fila de produção não encontrado");
            }
            
            if (variable_instance_exists(_quartel, "unidades_disponiveis")) {
                var _unidades_count = ds_list_size(_quartel.unidades_disponiveis);
                show_debug_message("✅ Unidades disponíveis: " + string(_unidades_count));
                
                // Listar unidades
                for (var i = 0; i < _unidades_count; i++) {
                    var _unidade = _quartel.unidades_disponiveis[| i];
                    show_debug_message("   - " + _unidade.nome + " ($" + string(_unidade.custo_dinheiro) + ")");
                }
            } else {
                show_debug_message("❌ Lista de unidades não encontrada");
            }
        }
    }
    
    // Testar primeira instância de quartel naval
    if (_marinha_count > 0) {
        var _marinha = instance_find(_quartel_marinha_index, 0);
        if (instance_exists(_marinha)) {
            show_debug_message("✅ Testando quartel naval ID: " + string(_marinha));
            
            if (variable_instance_exists(_marinha, "unidades_disponiveis")) {
                var _unidades_count = ds_list_size(_marinha.unidades_disponiveis);
                show_debug_message("✅ Unidades navais disponíveis: " + string(_unidades_count));
                
                // Listar unidades navais
                for (var i = 0; i < _unidades_count; i++) {
                    var _unidade = _marinha.unidades_disponiveis[| i];
                    show_debug_message("   - " + _unidade.nome + " ($" + string(_unidade.custo_dinheiro) + ")");
                }
            }
        }
    }
    
    show_debug_message("🔍 === FIM DO TESTE ===");
    show_debug_message("💡 Use teclas 1-4 para produção rápida nos quartéis selecionados");
    show_debug_message("💡 Use C para cancelar produção, M para menu");
}
