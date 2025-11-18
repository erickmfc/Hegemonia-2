// =========================================================
// MINA DE COBRE - HERDA DE obj_estrutura_producao
// =========================================================

event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 1500;
custo_minerio = 300;

// === SISTEMA DE VIDA ===
hp_max = 550;
hp_atual = 550;
destrutivel = true;

// === SISTEMA DE PRODUÇÃO ===
producao_por_ciclo = 20;
tipo_recurso = "cobre";

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Minas só em terreno de campo

show_debug_message("⛏️ Mina de Cobre criada - Produção: " + string(producao_por_ciclo) + " cobre a cada 10 segundos");
