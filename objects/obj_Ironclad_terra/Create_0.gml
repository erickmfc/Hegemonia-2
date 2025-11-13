// Míssil Terra-Terra guiado e pesado
speed = 7; // um pouco mais rápido ajuda a convergir
gravity = 0.04; // menos arco para aumentar precisão
dano = 1000; // ✅ AUMENTADO: Dano suficiente para matar 10 soldados (10 x 100 HP)
dano_area = 1000; // ✅ NOVO: Dano em área para matar todos os soldados próximos
raio_dano_area = 150; // ✅ NOVO: Raio de dano em área (pixels)
dono = noone; // Quem disparou
// audio_play_sound(snd_foguete_voando, 0, true); // Temporariamente desabilitado para debug
target = noone;
alarm[0] = game_get_speed(gamespeed_fps) * 2; // Autodestruição após 2 segundos se não acertar

// Configurações visuais
image_xscale = 0.448; // ✅ REDUZIDO 20% ADICIONAL: 0.56 * 0.8 = 0.448
image_yscale = 0.448; // ✅ REDUZIDO 20% ADICIONAL: 0.56 * 0.8 = 0.448
image_angle = 0;
image_speed = 0.5;

// Parâmetros de guiamento/impacto (100% de precisão garantida)
turn_rate = 1.0; // ✅ AUMENTADO: Taxa máxima para sempre seguir o alvo (100% de precisão)
impact_radius = 100; // ✅ AUMENTADO: Raio muito grande para garantir 100% de acerto

// Rastreamento do alvo para detectar se está parado (garantir 100% quando imóvel)
last_tx = -1;
last_ty = -1;
still_frames = 0;

// === SISTEMA DE POOLING ===
pooled = false; // false = disponível no pool, true = em uso