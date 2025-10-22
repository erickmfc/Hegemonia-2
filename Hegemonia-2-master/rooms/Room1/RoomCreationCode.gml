/// Room Creation Code - Room1
/// Inicialização do Research Center

show_debug_message("Room1 creation code executando...");

// Cria uma instância do dashboard simples para exibir recursos
if (object_exists(obj_simple_dashboard)) {
    var _dashboard_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_simple_dashboard);
    
    if (instance_exists(_dashboard_instance)) {
        show_debug_message("✅ Dashboard simples criado com sucesso na sala Room1. ID: " + string(_dashboard_instance));
    } else {
        show_debug_message("❌ ERRO: Falha ao criar Dashboard simples!");
    }
} else {
    show_debug_message("⚠️ AVISO: obj_simple_dashboard não existe no projeto. Sistema de dashboard desabilitado temporariamente.");
}

// Cria uma instância do centro de pesquisa para habilitar a tecla B
if (object_exists(obj_research_center)) {
    var _research_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_research_center);
    
    if (instance_exists(_research_instance)) {
        show_debug_message("Research Center criado com sucesso na sala Room1. ID: " + string(_research_instance));
    } else {
        show_debug_message("ERRO: Falha ao criar Research Center!");
    }
} else if (object_exists(obj_centro_pesquisa)) {
    // Fallback: usar obj_centro_pesquisa se obj_research_center não existir
    var _research_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_centro_pesquisa);
    
    if (instance_exists(_research_instance)) {
        show_debug_message("Centro de Pesquisa (fallback) criado com sucesso na sala Room1. ID: " + string(_research_instance));
    } else {
        show_debug_message("ERRO: Falha ao criar Centro de Pesquisa!");
    }
} else {
    show_debug_message("AVISO: Nem obj_research_center nem obj_centro_pesquisa existem no projeto. Sistema de pesquisa desabilitado temporariamente.");
    // Temporariamente desabilita o sistema de pesquisa até o objeto ser reconhecido
    global.menu_pesquisa_aberto = false;
}

// Cria uma instância do UI Manager para gerenciar menus
if (object_exists(obj_ui_manager)) {
    var _ui_manager_instance = instance_create_layer(0, 0, "rm_mapa_principal", obj_ui_manager);
    
    if (instance_exists(_ui_manager_instance)) {
        show_debug_message("UI Manager criado com sucesso na sala Room1. ID: " + string(_ui_manager_instance));
    } else {
        show_debug_message("ERRO: Falha ao criar UI Manager!");
    }
} else {
    show_debug_message("AVISO: obj_ui_manager não existe no projeto. Sistema de UI desabilitado temporariamente.");
}

// === SISTEMA LIMPO - APENAS MOVIMENTAÇÃO ===
show_debug_message("=== SISTEMA LIMPO - APENAS MOVIMENTAÇÃO BÁSICA ===");
show_debug_message("Clique esquerdo para selecionar, clique direito para mover");

// === INICIALIZAR VARIÁVEIS GLOBAIS ===
if (!variable_global_exists("populacao_cidade")) {
    global.populacao_cidade = 0;
    show_debug_message("🏙️ População da cidade inicializada: 0");
}

if (!variable_global_exists("dinheiro")) {
    global.dinheiro = 10000; // ✅ CORRIGIDO: Usar global.dinheiro
    show_debug_message("💰 Dinheiro inicializado: $10.000");
}

if (!variable_global_exists("minerio")) {
    global.minerio = 1000; // ✅ ADICIONADO: Definir global.minerio
    show_debug_message("⛏️ Minério inicializado: 1000");
}

if (!variable_global_exists("populacao")) {
    global.populacao = 100; // ✅ ADICIONADO: Definir global.populacao
    show_debug_message("👥 População inicializada: 100");
}

if (!variable_global_exists("petroleo")) {
    global.petroleo = 500; // ✅ ADICIONADO: Definir global.petroleo
    show_debug_message("🛢️ Petróleo inicializado: 500");
}

// === INICIALIZAR VARIÁVEIS DE CONSTRUÇÃO ===
if (!variable_global_exists("menu_construcao_aberto")) {
    global.menu_construcao_aberto = false;
    show_debug_message("🏗️ Menu de construção inicializado: fechado");
}

