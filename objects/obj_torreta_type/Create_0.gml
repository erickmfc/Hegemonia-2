// ===============================================
// HEGEMONIA GLOBAL - TORRETA TYPE
// Create Event - Sistema de Metralhadora Anti-Terrestre
// ===============================================

// === PROPRIEDADES BÁSICAS ===
nacao_proprietaria = 1; // Nação padrão (será sobrescrito se necessário)
vida = 200; // HP da torreta
vida_atual = vida;
estado = "ocioso"; // "ocioso", "atacando"

// === SISTEMA DE METRALHADORA ===
metralhadora_cooldown = 0; // Cooldown entre tiros (frames)
metralhadora_intervalo = 2; // ✅ CORRIGIDO: 2 frames entre tiros = ~30 tiros/segundo (CONTÍNUO)
metralhadora_alcance = 300; // Alcance menor para metralhadora (apenas terrestres)
raio_de_visao = 350; // Raio de detecção

// === ALVO ===
alvo_inimigo = noone; // Alvo atual

// === PROPRIEDADES DE COMBATE ===
dano_por_tiro = 5; // Dano de cada tiro de metralhadora
atq_cooldown = 0; // Cooldown geral de ataque

// === CONFIGURAÇÕES VISUAIS ===
visible = true;
image_alpha = 1.0;
image_angle = 0;

show_debug_message("🔫 Torreta Type criada - Sistema de Metralhadora Anti-Terrestre");
