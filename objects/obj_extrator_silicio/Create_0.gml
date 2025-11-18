// =========================================================
// EXTRATOR DE SILÍCIO - HERDA DE obj_estrutura_producao
// =========================================================

event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 2500;
custo_minerio = 500;

// === SISTEMA DE VIDA ===
hp_max = 650;
hp_atual = 650;
destrutivel = true;

// === SISTEMA DE PRODUÇÃO ===
producao_por_ciclo = 15;
tipo_recurso = "silicio";

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Extrator só em terreno de campo

show_debug_message("💎 Extrator de Silício criado - Produção: " + string(producao_por_ciclo) + " silício a cada 10 segundos");
