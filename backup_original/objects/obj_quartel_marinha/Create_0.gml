// ===============================================
// HEGEMONIA GLOBAL - ESTRUTURA: QUARTEL MARINHA
// Sistema Avançado de Recrutamento Naval (FASE 2)
// ===============================================

// Sem herança de objeto pai neste quartel (parentObjectId = null)

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 800;
custo_minerio = 400; 
custo_petroleo = 200; // Recurso adicional para marinha

// === CONFIGURAÇÕES DE PRODUÇÃO ===
producao_por_ciclo = 0; // Não produz recursos automáticos
tipo_recurso = "naval"; // Tipo especial para identificar como estrutura naval

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

// === SISTEMA DE UNIDADES NAVALES MÚLTIPLAS ===
unidades_disponiveis = ds_list_create();
unidade_selecionada = 0; // Índice da unidade selecionada

// Limpar e cadastrar apenas o primeiro navio real (BR-120)
ds_list_clear(unidades_disponiveis);
ds_list_add(unidades_disponiveis, {
    nome: "BR-120",
    objeto: obj_br_120,
    classe: NAVAL_CLASS.CORVETA,
    custo_dinheiro: 0,
    custo_populacao: 0,
    custo_petroleo: 0,
    tempo_treino: 60, // 1 segundo para testes (era 600 = 10 segundos)
    descricao: "Modelo protótipo brasileiro BR-120",
    sprite: spr_marinha
});

// === SISTEMA DE UPGRADES ===
nivel_quartel = 1;
nivel_maximo = 3;
custo_upgrade = 800;

// === FILA DE RECRUTAMENTO ===
fila_recrutamento = ds_queue_create();
max_fila = 4; // Máximo de 4 unidades na fila (menos que terrestre)

// === ESTATÍSTICAS ===
unidades_treinadas_total = 0;
tempo_total_treinamento = 0;

// === SISTEMA DE COMANDO TÁTICO NAVAL ===
interface_comando_ativa = false;
unidades_selecionadas = ds_list_create();
comando_selecionado = "nenhum"; // "nenhum", "patrulhar", "atacar"
postura_selecionada = "agressiva"; // "agressiva", "defensiva", "passiva"
ponto_patrulha_temp = noone; // Ponto temporário para definir patrulha
modo_selecao = false; // Se está no modo de seleção de unidades

// === VARIÁVEIS ADICIONAIS PARA COMPATIBILIDADE ===
unidades_para_criar = 1;
unidades_criadas = 0;
quantidade_recrutar = 1;
quantidade_restante = 0; // Quantidade de unidades restantes para criar

// === CONFIGURAÇÕES ESPECÍFICAS NAVALES ===
requer_agua = true; // Deve ser construído na água
raio_construcao_agua = 100; // Raio para verificar se há água

show_debug_message("Um quartel marinha foi construído e está pronto para recrutar unidades navais.");
show_debug_message("Custo de construção: $" + string(custo_dinheiro) + " dinheiro, " + string(custo_minerio) + " minério, " + string(custo_petroleo) + " petróleo");