// ===============================================
// HEGEMONIA GLOBAL - PILAR PIRATA (INVISÍVEL)
// Marco de patrulha para navios piratas
// ===============================================

// Identificação
tipo = "pilar_pirata";
nome = "Marco Pirata";

// ✅ INVISÍVEL: Não aparece no mapa
visible = false;  // Não renderizar
image_alpha = 0;  // Totalmente transparente

// Sistema de agrupamento (para rotas diferentes)
grupo_pilares = 0;  // Pilares do mesmo grupo formam uma rota

// Lista de navios que usam este pilar (para debug)
navios_vinculados = ds_list_create();

// Raio de detecção para vinculação automática
raio_vinculacao = 1000;  // 1000px de raio para vincular navios

show_debug_message("🏴‍☠️ Pilar Pirata criado em (" + string(x) + ", " + string(y) + ") - INVISÍVEL");
