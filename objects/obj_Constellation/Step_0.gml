// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION
// Step Event - Herda 100% da lógica do obj_navio_base
// ===============================================

// Chamar o Step do objeto pai (herda toda a lógica)
event_inherited();

// === VARIÁVEIS DE INSTÂNCIA DECLARADAS COM VAR ===
// Corrigindo avisos GM2016 - declarar variáveis fora do Create com 'var'
var ultima_acao = variable_instance_exists(id, "ultima_acao") ? ultima_acao : "nenhuma";
var cor_feedback = variable_instance_exists(id, "cor_feedback") ? cor_feedback : c_white;
var feedback_timer = variable_instance_exists(id, "feedback_timer") ? feedback_timer : 0;