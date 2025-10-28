// ===============================================
// HEGEMONIA GLOBAL - ESTRUTURA: CASA
// Sistema de Níveis e Evolução de Habitação
// ===============================================

// Herda todos os eventos e lógicas do pai (obj_estrutura_producao).
event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 150;
custo_minerio = 25;

// === SISTEMA DE VIDA ===
hp_max = 200;
hp_atual = 200;
destrutivel = true; // ✅ Casa pode ser destruída

// === SISTEMA DE NÍVEIS DE CASA ===
nivel_casa = 1;                    // Nível atual da casa (1, 2, 3)
capacidade_por_nivel = [10, 20, 30]; // Capacidade por nível
capacidade_atual = 10;             // Capacidade atual (nível 1)
pessoas_ocupadas = 0;              // Pessoas atualmente na casa

// === CUSTOS DE EVOLUÇÃO ===
custo_evolucao_nivel2_dinheiro = 300;  // Custo para evoluir para nível 2
custo_evolucao_nivel2_minerio = 50;
custo_evolucao_nivel3_dinheiro = 600;  // Custo para evoluir para nível 3
custo_evolucao_nivel3_minerio = 100;

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;
pode_evoluir = true;

// === SISTEMA DE HABITAÇÃO ===
// A casa não produz população automaticamente
// Ela apenas aumenta o limite populacional
producao_por_ciclo = 0;           // Não produz população
tipo_recurso = "";                 // Não produz recursos

// === ATUALIZAR LIMITE POPULACIONAL ===
// Adiciona a capacidade desta casa ao limite global
global.limite_populacional += capacidade_atual;

show_debug_message("🏠 Casa Nível " + string(nivel_casa) + " construída - Capacidade: " + string(capacidade_atual) + " pessoas");
show_debug_message("📊 Limite populacional total: " + string(global.limite_populacional) + " pessoas");

