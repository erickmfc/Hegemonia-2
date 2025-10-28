/// @description Step Event 0 - Sistema Base da Independence
// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE
// Desabilita sistema de mísseis do obj_navio_base
// Independence usa sistema próprio de mísseis múltiplos no Step_1
// ===============================================

// DESABILITAR sistema de mísseis do obj_navio_base ANTES de herdar
// Isso evita que obj_navio_base dispare mísseis, pois o Step_1.gml gerencia isso de forma múltipla
pode_disparar_missil = false;

// ✅ CORREÇÃO GM2040: Chamar o Step do objeto pai com verificação
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// As variáveis de instância (metralhadora_ativa, metralhadora_timer, etc) 
// já foram inicializadas no Create Event, não precisam ser redeclaradas aqui
