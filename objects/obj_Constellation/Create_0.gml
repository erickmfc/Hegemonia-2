/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION (HERDA DE NAVIO_BASE)
// Herda de obj_lancha_patrulha (que funciona!)
// ===============================================

// Chamar o Create do objeto pai PRIMEIRO
event_inherited();

// === CONFIGURAÇÕES ESPECÍFICAS DO CONSTELLATION ===

// Atributos únicos do Constellation
hp_atual = 800;
hp_max = 800;
velocidade_movimento = 2.5;
radar_alcance = 1000;
missil_alcance = 800;
alcance_ataque = missil_alcance;
dano_ataque = 100;
reload_time = 120;

// Nome da unidade
nome_unidade = "Constellation"; // Sobrescreve o nome do pai

// === VARIÁVEIS DE FEEDBACK ===
ultima_acao = "nenhuma";
cor_feedback = c_white;
feedback_timer = 0;

show_debug_message("🚢 Constellation configurado - HP: " + string(hp_atual) + ", Dano: " + string(dano_ataque));