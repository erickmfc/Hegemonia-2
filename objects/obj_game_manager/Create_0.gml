// Evento Create de obj_game_manager

// =============================================
// HEGEMONIA GLOBAL - INICIALIZAÇÃO DE RECURSOS
// Bloco 2, Fase 1: Tesouro da Nação
// =============================================

// === SISTEMA DE DEBUG GLOBAL ULTRA OTIMIZADO ===
// Sistema configurável para reduzir debug messages de 973 para ~10 por frame (99% de redução)
// ✅ OTIMIZAÇÃO: Desabilitar debug por padrão para melhor performance
if (!variable_global_exists("debug_enabled")) {
    global.debug_enabled = false; // ✅ Desabilitado por padrão
}
global.debug_timer_global = 0; // Timer global para debug
global.debug_frame_count = 0; // Contador de frames para debug

// ✅ CORREÇÃO: Inicializar global.game_frame para uso em frame skipping
if (!variable_global_exists("game_frame")) {
    global.game_frame = 0;
}

// ✅ OTIMIZAÇÃO: Função wrapper para debug condicional (melhor performance)
if (!variable_global_exists("debug_log")) {
    global.debug_log = function(msg) {
        if (global.debug_enabled) {
            show_debug_message(msg);
        }
    };
}

// ✅ OTIMIZAÇÃO: Timer para barras de vida
global.barras_vida_frame = 0; // Timer para desenho de barras (evita desenhar todo frame)

// Resetar contador a cada frame
global.debug_reset_frame = function() {
    global.debug_current_frame = 0;
    global.debug_frame_count++;
};

// Debug apenas uma vez por segundo
if (global.debug_enabled) {
    show_debug_message("Sistema de debug ULTRA otimizado inicializado. Modo: " + string(global.debug_enabled));
}

// Inicializar enums do jogo
sc_game_init();

// ✅ CORREÇÃO GM2039: scr_enums_navais contém apenas enums que são globais automaticamente
// Não precisa chamar - os enums já estão disponíveis quando o script é incluído no projeto

// === CONFIGURAÇÃO DE QUALIDADE DE GRÁFICOS ===
// ✅ CORREÇÃO: Habilitar interpolação de pixels para evitar pixelização
gpu_set_texfilter(true); // Habilita filtro de textura (suavização)
show_debug_message("✅ Filtro de textura habilitado para melhor qualidade gráfica");

// === SISTEMA GLOBAL DE UI ===
// Configurar sistema de interface global para resolver problemas de fonte
scr_config_ui_global();
scr_verificar_ui_sistema();

// === CONFIGURAÇÃO DA GUI PARA DETECÇÃO CORRETA DE CLIQUES ===
// Define que a GUI deve manter proporção 1:1 sempre, garantindo que device_mouse_x_to_gui funcione corretamente
display_set_gui_maximise(1, 1, 0, 0);
show_debug_message("✅ GUI configurado com display_set_gui_maximise para detecção correta de cliques");

// === RECURSOS FUNDAMENTAIS ===
// Estes são os 4 recursos base essenciais para o funcionamento da nação

// Dinheiro: Usado para investimentos, construções e manutenção.
global.dinheiro = 5000000; // $5.000.000 Créditos Globais (CG) - DEFINIDO PARA 5 MILHÕES

// Minério: Essencial para a produção industrial e militar.
global.minerio = 4500; // ✅ TRIPLICADO: 1500 * 3 = 4500

// Petróleo: Fundamental para unidades motorizadas e setores energéticos.
global.petroleo = 3000; // ✅ TRIPLICADO: 1000 * 3 = 3000

// População: Representa a força de trabalho e a base para o crescimento da nação.
global.populacao = 5000; // ✅ AUMENTADO PARA 5000

// === SISTEMA DE LIMITE POPULACIONAL ===
// Limite inicial de população (sem casas)
global.limite_populacional = 1000; // Limite base sem casas
global.populacao_atual = 0; // População atual (será calculada dinamicamente)

// Sistema de Alimento
global.alimento = 0; // Inicia com 0, será produzido pelas fazendas

// === RECURSOS ESTRATÉGICOS AVANÇADOS ===
// Recursos obtidos através de pesquisa e exploração

