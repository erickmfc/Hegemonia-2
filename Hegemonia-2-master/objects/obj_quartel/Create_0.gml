// ===============================================
// HEGEMONIA GLOBAL - ESTRUTURA: QUARTEL
// Sistema Original com Menu de Recrutamento
// ===============================================

// Herda todos os eventos e lógicas do pai (obj_estrutura_producao).
event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 400;
custo_minerio = 250; 

// === CONFIGURAÇÕES DE PRODUÇÃO ===
producao_por_ciclo = 0; // Não produz recursos automáticos
tipo_recurso = "militar"; // Tipo especial para identificar como estrutura militar

// === CORREÇÃO CRÍTICA: DESATIVAR ALARME DE PRODUÇÃO ===
// O quartel não deve produzir recursos automaticamente como outras estruturas
// Ele usa o Alarm_0 apenas para recrutamento de unidades
alarm[0] = -1; // Desativa o alarme de produção automática

// === CONFIGURAÇÕES DE RECRUTAMENTO ===
menu_recrutamento_ativo = false;
recrutamento_em_andamento = false;
unidade_sendo_treinada = noone;
tempo_treinamento_restante = 0;

// === VARIÁVEL DE ESTADO DE TREINAMENTO ===
esta_treinando = false;

// === CONFIGURAÇÕES DE NAÇÃO ===
nacao_proprietaria = 1; // Valor padrão - 1 = jogador, 2 = inimigo

// === CONFIGURAÇÕES DE UI ===
mostrar_menu = false;
botao_largura = 180;
botao_altura = 35;

// === SISTEMA DE UNIDADES DISPONÍVEIS ===
unidades_disponiveis = ds_list_create();
unidade_selecionada = 0; // Índice da unidade selecionada

// Adicionar unidades disponíveis
ds_list_add(unidades_disponiveis, {
    nome: "Infantaria",
    objeto: obj_infantaria,
    custo_dinheiro: 100,
    custo_populacao: 1,
    tempo_treino: 300,
    descricao: "Unidade de combate básica com rifle",
    sprite: spr_infantaria
});

ds_list_add(unidades_disponiveis, {
    nome: "Soldado Anti-Aéreo",
    objeto: obj_soldado_antiaereo,
    custo_dinheiro: 200,
    custo_populacao: 1,
    tempo_treino: 450,
    descricao: "Especialista com mísseis de longo alcance",
    sprite: spr_soldado_antiaereo,
    categoria: "terrestre"
});

ds_list_add(unidades_disponiveis, {
    nome: "Tanque",
    objeto: obj_tanque,
    custo_dinheiro: 500,
    custo_populacao: 3,
    tempo_treino: 300,
    descricao: "Unidade blindada pesada com canhão",
    sprite: spr_tanque
});

ds_list_add(unidades_disponiveis, {
    nome: "Blindado Anti-Aéreo",
    objeto: obj_blindado_antiaereo,
    custo_dinheiro: 800,
    custo_populacao: 4,
    tempo_treino: 300,
    descricao: "Veículo especializado em defesa aérea",
    sprite: spr_blindado_antiaereo,
    categoria: "terrestre"
});

// === FILA DE RECRUTAMENTO SIMPLES ===
fila_recrutamento = ds_queue_create();

// === VARIÁVEIS PARA COMPATIBILIDADE ===
ultimo_recrutamento_tanque = false;

// Variáveis para evitar avisos GM2016
quantidade_recrutar = 1;
unidades_para_criar = 1;
unidades_criadas = 0;
recrutar_tanque = false;

show_debug_message("Um quartel foi construído e está pronto para recrutar unidades.");
show_debug_message("Custo de construção: $" + string(custo_dinheiro) + " dinheiro, " + string(custo_minerio) + " minério");