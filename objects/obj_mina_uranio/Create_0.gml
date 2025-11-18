// =========================================================
// MINA DE URÂNIO - HERDA DE obj_estrutura_producao
// =========================================================

event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 6000;
custo_minerio = 1200;

// === SISTEMA DE VIDA ===
hp_max = 800;
hp_atual = 800;
destrutivel = true;

// === SISTEMA DE PRODUÇÃO ===
producao_por_ciclo = 1;
tipo_recurso = "uranio";

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Minas só em terreno de campo

// === CICLO PERSONALIZADO ===
// Urânio tem ciclo mais longo (30 segundos)
alarm[0] = game_get_speed(gamespeed_fps) * 30;

show_debug_message("⛏️ Mina de Urânio criada - Produção: " + string(producao_por_ciclo) + " urânio a cada 30 segundos");
