// ===============================================
// HEGEMONIA GLOBAL - ESTRUTURA: CASA
// Bloco 2, Fase 3: Produção de População
// ===============================================

// Herda todos os eventos e lógicas do pai (obj_estrutura_producao).
event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
// No Evento Create do obj_casa
custo_dinheiro = 150;
custo_minerio = 25; // Exemplo

// Agora, apenas especificamos as variáveis deste filho em particular.
// Estas linhas 'sobrescrevem' os valores padrão do pai.
producao_por_ciclo = 10; // A casa gera 10 pessoas por ciclo.
tipo_recurso = "populacao"; // Define o tipo de recurso que esta estrutura gera.

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;
populacao_adicionada = false;

// === VARIÁVEIS DE POPULAÇÃO ===
limite_pessoas_por_casa = 10;        // Máximo de pessoas por casa
limite_maximo_cidade = 1000;         // Limite máximo da cidade
pessoas_esta_casa = 0;               // Pessoas desta casa específica

show_debug_message("Uma casa foi construída e está gerando 10 pessoas de população.");
