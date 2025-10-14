// ===============================================
// HEGEMONIA GLOBAL - QUARTEL BASE (OBJETO PAI)
// Sistema 100% Independente e Simplificado
// ===============================================

// === CONFIGURAÇÕES BÁSICAS ===
hp_max = 200;
hp_atual = 200;
nacao_proprietaria = 1;
selecionado = false;

// === SISTEMA DE PRODUÇÃO UNIFICADO ===
fila_producao = ds_queue_create();
timer_producao = 0;
produzindo = false;
unidades_produzidas = 0;

// === CONFIGURAÇÕES DE UNIDADES ===
unidades_disponiveis = ds_list_create();
unidade_atual_producao = noone;

// === SISTEMA DE RECURSOS SIMPLIFICADO ===
recursos_necessarios = ds_map_create();
recursos_necessarios[? "dinheiro"] = 0;
recursos_necessarios[? "minerio"] = 0;
recursos_necessarios[? "populacao"] = 0;

// === CONFIGURAÇÕES VISUAIS ===
image_blend = c_white;

// === SISTEMA DE INTERFACE ===
mostrar_menu = false;
menu_ativo = false;

show_debug_message("🏗️ Quartel Base criado - Sistema unificado ativo");