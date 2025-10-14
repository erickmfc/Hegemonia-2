// ===============================================
// HEGEMONIA GLOBAL - MÍSSIL TERRA-TERRA
// Projétil para ataque naval contra alvos terrestres
// ===============================================

show_debug_message("🚀 === MÍSSIL TERRA-TERRA CRIADO ===");
show_debug_message("📍 Posição inicial: (" + string(x) + ", " + string(y) + ")");

dano = 30; // Aumentado de 25 para 30
velocidade_base = 10; // Aumentado de 8 para 10
alcance_maximo = 250; // Aumentado de 300 para 250 (mais focado)
tempo_vida_maximo = 150; // Reduzido para melhor performance
tempo_vida = 0;

// Configurações visuais MÁXIMAS para garantir visibilidade
image_blend = c_red; // Vermelho brilhante para debug
image_xscale = 3.0; // Triplo do tamanho para debug
image_yscale = 3.0;
image_alpha = 1.0; // Opacidade total

show_debug_message("🎨 Configurações visuais aplicadas:");
show_debug_message("   - Cor: Vermelho");
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
    show_debug_message("🎯 Direção calculada para alvo: " + string(direction) + "°");
} else {
    // Se não há alvo, usar direção padrão
    direction = 0;
    show_debug_message("⚠️ Sem alvo definido, direção padrão: 0°");
}

show_debug_message("✅ Míssil terra-terra inicializado completamente!");
