/// @description Controlador de seleção de unidades
// Variáveis de controle
selecionando = false;
inicio_selecao_x = 0;
inicio_selecao_y = 0;

// === VARIÁVEIS GLOBAIS PARA COMANDOS AVANÇADOS ===
// Sistema de Seguir com alvo definido pelo jogador
global.esperando_alvo_seguir = noone;

// Sistema de Patrulha com waypoints customizados
global.definindo_patrulha = noone;