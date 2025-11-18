// =========================================================
// SERRARIA - HERDA DE obj_estrutura_producao
// =========================================================

event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 800;
custo_minerio = 150;

// === SISTEMA DE VIDA ===
hp_max = 500;
hp_atual = 500;
destrutivel = true;

// === SISTEMA DE PRODUÇÃO ===
producao_por_ciclo = 8;
tipo_recurso = "madeira";

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Serraria só em terreno de campo

show_debug_message("🪵 Serraria criada - Produção: " + string(producao_por_ciclo) + " madeira a cada 10 segundos");
