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

// ✅ Lancha Patrulha - 3 segundos
ds_list_add(unidades_disponiveis, {
    nome: "Lancha Patrulha",
    objeto: obj_lancha_patrulha,
    custo_dinheiro: 50,
    custo_populacao: 1,
    tempo_treino: 180,    // ✅ 3 SEGUNDOS (180 frames)
    descricao: "Unidade naval rápida para patrulhamento"
});

// ✅ Constellation - 3 segundos (se existir)
if (object_exists(obj_Constellation)) {
    ds_list_add(unidades_disponiveis, {
        nome: "Constellation",
        objeto: obj_Constellation,
        custo_dinheiro: 2500,
        custo_populacao: 12,
        tempo_treino: 180,    // ✅ 3 SEGUNDOS (180 frames)
        descricao: "Navio de guerra avançado com sistema de mísseis"
    });
}

// === SISTEMA DE SELEÇÃO ===
selecionado = false;
menu_recrutamento = noone;

// === CONFIGURAÇÕES VISUAIS ===
image_blend = make_color_rgb(100, 150, 255); // Azul marinho

show_debug_message("Quartel de Marinha construído e pronto para produção naval!");