/// @description Inicialização da Lancha Patrulha

// === ENUMS GLOBAIS ===
// Os enums LanchaState e LanchaMode agora estão no script global scr_enums_navais

// Atributos básicos (adaptados para o jogo)
hp_atual = 150;  // HP da lancha conforme documentação
hp_max = 150;
nacao_proprietaria = 1; // 1 = jogador (conforme obj_inimigo usa 2)

// === SISTEMA DE NAVEGAÇÃO NAVAL ===
// Sistema antigo (mantido para compatibilidade)
velocidade = 1.5;              // Velocidade de movimento (pixels por frame)
velocidade_rotacao = 1.0;      // Velocidade de rotação (graus por frame)
tolerancia_chegada = 40;       // ✅ AUMENTADO: Distância mínima para considerar chegada

// === FÍSICA DE MOVIMENTO (NOVO SISTEMA - Estilo Rusted Warfare) ===
// Baseado em unit_data da documentação - Realismo de inércia (drift na água)
// ✅ Lancha Patrulha: 1.5 (mais rápida)
moveSpeed = 3.0;             // Velocidade máxima (1.5x base)
acceleration = 0.15;         // Aceleração (quanto menor, mais pesada parece)
friction_water = 0.08;       // Resistência da água (desaceleração natural)
turnSpeed = 2.5;             // Velocidade de rotação do casco

// === NAVEGAÇÃO ===
target_x = x;                // Destino X (novo sistema)
target_y = y;                // Destino Y (novo sistema)
destino_x = x;               // Destino X (sistema antigo - compatibilidade)
destino_y = y;               // Destino Y (sistema antigo - compatibilidade)
is_moving = false;           // Estado atual de movimento
stop_distance = 16;          // Distância para considerar que "chegou"
usar_novo_sistema = false;   // Flag para controlar qual sistema de movimento usar

// === POSIÇÃO DO CLIQUE (para linha visual) ===
click_x = x;                 // Posição X onde o jogador clicou
click_y = y;                 // Posição Y onde o jogador clicou

// === SISTEMA DE PATRULHA (igual aos aviões) ===
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// Sistema de detecção de "presa" (menos agressivo)
distancia_anterior = 0;
timer_presa = 0;
max_timer_presa = 120; // ✅ AUMENTADO: Se não se aproximar por 120 frames, considerar presa

// Estado e modo - DEFINIR PRIMEIRO
estado = LanchaState.PARADO;
modo_combate = LanchaMode.PASSIVO;

// Sensores e alcance (adaptados)
radar_alcance = 750; // alcance conforme documentação
missil_alcance = 700; // alcance de tiro
alcance_ataque = missil_alcance;

// Alvo
alvo_x = x;
alvo_y = y;

// === FUNÇÃO DE MOVIMENTO ===
ordem_mover = function(dest_x, dest_y) {
    // Sempre atualizar destino, mesmo se já estiver movendo
    destino_x = dest_x;
    destino_y = dest_y;
    
    // === NOVO SISTEMA: Atualizar também target_x/target_y ===
    target_x = dest_x;
    target_y = dest_y;
    is_moving = true;
    
    estado = LanchaState.MOVENDO;
    estado_string = "movendo";
    speed = velocidade; // Garantir que está se movendo (sistema antigo)
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🚢 Lancha: Movendo para (" + string(dest_x) + ", " + string(dest_y) + ")");
    }
}

// === TERRENOS PERMITIDOS ===
terrenos_permitidos = [TERRAIN.AGUA]; // Só água

// Seleção e UI
selecionado = false;
selected = false;            // Compatibilidade com novo sistema

// === GRÁFICOS ===
image_angle = direction;     // O sprite segue a direção inicial

// Controle de taxa de tiro / ataque
reload_time = 60; // steps entre tiros
reload_timer = 0;

// Sistema de rotação (atualizado para novo sistema de navegação)
// velocidade_rotacao agora definida acima (3.5)

