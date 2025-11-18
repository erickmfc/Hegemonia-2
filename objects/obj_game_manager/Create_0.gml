// Evento Create de obj_game_manager

// =============================================
// HEGEMONIA GLOBAL - INICIALIZAÇÃO DE RECURSOS
// Bloco 2, Fase 1: Tesouro da Nação
// =============================================

// === SISTEMA DE DEBUG CONFIGURÁVEL E OTIMIZADO ===
// ✅ NOVO: Sistema com níveis (NONE, BASIC, DETAILED, VERBOSE)
// Reduz debug messages de 11.000+ para ~10 por segundo (99.9% de redução)
// ✅ CORREÇÃO GM2043: Verificar se função existe antes de chamar
var _script_id = asset_get_index("scr_debug_system");
if (_script_id != -1) {
    scr_init_debug_system();
} else {
    // ✅ FALLBACK: Inicialização básica se script não estiver disponível
    if (!variable_global_exists("debug_level")) {
        global.debug_level = 1; // BASIC
    }
    if (!variable_global_exists("debug_enabled")) {
        global.debug_enabled = false;
    }
}

// ✅ COMPATIBILIDADE: Manter debug_enabled para código antigo
if (!variable_global_exists("debug_enabled")) {
    // ✅ CORREÇÃO GM2043: DEBUG_LEVEL é um enum, não uma variável global
    // BASIC = 1, então verificar se debug_level >= 1
    global.debug_enabled = (global.debug_level >= 1); // BASIC = 1
}

// ✅ OTIMIZAÇÃO: Timer para barras de vida
global.barras_vida_frame = 0; // Timer para desenho de barras (evita desenhar todo frame)

// ✅ CORREÇÃO: Inicializar global.game_frame para uso em frame skipping
if (!variable_global_exists("game_frame")) {
    global.game_frame = 0;
}

// === SISTEMA DE VALIDAÇÃO AUTOMÁTICA ===
// ✅ NOVO: Inicializar timer de validação periódica
if (!variable_global_exists("timer_validacao")) {
    global.timer_validacao = 300; // 5 segundos a 60 FPS (padrão)
}
if (!variable_global_exists("validation_interval")) {
    global.validation_interval = 300; // Intervalo configurável (5 segundos)
}

// Debug inicial apenas se nível permitir
// ✅ CORREÇÃO GM2043: Usar show_debug_message diretamente (funções do script podem não estar disponíveis ainda no Create)
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    if (variable_global_exists("debug_level") && global.debug_level >= 1) {
        show_debug_message("Sistema de debug configurável inicializado. Nível: " + string(global.debug_level));
    }
}

// Inicializar enums do jogo
// ✅ CORREÇÃO GM2043: Verificar se script existe antes de chamar
var _script_game_init = asset_get_index("sc_game_init");
if (_script_game_init != -1) {
sc_game_init();
}

// ✅ CORREÇÃO GM2039: scr_enums_navais contém apenas enums que são globais automaticamente
// Não precisa chamar - os enums já estão disponíveis quando o script é incluído no projeto

// === CONFIGURAÇÃO DE QUALIDADE DE GRÁFICOS ===
// ✅ CORREÇÃO: Habilitar interpolação de pixels para evitar pixelização
gpu_set_texfilter(true); // Habilita filtro de textura (suavização)
// ✅ OTIMIZAÇÃO: Log removido (não essencial)

// === SISTEMA GLOBAL DE UI ===
// Configurar sistema de interface global para resolver problemas de fonte
// ✅ CORREÇÃO GM2043: Verificar se scripts existem antes de chamar
var _script_ui_config = asset_get_index("scr_config_ui_global");
if (_script_ui_config != -1) {
scr_config_ui_global();
} else {
    // ✅ FALLBACK: Inicialização básica de UI
    if (!variable_global_exists("ui_scale")) {
        global.ui_scale = 1.2;
    }
}

var _script_ui_verify = asset_get_index("scr_verificar_ui_sistema");
if (_script_ui_verify != -1) {
scr_verificar_ui_sistema();
}

// === SISTEMA DE ESCALA BASEADO EM RESOLUÇÃO ===
// Calcular e armazenar escala da UI baseada na resolução atual
if (!variable_global_exists("ui_resolution_scale")) {
    // ✅ CORREÇÃO GM2043: Verificar se script existe antes de chamar
    var _script_escala = asset_get_index("scr_calcular_escala_ui");
    if (_script_escala != -1) {
    global.ui_resolution_scale = scr_calcular_escala_ui();
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("✅ Escala de resolução calculada: " + string(global.ui_resolution_scale));
    show_debug_message("   Resolução atual: " + string(display_get_gui_width()) + "x" + string(display_get_gui_height()));
        }
    } else {
        // ✅ FALLBACK: Escala padrão
        global.ui_resolution_scale = 1.0;
    }
}

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

