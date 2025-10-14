// ====================
// ATRIBUTOS DO SOLDADO
// ====================
vida = 100;
vida_max = 100;
dano = 20;
velocidade = 2;

// Estado inicial
selecionado = false;
estado = "parado";

// Movimento
destino_x = x;
destino_y = y;

// Patrulha (sistema melhorado)
patrulha = ds_list_create();
patrulha_indice = 0;
modo_patrulha = false; // true quando está no modo de definir patrulha

// Ataque
alcance_visao = 200; // Maior que o alcance de tiro para detectar inimigos
alcance_tiro  = 180; // 3x mais que antes (60 * 3 = 180)
atq_cooldown = 0;
atq_rate = 30; // frames (meio segundo se FPS=60)

// Alvo inimigo
alvo = noone;

// Para seguir
seguir_alvo = noone;
