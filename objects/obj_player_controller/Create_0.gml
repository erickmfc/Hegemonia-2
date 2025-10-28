/// @description obj_player_controller - Create

// Controlador principal do jogador
selected_unit = noone; // id da unidade atualmente selecionada
selecionado = false;    // Estado de seleção
alvo_x = 0;            // Coordenada X do alvo
alvo_y = 0;            // Coordenada Y do alvo
destino_x = 0;         // Coordenada X do destino
destino_y = 0;         // Coordenada Y do destino
estado_string = "";    // String do estado
estado = "";           // Estado atual
modo_definicao_patrulha = false; // Modo de definição de patrulha

show_debug_message("🎮 Player Controller criado!");