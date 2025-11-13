// ===============================================
// HEGEMONIA GLOBAL - OBJ_TYPER39
// Míssil Anti-Aéreo (Baseado no SkyFury)
// ===============================================

// === PROPRIEDADES DO MÍSSIL (inspirado no SkyFury) ===
speed = 9; // Velocidade alta para interceptação
dano = 35; // Dano alto contra alvos aéreos
dono = noone; // Quem disparou
target = noone; // Alvo do míssil (usar target como SkyFury)
alvo = noone; // Compatibilidade (mesmo que target)

// Timer de autodestruição
alarm[0] = game_get_speed(gamespeed_fps) * 5; // 5 segundos

// Configurações visuais
image_xscale = 1.2;
image_yscale = 1.2;
image_angle = 0;
image_speed = 0.5;

// Parâmetros de guiamento (inspirado no SkyFury)
turn_rate = 0.25; // Taxa de curva agressiva
impact_radius = 50; // Raio de impacto
velocidade_min = speed * 0.8;
velocidade_max = speed * 1.2;

// Timer de vida
timer_vida_maximo = 300; // 5 segundos a 60 FPS
timer_vida_atual = timer_vida_maximo;

// === SISTEMA DE POOLING ===
pooled = false;

// === CONTADOR PARA FUMACA ===
contador_fumaca = 0;

// === CONFIGURAÇÕES DE VISIBILIDADE ===
visible = true;
image_alpha = 1.0;
image_blend = c_white;

// === SOM DE DISPARO ===
var _snd_rocket_fire = asset_get_index("BF2_Rocket_fire");
if (_snd_rocket_fire != -1) {
    audio_play_sound(_snd_rocket_fire, 5, false);
}

show_debug_message("🚀 obj_typer39 criado - Target: " + string(target));