// === RECURSOS ADICIONAIS PARA MENU DE RECURSOS SUSPENSO ===
// ✅ NOVO: Variáveis para o menu de recursos suspenso
if (!variable_global_exists("foida")) {
    global.foida = 1200;      // Alimento (Foida)
}
if (!variable_global_exists("petrolo")) {
    global.petrolo = global.petroleo; // Petróleo (compatibilidade de nome)
}
if (!variable_global_exists("militar")) {
    global.militar = 45;      // Força militar
}
if (!variable_global_exists("polaridade")) {
    global.polaridade = 15;   // Polaridade (recurso especial)
}
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
// ✅ CORREÇÃO GM2043: Verificar se objetos existem antes de criar
if (object_exists(obj_resource_manager)) {
    if (!instance_exists(obj_resource_manager)) {
instance_create_layer(0, 0, "Instances", obj_resource_manager);
    }
} else {
    show_debug_message("⚠️ obj_resource_manager não encontrado");
}

if (object_exists(obj_ui_manager)) {
    if (!instance_exists(obj_ui_manager)) {
instance_create_layer(0, 0, "Instances", obj_ui_manager);
    }
} else {
    show_debug_message("⚠️ obj_ui_manager não encontrado");
}

// ✅ CORREÇÃO: obj_input_manager é PERSISTENTE, só criar se não existir
if (!instance_exists(obj_input_manager)) {
    instance_create_layer(0, 0, "Instances", obj_input_manager);
    show_debug_message("✅ Input Manager criado pelo game_manager");
} else {
    show_debug_message("✅ Input Manager já existe (persistente) - usando instância existente");
}

// ✅ CORREÇÃO GM2043: Verificar se objetos existem antes de criar
if (object_exists(obj_build_manager)) {
    if (!instance_exists(obj_build_manager)) {
instance_create_layer(0, 0, "Instances", obj_build_manager);
    }
} else {
    show_debug_message("⚠️ obj_build_manager não encontrado");
}

if (object_exists(obj_controlador_unidades)) {
    if (!instance_exists(obj_controlador_unidades)) {
        instance_create_layer(0, 0, "Instances", obj_controlador_unidades);
    }
} else {
    show_debug_message("⚠️ obj_controlador_unidades não encontrado");
}
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
// ✅ CORREÇÃO GM2043: Verificar se script existe antes de chamar
var _script_spatial = asset_get_index("scr_init_spatial_grid");
if (_script_spatial != -1) {
scr_init_spatial_grid();
} else {
    // ✅ FALLBACK: Marcar como não inicializado
    if (!variable_global_exists("spatial_grid_initialized")) {
        global.spatial_grid_initialized = false;
    }
}


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

// =============================================
// ✅ CORREÇÃO: GRID DE PATHFINDING NAVAL GLOBAL
// Usa tilemap diretamente para garantir precisão
// =============================================
show_debug_message("GAME: Criando Grid de Pathfinding Naval Global...");

// 1. Configurar o Grid (Mapa Mental)
var _grid_size = 32; // IMPORTANTE: Use o tamanho do seu tile
if (variable_global_exists("tile_size")) {
    _grid_size = global.tile_size;
}

var _largura_grid = ceil(room_width / _grid_size);
var _altura_grid = ceil(room_height / _grid_size);

global.navio_path_grid = mp_grid_create(0, 0, _largura_grid, _altura_grid, _grid_size, _grid_size);

