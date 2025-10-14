// ========================================
// VARIÁVEIS GLOBAIS PARA SISTEMA DE CONSTRUÇÃO
// ========================================
// Adicione estas variáveis no evento Create do seu objeto gerenciador

// Sistema de construção
global.modo_construcao = false;
global.objeto_construindo = noone;

// Exemplos de como definir objetos para construção:
// global.objeto_construindo = obj_quartel_marinha;  // Quartel Marinha (precisa de água)
// global.objeto_construindo = obj_quartel;          // Quartel Normal (precisa de terra)
// global.objeto_construindo = obj_casa;             // Casa (precisa de terra)
// global.objeto_construindo = obj_mina;             // Mina (precisa de terra)

// ========================================
// EXEMPLO DE CONFIGURAÇÃO DE BOTÕES
// ========================================

// Para botão do Quartel Marinha (Left Pressed):
/*
global.modo_construcao = true;
global.objeto_construindo = obj_quartel_marinha;
show_message("Clique em uma posição de água para construir o Quartel Marinha");
*/

// Para botão do Quartel Normal (Left Pressed):
/*
global.modo_construcao = true;
global.objeto_construindo = obj_quartel;
show_message("Clique em uma posição de terra para construir o Quartel");
*/

// Para botão da Casa (Left Pressed):
/*
global.modo_construcao = true;
global.objeto_construindo = obj_casa;
show_message("Clique em uma posição de terra para construir a Casa");
*/
