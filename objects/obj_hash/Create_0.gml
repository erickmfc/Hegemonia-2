// ===============================================
// HEGEMONIA GLOBAL - MÍSSIL HASH (SUPER PESADO)
// Míssil de alto dano: Terra-Terra, Ar-Terra e Anti-Submarino
// Dano: 140 (dobro do Ironclad que tem 70)
// ===============================================

speed = 8; // Velocidade melhorada para interceptação
gravity = 0.03; // Gravitade ajustada para melhor precisão
dano = 168; // Dano aumentado em 20% (140 * 1.2 = 168) - SUPER PESADO COM DANO EM ÁREA
dano_area = 40; // Dano de área aérea - afeta unidades próximas
dono = noone; // Quem disparou
target = noone; // Alvo do míssil
alvo = noone; // Variável alternativa para compatibilidade com F-15

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
image_xscale = 0.1; // Escala horizontal
image_yscale = 0.1; // Escala vertical
image_angle = 0; // Ângulo inicial
image_speed = 0.5; // Velocidade da animação

// Parâmetros de guiamento/impacto (ajustáveis)
turn_rate = 0.20; // Taxa de curva melhorada para 99% de acerto
impact_radius = 30; // Raio de acerto aumentado para garantir 99%

// Rastreamento do alvo para detectar se está parado (garantir 100% quando imóvel)
last_tx = -1;
last_ty = -1;
still_frames = 0;