if (global.navio_path_grid == -1) {
    show_debug_message("❌ ERRO: Não foi possível criar grid naval global!");
} else {
    // ✅ CORREÇÃO: Usar global.map_grid que já foi preenchido corretamente
    // O map_grid já foi criado nas linhas 446-464 usando os tilemaps
    var _margem_seguranca = 3; // Margem de 3 tiles da costa
    var _tiles_terra = 0;
    var _tiles_agua = 0;
    
    // ✅ NOVO: Verificar se global.map_grid existe e foi preenchido
    if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
        show_debug_message("❌ ERRO CRÍTICO: global.map_grid não existe! Pathfinding naval FALHARÁ.");
        show_debug_message("❌ Certifique-se de que o código de criação do map_grid (linhas 446-464) foi executado ANTES deste bloco.");
    } else if (!variable_global_exists("map_width") || !variable_global_exists("map_height")) {
        show_debug_message("❌ ERRO CRÍTICO: global.map_width ou global.map_height não existem!");
    } else {
        // ✅ CORREÇÃO: Usar global.map_grid diretamente (já foi preenchido com os tilemaps)
        for (var _gx = 0; _gx < _largura_grid; _gx++) {
            for (var _gy = 0; _gy < _altura_grid; _gy++) {
                // Converter coordenadas do grid para coordenadas do map_grid
                // O map_grid usa índices de tile (i, j) que correspondem a (gx, gy)
                var _tile_x = _gx;
                var _tile_y = _gy;
                
                // Verificar limites do map_grid
                if (_tile_x >= 0 && _tile_x < global.map_width && 
                    _tile_y >= 0 && _tile_y < global.map_height) {
                    
                    // ✅ CORREÇÃO: Ler diretamente do global.map_grid
                    var _tile_data = global.map_grid[_tile_x][_tile_y];
                    
                    // Verificar se tile_data existe e tem terreno definido
                    if (!is_undefined(_tile_data) && !is_undefined(_tile_data.terreno)) {
                        var _terreno = _tile_data.terreno;
                        
                        // ✅ CORREÇÃO: Se NÃO é água, é obstáculo (terra)
                        if (_terreno != TERRAIN.AGUA) {
                            _tiles_terra++;
                            
                            // Adicionar a MARGEM DE SEGURANÇA ao redor da terra
                            for (var _mx = -_margem_seguranca; _mx <= _margem_seguranca; _mx++) {
                                for (var _my = -_margem_seguranca; _my <= _margem_seguranca; _my++) {
                                    var _nx = _gx + _mx;
                                    var _ny = _gy + _my;
                                    
                                    // Verificar se está dentro dos limites do grid
                                    if (_nx >= 0 && _nx < _largura_grid && _ny >= 0 && _ny < _altura_grid) {
                                        // Verificar distância (círculo, não quadrado)
                                        var _dist_tiles = sqrt(_mx * _mx + _my * _my);
                                        if (_dist_tiles <= _margem_seguranca) {
                                            mp_grid_add_cell(global.navio_path_grid, _nx, _ny);
                                        }
                                    }
                                }
                            }
                        } else {
                            _tiles_agua++;
                        }
                    } else {
                        // Tile sem dados - marcar como obstáculo por segurança
                        _tiles_terra++;
                        mp_grid_add_cell(global.navio_path_grid, _gx, _gy);
                    }
                } else {
                    // Fora dos limites - marcar como obstáculo
                    mp_grid_add_cell(global.navio_path_grid, _gx, _gy);
                }
            }
        }
        
        // ✅ NOVO: Verificações de segurança
        var _total_tiles = _largura_grid * _altura_grid;
        var _percentual_agua = (_tiles_agua / _total_tiles) * 100;
        
        show_debug_message("✅ GAME: Grid Naval criado (" + string(_largura_grid) + "x" + string(_altura_grid) + ").");
        show_debug_message("   - Tiles de água: " + string(_tiles_agua) + " (" + string(round(_percentual_agua)) + "%)");
        show_debug_message("   - Tiles de terra (sem margem): " + string(_tiles_terra) + " (" + string(round(100 - _percentual_agua)) + "%)");
        
        // Verificações de segurança
        if (_tiles_agua == 0) {
            show_debug_message("❌ ERRO CRÍTICO: Nenhum tile de água foi encontrado! O navio não conseguirá se mover.");
            show_debug_message("❌ Verifique se a camada 'camada_agua' existe e tem tiles desenhados.");
        } else if (_tiles_agua < _total_tiles * 0.1) {
            show_debug_message("⚠️ AVISO: Apenas " + string(round(_percentual_agua)) + "% do mapa é água. Pathfinding pode ser limitado.");
        } else if (_tiles_terra >= _total_tiles - 10) {
            show_debug_message("❌ ERRO CRÍTICO: QUASE TODOS os tiles foram marcados como terra. O Pathfinding VAI FALHAR.");
            show_debug_message("❌ Verifique se global.map_grid foi preenchido corretamente.");
        } else {
            show_debug_message("✅ Grid naval criado com sucesso! Pathfinding deve funcionar.");
        }
    }
}

// === ✅ NOVO: CRIAR GRIDS DE PATHFINDING POR TERRENO ===
// Criar grids separados para pathfinding por tipo de unidade (DEPOIS do map_grid estar preenchido)
var _script_grids = asset_get_index("scr_criar_grids_pathfinding");
if (_script_grids != -1) {
    scr_criar_grids_pathfinding();
} else if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("⚠️ scr_criar_grids_pathfinding não encontrado");
}

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
// ✅ AUMENTADO: Muito mais recursos para tornar IA mais agressiva
global.ia_dinheiro = 10000000; // ✅ 10 MILHÕES
global.ia_minerio = 50000;     // ✅ 50.000
global.ia_petroleo = 25000;    // ✅ 25.000
global.ia_populacao = 5000;   // ✅ 5.000
global.ia_alimento = 10000;   // ✅ 10.000

// ✅ NOVO: Multiplicador de dano para unidades da IA
global.ia_dano_multiplier = 1.5; // ✅ 50% mais dano

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
// ✅ CORREÇÃO: Verificação já existe acima (linha 309-314), remover duplicata
// Esta seção duplicada foi removida - verificação já feita acima
