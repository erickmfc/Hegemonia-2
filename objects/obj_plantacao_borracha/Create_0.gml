// =========================================================
// PLANTAÇÃO DE BORRACHA - HERDA DE obj_estrutura_producao
// =========================================================

event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 1200;
custo_minerio = 200;

// === SISTEMA DE VIDA ===
hp_max = 450;
hp_atual = 450;
destrutivel = true;

// === SISTEMA DE PRODUÇÃO ===
producao_por_ciclo = 25;
tipo_recurso = "borracha";

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Plantação só em terreno de campo

show_debug_message("🌳 Plantação de Borracha criada - Produção: " + string(producao_por_ciclo) + " borracha a cada 10 segundos");