// Metais Preciosos
global.ouro = 300;      // ✅ TRIPLICADO: 100 * 3 = 300 - Reservas monetárias e tecnologia avançada
global.titanio = 150;   // ✅ TRIPLICADO: 50 * 3 = 150 - Tecnologia militar e aeroespacial
global.uranio = 75;     // ✅ TRIPLICADO: 25 * 3 = 75 - Energia nuclear e armamento pesado

// Metais Industriais
global.aluminio = 600;  // ✅ TRIPLICADO: 200 * 3 = 600 - Construção e indústria aeronáutica
global.cobre = 900;     // ✅ TRIPLICADO: 300 * 3 = 900 - Eletrônicos e infraestrutura elétrica
global.litio = 225;     // ✅ TRIPLICADO: 75 * 3 = 225 - Baterias e tecnologia moderna

// Recursos Orgânicos
global.borracha = 450;  // ✅ TRIPLICADO: 150 * 3 = 450 - Indústria automotiva e militar
global.madeira = 1500;  // ✅ TRIPLICADO: 500 * 3 = 1500 - Construção básica e infraestrutura

// Recursos Tecnológicos
global.silicio = 300;   // ✅ TRIPLICADO: 100 * 3 = 300 - Eletrônicos e computadores
global.aco = 1200;      // ✅ TRIPLICADO: 400 * 3 = 1200 - Construção pesada e armamento

// === RECURSOS COMPLEMENTARES ===
// Recursos secundários importantes para o funcionamento

global.energia = 3000;  // ✅ TRIPLICADO: 1000 * 3 = 3000 - Capacidade energética da nação

// === SISTEMA DE INFLATION ===
// Inicializar variáveis de inflação
global.taxa_inflacao = 0.0;        // Inflação atual (0% inicial)
global.inflacao_maxima = 0.50;     // Máximo 50% de inflação
global.inflacao_decay = 0.001;     // Redução automática por frame
global.ultima_impressao = 0;       // Timer da última impressão

// === SISTEMA DE CUSTOS COM INFLATION ===
// Função para calcular custos com inflação
global.calcular_custo_inflacionado = function(custo_base) {
    return custo_base * (1 + global.taxa_inflacao);
};

// === SISTEMA DE ESTABILIDADE SOCIAL ===
global.estabilidade_social = 100;   // 100% de estabilidade inicial
global.instabilidade_por_inflacao = 0.8; // Perda de estabilidade por inflação

// === SISTEMA DE IMPOSTOS (FUTURO) ===
// TODO: Implementar sistema de arrecadação de impostos
// global.taxa_impostos = 0.20; // Taxa de 20% de impostos sobre atividade econômica
// global.base_economica_por_cidadao = 10; // Cada cidadão gera 10 CG de atividade econômica por mês
// global.ultima_coleta_impostos = 0; // Timer da última coleta de impostos
// global.ciclo_impostos = 1800; // Coleta de impostos a cada 30 segundos (1800 frames)

// === SISTEMA FINANCEIRO - BANCO ===
// Sistema de empréstimos e dívida
global.divida_total = 0;                    // Dívida total da nação
global.juros_mensais = 0;                   // Juros a pagar por mês
global.taxa_juros = 0.05;                   // Taxa de juros (5% ao mês)
global.emprestimo_disponivel = 20000000;    // Empréstimo disponível ($20M)
global.banco_construido = false;            // Se o banco foi construído
global.pagamento_automatico = true;         // Pagamento automático de juros
global.ultimo_pagamento = 0;                // Timer do último pagamento

// === SISTEMA DE COMANDOS AÉREOS ===
// Variável global para controle de patrulha avançada
// ✅ CORREÇÃO: Inicialização robusta com verificação de existência
if (!variable_global_exists("definindo_patrulha_unidade")) {
    global.definindo_patrulha_unidade = noone; // Unidade em modo de definição de patrulha
}
global.turistas = 50;         // Renda através do turismo
global.militares_totais = 0;  // Força militar total
global.ranking_posicao = 1;   // Posição no ranking mundial
global.renda_diaria = 1000;   // Renda diária base

// === ESTOQUE NACIONAL CONSOLIDADO ===
// Mapa centralizado que contém TODOS os recursos da nação
global.estoque_recursos = ds_map_create();

// Adicionando recursos fundamentais
ds_map_add(global.estoque_recursos, "Dinheiro", global.dinheiro); // Agora $50.000.000 CG
ds_map_add(global.estoque_recursos, "Minério", global.minerio);
ds_map_add(global.estoque_recursos, "Petróleo", global.petroleo);
ds_map_add(global.estoque_recursos, "População", global.populacao);
ds_map_add(global.estoque_recursos, "Alimento", global.alimento);

