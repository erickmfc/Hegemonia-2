// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO
// Bloco 4, Fase 3: Limpeza ao Fechar
// ===============================================

// Evento Destroy de obj_menu_recrutamento
// Garantir que a variável global seja resetada quando o menu for destruído

global.menu_recrutamento_aberto = false;

show_debug_message("Menu de recrutamento destruído. Variável global resetada.");