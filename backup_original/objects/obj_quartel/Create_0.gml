// ===============================================
// HEGEMONIA GLOBAL - ESTRUTURA: QUARTEL
// Sistema Avançado de Recrutamento (FASE 2)
// ===============================================

// Herda todos os eventos e lógicas do pai (obj_estrutura_producao).
event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 400;
custo_minerio = 250; 

// === CONFIGURAÇÕES DE PRODUÇÃO ===
producao_por_ciclo = 0; // Não produz recursos automáticos
tipo_recurso = "militar"; // Tipo especial para identificar como estrutura militar

// === CONFIGURAÇÕES DE RECRUTAMENTO ===
menu_recrutamento_ativo = false;
recrutamento_em_andamento = false;
unidade_sendo_treinada = noone;
tempo_treinamento_restante = 0;

// === VARIÁVEL DE ESTADO DE TREINAMENTO ===
esta_treinando = false;

// === VARIÁVEIS PARA RECRUTAMENTO MÚLTIPLO ===
unidades_para_criar = 1;  // Quantidade total de unidades a serem criadas
unidades_criadas = 0;     // Quantidade de unidades já criadas
quantidade_recrutar = 1;  // Quantidade solicitada para recrutamento

// === CONFIGURAÇÕES DE NAÇÃO ===
nacao_proprietaria = 1; // Valor padrão - 1 = jogador, 2 = inimigo

// === CONFIGURAÇÕES DE UI ===
mostrar_menu = false;
botao_largura = 180;
botao_altura = 35;

// === SISTEMA DE UNIDADES MÚLTIPLAS (NOVO) ===
unidades_disponiveis = ds_list_create();
unidade_selecionada = 0; // Índice da unidade selecionada

// Adicionar unidades disponíveis
ds_list_add(unidades_disponiveis, {
    nome: "Infantaria Básica",
    objeto: obj_infantaria,
    custo_dinheiro: 100,
    custo_populacao: 1,
    tempo_treino: 300,
    descricao: "Unidade de combate básica com rifle",
    sprite: spr_infantaria // Assumindo que existe
});

ds_list_add(unidades_disponiveis, {
    nome: "Infantaria Pesada",
    objeto: obj_infantaria,
    custo_dinheiro: 200,
    custo_populacao: 2,
    tempo_treino: 450,
    descricao: "Unidade mais resistente com armadura",
    sprite: spr_infantaria // Placeholder
});

ds_list_add(unidades_disponiveis, {
    nome: "Atirador de Elite",
    objeto: obj_infantaria,
    custo_dinheiro: 300,
    custo_populacao: 1,
    tempo_treino: 600,
    descricao: "Atirador com maior precisão e alcance",
    sprite: spr_infantaria // Placeholder
});

ds_list_add(unidades_disponiveis, {
    nome: "Tanque",
    objeto: obj_tanque,
    custo_dinheiro: 500,
    custo_populacao: 3,
    tempo_treino: 900,
    descricao: "Unidade blindada pesada com canhão",
    sprite: spr_tanque
});

// === SISTEMA DE UPGRADES (NOVO) ===
nivel_quartel = 1;
nivel_maximo = 3;
custo_upgrade = 500;

// === FILA DE RECRUTAMENTO (NOVO) ===
fila_recrutamento = ds_queue_create();
max_fila = 5; // Máximo de 5 unidades na fila

// === ESTATÍSTICAS ===
unidades_treinadas_total = 0;
tempo_total_treinamento = 0;

// === SISTEMA DE COMANDO TÁTICO (NOVO) ===
interface_comando_ativa = false;
unidades_selecionadas = ds_list_create();
comando_selecionado = "nenhum"; // "nenhum", "seguir", "patrulhar"
postura_selecionada = "agressiva"; // "agressiva", "defensiva", "passiva"
ponto_patrulha_temp = noone; // Ponto temporário para definir patrulha
modo_selecao = false; // Se está no modo de seleção de unidades

// === VARIÁVEIS ADICIONAIS PARA COMPATIBILIDADE ===
unidades_para_criar = 1;
unidades_criadas = 0;
quantidade_recrutar = 1;

show_debug_message("Um quartel foi construído e está pronto para recrutar unidades.");
show_debug_message("Custo de construção: $" + string(custo_dinheiro) + " dinheiro, " + string(custo_minerio) + " minério");