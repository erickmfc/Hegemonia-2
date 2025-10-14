// ===============================================
// HEGEMONIA GLOBAL - MÍSSIL AÉREO
// Projétil Especializado para Combate Aéreo
// ===============================================

// === ATRIBUTOS DO MÍSSIL ===
dano = 35; // Dano alto contra alvos aéreos
velocidade_base = 6; // Velocidade inicial
velocidade_atual = velocidade_base;
alcance_maximo = 600; // Alcance máximo do míssil
tempo_vida = 0;
tempo_vida_maximo = 300; // 5 segundos máximo de voo

// === ALVO E LANÇADOR ===
alvo = noone; // Alvo aéreo a ser interceptado
lancador = noone; // Soldado que lançou o míssil
distancia_percorrida = 0;

// === SISTEMA DE INTERCEPTAÇÃO ===
predicao_posicao = true; // Se deve prever onde o alvo estará
velocidade_predicao = 0.8; // Fator de predição (0.8 = 80% de precisão)
correcao_trajetoria = true; // Se deve corrigir trajetória durante o voo
frequencia_correcao = 5; // A cada quantos frames corrige a trajetoria
contador_correcao = 0;

// === EFEITOS VISUAIS ===
rastro_ativo = true;
particulas_explosao = true;

// === ESTADO INICIAL ===
estado = "voando"; // "voando", "explodindo", "destruido"
// image_angle será definido pelo lançador
image_xscale = 1.2; // Míssil um pouco maior que bala normal
image_yscale = 1.2;

show_debug_message("Míssil aéreo criado - Alvo: " + string(alvo) + ", Lançador: " + string(lancador));
