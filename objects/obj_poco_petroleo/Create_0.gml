// =========================================================
// POÇO DE PETRÓLEO - HERDA DE obj_estrutura_producao
// =========================================================

event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 3000;
custo_minerio = 500;

// === SISTEMA DE VIDA ===
hp_max = 600;
hp_atual = 600;
destrutivel = true;

// === SISTEMA DE PRODUÇÃO ===
producao_por_ciclo = 5;
tipo_recurso = "petroleo";

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Poços de petróleo só em terreno de campo

// === CICLO PERSONALIZADO ===
// Petróleo tem ciclo de 15 segundos
alarm[0] = game_get_speed(gamespeed_fps) * 15;

show_debug_message("🛢️ Poço de Petróleo criado - Produção: " + string(producao_por_ciclo) + " petróleo a cada 15 segundos");