// Adicionando metais preciosos
ds_map_add(global.estoque_recursos, "Ouro", global.ouro);
ds_map_add(global.estoque_recursos, "Titânio", global.titanio);
ds_map_add(global.estoque_recursos, "Urânio", global.uranio);

// Adicionando metais industriais
ds_map_add(global.estoque_recursos, "Alumínio", global.aluminio);
ds_map_add(global.estoque_recursos, "Cobre", global.cobre);
ds_map_add(global.estoque_recursos, "Lítio", global.litio);

// Adicionando recursos orgânicos
ds_map_add(global.estoque_recursos, "Borracha", global.borracha);
ds_map_add(global.estoque_recursos, "Madeira", global.madeira);

// Adicionando recursos tecnológicos
ds_map_add(global.estoque_recursos, "Silício", global.silicio);
ds_map_add(global.estoque_recursos, "Aço", global.aco);

// Adicionando recursos complementares
ds_map_add(global.estoque_recursos, "Energia", global.energia);

show_debug_message("Tesouro da Nação definido com sucesso.");
show_debug_message("Total de recursos inicializados: " + string(ds_map_size(global.estoque_recursos)));

// === SISTEMA DE CONSTRUÇÃO ===
// Variável de estado para o sistema de construção
global.modo_construcao = false; // 'false' = desligado, 'true' = ligado
global.construcao_selecionada = ""; // Tipo de construção selecionada ("casa", "banco", etc.)
global.construindo_agora = noone; // Guarda qual objeto estamos prestes a construir. 'noone' = nada.

// === SISTEMA DE PESQUISA ===
// Configurações do centro de pesquisa
global.menu_pesquisa_aberto = false;

// === SISTEMA DE RECRUTAMENTO ===
// Variável de estado para o menu de recrutamento
global.menu_recrutamento_aberto = false;
global.slots_pesquisa_total = 3;
global.slots_pesquisa_usados = 0;
global.custo_slot_extra = 5000;

// Enum para status de pesquisa
enum RESOURCE_STATUS {
    LOCKED,
    AVAILABLE,
    RESEARCHING,
    RESEARCHED
}

// Mapa de status das pesquisas
global.nacao_recursos = ds_map_create();
global.research_timers = ds_map_create();

// Lista de pesquisas disponíveis
var research_list = [
    "Aluminio", "Borracha", "Centro", "Cobre", "Litio", "Mina",
    "Ouro", "Petroleo", "Serraria", "Silicio", "Titanio", "Uranio"
];

// Inicializar todas as pesquisas como disponíveis
for (var i = 0; i < array_length(research_list); i++) {
    ds_map_add(global.nacao_recursos, research_list[i], RESOURCE_STATUS.AVAILABLE);
}

show_debug_message("Sistema de pesquisa inicializado com " + string(array_length(research_list)) + " opções.");

// === RELATÓRIO INICIAL DO TESOURO ===
show_debug_message("\n=== RELATÓRIO DO TESOURO DA NAÇÃO ===");
show_debug_message("RECURSOS FUNDAMENTAIS:");
show_debug_message("  Dinheiro: $" + string(global.dinheiro) + " Créditos Globais (CG)");
show_debug_message("  Minério: " + string(global.minerio) + " toneladas");
show_debug_message("  Petróleo: " + string(global.petroleo) + " barris");
show_debug_message("  População: " + string(global.populacao) + " habitantes");
show_debug_message("  Alimento: " + string(global.alimento) + " unidades");

show_debug_message("\nMETAIS PRECIOSOS:");
show_debug_message("  Ouro: " + string(global.ouro) + " kg");
show_debug_message("  Titânio: " + string(global.titanio) + " kg");
show_debug_message("  Urânio: " + string(global.uranio) + " kg");

show_debug_message("\nMETAIS INDUSTRIAIS:");
show_debug_message("  Alumínio: " + string(global.aluminio) + " toneladas");
show_debug_message("  Cobre: " + string(global.cobre) + " toneladas");
show_debug_message("  Lítio: " + string(global.litio) + " toneladas");

show_debug_message("\nRECURSOS ORGÂNICOS:");
show_debug_message("  Borracha: " + string(global.borracha) + " toneladas");
show_debug_message("  Madeira: " + string(global.madeira) + " m³");

