// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO
// Bloco 4, Fase 3: Interface de Recrutamento
// ===============================================

// Evento Create de obj_menu_recrutamento
id_do_quartel = noone; // Variável que guardará o ID do quartel

// Variável para evitar fechamento imediato (previne bug de duplo clique)
delay_abertura = 10; // 10 frames de delay antes de permitir fechamento

show_debug_message("Menu de recrutamento criado. Aguardando vinculação com quartel...");