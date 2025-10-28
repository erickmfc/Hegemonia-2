// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION
// Step Event - Herda 100% da lógica do obj_navio_base
// ===============================================

// ✅ CORREÇÃO GM2040: Chamar o Step do objeto pai com verificação
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// As variáveis de instância (ultima_acao, cor_feedback, feedback_timer) 
// já foram inicializadas no Create Event, não precisam ser redeclaradas aqui