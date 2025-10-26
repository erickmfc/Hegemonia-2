// ===============================================
// HEGEMONIA GLOBAL - MÍSSIL ICE (ANTI-SUBMARINO)
// Projétil especializado para combater submarinos
// ===============================================

show_debug_message("❄️ === MÍSSIL ICE CRIADO (ANTI-SUBMARINO) ===");
show_debug_message("📍 Posição inicial: (" + string(x) + ", " + string(y) + ")");

// === CONFIGURAÇÕES ESPECÍFICAS PARA ANTI-SUBMARINO ===
// Dano alto para ser efetivo contra submarinos (180 HP)
dano = 75; // Dano significativo para quebrar a blindagem submarina
// Velocidade moderada-alta para atingir alvos em movimento
velocidade_base = 14; // Mais rápido que mísseis terrestres
// Alcance maior para buscar submarinos
alcance_maximo = 600; // Maior alcance para perseguir submarinos
// Tempo de vida maior para alcançar alvos distantes
tempo_vida_maximo = 250; // Aumentado para permitir perseguição
tempo_vida = 0;

// Configurações visuais específicas para míssil anti-submarino
image_blend = make_color_rgb(100, 150, 255); // Azul frio - tema "ice"
image_xscale = 2.5; // Maior que o padrão para destacar
image_yscale = 2.5;
image_alpha = 1.0; // Opacidade total

show_debug_message("🎨 Configurações visuais aplicadas:");
show_debug_message("   - Cor: Azul Frio (Ice)");
show_debug_message("   - Escala: " + string(image_xscale) + "x" + string(image_yscale));
show_debug_message("   - Opacidade: " + string(image_alpha));

// Sistema de rastro
rastro_ativo = true;
tempo_rastro = 0;

// Posição inicial para cálculo de alcance
xstart = x;
ystart = y;

// === CONFIGURAÇÃO DE DIREÇÃO PARA O ALVO ===
// Inicializar variável alvo se não existir
if (!variable_instance_exists(id, "alvo")) {
    alvo = noone;
}

if (alvo != noone && instance_exists(alvo)) {
    direction = point_direction(x, y, alvo.x, alvo.y);
    show_debug_message("🎯 Direção calculada para submarino alvo: " + string(direction) + "°");
} else {
    // Se não há alvo, usar direção padrão
    direction = 0;
    show_debug_message("⚠️ Sem alvo definido, direção padrão: 0°");
}

// === MODIFICADOR DE DANO CONTRA SUBMARINOS ===
// Bônus de dano específico para submarinos
dano_bonus_submarino = 1.5; // 50% de dano extra contra submarinos

show_debug_message("✅ Míssil Ice (Anti-submarino) inicializado completamente!");