show_debug_message("\nRECURSOS TECNOLÓGICOS:");
show_debug_message("  Silício: " + string(global.silicio) + " toneladas");
show_debug_message("  Aço: " + string(global.aco) + " toneladas");

show_debug_message("\nRECURSOS COMPLEMENTARES:");
show_debug_message("  Energia: " + string(global.energia) + " MW");
show_debug_message("  Renda Diária: $" + string(global.renda_diaria));
show_debug_message("===================================\n");

/// ================= CRIAÇÃO DOS MINISTÉRIOS =================
instance_create_layer(0, 0, "Instances", obj_resource_manager);
instance_create_layer(0, 0, "Instances", obj_ui_manager);

// ✅ CORREÇÃO: obj_input_manager é PERSISTENTE, só criar se não existir
if (!instance_exists(obj_input_manager)) {
    instance_create_layer(0, 0, "Instances", obj_input_manager);
    show_debug_message("✅ Input Manager criado pelo game_manager");
} else {
    show_debug_message("✅ Input Manager já existe (persistente) - usando instância existente");
}

instance_create_layer(0, 0, "Instances", obj_build_manager);
instance_create_layer(0, 0, "Instances", obj_controlador_unidades); // Controlador de unidades
// Sistema de barras de vida integrado ao game_manager
global.barras_vida_ativas = true;

// =============================================
// SISTEMA DE PROJECTILE POOL MANAGER
// =============================================
if (!instance_exists(obj_projectile_pool_manager)) {
    instance_create_layer(0, 0, "Instances", obj_projectile_pool_manager);
    show_debug_message("✅ Projectile Pool Manager criado");
} else {
    show_debug_message("✅ Projectile Pool Manager já existe");
}

// =============================================
// SISTEMA DE CACHE DE BUSCA DE INIMIGOS
// =============================================
if (!instance_exists(obj_enemy_search_cache_manager)) {
    instance_create_layer(0, 0, "Instances", obj_enemy_search_cache_manager);
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("✅ Enemy Search Cache Manager criado");
    }
}

// =============================================
// SISTEMA DE OTIMIZAÇÃO DE DRAW CALLS
// =============================================
if (!instance_exists(obj_draw_optimizer)) {
    instance_create_layer(0, 0, "Instances", obj_draw_optimizer);
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("✅ Draw Optimizer criado");
    }
}

// =============================================
// SISTEMA DE STANDBY PARA UNIDADES INIMIGAS
// ✅ DESABILITADO: Estava impedindo IA de atacar
// =============================================
/*
if (!instance_exists(obj_enemy_standby_manager)) {
    instance_create_layer(0, 0, "Instances", obj_enemy_standby_manager);
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("✅ Enemy Standby Manager criado");
    }
}
*/


/// ================= CONFIGURAÇÕES DO MAPA =================
global.tile_size = 32;
global.map_width = room_width / global.tile_size;
global.map_height = room_height / global.tile_size;

/// ================= SISTEMA SPATIAL GRID (OPCIONAL) =================
// ✅ OTIMIZAÇÃO: Inicializar spatial grid para busca otimizada de unidades
scr_init_spatial_grid();


/// ================= DEFINIÇÃO DAS CAMADAS DE TERRENO =================
var camada_campo = layer_tilemap_get_id(layer_get_id("camada_campo"));
var camada_floresta = layer_tilemap_get_id(layer_get_id("camada_floresta"));
var camada_deserto = layer_tilemap_get_id(layer_get_id("camada_deserto"));
var camada_agua = layer_tilemap_get_id(layer_get_id("camada_agua"));


/// ================= CRIAÇÃO E PREENCHIMENTO DO GRID DE DADOS =================
global.map_grid = array_create(global.map_width);

for (var i = 0; i < global.map_width; i++) {
    global.map_grid[i] = array_create(global.map_height);
    for (var j = 0; j < global.map_height; j++) {
        
        var tipo_terreno = TERRAIN.CAMPO;
        
        if (tilemap_get(camada_agua, i, j) > 0) {
            tipo_terreno = TERRAIN.AGUA;
        } else if (tilemap_get(camada_floresta, i, j) > 0) {
            tipo_terreno = TERRAIN.FLORESTA;
        } else if (tilemap_get(camada_deserto, i, j) > 0) {
            tipo_terreno = TERRAIN.DESERTO;
        }
        
        global.map_grid[i][j] = new TileData(tipo_terreno, NATIONS.NEUTRA);
    }
}
show_debug_message("Grid de dados do mapa criado com sucesso.");