// Identificador e nome
nome_unidade = "Lancha Patrulha";

// Variáveis auxiliares
alvo_unidade = noone; // id da instancia inimiga a atacar

// ✅ OTIMIZAÇÃO: Timer para verificação periódica de inimigos (a cada 30 frames = ~0.5s a 60 FPS)
timer_verificacao_inimigos = 0;
intervalo_verificacao_inimigos = 30; // Verificar inimigos a cada 30 frames

// --- VARIÁVEIS ADAPTADAS DO F5 (APÓS DEFINIR TODAS AS VARIÁVEIS) ---
estado_anterior = LanchaState.PARADO; // Guarda estado anterior para retorno após ataque

// --- MAPEAMENTO DE COMPATIBILIDADE COM SISTEMA GLOBAL ---
modo_ataque = (modo_combate == LanchaMode.ATAQUE);
timer_ataque = reload_timer; // Mapeamento para compatibilidade
estado_string = "parado"; // Estado em string para compatibilidade


func_procurar_inimigo = function() {
    // ✅ CORREÇÃO: obj_inimigo removido - buscar apenas obj_infantaria
    var melhor = noone;
    var melhor_d = 999999;
    with (obj_infantaria) {
        if (nacao_proprietaria != other.nacao_proprietaria) {
            var d = point_distance(other.x, other.y, x, y);
            if (d < other.radar_alcance && d < melhor_d) {
                melhor = id;
                melhor_d = d;
            }
        }
    }
    return melhor;
}

func_atacar_alvo = function() {
    if (!instance_exists(alvo_unidade)) {
        alvo_unidade = noone;
        estado = LanchaState.PARADO;
        estado_string = "parado"; // Sincronizar
        return;
    }
    var d = point_distance(x, y, alvo_unidade.x, alvo_unidade.y);
    if (d <= missil_alcance) {
        if (reload_timer <= 0) {
            var _tiro = scr_get_projectile_from_pool(obj_tiro_simples, x, y, "Instances");
            if (instance_exists(_tiro)) {
                _tiro.alvo = alvo_unidade;
                _tiro.dono = id;
                _tiro.dano = 35;
                _tiro.speed = 8;
                _tiro.direction = point_direction(x, y, alvo_unidade.x, alvo_unidade.y);
                if (variable_instance_exists(_tiro, "timer_vida")) {
                    _tiro.timer_vida = 300;
                }
            }
            reload_timer = reload_time;
            timer_ataque = reload_timer; // Sincronizar
            if (global.debug_enabled) show_debug_message("🚢 Tiro disparado!");
        }
        estado = LanchaState.ATACANDO;
        estado_string = "atacando"; // Sincronizar
    } else {
        // Navegação removida - não perseguir alvo
    }
}

// callbacks amigáveis para o controlador
on_select = function() {
    selecionado = true;
    // opcional: efeitos visuais, som, etc
};
on_deselect = function() {
    selecionado = false;
};


// --- FUNÇÕES DE SINCRONIZAÇÃO (ADICIONADAS) ---
func_sincronizar_timers = function() {
    timer_ataque = reload_timer;
}

func_atualizar_modo_ataque = function() {
    modo_ataque = (modo_combate == LanchaMode.ATAQUE);
}

func_sincronizar_estado = function() {
    switch (estado) {
        case LanchaState.PARADO:
            estado_string = "parado";
            break;
        case LanchaState.MOVENDO:
            estado_string = "movendo";
            break;
        case LanchaState.ATACANDO:
            estado_string = "atacando";
            break;
        case LanchaState.PATRULHANDO:
            estado_string = "patrulhando";
            break;
        case LanchaState.DEFININDO_PATRULHA:
            estado_string = "definindo_patrulha";
            break;
    }
}

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;


if (global.debug_enabled) show_debug_message("🚢 Lancha Patrulha criada!");
