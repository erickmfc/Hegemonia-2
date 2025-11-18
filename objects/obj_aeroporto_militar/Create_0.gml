// ===============================================
// HEGEMONIA GLOBAL - AEROPORTO MILITAR
// Sistema de Produção Aérea
// ===============================================

// === CONFIGURAÇÕES BÁSICAS ===
custo_dinheiro = 1000;
custo_minerio = 500;
hp_max = 2000; // ✅ AUMENTADO: Mais resistente (era 800)
hp_atual = 2000; // ✅ AUMENTADO: Mais resistente (era 800)
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
    tempo_treino: 180, // ✅ MUDADO: 3 segundos (180 frames) - MÁXIMO
    descricao: "Caça-bombardeiro de alta velocidade"
});

// Helicóptero Militar
ds_list_add(unidades_disponiveis, {
    nome: "Helicóptero Militar",
    objeto: obj_helicoptero_militar,
    custo_dinheiro: 600,
    custo_populacao: 2,
    tempo_treino: 180, // ✅ MUDADO: 3 segundos (180 frames) - MÁXIMO
    descricao: "Helicóptero de ataque e transporte"
});

// C-100 Transporte
ds_list_add(unidades_disponiveis, {
    nome: "C-100 Transporte",
    objeto: obj_c100,
    custo_dinheiro: 1200,
    custo_populacao: 4,
    tempo_treino: 180, // ✅ MUDADO: 3 segundos (180 frames) - MÁXIMO
    descricao: "Avião de transporte com embarque de tropas e flares defensivos"
});

// Caça F-15 Eagle
ds_list_add(unidades_disponiveis, {
    nome: "F-15 Eagle",
    objeto: obj_f15,
    custo_dinheiro: 1500,
    custo_populacao: 5,
    tempo_treino: 180, // ✅ MUDADO: 3 segundos (180 frames) - MÁXIMO
    descricao: "Caça superior com HP 800 e sistema de mísseis avançado"
});

// Caça SU-35 Flanker
ds_list_add(unidades_disponiveis, {
    nome: "SU-35 Flanker",
    objeto: obj_su35,
    custo_dinheiro: 5900,
    custo_populacao: 5,
    tempo_treino: 180, // ✅ MUDADO: 3 segundos (180 frames) - MÁXIMO
    descricao: "Caça superior com HP 800 e sistema de mísseis avançado"
});

// === SISTEMA DE SELEÇÃO ===
selecionado = false;
menu_recrutamento = noone;

// === CONFIGURAÇÕES DE TAMANHO DE IMAGEM ===
// Dimensões originais do sprite do aeroporto
sprite_largura_original = 1290; // Largura original do sprite (bbox_right - bbox_left)
sprite_altura_original = 672;   // Altura original do sprite (height)
sprite_escala = 0.3;            // Escala aplicada ao sprite

// Tamanho final da imagem renderizada
imagem_largura = sprite_largura_original * sprite_escala;  // ~3483 pixels
imagem_altura = sprite_altura_original * sprite_escala;    // ~1814 pixels

// === CONFIGURAÇÕES VISUAIS CORRIGIDAS ===
// ✅ CORREÇÃO: Remover image_blend para deixar o sprite original sem sombra
image_blend = c_white; // ✅ CORREÇÃO: Cor neutra (branco) para manter sprite original sem modificações
image_xscale = sprite_escala; // ✅ ESCALA APLICADA (1290x672 -> ~3483x1814)
image_yscale = sprite_escala; // ✅ ESCALA APLICADA (1290x672 -> ~3483x1814)
image_alpha = 1.0; // ✅ VISÍVEL

// === CONFIGURAÇÕES DE INTERAÇÃO ===
raio_interacao = 90; // Raio de interação ajustado para o tamanho da imagem
pode_interagir = true;

// === TERRENO PERMITIDO ===
terreno_permitido = TERRAIN.CAMPO; // Aeroportos só em terreno de campo

show_debug_message("🏢 Aeroporto Militar criado - Sistema aéreo ativo");
show_debug_message("💰 Custo: $" + string(custo_dinheiro) + " dinheiro, " + string(custo_minerio) + " minério");
show_debug_message("✈️ Unidades disponíveis: " + string(ds_list_size(unidades_disponiveis)));
show_debug_message("📐 Tamanho da imagem: " + string(imagem_largura) + "x" + string(imagem_altura) + " pixels (escala: " + string(sprite_escala) + "x)");