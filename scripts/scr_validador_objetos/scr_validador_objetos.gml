// ===============================================
// HEGEMONIA GLOBAL - VALIDADOR DE OBJETOS
// Sistema de Validação e Fallback Seguro
// ===============================================

/// @description Validar se objeto existe e retornar fallback seguro
/// @param objeto_original Objeto original a verificar
/// @param tipo_quartel Tipo do quartel ("terrestre" ou "naval")
function validar_objeto_unidade(objeto_original, tipo_quartel) {
    // Verificar se objeto existe
    if (object_exists(objeto_original)) {
        return objeto_original;
    }
    
    // Fallback baseado no tipo de quartel
    var _fallback = noone;
    
    switch (tipo_quartel) {
        case "terrestre":
            _fallback = obj_infantaria;
            break;
        case "naval":
            _fallback = obj_lancha_patrulha;
            break;
        default:
            _fallback = obj_infantaria; // Fallback padrão
            break;
    }
    
    show_debug_message("⚠️ Objeto não encontrado: " + string(objeto_original));
    show_debug_message("🔄 Usando fallback: " + string(_fallback));
    
    return _fallback;
}

/// @description Validar lista de unidades de um quartel
/// @param quartel_id ID do quartel
function validar_unidades_quartel(quartel_id) {
    var _quartel = quartel_id;
    var _tipo_quartel = "terrestre";
    
    // Determinar tipo de quartel
    if (_quartel.object_index == obj_quartel_marinha) {
        _tipo_quartel = "naval";
    }
    
    // Validar cada unidade na lista
    for (var i = 0; i < ds_list_size(_quartel.unidades_disponiveis); i++) {
        var _unidade_data = ds_list_find_value(_quartel.unidades_disponiveis, i);
        var _objeto_original = _unidade_data.objeto;
        var _objeto_validado = validar_objeto_unidade(_objeto_original, _tipo_quartel);
        
        // Atualizar objeto se necessário
        if (_objeto_validado != _objeto_original) {
            _unidade_data.objeto = _objeto_validado;
            ds_list_replace(_quartel.unidades_disponiveis, i, _unidade_data);
            show_debug_message("✅ Unidade " + _unidade_data.nome + " atualizada com objeto válido");
        }
    }
}

/// @description Validar todos os quartéis no jogo
function validar_todos_quartéis() {
    show_debug_message("🔍 Iniciando validação de quartéis...");
    
    // Validar quartéis terrestres
    with (obj_quartel) {
        validar_unidades_quartel(id);
    }
    
    // Validar quartéis navais
    with (obj_quartel_marinha) {
        validar_unidades_quartel(id);
    }
    
    show_debug_message("✅ Validação de quartéis concluída!");
}

/// @description Criar objeto de teste se necessário
/// @param nome_objeto Nome do objeto a criar
/// @param tipo_quartel Tipo do quartel
function criar_objeto_teste_se_necessario(nome_objeto, tipo_quartel) {
    // Lista de objetos que devem existir
    var _objetos_necessarios = [];
    
    if (tipo_quartel == "terrestre") {
        _objetos_necessarios = [
            obj_infantaria,
            obj_soldado_antiaereo,
            obj_tanque
        ];
    } else if (tipo_quartel == "naval") {
        _objetos_necessarios = [
            obj_lancha_patrulha
        ];
    }
    
    // Verificar se algum objeto necessário não existe
    for (var i = 0; i < array_length(_objetos_necessarios); i++) {
        var _objeto = _objetos_necessarios[i];
        if (!object_exists(_objeto)) {
            show_debug_message("❌ Objeto crítico não encontrado: " + string(_objeto));
            show_debug_message("⚠️ Sistema pode não funcionar corretamente!");
        }
    }
}

/// @description Obter estatísticas de validação
function obter_estatisticas_validacao() {
    var _stats = {
        quartéis_terrestres: 0,
        quartéis_navais: 0,
        unidades_válidas: 0,
        unidades_inválidas: 0
    };
    
    // Contar quartéis terrestres
    with (obj_quartel) {
        _stats.quartéis_terrestres++;
        for (var i = 0; i < ds_list_size(unidades_disponiveis); i++) {
            var _unidade_data = ds_list_find_value(unidades_disponiveis, i);
            if (object_exists(_unidade_data.objeto)) {
                _stats.unidades_válidas++;
            } else {
                _stats.unidades_inválidas++;
            }
        }
    }
    
    // Contar quartéis navais
    with (obj_quartel_marinha) {
        _stats.quartéis_navais++;
        for (var i = 0; i < ds_list_size(unidades_disponiveis); i++) {
            var _unidade_data = ds_list_find_value(unidades_disponiveis, i);
            if (object_exists(_unidade_data.objeto)) {
                _stats.unidades_válidas++;
            } else {
                _stats.unidades_inválidas++;
            }
        }
    }
    
    show_debug_message("📊 Estatísticas de validação:");
    show_debug_message("   Quartéis terrestres: " + string(_stats.quartéis_terrestres));
    show_debug_message("   Quartéis navais: " + string(_stats.quartéis_navais));
    show_debug_message("   Unidades válidas: " + string(_stats.unidades_válidas));
    show_debug_message("   Unidades inválidas: " + string(_stats.unidades_inválidas));
    
    return _stats;
}
