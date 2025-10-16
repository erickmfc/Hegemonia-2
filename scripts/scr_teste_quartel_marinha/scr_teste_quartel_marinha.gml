/// @description Teste completo do quartel de marinha
/// @param x_pos Posição X para criar quartel
/// @param y_pos Posição Y para criar quartel

show_debug_message("🚢 === TESTE COMPLETO DO QUARTEL DE MARINHA ===");

// === 1. CRIAR QUARTEL DE MARINHA ===
show_debug_message("📋 1. CRIANDO QUARTEL DE MARINHA...");

var _quartel = instance_create_layer(argument0, argument1, "rm_mapa_principal", obj_quartel_marinha);

if (instance_exists(_quartel)) {
    show_debug_message("✅ Quartel de marinha criado com sucesso!");
    show_debug_message("   - ID: " + string(_quartel));
    show_debug_message("   - Posição: (" + string(round(_quartel.x)) + ", " + string(round(_quartel.y)) + ")");
    show_debug_message("   - HP: " + string(_quartel.hp_atual) + "/" + string(_quartel.hp_max));
} else {
    show_debug_message("❌ Falha ao criar quartel de marinha!");
    return;
}

// === 2. VERIFICAR CONFIGURAÇÕES DO QUARTEL ===
show_debug_message("📋 2. VERIFICANDO CONFIGURAÇÕES...");

show_debug_message("✅ Configurações básicas:");
show_debug_message("   - Custo dinheiro: $" + string(_quartel.custo_dinheiro));
show_debug_message("   - HP: " + string(_quartel.hp_atual) + "/" + string(_quartel.hp_max));
show_debug_message("   - Nação: " + string(_quartel.nacao_proprietaria));

show_debug_message("✅ Sistema de produção:");
show_debug_message("   - Produzindo: " + string(_quartel.produzindo));
show_debug_message("   - Unidades produzidas: " + string(_quartel.unidades_produzidas));
show_debug_message("   - Fila vazia: " + string(ds_queue_empty(_quartel.fila_producao)));

show_debug_message("✅ Sistema de seleção:");
show_debug_message("   - Selecionado: " + string(_quartel.selecionado));
show_debug_message("   - Menu recrutamento: " + string(_quartel.menu_recrutamento));

// === 3. VERIFICAR UNIDADES DISPONÍVEIS ===
show_debug_message("📋 3. VERIFICANDO UNIDADES DISPONÍVEIS...");

if (ds_exists(_quartel.unidades_disponiveis, ds_type_list)) {
    var _total_unidades = ds_list_size(_quartel.unidades_disponiveis);
    show_debug_message("✅ Total de unidades disponíveis: " + string(_total_unidades));
    
    for (var i = 0; i < _total_unidades; i++) {
        var _unidade = _quartel.unidades_disponiveis[| i];
        show_debug_message("   " + string(i + 1) + ". " + _unidade.nome);
        show_debug_message("      - Custo: $" + string(_unidade.custo_dinheiro));
        show_debug_message("      - Tempo: " + string(_unidade.tempo_treino / room_speed) + " segundos");
        show_debug_message("      - Objeto: " + string(object_get_name(_unidade.objeto)));
    }
} else {
    show_debug_message("❌ Lista de unidades não existe!");
}

// === 4. TESTAR SISTEMA DE RECURSOS ===
show_debug_message("📋 4. TESTANDO SISTEMA DE RECURSOS...");

// Dar dinheiro para teste
if (!variable_global_exists("dinheiro")) {
    global.dinheiro = 10000;
    show_debug_message("⚠️ global.dinheiro não existia, criada com valor 10000");
} else {
    show_debug_message("✅ global.dinheiro existe: $" + string(global.dinheiro));
}

// Testar verificação de recursos
if (ds_list_size(_quartel.unidades_disponiveis) > 0) {
    var _primeira_unidade = _quartel.unidades_disponiveis[| 0];
    var _custo = _primeira_unidade.custo_dinheiro;
    
    if (global.dinheiro >= _custo) {
        show_debug_message("✅ Recursos suficientes para " + _primeira_unidade.nome + " ($" + string(_custo) + ")");
    } else {
        show_debug_message("❌ Recursos insuficientes para " + _primeira_unidade.nome + " ($" + string(_custo) + ")");
    }
}

// === 5. TESTAR SISTEMA DE CLIQUE ===
show_debug_message("📋 5. TESTANDO SISTEMA DE CLIQUE...");

