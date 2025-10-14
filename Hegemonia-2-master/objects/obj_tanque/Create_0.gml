// ===============================================
// OBJ_TANQUE - CREATE EVENT (SISTEMA P / O / L / K)
// ===============================================

// --- Atributos Básicos ---
hp_atual = 350;
hp_max = 350;
velocidade = 1.2;
alcance_visao = 450;
alcance_tiro = 400;
intervalo_ataque = 120; // 2 segundos
projetil_objeto = obj_tiro_simples;

// --- Estados e Modos ---
estado = "parado";         // parado, movendo, patrulhando, atacando
modo_combate = "passivo";  // passivo / ataque
selecionado = false;
alvo = noone;

// --- Movimento ---
destino_x = x;
destino_y = y;

// --- Patrulha ---
pontos_patrulha = ds_list_create();
indice_patrulha = 0;
modo_definicao_patrulha = false;
patrulhando = false;

// --- Timers ---
timer_ataque = 0;

// --- Visual ---
image_blend = c_olive;

// --- Sons / efeitos (opcional) ---
// snd_tiro = snd_tiro_tanque; // Som não existe ainda - comentado para evitar erro

// --- Controle interno ---
modo_patrulha_manual = false; // usado quando o jogador ativa patrulha com tecla K

// --- Sistema Visual RTS Profissional ---
selected = false;              // se está selecionado (alias para selecionado)
mostrar_area_tiro = false;     // se exibe o alcance de tiro
mostrar_info = false;          // se exibe os textos de status
modo_ataque = false;           // modo de ataque ativo
modo_defesa = false;           // modo de defesa ativo
modo_parado = true;            // modo parado ativo

// --- Efeitos de Animação ---
fade_alpha = 0;                // alpha para fade-in/out
fade_timer = 0;                // timer para animação
fade_speed = 0.1;              // velocidade do fade
