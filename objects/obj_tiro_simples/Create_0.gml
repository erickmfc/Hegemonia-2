// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO SIMPLES
// Create Event - Sistema de Projétil VISÍVEL
// ================================================

// === PROPRIEDADES DO TIRO ===
speed = 5;                         // Velocidade padrão (será ajustada pelo atirador)
dano = 100; // ✅ AUMENTADO: Dano suficiente para matar soldados (era 70)
alvo = noone;                      // Unidade alvo
dono = noone;                      // Unidade que atirou
timer_vida = 300;                  // Tempo de vida MAIOR (5 segundos)

// ✅ CORREÇÃO: Ajustar timer de vida baseado na distância do alvo (se disponível)
if (variable_instance_exists(id, "alvo") && instance_exists(alvo)) {
    var _distancia_alvo = point_distance(x, y, alvo.x, alvo.y);
    timer_vida = max(300, (_distancia_alvo / speed) * 1.5); // 50% de margem
}

// ✅ NOVO: Dano em área para mísseis terrestres
dano_area = 1000;                  // Dano em área para matar unidades próximas
raio_dano_area = 300;              // ✅ Raio de dano em área de 300 pixels (para Constellation e outros navios)

// === CONFIGURAÇÕES VISUAIS OTIMIZADAS ===
image_xscale = 0.5;                // ESCALA OTIMIZADA (era 5.0 - muito grande)
image_yscale = 0.5;                // ESCALA OTIMIZADA (era 5.0 - muito grande)
image_blend = c_blue;              // COR AZUL BRILHANTE
image_alpha = 1.0;                 // OPACIDADE TOTAL
image_speed = 0.5;                 // Velocidade da animação
image_angle = 0;                   // Ângulo inicial

// === CONFIGURAÇÕES DE VISIBILIDADE ===
visible = true;                    // GARANTIR QUE ESTÁ VISÍVEL
depth = -1000;                     // PROFUNDIDADE PARA FICAR NA FRENTE

// === SISTEMA DE POOLING ===
pooled = false; // false = disponível no pool, true = em uso

show_debug_message("🚀 Tiro simples criado - CONFIGURAÇÃO CORRIGIDA!");
show_debug_message("📏 Sprite: air (44x11 pixels)");
show_debug_message("📏 Escala: " + string(image_xscale) + "x" + string(image_yscale));
show_debug_message("⏱️ Tempo de vida: " + string(timer_vida) + " frames (" + string(timer_vida/60) + " segundos)");
show_debug_message("🎯 Alvo: " + string(alvo) + " | Velocidade: " + string(speed) + " | Dano: " + string(dano));