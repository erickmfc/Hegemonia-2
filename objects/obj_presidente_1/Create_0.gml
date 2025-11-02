// ===============================================
// HEGEMONIA GLOBAL - IA PRESIDENTE 1
// Sistema de Inteligência Artificial para Unidades Inimigas
// ===============================================

// === IDENTIFICAÇÃO DA IA ===
nacao_proprietaria = 2; // 2 = IA Inimiga
nome_ia = "Presidente 1";

// === SISTEMA DE DECISÃO ===
intervalo_decisao = 60; // REDUZIDO de 90 para 60 - DECISÃO A CADA 1 SEGUNDO (ULTRA RÁPIDA)
timer_decisao = 10; // REDUZIDO de 30 para 10 - COMEÇAR QUASE IMEDIATAMENTE

// === PRIORIDADES DA IA ===
prioridade_economia = 0.2;  // REDUZIDO de 0.4 para 0.2 - MENOS ECONOMIA
prioridade_militar = 0.8;   // AUMENTADO de 0.6 para 0.8 - MAIS AGRESSIVA

// === ESTADO ATUAL ===
objetivo_atual = "expandir"; // expandir, atacar, defender
unidades_totais = 0;
estruturas_totais = 0;

// === POSIÇÃO BASE (onde a IA está posicionada no mapa) ===
base_x = x;
base_y = y;
raio_expansao = 3000; // AUMENTADO de 800 para 3000 - DETECTA EM TODO O MAPA

// === UNIDADES EM CONTROLE (cache para performance) ===
lista_unidades = ds_list_create();
lista_estruturas = ds_list_create();
lista_inimigas_visiveis = ds_list_create();

// === COMANDOS MILITARES ===
esquadrao_formando = false;
esquadrao_tamanho_minimo = 2; // REDUZIDO de 5 para 2 - ATACAR COM MENOS UNIDADES
unidades_em_esquadrao = ds_list_create();
alvo_atual = noone;

// === CONTADOR DE ATUALIZAÇÃO ===
counter_update = 0;

// === VISUAL ===
visible = true; // Visível no mapa
image_alpha = 0.3; // Semi-transparente para indicar que é um marcador da IA

// === DEBUG ===
show_debug_message("🤖 IA " + nome_ia + " inicializada!");
show_debug_message("📍 Posição base: (" + string(base_x) + ", " + string(base_y) + ")");
show_debug_message("💰 Recursos IA: $" + string(global.ia_dinheiro) + " | Minério: " + string(global.ia_minerio));
