// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema 100% Independente (SEM HERANÇA)
// ===============================================

// === CONFIGURAÇÕES BÁSICAS ===
custo_dinheiro = 600;
custo_minerio = 400;
hp_max = 800; // ✅ AUMENTADO: Mais resistente (era 200)
hp_atual = 800; // ✅ AUMENTADO: Mais resistente (era 200)
nacao_proprietaria = 1;

// === SISTEMA DE PRODUÇÃO NAVAL ===
fila_producao = ds_queue_create();
fila_recrutamento = ds_queue_create(); // ✅ CORREÇÃO: Fila de recrutamento para IA
timer_producao = 0;
produzindo = false;
esta_treinando = false; // ✅ CORREÇÃO: Variável de controle de treinamento
tempo_treinamento_restante = 0; // ✅ CORREÇÃO: Timer de treinamento
unidades_produzidas = 0;

// === CONFIGURAÇÕES DE UNIDADES NAVAL SIMPLIFICADAS ===
unidades_disponiveis = ds_list_create();

// ✅ Lancha Patrulha - 4 segundos máximo
ds_list_add(unidades_disponiveis, {
    nome: "Lancha Patrulha",
    objeto: obj_lancha_patrulha,
    sprite: spr_lancha_patrulha,
    custo_dinheiro: 50,
    custo_populacao: 1,
    tempo_treino: 240,    // ✅ MUDADO: 4 SEGUNDOS (240 frames) - MÁXIMO
    descricao: "Unidade naval rápida para patrulhamento"
});

// ✅ Constellation - 4 segundos máximo (se existir)
if (object_exists(obj_Constellation)) {
    ds_list_add(unidades_disponiveis, {
        nome: "Constellation",
        objeto: obj_Constellation,
        sprite: spr_Constellation,
        custo_dinheiro: 2500,
        custo_populacao: 12,
        tempo_treino: 240,    // ✅ MUDADO: 4 SEGUNDOS (240 frames) - MÁXIMO
        descricao: "Navio de guerra avançado com sistema de mísseis"
    });
    show_debug_message("✅ Constellation adicionado à lista de unidades!");
} else {
    show_debug_message("❌ ERRO: obj_Constellation não existe!");
}

// ✅ Independence - 4 segundos máximo (se existir)
if (object_exists(obj_Independence)) {
    ds_list_add(unidades_disponiveis, {
        nome: "Independence",
        objeto: obj_Independence,
        sprite: spr_Independence,
        custo_dinheiro: 5000,
        custo_populacao: 20,
        tempo_treino: 240,    // ✅ MUDADO: 4 SEGUNDOS (240 frames) - MÁXIMO
        descricao: "Fragata pesada com canhão e sistema de metralhadora"
    });
    show_debug_message("✅ Independence adicionado à lista de unidades!");
} else {
    show_debug_message("❌ ERRO: obj_Independence não existe!");
}

// ✅ Ww-Hendrick - 4 segundos máximo (se existir)
if (object_exists(obj_wwhendrick)) {
    ds_list_add(unidades_disponiveis, {
        nome: "Ww-Hendrick",
        objeto: obj_wwhendrick,
        sprite: spr_wwhendrick,
        custo_dinheiro: 2500,
        custo_populacao: 12,
        tempo_treino: 240,    // ✅ MUDADO: 4 SEGUNDOS (240 frames) - MÁXIMO
        descricao: "Submarino furtivo com sistema de submersão. Controles: O/P/K/L | Clique para submergir/emergir"
    });
    show_debug_message("✅ Ww-Hendrick adicionado à lista de unidades!");
} else {
    show_debug_message("❌ ERRO: obj_wwhendrick não existe!");
}

// ✅ Porta-Aviões Ronald Reagan - 4 segundos máximo (se existir)
if (object_exists(obj_RonaldReagan)) {
    ds_list_add(unidades_disponiveis, {
        nome: "Ronald Reagan",
        objeto: obj_RonaldReagan,
        sprite: spr_RonaldReagan,
        custo_dinheiro: 12000,
        custo_populacao: 60,
        tempo_treino: 240,    // ✅ MUDADO: 4 SEGUNDOS (240 frames) - MÁXIMO
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

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.AGUA; // Quartel naval só em água

show_debug_message("Quartel de Marinha construído e pronto para produção naval!");