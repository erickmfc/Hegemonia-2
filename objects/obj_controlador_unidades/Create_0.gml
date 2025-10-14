/// @description Controlador de seleção de unidades
// Variáveis de controle
selecionando = false;
inicio_selecao_x = 0;
inicio_selecao_y = 0;

// === VARIÁVEIS GLOBAIS PARA COMANDOS AVANÇADOS ===
// Sistema de Seguir com alvo definido pelo jogador
global.esperando_alvo_seguir = noone;

// ✅ CORREÇÃO: Garantir que a variável global existe com verificação robusta
if (!variable_global_exists("definindo_patrulha_unidade")) {
    global.definindo_patrulha_unidade = noone;
}
if (!variable_global_exists("unidade_selecionada")) {
    global.unidade_selecionada = noone;
}