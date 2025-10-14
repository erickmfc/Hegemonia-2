// Evento Create de obj_game_manager

// =============================================
// HEGEMONIA GLOBAL - INICIALIZAÇÃO DE RECURSOS
// Bloco 2, Fase 1: Tesouro da Nação
// =============================================

// === EXECUTAR SCRIPTS DE CONSTRUÇÃO ===
// Execute o script de construtores para definir classes e funções
sc_constructors();

// === EXECUTAR SCRIPTS DE INICIALIZAÇÃO ===
// Execute o script de inicialização para definir enums
sc_game_init();

show_debug_message("CONTROLES GLOBAIS: Inicializando o Tesouro da Nação...");

// === RECURSOS FUNDAMENTAIS ===
// Estes são os 4 recursos base essenciais para o funcionamento da nação

// Dinheiro: Usado para investimentos, construções e manutenção.
global.dinheiro = 50000; // Aumentado para $50000 para permitir múltiplas pesquisas

// Minério: Essencial para a produção industrial e militar.
global.minerio = 1500;

// Petróleo: Fundamental para unidades motorizadas e setores energéticos.
global.petroleo = 1000;

// População: Representa a força de trabalho e a base para o crescimento da nação.
global.populacao = 2000;

// === RECURSOS ESTRATÉGICOS AVANÇADOS ===
// Recursos obtidos através de pesquisa e exploração

// Metais Preciosos
global.ouro = 100;      // Reservas monetárias e tecnologia avançada
global.titanio = 50;    // Tecnologia militar e aeroespacial
global.uranio = 25;     // Energia nuclear e armamento pesado

// Metais Industriais
global.aluminio = 200;  // Construção e indústria aeronáutica
global.cobre = 300;     // Eletrônicos e infraestrutura elétrica
global.litio = 75;      // Baterias e tecnologia moderna

// Recursos Orgânicos
global.borracha = 150;  // Indústria automotiva e militar
global.madeira = 500;   // Construção básica e infraestrutura

// Recursos Tecnológicos
global.silicio = 100;   // Eletrônicos e computadores
global.aco = 400;       // Construção pesada e armamento

// === RECURSOS COMPLEMENTARES ===
// Recursos secundários importantes para o funcionamento

global.energia = 1000;        // Capacidade energética da nação
global.turistas = 50;         // Renda através do turismo
global.militares_totais = 0;  // Força militar total
global.ranking_posicao = 1;   // Posição no ranking mundial
global.renda_diaria = 1000;   // Renda diária base

// === ESTOQUE NACIONAL CONSOLIDADO ===
// Mapa centralizado que contém TODOS os recursos da nação
global.estoque_recursos = ds_map_create();

// Adicionando recursos fundamentais
ds_map_add(global.estoque_recursos, "Dinheiro", global.dinheiro); // Agora $50000
ds_map_add(global.estoque_recursos, "Minério", global.minerio);
ds_map_add(global.estoque_recursos, "Petróleo", global.petroleo);
ds_map_add(global.estoque_recursos, "População", global.populacao);

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
show_debug_message("  Dinheiro: $" + string(global.dinheiro));
show_debug_message("  Minério: " + string(global.minerio) + " toneladas");
show_debug_message("  Petróleo: " + string(global.petroleo) + " barris");
show_debug_message("  População: " + string(global.populacao) + " habitantes");

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
instance_create_layer(0, 0, "Instances", obj_input_manager);
instance_create_layer(0, 0, "Instances", obj_build_manager);
instance_create_layer(0, 0, "Instances", obj_controlador_unidades); // Controlador de unidades


/// ================= CONFIGURAÇÕES DO MAPA =================
global.tile_size = 32;
global.map_width = room_width / global.tile_size;
global.map_height = room_height / global.tile_size;


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
// Verificar se os objetos existem antes de adicionar ao pathfinding
var objetos_edificios = [
    "obj_casa", "obj_banco", "obj_quartel", "obj_mina_ouro", 
    "obj_mina_aluminio", "obj_mina_cobre", "obj_research_center"
];

for (var i = 0; i < array_length(objetos_edificios); i++) {
    if (object_exists(objetos_edificios[i])) {
        mp_grid_add_instances(global.pathfinding_grid, asset_get_index(objetos_edificios[i]), true);
        show_debug_message("✅ Adicionado ao pathfinding: " + objetos_edificios[i]);
    } else {
        show_debug_message("⚠️ Objeto não encontrado para pathfinding: " + objetos_edificios[i]);
    }
}

show_debug_message("Grade de pathfinding criada com sucesso.");

// === CONFIGURAÇÃO DE CONTROLE DE UNIDADES ===
// Variável para armazenar a unidade atualmente selecionada
global.unidade_selecionada = noone;
global.mostrar_painel_comandos = false;

show_debug_message("CONTROLES GLOBAIS: Inicialização completa!");

// === VERIFICAÇÃO DE INTEGRIDADE ===
// Executar verificação de integridade do sistema
scr_verificar_integridade();

// === TESTE DO SISTEMA ===
// Executar testes básicos do sistema
scr_testar_sistema();
