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
    sprite: spr_lancha_patrulha,
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
        sprite: spr_Constellation,
        custo_dinheiro: 2500,
        custo_populacao: 12,
        tempo_treino: 180,    // ✅ 3 SEGUNDOS (180 frames)
        descricao: "Navio de guerra avançado com sistema de mísseis"
    });
    show_debug_message("✅ Constellation adicionado à lista de unidades!");
} else {
    show_debug_message("❌ ERRO: obj_Constellation não existe!");
}

// ✅ Independence - 3 segundos (se existir)
if (object_exists(obj_Independence)) {
    ds_list_add(unidades_disponiveis, {
        nome: "Independence",
        objeto: obj_Independence,
        sprite: spr_Independence,
        custo_dinheiro: 5000, // Custo maior que Constellation
        custo_populacao: 20, // População maior
        tempo_treino: 180,    // ✅ 3 SEGUNDOS (180 frames)
        descricao: "Fragata pesada com canhão e sistema de metralhadora"
    });
    show_debug_message("✅ Independence adicionado à lista de unidades!");
} else {
    show_debug_message("❌ ERRO: obj_Independence não existe!");
}

// ✅ Ww-Hendrick (Submarino Jogável) - 10 segundos (se existir)
if (object_exists(obj_wwhendrick)) {
    ds_list_add(unidades_disponiveis, {
        nome: "Ww-Hendrick",
        objeto: obj_wwhendrick,
        sprite: spr_wwhendrick,
        custo_dinheiro: 2500, // Custo médio
        custo_populacao: 12, // População média
        tempo_treino: 180,    // ✅ 3 SEGUNDOS (180 frames)
        descricao: "Submarino furtivo com sistema de submersão. Controles: O/P/K/L | Clique para submergir/emergir"
    });
    show_debug_message("✅ Ww-Hendrick adicionado à lista de unidades!");
} else {
    show_debug_message("❌ ERRO: obj_wwhendrick não existe!");
}

// ✅ Porta-Aviões Ronald Reagan - 6 segundos (se existir)
if (object_exists(obj_RonaldReagan)) {
    ds_list_add(unidades_disponiveis, {
        nome: "Ronald Reagan",
        objeto: obj_RonaldReagan,
        sprite: spr_RonaldReagan,
        custo_dinheiro: 12000, // Muito caro - navio de transporte superior
        custo_populacao: 60, // População muito maior
        tempo_treino: 180,    // ✅ 3 SEGUNDOS (180 frames)
        descricao: "Porta-Aviões nuclear. Transporta 35 aviões, 20 veículos e 100 soldados (155 unidades). HP: 4000."
    });
    show_debug_message("✅ Porta-Aviões Ronald Reagan adicionado à lista de unidades!");
} else {
    show_debug_message("❌ ERRO: obj_RonaldReagan não existe!");
}

// Verificar se obj_canhao existe
if (object_exists(obj_canhao)) {
    show_debug_message("✅ obj_canhao existe!");
} else {
    show_debug_message("❌ ERRO: obj_canhao não existe!");
}

// NOTA: obj_tiro_canhao será criado quando necessário pela Independence

// === SISTEMA DE SELEÇÃO ===
selecionado = false;
menu_recrutamento = noone;

// === CONFIGURAÇÕES VISUAIS ===
image_blend = make_color_rgb(100, 150, 255); // Azul marinho

show_debug_message("Quartel de Marinha construído e pronto para produção naval!");