// Míssil Terra-Terra guiado e pesado
speed = 7; // um pouco mais rápido ajuda a convergir
gravity = 0.04; // menos arco para aumentar precisão
dano = 70; // Dano do míssil terrestre
dono = noone; // Quem disparou
// audio_play_sound(snd_foguete_voando, 0, true); // Temporariamente desabilitado para debug
target = noone;
alarm[0] = game_get_speed(gamespeed_fps) * 2; // Autodestruição após 2 segundos se não acertar

// Configurações visuais
image_xscale = 0.7; // Escala horizontal
image_yscale = 0.7; // Escala vertical
image_angle = 0; // Ângulo inicial
image_speed = 0.5; // Velocidade da animação

// Parâmetros de guiamento/impacto (ajustáveis)
turn_rate = 0.20; // Taxa de curva melhorada para 100% parado / 99% em movimento
impact_radius = 28; // Raio de acerto aumentado

// Rastreamento do alvo para detectar se está parado (garantir 100% quando imóvel)
last_tx = -1;
last_ty = -1;
still_frames = 0;
