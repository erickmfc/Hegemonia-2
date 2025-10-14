// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema 100% Independente (SEM HERANÇA)
// ===============================================

// === CONFIGURAÇÕES BÁSICAS ===
custo_dinheiro = 600;
custo_minerio = 400;
hp_max = 200;
hp_atual = 200;
nacao_proprietaria = 1;

// === SISTEMA DE PRODUÇÃO NAVAL ===
fila_producao = ds_queue_create();
timer_producao = 0;
produzindo = false;
unidades_produzidas = 0;

// === CONFIGURAÇÕES DE UNIDADES NAVAL SIMPLIFICADAS ===
unidades_disponiveis = ds_list_create();

// ✅ CORRIGIDO: Lancha Patrulha com custo baixo e tempo rápido para teste
ds_list_add(unidades_disponiveis, {
    nome: "Lancha Patrulha",
    objeto: obj_lancha_patrulha,
    custo_dinheiro: 50,  // ✅ VALOR BAIXO PARA TESTE
    custo_populacao: 1,
    tempo_treino: 180,    // ✅ 3 SEGUNDOS (180 frames)
    descricao: "Unidade naval rápida para patrulhamento"
});

// Adicionar Fragata
ds_list_add(unidades_disponiveis, {
    nome: "Fragata",
    objeto: obj_lancha_patrulha, // ✅ TEMPORÁRIO: Usar lancha até obj_fragata ser reconhecido
    custo_dinheiro: 800,
    custo_populacao: 5,
    tempo_treino: 600, // 10 segundos
    descricao: "Navio de guerra médio com boa defesa"
});

// Adicionar Destroyer
ds_list_add(unidades_disponiveis, {
    nome: "Destroyer",
    objeto: obj_lancha_patrulha, // ✅ TEMPORÁRIO: Usar lancha até obj_destroyer ser reconhecido
    custo_dinheiro: 1500,
    custo_populacao: 8,
    tempo_treino: 900, // 15 segundos
    descricao: "Navio de guerra pesado com alta defesa"
});

// Adicionar Submarino
ds_list_add(unidades_disponiveis, {
    nome: "Submarino",
    objeto: obj_lancha_patrulha, // ✅ TEMPORÁRIO: Usar lancha até obj_submarino ser reconhecido
    custo_dinheiro: 2000,
    custo_populacao: 10,
    tempo_treino: 1200, // 20 segundos
    descricao: "Unidade submarina furtiva"
});

// Adicionar Porta-aviões
ds_list_add(unidades_disponiveis, {
    nome: "Porta-aviões",
    objeto: obj_lancha_patrulha, // ✅ TEMPORÁRIO: Usar lancha até obj_porta_avioes ser reconhecido
    custo_dinheiro: 3000,
    custo_populacao: 15,
    tempo_treino: 1800, // 30 segundos
    descricao: "Navio de guerra gigante com capacidade aérea"
});

// === SISTEMA DE SELEÇÃO ===
selecionado = false;
menu_recrutamento = noone;

// === CONFIGURAÇÕES VISUAIS ===
image_blend = make_color_rgb(100, 150, 255); // Azul marinho

show_debug_message("Quartel de Marinha construído e pronto para produção naval!");