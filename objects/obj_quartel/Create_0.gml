// ===============================================
// HEGEMONIA GLOBAL - ESTRUTURA: QUARTEL
// Sistema Original com Menu de Recrutamento
// ===============================================

// Herda todos os eventos e lógicas do pai (obj_estrutura_producao).
event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 400;
custo_minerio = 250;

// === SISTEMA DE VIDA ===
hp_max = 300;
hp_atual = 300;
destrutivel = true; // ✅ Quartel pode ser destruído 

// === CONFIGURAÇÕES DE PRODUÇÃO ===
producao_por_ciclo = 0; // Não produz recursos automáticos
tipo_recurso = "militar"; // Tipo especial para identificar como estrutura militar

// === CORREÇÃO CRÍTICA: DESATIVAR ALARME DE PRODUÇÃO ===
// O quartel não deve produzir recursos automaticamente como outras estruturas
// Ele usa o sistema de FILA no Step_0, não o Alarm_0
// ✅ GARANTIR QUE ALARME ESTÁ DESATIVADO (o pai pode ter ativado)
alarm[0] = -1; // Desativa o alarme de produção automática
// ✅ VERIFICAR E DESATIVAR NOVAMENTE APÓS VARIÁVEIS
if (alarm[0] > 0) alarm[0] = -1; // Forçar desativação se ainda estiver ativo

// === CONFIGURAÇÕES DE RECRUTAMENTO ===
menu_recrutamento_ativo = false;
menu_recrutamento = noone; // ✅ Referência ao menu de recrutamento deste quartel
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
    tempo_treino: 240, // ✅ MUDADO: 4 segundos (240 frames) - MÁXIMO
    descricao: "Unidade de combate básica com rifle",
    sprite: spr_infantaria
});

ds_list_add(unidades_disponiveis, {
    nome: "Soldado Anti-Aéreo",
    objeto: obj_soldado_antiaereo,
    custo_dinheiro: 200,
    custo_populacao: 1,
    tempo_treino: 240, // ✅ MUDADO: 4 segundos (240 frames) - MÁXIMO
    descricao: "Especialista com mísseis de longo alcance",
    sprite: spr_soldado_antiaereo,
    categoria: "terrestre"
});

ds_list_add(unidades_disponiveis, {
    nome: "Tanque",
    objeto: obj_tanque,
    custo_dinheiro: 500,
    custo_populacao: 3,
    tempo_treino: 240, // ✅ MUDADO: 4 segundos (240 frames) - MÁXIMO
    descricao: "Unidade blindada pesada com canhão",
    sprite: spr_tanque
});

ds_list_add(unidades_disponiveis, {
    nome: "Blindado Anti-Aéreo",
    objeto: obj_blindado_antiaereo,
    custo_dinheiro: 800,
    custo_populacao: 4,
    tempo_treino: 240, // ✅ MUDADO: 4 segundos (240 frames) - MÁXIMO
    descricao: "Veículo especializado em defesa aérea",
    sprite: spr_blindado_antiaereo,
    categoria: "terrestre"
});

// === FILA DE RECRUTAMENTO SIMPLES ===
fila_recrutamento = ds_queue_create();

// ✅ GARANTIR QUE FILA ESTÁ VAZIA AO CRIAR
ds_queue_clear(fila_recrutamento);
esta_treinando = false; // ✅ GARANTIR QUE NÃO ESTÁ TREINANDO
tempo_treinamento_restante = 0; // ✅ RESETAR TIMER

// === VARIÁVEIS PARA COMPATIBILIDADE ===
ultimo_recrutamento_tanque = false;

// Variáveis para evitar avisos GM2016
quantidade_recrutar = 1;
unidades_para_criar = 1;
unidades_criadas = 0;
recrutar_tanque = false;

// Contador para debug do Step
step_counter = 0;

// === PROTEÇÃO CONTRA DESATIVAÇÃO ===
// ✅ CORREÇÃO: Garantir que quartel sempre esteja visível e ativo
visible = true;
force_always_active = true; // Nunca desativar estruturas importantes
instance_activate_object(id); // Garantir que está ativo

show_debug_message("Um quartel foi construído e está pronto para recrutar unidades.");
show_debug_message("Custo de construção: $" + string(custo_dinheiro) + " dinheiro, " + string(custo_minerio) + " minério");
show_debug_message("✅ Quartel protegido contra desativação - ID: " + string(id));