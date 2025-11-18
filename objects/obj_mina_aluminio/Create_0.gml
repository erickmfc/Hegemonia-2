// =========================================================
// MINA DE ALUMÍNIO - HERDA DE obj_estrutura_producao
// Configura as propriedades específicas desta estrutura
// =========================================================

// Executar o código do objeto pai primeiro
event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 2000;
custo_minerio = 400;

// === SISTEMA DE VIDA ===
hp_max = 600;
hp_atual = 600;
destrutivel = true;

// === SISTEMA DE PRODUÇÃO ===
producao_por_ciclo = 12;        // Produz 12 unidades de alumínio por ciclo
tipo_recurso = "aluminio";     // Tipo de recurso produzido

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Minas só em terreno de campo

show_debug_message("⛏️ Mina de Alumínio criada - Produção: " + string(producao_por_ciclo) + " alumínio a cada 10 segundos");
