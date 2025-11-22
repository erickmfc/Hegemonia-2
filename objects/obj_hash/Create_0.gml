// ===============================================
// HEGEMONIA GLOBAL - MÍSSIL HASH (SUPER PESADO)
// Míssil de alto dano: Terra-Terra, Ar-Terra e Anti-Submarino
// Dano: 140 (dobro do Ironclad que tem 70)
// ===============================================

speed = 8; // Velocidade melhorada para interceptação
gravity = 0.03; // Gravitade ajustada para melhor precisão
dano = 1000; // ✅ AUMENTADO: Dano suficiente para matar 10 soldados
dano_area = 1000; // ✅ AUMENTADO: Dano em área para matar todos os soldados próximos
dono = noone; // Quem disparou
target = noone; // Alvo do míssil
alvo = noone; // Variável alternativa para compatibilidade com F-15

// ✅ APLICAR MULTIPLICADOR DE DANO DO DONO (sistema de gerações)
if (instance_exists(dono) && variable_instance_exists(dono, "dano_multiplier")) {
    dano = floor(dano * dono.dano_multiplier);
    dano_area = floor(dano_area * dono.dano_multiplier);
}

// Receber alvo se foi passado pelo dono
if (variable_instance_exists(id, "alvo_em_mira")) {
    alvo = alvo_em_mira;
    target = alvo_em_mira;
}

// === SOM DE MÍSSIL ===
// ✅ CORREÇÃO GM1041: Verificar se o som existe antes de tocar
if (variable_global_exists("som_tanque")) {
    var _sound_index = asset_get_index("som_tanque");
    if (_sound_index != -1) {
        audio_play_sound(som_tanque, 0, true);
    }
}

alarm[0] = game_get_speed(gamespeed_fps) * 3; // Autodestruição após 3 segundos se não acertar

// Configurações visuais
image_xscale = 0.08; // ✅ REDUZIDO 20%: 0.1 * 0.8 = 0.08
image_yscale = 0.08; // ✅ REDUZIDO 20%: 0.1 * 0.8 = 0.08
image_angle = 0;
image_speed = 0.5;

// Parâmetros de guiamento/impacto (100% de precisão garantida)
turn_rate = 1.0; // ✅ AUMENTADO: Taxa máxima para sempre seguir o alvo (100% de precisão)
impact_radius = 100; // ✅ AUMENTADO: Raio muito grande para garantir 100% de acerto

// Rastreamento do alvo para detectar se está parado (garantir 100% quando imóvel)
last_tx = -1;
last_ty = -1;
still_frames = 0;