/// ================= DESENHO DAS FRONTEIRAS =================
// A lógica de desenho das fronteiras (draw_line) foi movida para o Draw Event
// para garantir que seja atualizada a cada frame.

/// ================= CRIAÇÃO DA GRADE DE PATHFINDING =================
show_debug_message("Criando grade de pathfinding para o mapa...");

// Cria uma variável global para guardar nossa grade
// Ela tem o mesmo tamanho da sala e a mesma célula do nosso grid
global.pathfinding_grid = mp_grid_create(0, 0, room_width / global.tile_size, room_height / global.tile_size, global.tile_size, global.tile_size);

// Adiciona todas as instâncias de edifícios como obstáculos na grade
// === EDIFÍCIOS DO MENU DE CONSTRUÇÃO ===
mp_grid_add_instances(global.pathfinding_grid, obj_casa, true);
mp_grid_add_instances(global.pathfinding_grid, obj_banco, true);
mp_grid_add_instances(global.pathfinding_grid, obj_fazenda, true);
mp_grid_add_instances(global.pathfinding_grid, obj_quartel, true);
mp_grid_add_instances(global.pathfinding_grid, obj_quartel_marinha, true);
mp_grid_add_instances(global.pathfinding_grid, obj_aeroporto_militar, true);

// === EDIFÍCIOS DE PESQUISA E MINERAÇÃO ===
mp_grid_add_instances(global.pathfinding_grid, obj_mina_ouro, true);
mp_grid_add_instances(global.pathfinding_grid, obj_mina_aluminio, true);
mp_grid_add_instances(global.pathfinding_grid, obj_mina_cobre, true);
mp_grid_add_instances(global.pathfinding_grid, obj_research_center, true);

show_debug_message("Grade de pathfinding criada com sucesso.");

// === CONFIGURAÇÃO DE CONTROLE DE UNIDADES ===
// Variável para armazenar a unidade atualmente selecionada
global.unidade_selecionada = noone;
global.mostrar_painel_comandos = false;

show_debug_message("CONTROLES GLOBAIS: Inicialização completa!");

// === CONFIGURAÇÃO DE DEBUG VERBOSO (SILENCIAR NAVIOS POR PADRÃO) ===
if (!variable_global_exists("verbose_navios")) {
    global.verbose_navios = false; // Pode ativar em testes para ver logs detalhados de navios
}

// === RECURSOS DA IA (PRESIDENTE 1) ===
// Sistema de recursos separados para a IA inimiga
global.ia_dinheiro = 1000000; // 1 MILHÃO de dinheiro para a IA
global.ia_minerio = 1000;
global.ia_petroleo = 500;
global.ia_populacao = 100;
global.ia_alimento = 0;

show_debug_message("✅ Recursos da IA inicializados");

// === SISTEMA DE DEFESA DO PRESIDENTE ===
// Variáveis globais para sistema de defesa
global.defesa_presidente_ativa = true;
global.tiles_sistema_ativo = false; // ⚠️ Será true quando tiles forem implementados

show_debug_message("🛡️ Sistema de defesa do presidente configurado");

// === SISTEMA DE DEACTIVATION MANAGER ===
// ✅ DESABILITADO: Estava fazendo unidades sumirem ao mudar de local
// Criar objeto gerenciador de deactivation para estatísticas e debug
/*
if (object_exists(obj_deactivation_manager)) {
    var _deact_mgr = instance_create_layer(0, 0, "Instances", obj_deactivation_manager);
    if (variable_global_exists("debug_enabled") && global.debug_enabled && instance_exists(_deact_mgr)) {
        show_debug_message("✅ Sistema de Deactivation Manager criado");
    }
} else {
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("⚠️ obj_deactivation_manager não encontrado - usando scr_manage_instance_lod()");
    }
}
*/

// === SISTEMA DE PROJECTILE POOLING ===
if (object_exists(obj_projectile_pool_manager)) {
    var _pool_mgr = instance_create_layer(0, 0, "Instances", obj_projectile_pool_manager);
    if (variable_global_exists("debug_enabled") && global.debug_enabled && instance_exists(_pool_mgr)) {
        show_debug_message("✅ Projectile Pool Manager criado");
    }
}
