// =========================================================
// MINA DE TITÂNIO - HERDA DE obj_estrutura_producao
// =========================================================

event_inherited();

// === CUSTOS DE CONSTRUÇÃO ===
custo_dinheiro = 4000;
custo_minerio = 800;

// === SISTEMA DE VIDA ===
hp_max = 700;
hp_atual = 700;
destrutivel = true;

// === SISTEMA DE PRODUÇÃO ===
producao_por_ciclo = 3;
tipo_recurso = "titanio";

// === VARIÁVEIS DE SELEÇÃO ===
selecionado = false;
timer_feedback = 0;

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Minas só em terreno de campo

// === CICLO PERSONALIZADO ===
// Titânio tem ciclo mais longo (20 segundos)
alarm[0] = game_get_speed(gamespeed_fps) * 20;

show_debug_message("⛏️ Mina de Titânio criada - Produção: " + string(producao_por_ciclo) + " titânio a cada 20 segundos");
