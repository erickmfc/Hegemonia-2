// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION FUNCIONAL
// Sistema Completo e Simples para Demonstração
// ===============================================

show_debug_message("🚢 CONSTELLATION CRIADO - Sistema Funcional Ativo!");

// === ATRIBUTOS BÁSICOS ===
hp_atual = 800;
hp_max = 800;
velocidade_movimento = 2.5; // Velocidade visível
nacao_proprietaria = 1; // 1 = jogador

// === ESTADOS SIMPLES ===
estado = "parado"; // "parado", "movendo", "atacando"
destino_x = x;
destino_y = y;
alvo_unidade = noone;

// === SISTEMA DE COMBATE ===
alcance_radar = 1000;
missil_alcance = 800;
dano_missil = 100;
reload_time = 120; // 2 segundos
reload_timer = 0;

// === SISTEMA DE PATRULHA ===
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;
modo_definicao_patrulha = false;

// === SISTEMA DE MÍSSEIS ===
missil_tipo_atual = "auto"; // "ar", "terra", "auto"

// === SISTEMA DE SELEÇÃO ===
selecionado = false;

// === VARIÁVEIS DE FEEDBACK VISUAL ===
feedback_timer = 0;
ultima_acao = "Criado";
cor_feedback = c_white;

// === SISTEMA DE DEBUG VISUAL ===
debug_info = {
    estado: "parado",
    velocidade: velocidade_movimento,
    hp: hp_atual,
    acoes: 0
};

// === CONFIGURAR MÁSCARA DE COLISÃO ===
mask_index = sprite_index; // Usar o sprite como máscara de colisão

// === CONFIGURAR BOUNDING BOX ===
// Garantir que a bounding box está correta
if (sprite_index != -1) {
    show_debug_message("🚢 Constellation sprite: " + string(sprite_index));
    show_debug_message("🚢 Constellation mask: " + string(mask_index));
    show_debug_message("🚢 Constellation bbox: (" + string(bbox_left) + ", " + string(bbox_top) + ") a (" + string(bbox_right) + ", " + string(bbox_bottom) + ")");
}

// === CONFIGURAR SISTEMA DE COLISÃO ===
// Garantir que o objeto é sólido para detecção
solid = false; // Não é sólido, mas pode ser detectado
visible = true; // Deve ser visível

// === CONFIGURAR DEPTH ===
// Garantir que o objeto está na layer correta
depth = -100; // Depth padrão para unidades

// === CONFIGURAR SISTEMA DE COLISÃO ===
// Garantir que o objeto pode ser detectado
collision_mask = sprite_index; // Usar o sprite como máscara de colisão

// === CONFIGURAR SISTEMA DE COLISÃO ===
// Garantir que o objeto pode ser detectado pelo sistema de colisão
if (sprite_index != -1) {
    show_debug_message("🚢 Constellation collision_mask configurado: " + string(collision_mask));
}

show_debug_message("✅ Constellation pronto para ação!");
show_debug_message("   HP: " + string(hp_atual) + "/" + string(hp_max));
show_debug_message("   Velocidade: " + string(velocidade_movimento));
show_debug_message("   Estado: " + estado);
show_debug_message("   Máscara: " + string(mask_index));
show_debug_message("   Posição: (" + string(x) + ", " + string(y) + ")");
show_debug_message("   ID: " + string(id));
show_debug_message("   Depth: " + string(depth));
show_debug_message("   Visible: " + string(visible));
show_debug_message("   Solid: " + string(solid));
show_debug_message("   Collision Mask: " + string(collision_mask));