// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO MARINHA
// Sistema de Interface Naval (FASE 2)
// ===============================================

// Variável para armazenar referência ao quartel que criou este menu
quartel_referencia = noone; // Será definida logo após a criação via with(menu)

// Observação: Não destruir aqui. O Step_0.gml já verifica se a referência é válida
// e fecha o menu com segurança quando necessário.

show_debug_message("Menu de Recrutamento Naval criado. Aguardando referência do quartel...");