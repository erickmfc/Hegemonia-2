// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema de Produção Naval - ALARM EVENT
// ===============================================

// Verificar se está produzindo e tem unidades na fila
if (produzindo && !ds_queue_empty(fila_producao)) {
    show_debug_message("🚢 Produzindo unidade naval...");
    
    // Criar unidade naval - ✅ POSIÇÃO INTELIGENTE
    // Posição baseada no número de unidades já produzidas para evitar sobreposição
    var _offset_base = 100;
    var _offset_x = _offset_base + (unidades_produzidas * 20);
    var _offset_y = _offset_base + (unidades_produzidas * 15);
    var _spawn_x = x + _offset_x;
    var _spawn_y = y + _offset_y;
    
    // Obter dados da unidade da fila
    var _unidade_data = ds_queue_dequeue(fila_producao);
    var _obj_unidade = _unidade_data.objeto;
    
    show_debug_message("🚢 Criando: " + _unidade_data.nome + " em (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
    
    // ✅ CORRIGIDO: Verificar se objeto existe antes de criar
    if (object_exists(_obj_unidade)) {
        show_debug_message("✅ Objeto válido: " + string(_obj_unidade));
        
        // ✅ CORRIGIDO: Usar instance_create_layer em vez de instance_create
        var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", _obj_unidade);
        
        show_debug_message("🔍 Resultado da criação: " + string(_unidade_criada));
        
        if (instance_exists(_unidade_criada)) {
            unidades_produzidas++;
            _unidade_criada.nacao_proprietaria = nacao_proprietaria;
            show_debug_message("✅ " + _unidade_data.nome + " #" + string(unidades_produzidas) + " criada!");
        } else {
            show_debug_message("❌ Falha ao criar unidade!");
        }
    } else {
        // Fallback: usar obj_lancha_patrulha diretamente
        var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", obj_lancha_patrulha);
        
        if (instance_exists(_unidade_criada)) {
            unidades_produzidas++;
            _unidade_criada.nacao_proprietaria = nacao_proprietaria;
            show_debug_message("✅ " + _unidade_data.nome + " criada (fallback)!");
        }
    }
    
    // Próxima unidade da fila
    if (!ds_queue_empty(fila_producao)) {
        var _proxima_unidade = ds_queue_head(fila_producao);
        alarm[0] = _proxima_unidade.tempo_treino;
        show_debug_message("🔄 Próxima unidade em " + string(_proxima_unidade.tempo_treino) + " frames");
    } else {
        produzindo = false;
        show_debug_message("🏁 Quartel ocioso - fila vazia");
    }
}