/// @description Diagnóstico completo do sistema de quartéis
/// @return {undefined}

function scr_diagnostico_sistema_quartel() {
    show_debug_message("🔍 === DIAGNÓSTICO COMPLETO DO SISTEMA DE QUARTÉIS ===");
    
    // === VERIFICAR OBJETOS BASE ===
    var _base_index = asset_get_index("obj_quartel_base");
    if (_base_index != -1) {
        show_debug_message("✅ obj_quartel_base encontrado");
        
        // Verificar instâncias
        var _base_count = instance_number(_base_index);
        show_debug_message("📊 Quartéis base no mapa: " + string(_base_count));
    } else {
        show_debug_message("❌ obj_quartel_base NÃO ENCONTRADO");
    }
    
    // === VERIFICAR QUARTEL TERRESTRE ===
    var _terrestre_index = asset_get_index("obj_quartel");
    if (_terrestre_index != -1) {
        show_debug_message("✅ obj_quartel encontrado");
        
        var _terrestre_count = instance_number(_terrestre_index);
        show_debug_message("📊 Quartéis terrestres no mapa: " + string(_terrestre_count));
        
        if (_terrestre_count > 0) {
            var _quartel = instance_find(_terrestre_index, 0);
            if (instance_exists(_quartel)) {
                show_debug_message("🏗️ Testando quartel terrestre ID: " + string(_quartel));
                
                // Verificar sistema
                if (variable_instance_exists(_quartel, "fila_producao")) {
                    var _fila_size = ds_queue_size(_quartel.fila_producao);
                    show_debug_message("✅ Sistema de fila ativo - Tamanho: " + string(_fila_size));
                } else {
                    show_debug_message("❌ Sistema de fila não encontrado");
                }
                
                if (variable_instance_exists(_quartel, "unidades_disponiveis")) {
                    var _unidades_count = ds_list_size(_quartel.unidades_disponiveis);
                    show_debug_message("✅ Unidades terrestres configuradas: " + string(_unidades_count));
                } else {
                    show_debug_message("❌ Lista de unidades não encontrada");
                }
            }
        }
    } else {
        show_debug_message("❌ obj_quartel NÃO ENCONTRADO");
    }
    
    // === VERIFICAR QUARTEL NAVAL ===
    var _naval_index = asset_get_index("obj_quartel_marinha");
    if (_naval_index != -1) {
        show_debug_message("✅ obj_quartel_marinha encontrado");
        
        var _naval_count = instance_number(_naval_index);
        show_debug_message("📊 Quartéis navais no mapa: " + string(_naval_count));
        
        if (_naval_count > 0) {
            var _marinha = instance_find(_naval_index, 0);
            if (instance_exists(_marinha)) {
                show_debug_message("🚢 Testando quartel naval ID: " + string(_marinha));
                
                // Verificar sistema
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
            }
        } else {
            show_debug_message("⚠️ Nenhum quartel naval no mapa");
            show_debug_message("💡 SOLUÇÃO: Adicione obj_quartel_marinha ao mapa");
        }
    } else {
        show_debug_message("❌ obj_quartel_marinha NÃO ENCONTRADO");
    }
    
    // === VERIFICAR SCRIPTS ===
    show_debug_message("🔧 VERIFICAÇÃO DE SCRIPTS:");
    
    var _scripts = [
        "scr_verificar_recursos_unificados",
        "scr_deduzir_recursos_unificados", 
        "scr_criar_unidade_segura",
        "scr_adicionar_fila_producao"
    ];
    
    for (var i = 0; i < array_length(_scripts); i++) {
        var _script_name = _scripts[i];
        var _script_index = asset_get_index(_script_name);
        if (_script_index != -1) {
            show_debug_message("   ✅ " + _script_name);
        } else {
            show_debug_message("   ❌ " + _script_name + " NÃO ENCONTRADO");
        }
    }
    
    // === INSTRUÇÕES DE TESTE ===
    show_debug_message("🎮 INSTRUÇÕES DE TESTE:");
    show_debug_message("   1. Clique esquerdo no quartel para selecionar");
    show_debug_message("   2. Use teclas 1-4 para produção rápida");
    show_debug_message("   3. Use C para cancelar produção");
    show_debug_message("   4. Use M para menu");
    show_debug_message("   5. Verifique se unidades aparecem ao lado do quartel");
    
    show_debug_message("🔍 === FIM DO DIAGNÓSTICO ===");
}
