// =========================================================
// MINA DE OURO - HERDA DE obj_estrutura_producao
// Configura as propriedades específicas desta estrutura
// =========================================================

// Executar o código do objeto pai primeiro
event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 2500;
custo_minerio = 500;

// === SISTEMA DE VIDA ===
hp_max = 600;
hp_atual = 600;
destrutivel = true;

// === SISTEMA DE PRODUÇÃO ===
producao_por_ciclo = 2;     // Produz 2 unidades de ouro por ciclo
tipo_recurso = "ouro";     // Tipo de recurso produzido

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Minas só em terreno de campo

show_debug_message("⛏️ Mina de Ouro criada - Produção: " + string(producao_por_ciclo) + " ouro a cada 10 segundos");
