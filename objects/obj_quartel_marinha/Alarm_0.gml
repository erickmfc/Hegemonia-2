// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema de Produção Naval - ALARM EVENT
// ===============================================

// Verificar se está produzindo e tem unidades na fila
if (produzindo && !ds_queue_empty(fila_producao)) {
    show_debug_message("🚢 Produzindo unidade naval...");
    
    // Criar unidade naval - ✅ POSIÇÃO INTELIGENTE COM DISTRIBUIÇÃO ALEATÓRIA
    // Posição baseada no número de unidades já produzidas para evitar sobreposição
    var _offset_base = 150; // ✅ AUMENTADO de 100 para 150
    var _offset_x = _offset_base + (unidades_produzidas * 50); // ✅ AUMENTADO para 50 para maior espaço
    var _offset_y = _offset_base + (unidades_produzidas * 40); // ✅ AUMENTADO para 40 para maior espaço
    var _variacao_x = random_range(-30, 30); // ✅ NOVO: Variação horizontal aleatória
    var _variacao_y = random_range(-30, 30); // ✅ NOVO: Variação vertical aleatória
    var _spawn_x = x + _offset_x + _variacao_x;
    var _spawn_y = y + _offset_y + _variacao_y;
    
    // Obter dados da unidade da fila
    var _unidade_data = ds_queue_dequeue(fila_producao);
    var _obj_unidade = _unidade_data.objeto;
    
    show_debug_message("🚢 Criando: " + _unidade_data.nome + " em (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
    
    // ✅ CORRIGIDO: Verificar se objeto existe antes de criar
    if (object_exists(_obj_unidade)) {
        show_debug_message("✅ Objeto válido: " + string(_obj_unidade));
        
        // ✅ CORRIGIDO: Usar instance_create_layer em vez de instance_create
        var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "Instances", _obj_unidade);
        
        // ADICIONAR DEBUG:
        show_debug_message("🔍 Objeto a ser criado: " + string(_obj_unidade));
        show_debug_message("🔍 Nome da unidade: " + _unidade_data.nome);
        show_debug_message("🔍 Posição: (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
        
        show_debug_message("🔍 Resultado da criação: " + string(_unidade_criada));
        
        if (instance_exists(_unidade_criada)) {
            unidades_produzidas++;
            _unidade_criada.nacao_proprietaria = nacao_proprietaria;
            show_debug_message("✅ " + _unidade_data.nome + " #" + string(unidades_produzidas) + " criada!");
            
            // Debug específico para Independence
            if (_unidade_data.nome == "Independence") {
                show_debug_message("🚢 INDEPENDENCE CRIADA COM SUCESSO!");
                show_debug_message("🚢 ID: " + string(_unidade_criada));
                show_debug_message("🚢 HP: " + string(_unidade_criada.hp_atual) + "/" + string(_unidade_criada.hp_max));
                show_debug_message("🚢 Velocidade: " + string(_unidade_criada.velocidade_movimento));
                show_debug_message("🚢 Tem canhão: " + string(instance_exists(_unidade_criada.canhao_instancia)));
            }
        } else {
            show_debug_message("❌ Falha ao criar unidade!");
        }
    } else {
        show_debug_message("❌ ERRO: Objeto " + string(_obj_unidade) + " não existe!");
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