if (!variable_global_exists("modo_construcao")) {
    global.modo_construcao = false;
    show_debug_message("🔧 Modo de construção inicializado: desativado");
}

if (!variable_global_exists("construindo_agora")) {
    global.construindo_agora = noone;
    show_debug_message("📐 Construindo agora inicializado: nenhum");
}

if (!variable_global_exists("menu_recrutamento_aberto")) {
    global.menu_recrutamento_aberto = false;
    show_debug_message("👥 Menu de recrutamento inicializado: fechado");
}

// === INICIALIZAR SISTEMA DE RECURSOS ===
if (!ds_exists(global.estoque_recursos, ds_type_map)) {
    global.estoque_recursos = ds_map_create();
    ds_map_add(global.estoque_recursos, "Dinheiro", global.dinheiro);
    ds_map_add(global.estoque_recursos, "Minério", global.minerio);
    ds_map_add(global.estoque_recursos, "Petróleo", global.petroleo);
    show_debug_message("📦 Sistema de recursos inicializado");
}

// === INICIALIZAR VARIÁVEIS DE CONSTRUÇÃO ===
if (!variable_global_exists("tile_size")) {
    global.tile_size = 64; // ✅ ADICIONADO: Definir global.tile_size
    show_debug_message("🔲 Tamanho do tile inicializado: 64");
}

if (!variable_global_exists("construindo_edificio")) {
    global.construindo_edificio = noone; // ✅ ADICIONADO: Definir global.construindo_edificio
    show_debug_message("🏗️ Construindo edifício inicializado: nenhum");
}

if (!variable_global_exists("debug_enabled")) {
    global.debug_enabled = true; // ✅ ADICIONADO: Definir global.debug_enabled
    show_debug_message("🐛 Debug habilitado: true");
}

// === INICIALIZAR SISTEMA DE PESQUISA ===
if (!ds_exists(global.nacao_recursos, ds_type_map)) {
    global.nacao_recursos = ds_map_create();
    ds_map_add(global.nacao_recursos, "Dinheiro", global.dinheiro);
    ds_map_add(global.nacao_recursos, "Minério", global.minerio);
    ds_map_add(global.nacao_recursos, "Petróleo", global.petroleo);
    show_debug_message("🔬 Sistema de pesquisa inicializado");
}

if (!ds_exists(global.research_timers, ds_type_map)) {
    global.research_timers = ds_map_create();
    show_debug_message("⏱️ Timers de pesquisa inicializados");
}

if (!variable_global_exists("slots_pesquisa_total")) {
    global.slots_pesquisa_total = 3; // ✅ ADICIONADO: Definir global.slots_pesquisa_total
    show_debug_message("🔬 Slots de pesquisa total inicializado: 3");
}

if (!variable_global_exists("slots_pesquisa_usados")) {
    global.slots_pesquisa_usados = 0; // ✅ ADICIONADO: Definir global.slots_pesquisa_usados
    show_debug_message("🔬 Slots de pesquisa usados inicializado: 0");
}

if (!variable_global_exists("game_frame")) {
    global.game_frame = 0; // ✅ ADICIONADO: Definir global.game_frame
    show_debug_message("🎮 Frame do jogo inicializado: 0");
}

if (!variable_global_exists("ui_scale")) {
    global.ui_scale = 1.2; // ✅ ADICIONADO: Definir global.ui_scale
    show_debug_message("🎨 Escala da UI inicializada: 1.2");
}

if (!variable_global_exists("text_quality")) {
    global.text_quality = "high"; // ✅ ADICIONADO: Definir global.text_quality
    show_debug_message("📝 Qualidade do texto inicializada: high");
}

if (!variable_global_exists("nacao_proprietaria")) {
    global.nacao_proprietaria = 1; // ✅ ADICIONADO: Definir global.nacao_proprietaria
    show_debug_message("🏴 Nação proprietária inicializada: 1");
}

if (!variable_global_exists("nacao_recursos")) {
    global.nacao_recursos = ds_map_create(); // ✅ ADICIONADO: Definir global.nacao_recursos
    ds_map_add(global.nacao_recursos, "Dinheiro", global.dinheiro);
    ds_map_add(global.nacao_recursos, "Minério", global.minerio);
    ds_map_add(global.nacao_recursos, "Petróleo", global.petroleo);
    show_debug_message("🏴 Recursos da nação inicializados");
}

