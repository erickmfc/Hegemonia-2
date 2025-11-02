// ===============================================
// HEGEMONIA GLOBAL - AEROPORTO MILITAR
// Sistema de Produção Aérea
// ===============================================

// === CONFIGURAÇÕES BÁSICAS ===
custo_dinheiro = 1000;
custo_minerio = 500;
hp_max = 800;
hp_atual = 800;
destrutivel = true; // ✅ Aeroporto pode ser destruído
nacao_proprietaria = 1;

// === SISTEMA DE PRODUÇÃO AÉREA ===
fila_producao = ds_queue_create();
timer_producao = 0;
produzindo = false; // ✅ GARANTIR QUE NÃO ESTÁ PRODUZINDO
unidades_produzidas = 0;

// ✅ LIMPAR FILA PARA EVITAR PRODUÇÃO AUTOMÁTICA
ds_queue_clear(fila_producao);
show_debug_message("🧹 Fila de produção limpa - aguardando comando do jogador");

// === CONFIGURAÇÕES DE UNIDADES AÉREAS ===
unidades_disponiveis = ds_list_create();

// Caça F-5
ds_list_add(unidades_disponiveis, {
    nome: "Caça F-5",
    objeto: obj_caca_f5,
    custo_dinheiro: 800,
    custo_populacao: 3,
    tempo_treino: 240, // ✅ MUDADO: 4 segundos (240 frames) - MÁXIMO
    descricao: "Caça-bombardeiro de alta velocidade"
});

// Helicóptero Militar
ds_list_add(unidades_disponiveis, {
    nome: "Helicóptero Militar",
    objeto: obj_helicoptero_militar,
    custo_dinheiro: 600,
    custo_populacao: 2,
    tempo_treino: 240, // ✅ MUDADO: 4 segundos (240 frames) - MÁXIMO
    descricao: "Helicóptero de ataque e transporte"
});

// C-100 Transporte
ds_list_add(unidades_disponiveis, {
    nome: "C-100 Transporte",
    objeto: obj_c100,
    custo_dinheiro: 1200,
    custo_populacao: 4,
    tempo_treino: 240, // ✅ MUDADO: 4 segundos (240 frames) - MÁXIMO
    descricao: "Avião de transporte com embarque de tropas e flares defensivos"
});

// Caça F-15 Eagle
ds_list_add(unidades_disponiveis, {
    nome: "F-15 Eagle",
    objeto: obj_f15,
    custo_dinheiro: 1500,
    custo_populacao: 5,
    tempo_treino: 240, // ✅ MUDADO: 4 segundos (240 frames) - MÁXIMO
    descricao: "Caça superior com HP 800 e sistema de mísseis avançado"
});

// === SISTEMA DE SELEÇÃO ===
selecionado = false;
menu_recrutamento = noone;

// === CONFIGURAÇÕES VISUAIS CORRIGIDAS ===
image_blend = make_color_rgb(80, 100, 120); // Azul militar
image_xscale = 2.7; // ✅ ESCALA REDUZIDA 10% (64x64 -> 172x172)
image_yscale = 2.7; // ✅ ESCALA REDUZIDA 10% (64x64 -> 172x172)
image_alpha = 1.0; // ✅ VISÍVEL

// === CONFIGURAÇÕES DE INTERAÇÃO ===
raio_interacao = 90; // Raio ajustado para sprite reduzido (172x172)
pode_interagir = true;

show_debug_message("🏢 Aeroporto Militar criado - Sistema aéreo ativo");
show_debug_message("💰 Custo: $" + string(custo_dinheiro) + " dinheiro, " + string(custo_minerio) + " minério");
show_debug_message("✈️ Unidades disponíveis: " + string(ds_list_size(unidades_disponiveis)));