// Simular clique no quartel
show_debug_message("🖱️ Simulando clique no quartel...");

// Verificar se Mouse_53 event existe
if (event_exists(_quartel, ev_mouse, ev_mouse_left)) {
    show_debug_message("✅ Mouse_53 event existe no quartel");
} else {
    show_debug_message("❌ Mouse_53 event não existe no quartel!");
}

// === 6. TESTAR CRIAÇÃO DE MENU ===
show_debug_message("📋 6. TESTANDO CRIAÇÃO DE MENU...");

// Verificar se objeto do menu existe
if (object_exists(obj_menu_recrutamento_marinha)) {
    show_debug_message("✅ obj_menu_recrutamento_marinha existe");
    
    // Verificar layers disponíveis
    show_debug_message("📊 Layers disponíveis:");
    show_debug_message("   - 'Instances': " + string(layer_exists("Instances")));
    show_debug_message("   - 'GUI': " + string(layer_exists("GUI")));
    show_debug_message("   - 'rm_mapa_principal': " + string(layer_exists("rm_mapa_principal")));
    
    // Tentar criar menu manualmente
    var _menu_teste = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
    
    if (instance_exists(_menu_teste)) {
        show_debug_message("✅ Menu criado manualmente com sucesso!");
        show_debug_message("   - Menu ID: " + string(_menu_teste));
        show_debug_message("   - Posição: (" + string(_menu_teste.x) + ", " + string(_menu_teste.y) + ")");
        show_debug_message("   - Visível: " + string(_menu_teste.visible));
        
        // Configurar menu
        _menu_teste.meu_quartel_id = _quartel;
        _quartel.menu_recrutamento = _menu_teste;
        global.menu_recrutamento_aberto = true;
        
        show_debug_message("✅ Menu configurado e conectado ao quartel");
        
        // Destruir menu de teste
        instance_destroy(_menu_teste);
        show_debug_message("🗑️ Menu de teste destruído");
        
    } else {
        show_debug_message("❌ Falha ao criar menu manualmente!");
    }
    
} else {
    show_debug_message("❌ obj_menu_recrutamento_marinha não existe!");
}

// === 7. TESTAR SISTEMA DE PRODUÇÃO ===
show_debug_message("📋 7. TESTANDO SISTEMA DE PRODUÇÃO...");

if (ds_list_size(_quartel.unidades_disponiveis) > 0) {
    var _unidade_teste = _quartel.unidades_disponiveis[| 0];
    
    // Tentar adicionar unidade à fila
    ds_queue_enqueue(_quartel.fila_producao, _unidade_teste);
    _quartel.produzindo = true;
    
    show_debug_message("✅ Unidade adicionada à fila de produção:");
    show_debug_message("   - Unidade: " + _unidade_teste.nome);
    show_debug_message("   - Fila size: " + string(ds_queue_size(_quartel.fila_producao)));
    show_debug_message("   - Produzindo: " + string(_quartel.produzindo));
    
    // Verificar se Step event está funcionando
    show_debug_message("✅ Step event deve processar a produção automaticamente");
    
} else {
    show_debug_message("❌ Nenhuma unidade disponível para teste de produção");
}

// === 8. INSTRUÇÕES PARA TESTE MANUAL ===
show_debug_message("📋 8. INSTRUÇÕES PARA TESTE MANUAL...");

show_debug_message("🎯 Para testar o quartel manualmente:");
show_debug_message("   1. Clique no quartel de marinha");
show_debug_message("   2. Verifique se o menu aparece");
show_debug_message("   3. Teste os botões do menu");
show_debug_message("   4. Verifique se a produção funciona");
show_debug_message("   5. Observe as mensagens de debug");

// === RESULTADO FINAL ===
show_debug_message("🎯 === RESULTADO DO TESTE ===");

show_debug_message("✅ Quartel de marinha criado e configurado!");
show_debug_message("📊 Status:");
show_debug_message("   - Quartel: " + string(_quartel));
show_debug_message("   - Unidades disponíveis: " + string(ds_list_size(_quartel.unidades_disponiveis)));
show_debug_message("   - Dinheiro: $" + string(global.dinheiro));
show_debug_message("   - Menu objeto existe: " + string(object_exists(obj_menu_recrutamento_marinha)));

show_debug_message("🚢 === TESTE DO QUARTEL CONCLUÍDO ===");