if (!variable_global_exists("research_timers")) {
    global.research_timers = ds_map_create(); // ✅ ADICIONADO: Definir global.research_timers
    show_debug_message("⏱️ Timers de pesquisa inicializados");
}

if (!variable_global_exists("slots_pesquisa_total")) {
    global.slots_pesquisa_total = 3; // ✅ ADICIONADO: Definir global.slots_pesquisa_total
    show_debug_message("🔬 Slots de pesquisa total inicializado: 3");
}

if (!variable_global_exists("slots_pesquisa_usados")) {
    global.slots_pesquisa_usados = 0; // ✅ ADICIONADO: Definir global.slots_pesquisa_usados
    show_debug_message("🔬 Slots de pesquisa usados inicializado: 0");
}

if (!variable_global_exists("game_frame")) {
    global.game_frame = 0; // ✅ ADICIONADO: Definir global.game_frame
    show_debug_message("🎮 Frame do jogo inicializado: 0");
}

if (!variable_global_exists("ui_scale")) {
    global.ui_scale = 1.2; // ✅ ADICIONADO: Definir global.ui_scale
    show_debug_message("🎨 Escala da UI inicializada: 1.2");
}

if (!variable_global_exists("text_quality")) {
    global.text_quality = "high"; // ✅ ADICIONADO: Definir global.text_quality
    show_debug_message("📝 Qualidade do texto inicializada: high");
}

if (!variable_global_exists("nacao_proprietaria")) {
    global.nacao_proprietaria = 1; // ✅ ADICIONADO: Definir global.nacao_proprietaria
    show_debug_message("🏴 Nação proprietária inicializada: 1");
}

if (!variable_global_exists("nacao_recursos")) {
    global.nacao_recursos = ds_map_create(); // ✅ ADICIONADO: Definir global.nacao_recursos
    ds_map_add(global.nacao_recursos, "Dinheiro", global.dinheiro);
    ds_map_add(global.nacao_recursos, "Minério", global.minerio);
    ds_map_add(global.nacao_recursos, "Petróleo", global.petroleo);
    show_debug_message("🏴 Recursos da nação inicializados");
}

if (!variable_global_exists("research_timers")) {
    global.research_timers = ds_map_create(); // ✅ ADICIONADO: Definir global.research_timers
    show_debug_message("⏱️ Timers de pesquisa inicializados");
}

if (!variable_global_exists("slots_pesquisa_total")) {
    global.slots_pesquisa_total = 3; // ✅ ADICIONADO: Definir global.slots_pesquisa_total
    show_debug_message("🔬 Slots de pesquisa total inicializado: 3");
}

if (!variable_global_exists("slots_pesquisa_usados")) {
    global.slots_pesquisa_usados = 0; // ✅ ADICIONADO: Definir global.slots_pesquisa_usados
    show_debug_message("🔬 Slots de pesquisa usados inicializado: 0");
}

if (!variable_global_exists("game_frame")) {
    global.game_frame = 0; // ✅ ADICIONADO: Definir global.game_frame
    show_debug_message("🎮 Frame do jogo inicializado: 0");
}

if (!variable_global_exists("ui_scale")) {
    global.ui_scale = 1.2; // ✅ ADICIONADO: Definir global.ui_scale
    show_debug_message("🎨 Escala da UI inicializada: 1.2");
}

if (!variable_global_exists("text_quality")) {
    global.text_quality = "high"; // ✅ ADICIONADO: Definir global.text_quality
    show_debug_message("📝 Qualidade do texto inicializada: high");
}

if (!variable_global_exists("nacao_proprietaria")) {
    global.nacao_proprietaria = 1; // ✅ ADICIONADO: Definir global.nacao_proprietaria
    show_debug_message("🏴 Nação proprietária inicializada: 1");
}

if (!variable_global_exists("nacao_recursos")) {
    global.nacao_recursos = ds_map_create(); // ✅ ADICIONADO: Definir global.nacao_recursos
    ds_map_add(global.nacao_recursos, "Dinheiro", global.dinheiro);
    ds_map_add(global.nacao_recursos, "Minério", global.minerio);
    ds_map_add(global.nacao_recursos, "Petróleo", global.petroleo);
    show_debug_message("🏴 Recursos da nação inicializados");
}

