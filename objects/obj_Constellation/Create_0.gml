/// @description Constellation - Destroyer de mísseis (Simplificado)
// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION
// ===============================================

if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === OVERRIDE - ESTATÍSTICAS ESPECÍFICAS ===
nome_unidade = "Constellation";
hp_atual = 1500;
hp_max = 1500;

// Velocidade (baseada na Lancha)
velocidade = 1.5;
velocidade_rotacao = 2.0;

// Alcances
radar_alcance = 800;
missil_alcance = 800;
alcance_ataque = 800;

// Ataque
reload_time = 120;
dano_ataque = 80;

// === LOD E OTIMIZAÇÃO ===
lod_level = 2;
lod_process_index = irandom(99);
skip_frames_enabled = true;

show_debug_message("🚢 Constellation criado - HP: " + string(hp_atual) + " | Vel: " + string(velocidade));
