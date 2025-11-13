/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION (HERDA DE NAVIO_BASE)
// Herda de obj_lancha_patrulha (que funciona!)
// ===============================================

// ✅ CORREÇÃO GM2040: Chamar o Create do objeto pai PRIMEIRO com verificação
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === CONFIGURAÇÕES ESPECÍFICAS DO CONSTELLATION ===

// Atributos únicos do Constellation
hp_atual = 800;
hp_max = 800;
velocidade_movimento = 1.2;
radar_alcance = 1000; // IGUAL aos outros navios
missil_alcance = 1000; // IGUAL aos outros navios
alcance_ataque = missil_alcance;
dano_ataque = 1000; // ✅ AUMENTADO: Dano suficiente para matar 10 soldados (10 x 100 HP)
reload_time = 120;

// Nome da unidade
nome_unidade = "Constellation"; // Sobrescreve o nome do pai

// === VARIÁVEIS DE FEEDBACK ===
ultima_acao = "nenhuma";
cor_feedback = c_white;
feedback_timer = 0;

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;

show_debug_message("🚢 Constellation configurado - HP: " + string(hp_atual) + ", Dano: " + string(dano_ataque));