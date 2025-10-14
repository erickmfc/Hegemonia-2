// ===============================================
// HEGEMONIA GLOBAL - SISTEMA DE CRIAÇÃO SEGURO
// Criação de Unidades com Validação
// ===============================================

/// @description Criar unidade com verificação de segurança
/// @param _unidade_data Dados da unidade
function scr_criar_unidade_segura(_unidade_data) {
    // Verificar se objeto existe
    if (!object_exists(_unidade_data.objeto)) {
        show_debug_message("❌ Objeto não existe: " + string(_unidade_data.objeto));
        return noone;
    }
    
    // Calcular posição de spawn (evitar sobreposição)
    var _spawn_x = x + 80 + (unidades_produzidas * 20);
    var _spawn_y = y + 80 + (unidades_produzidas * 15);
    
    // Determinar layer baseado no tipo de quartel
    var _layer = "Instances"; // Layer padrão
    if (object_index == obj_quartel_marinha) {
        _layer = "rm_mapa_principal"; // Layer naval
    }
    
    // Criar unidade
    var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, _layer, _unidade_data.objeto);
    
    if (instance_exists(_unidade_criada)) {
        // Configurar unidade
        _unidade_criada.nacao_proprietaria = nacao_proprietaria;
        unidades_produzidas++;
        
        show_debug_message("✅ " + _unidade_data.nome + " criada em (" + 
                          string(_spawn_x) + ", " + string(_spawn_y) + ")");
        
        return _unidade_criada;
    } else {
        show_debug_message("❌ Falha ao criar unidade: " + _unidade_data.nome);
        return noone;
    }
}

/// @description Validar lista de unidades de um quartel
/// @param quartel_id ID do quartel
function scr_validar_unidades_quartel(quartel_id) {
    var _quartel = quartel_id;
    var _unidades_validas = 0;
    var _unidades_invalidas = 0;
    
    show_debug_message("🔍 Validando unidades do quartel ID: " + string(_quartel.id));
    
    // Validar cada unidade na lista
    for (var i = 0; i < ds_list_size(_quartel.unidades_disponiveis); i++) {
        var _unidade_data = ds_list_find_value(_quartel.unidades_disponiveis, i);
        
        if (object_exists(_unidade_data.objeto)) {
            _unidades_validas++;
            show_debug_message("✅ " + _unidade_data.nome + " - Objeto válido");
        } else {
            _unidades_invalidas++;
            show_debug_message("❌ " + _unidade_data.nome + " - Objeto inválido: " + string(_unidade_data.objeto));
        }
    }
    
    show_debug_message("📊 Validação concluída: " + string(_unidades_validas) + " válidas, " + string(_unidades_invalidas) + " inválidas");
    
    return {
        validas: _unidades_validas,
        invalidas: _unidades_invalidas
    };
}
