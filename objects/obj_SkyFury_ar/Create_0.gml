// Míssil Ar-Ar de alta velocidade e precisão
speed = 9; // Velocidade aumentada para interceptação
dano = 150; // Dano do míssil ar-ar aumentado
dono = noone; // Quem disparou
target = noone; // Alvo do míssil (usar sempre target, não alvo)

// Som removido a pedido do usuário

// Timer de autodestruição aumentado
alarm[0] = game_get_speed(gamespeed_fps) * 3; // 3 segundos para alcançar alvos distantes

// Configurações visuais
image_xscale = 0.384; // ✅ REDUZIDO 20% ADICIONAL: 0.48 * 0.8 = 0.384
image_yscale = 0.384; // ✅ REDUZIDO 20% ADICIONAL: 0.48 * 0.8 = 0.384
image_angle = 0;
image_speed = 0.5;

// Parâmetros de guiamento/impacto (melhorados para maior precisão)
turn_rate = 0.25; // ✅ MELHORADO: Taxa de curva mais agressiva (era 0.18)
impact_radius = 50; // ✅ MELHORADO: Raio de impacto aumentado (era 35, agora max(50, speed*1.2))
velocidade_min = speed * 0.8; // Velocidade mínima durante curvas
velocidade_max = speed * 1.2; // Velocidade máxima em linha reta

// GM2016: Timers de vida declarados no Create event
timer_vida_maximo = 72; // 1.2 segundos de vida
timer_vida_atual = timer_vida_maximo;

// === SISTEMA DE POOLING ===
pooled = false; // false = disponível no pool, true = em uso

// === CONTADOR PARA FUMACA (reduzir rastro) ===
contador_fumaca = 0;

// ✅ CORREÇÃO: Flag para evitar múltiplas criações de explosão
explosao_criada = false;