if (!variable_global_exists("research_timers")) {
    global.research_timers = ds_map_create(); // ✅ ADICIONADO: Definir global.research_timers
    show_debug_message("⏱️ Timers de pesquisa inicializados");
}

if (!variable_global_exists("slots_pesquisa_total")) {
    global.slots_pesquisa_total = 3; // ✅ ADICIONADO: Definir global.slots_pesquisa_total
    show_debug_message("🔬 Slots de pesquisa total inicializado: 3");
}

if (!variable_global_exists("slots_pesquisa_usados")) {
    global.slots_pesquisa_usados = 0; // ✅ ADICIONADO: Definir global.slots_pesquisa_usados
    show_debug_message("🔬 Slots de pesquisa usados inicializado: 0");
}

if (!variable_global_exists("game_frame")) {
    global.game_frame = 0; // ✅ ADICIONADO: Definir global.game_frame
    show_debug_message("🎮 Frame do jogo inicializado: 0");
}

// === CRIAR INIMIGOS PARA TESTE DO SISTEMA DE ATAQUE ===
show_debug_message("=== CRIANDO INIMIGOS PARA TESTE DO SISTEMA DE ATAQUE ===");

// Tentar criar inimigos com obj_inimigo_teste primeiro (OBJETO NOVO)
var inimigos_criados = 0;
var usar_fallback = false;

// Verificar se o objeto obj_inimigo existe
if (object_exists(obj_inimigo)) {
    show_debug_message("✅ obj_inimigo encontrado no projeto");
    
    // Criar 2 inimigos usando obj_inimigo
    for (var i = 0; i < 2; i++) {
        var inimigo = instance_create_layer(400 + (i * 150), 300 + (i * 100), "rm_mapa_principal", obj_inimigo);
        
        if (instance_exists(inimigo)) {
            inimigos_criados++;
            show_debug_message("🎯 Inimigo " + string(inimigos_criados) + " criado com obj_inimigo - ID: " + string(inimigo) + " | Posição: " + string(inimigo.x) + ", " + string(inimigo.y));
            show_debug_message("🎯 Inimigo configurado automaticamente com HP: 100/100 e nação: 2");
        } else {
            show_debug_message("❌ ERRO: Falha ao criar inimigo " + string(i + 1) + " com obj_inimigo");
            usar_fallback = true;
        }
    }
    
    if (inimigos_criados == 0) {
        show_debug_message("❌ Falha total ao criar inimigos com obj_inimigo - usando fallback");
        usar_fallback = true;
    }
} else {
    show_debug_message("❌ ERRO: obj_inimigo não encontrado no projeto!");
    show_debug_message("❌ Verifique se o objeto foi criado e salvo corretamente");
    usar_fallback = true;
}

// Se precisar usar fallback ou se obj_inimigo_teste falhou
if (usar_fallback) {
    show_debug_message("🔄 Usando obj_infantaria como fallback para criar inimigos...");
    
    for (var i = 0; i < 2; i++) {
        var inimigo = instance_create_layer(400 + (i * 150), 300 + (i * 100), "rm_mapa_principal", obj_infantaria);
        
        if (instance_exists(inimigo)) {
            // Configurar como inimigo
            inimigo.nacao_proprietaria = 2; // 2 = inimigo
            inimigo.hp_atual = 100;
            inimigo.hp_max = 100;
            inimigo.estado = "livre";
            inimigo.comando_atual = "LIVRE";
            
            show_debug_message("🎯 Inimigo " + string(i + 1) + " criado com obj_infantaria - ID: " + string(inimigo) + " | Posição: " + string(inimigo.x) + ", " + string(inimigo.y));
        } else {
            show_debug_message("❌ ERRO: Falha ao criar inimigo " + string(i + 1) + " mesmo com fallback");
        }
    }
}

show_debug_message("🎯 Total de inimigos criados: " + string(inimigos_criados));

show_debug_message("=== SISTEMA DE CASAS E ECONOMIA ATIVO ===");
show_debug_message("🏠 Cada casa adiciona 10 pessoas");
show_debug_message("🏦 Banco gera dinheiro baseado na população");
show_debug_message("💵 Taxa: $25 por habitante a cada 3 segundos");
show_debug_message("⚔️ Sistema de Ataque Ativo - Clique esquerdo para selecionar, direito para atacar/mover");