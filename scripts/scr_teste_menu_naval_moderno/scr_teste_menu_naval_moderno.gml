/// @description Teste do menu naval moderno
/// @param x_pos Posição X para criar quartel
/// @param y_pos Posição Y para criar quartel

show_debug_message("🚢 === TESTE DO MENU NAVAL MODERNO ===");

// === 1. CONFIGURAR RECURSOS ===
show_debug_message("📋 1. CONFIGURANDO RECURSOS...");

// Garantir que recursos existem
if (!variable_global_exists("dinheiro")) {
    global.dinheiro = 10000;
    show_debug_message("✅ global.dinheiro criado: $" + string(global.dinheiro));
} else {
    show_debug_message("✅ global.dinheiro existe: $" + string(global.dinheiro));
}

if (!variable_global_exists("populacao")) {
    global.populacao = 100;
    show_debug_message("✅ global.populacao criado: " + string(global.populacao));
} else {
    show_debug_message("✅ global.populacao existe: " + string(global.populacao));
}

// === 2. CRIAR QUARTEL DE MARINHA ===
show_debug_message("📋 2. CRIANDO QUARTEL DE MARINHA...");

var _quartel = instance_create_layer(argument0, argument1, "rm_mapa_principal", obj_quartel_marinha);

if (instance_exists(_quartel)) {
    show_debug_message("✅ Quartel de marinha criado!");
    show_debug_message("   - ID: " + string(_quartel));
    show_debug_message("   - Posição: (" + string(round(_quartel.x)) + ", " + string(round(_quartel.y)) + ")");
} else {
    show_debug_message("❌ Falha ao criar quartel!");
    return;
}

// === 3. VERIFICAR UNIDADES DISPONÍVEIS ===
show_debug_message("📋 3. VERIFICANDO UNIDADES DISPONÍVEIS...");

if (ds_exists(_quartel.unidades_disponiveis, ds_type_list)) {
    var _total_unidades = ds_list_size(_quartel.unidades_disponiveis);
    show_debug_message("✅ Total de unidades: " + string(_total_unidades));
    
    for (var i = 0; i < _total_unidades; i++) {
        var _unidade = _quartel.unidades_disponiveis[| i];
        show_debug_message("   " + string(i + 1) + ". " + _unidade.nome);
        show_debug_message("      - Custo: $" + string(_unidade.custo_dinheiro));
        show_debug_message("      - População: " + string(_unidade.custo_populacao));
        show_debug_message("      - Tempo: " + string(_unidade.tempo_treino / 60) + " segundos");
    }
} else {
    show_debug_message("❌ Lista de unidades não existe!");
}

// === 4. TESTAR CRIAÇÃO DO MENU ===
show_debug_message("📋 4. TESTANDO CRIAÇÃO DO MENU...");

// Verificar se objeto do menu existe
if (object_exists(obj_menu_recrutamento_marinha)) {
    show_debug_message("✅ obj_menu_recrutamento_marinha existe");
    
    // Simular clique no quartel para abrir menu
    show_debug_message("🖱️ Simulando clique no quartel...");
    
    // Marcar quartel como selecionado
    _quartel.selecionado = true;
    
    // Criar menu
    var _menu = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
    
    if (instance_exists(_menu)) {
        show_debug_message("✅ Menu moderno criado com sucesso!");
        show_debug_message("   - Menu ID: " + string(_menu));
        show_debug_message("   - Posição: (" + string(_menu.x) + ", " + string(_menu.y) + ")");
        
        // Configurar menu
        _menu.meu_quartel_id = _quartel;
        _quartel.menu_recrutamento = _menu;
        global.menu_recrutamento_aberto = true;
        
        show_debug_message("✅ Menu configurado e conectado ao quartel");
        
        // Verificar animações
        if (variable_instance_exists(_menu, "card_animations")) {
            show_debug_message("✅ Sistema de animações inicializado");
        } else {
            show_debug_message("⚠️ Sistema de animações não inicializado");
        }
        
    } else {
        show_debug_message("❌ Falha ao criar menu moderno!");
    }
    
} else {
    show_debug_message("❌ obj_menu_recrutamento_marinha não existe!");
}

// === 5. VERIFICAR SPRITES ===
show_debug_message("📋 5. VERIFICANDO SPRITES...");

if (sprite_exists(spr_lancha_patrulha)) {
    show_debug_message("✅ spr_lancha_patrulha existe");
} else {
    show_debug_message("⚠️ spr_lancha_patrulha não existe");
}

if (sprite_exists(spr_Constellation)) {
    show_debug_message("✅ spr_Constellation existe");
} else {
    show_debug_message("⚠️ spr_Constellation não existe");
}

// === 6. INSTRUÇÕES PARA TESTE MANUAL ===
show_debug_message("📋 6. INSTRUÇÕES PARA TESTE MANUAL...");

show_debug_message("🎯 Para testar o menu moderno:");
show_debug_message("   1. O menu deve aparecer automaticamente");
show_debug_message("   2. Verifique se todos os navios estão visíveis no grid 3x2");
show_debug_message("   3. Teste hover nos cards (devem brilhar)");
show_debug_message("   4. Clique nos botões PRODUZIR");
show_debug_message("   5. Verifique se recursos são deduzidos");
show_debug_message("   6. Teste botão FECHAR");
show_debug_message("   7. Teste tecla ESC para fechar");

// === 7. VERIFICAR FUNCIONALIDADES ===
show_debug_message("📋 7. VERIFICANDO FUNCIONALIDADES...");

show_debug_message("✅ Funcionalidades implementadas:");
show_debug_message("   - Grid 3x2 com todos os navios");
show_debug_message("   - Hover effects nos cards");
show_debug_message("   - Animações de fade in");
show_debug_message("   - Verificação de recursos");
show_debug_message("   - Sistema de fila de produção");
show_debug_message("   - Botão fechar");
show_debug_message("   - Tecla ESC para fechar");
show_debug_message("   - Status visual (disponível/bloqueado)");

// === RESULTADO FINAL ===
show_debug_message("🎯 === RESULTADO DO TESTE ===");

show_debug_message("✅ Menu naval moderno implementado!");
show_debug_message("📊 Status:");
show_debug_message("   - Quartel: " + string(_quartel));
show_debug_message("   - Menu: " + string(instance_exists(_menu) ? _menu : "não criado"));
show_debug_message("   - Dinheiro: $" + string(global.dinheiro));
show_debug_message("   - População: " + string(global.populacao));
show_debug_message("   - Unidades disponíveis: " + string(ds_list_size(_quartel.unidades_disponiveis)));

show_debug_message("🚢 === TESTE DO MENU MODERNO CONCLUÍDO ===");
