// ===============================================
// HEGEMONIA GLOBAL - WW-HENDRICK (PRIMEIRO SUBMARINO)
// Herda de obj_submarino_base
// ===============================================

// ✅ CORREÇÃO GM2040: Chamar o Create do objeto pai PRIMEIRO com verificação
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === CONFIGURAÇÕES ESPECÍFICAS DO WW-HENDRICK ===

// Atributos únicos do Ww-Hendrick
hp_atual = 200; // Mais robusto que submarino genérico
hp_max = 200;
velocidade_movimento = 1.4; // Mais rápido que submarino padrão
radar_alcance = 900; // Melhor radar
missil_alcance = 800; // Melhor alcance de torpedos
missil_max_alcance = 800;
alcance_ataque = missil_alcance;
dano_ataque = 60; // Dano de torpedo
reload_time = 90; // Recarga mais rápida

// Nome da unidade
nome_unidade = "Ww-Hendrick"; // Primeiro submarino

// === MELHORIAS DE SUBMERSÃO ===
profundidade_maxima = 60; // Pode ir mais fundo
// Tempo máximo removido - pode ficar submerso indefinidamente

show_debug_message("🌊 Ww-Hendrick configurado - HP: " + string(hp_atual) + ", Dano: " + string(dano_ataque));