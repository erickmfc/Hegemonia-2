// Míssil Ar-Ar de alta velocidade
speed = 7; // mais rápido para 85-95%
dano = 70; // Dano do míssil aéreo
dono = noone; // Quem disparou
target = noone;
// audio_play_sound(snd_foguete_voando, 0, true); // Temporariamente desabilitado para debug
alarm[0] = room_speed * 2; // Autodestruição após 2 segundos se não acertar

// Configurações visuais
image_xscale = 1.0; // Escala horizontal
image_yscale = 1.0; // Escala vertical
image_angle = 0; // Ângulo inicial
image_speed = 0.5; // Velocidade da animação

// Parâmetros de guiamento/impacto (ajustáveis)
turn_rate = 0.14; // correção agressiva
impact_radius = 16; // raio de acerto aéreo
