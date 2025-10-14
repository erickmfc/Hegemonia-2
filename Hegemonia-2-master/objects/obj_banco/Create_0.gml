// ===============================================
// HEGEMONIA GLOBAL - ESTRUTURA: BANCO
// Bloco 2, Fase 3: Produção de Dinheiro
// ===============================================

// Herda todos os eventos e lógicas do pai.
event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
// No Evento Create do obj_banco
custo_dinheiro = 500;
custo_minerio = 100; // Exemplo

// Especifica as variáveis para o banco.
producao_por_ciclo = 0; // Será calculado dinamicamente baseado na população
tipo_recurso = "dinheiro"; // Define o tipo de recurso.

// === SISTEMA DE ECONOMIA BASEADA NA POPULAÇÃO ===
taxa_por_habitante = 25; // Cada habitante gera 25 de dinheiro por ciclo
timer_economia = 0;
ciclo_economia = 180; // A cada 3 segundos (60 FPS * 3)

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

show_debug_message("Um banco foi construído e está gerando dinheiro baseado na população.");
