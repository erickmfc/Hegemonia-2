// ===============================================
// HEGEMONIA GLOBAL - ESTRUTURA: BANCO
// Sistema Financeiro Avançado - Empréstimos e Dívida
// ===============================================

// Herda todos os eventos e lógicas do pai.
event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 500;
custo_minerio = 100;

// === SISTEMA DE VIDA ===
hp_max = 500;
hp_atual = 500;
destrutivel = true; // ✅ Banco pode ser destruído

// === SISTEMA FINANCEIRO ===
// O banco não produz dinheiro automaticamente
// Ele oferece serviços financeiros
producao_por_ciclo = 0;           // Não produz recursos
tipo_recurso = "";                 // Não produz recursos

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

// === SISTEMA DE EMPRÉSTIMOS ===
emprestimo_maximo = 20000000;      // $20M máximo de empréstimo
emprestimo_atual = 0;              // Empréstimo atual desta instância
taxa_juros_banco = 0.05;          // 5% ao mês
juros_por_ciclo = 0;               // Juros calculados por ciclo

// === ATIVAR SISTEMA FINANCEIRO ===
// Marcar que o banco foi construído
global.banco_construido = true;

show_debug_message("🏦 Banco construído - Sistema financeiro ativado!");
show_debug_message("💰 Empréstimo disponível: $" + string(global.emprestimo_disponivel));
show_debug_message("📊 Taxa de juros: " + string(round(global.taxa_juros * 100)) + "% ao mês");
