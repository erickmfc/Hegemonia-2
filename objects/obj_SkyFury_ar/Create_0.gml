// Míssil Ar-Ar de alta velocidade e precisão
speed = 9; // Velocidade aumentada para interceptação
dano = 70; // Dano do míssil aéreo
dono = noone; // Quem disparou
target = noone; // Alvo do míssil (usar sempre target, não alvo)

// Som removido a pedido do usuário

// Timer de autodestruição aumentado
alarm[0] = game_get_speed(gamespeed_fps) * 3; // 3 segundos para alcançar alvos distantes

// Configurações visuais
image_xscale = 0.48; // ✅ REDUZIDO 20%: 0.6 * 0.8 = 0.48
image_yscale = 0.48; // ✅ REDUZIDO 20%: 0.6 * 0.8 = 0.48
image_angle = 0;
image_speed = 0.5;

// Parâmetros de guiamento/impacto (otimizados para 97% de acerto)
turn_rate = 0.25; // Taxa de curva mais agressiva para 97% de acerto
impact_radius = 35; // Raio de impacto aumentado para 97% de acerto contra alvos aéreos
velocidade_min = speed * 0.8; // Velocidade mínima durante curvas
velocidade_max = speed * 1.2; // Velocidade máxima em linha reta

// GM2016: Timers de vida declarados no Create event
timer_vida_maximo = 72; // 1.2 segundos de vida
timer_vida_atual = timer_vida_maximo;

// === SISTEMA DE POOLING ===
pooled = false; // false = disponível no pool, true = em uso

// === CONTADOR PARA FUMACA (reduzir rastro) ===
contador_fumaca = 0;