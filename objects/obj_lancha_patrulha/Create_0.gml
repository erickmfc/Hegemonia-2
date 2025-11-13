/// @description Inicialização da Lancha Patrulha

// === ENUMS GLOBAIS ===
// Os enums LanchaState e LanchaMode agora estão no script global scr_enums_navais

// Atributos básicos (adaptados para o jogo)
hp_atual = 150;  // HP da lancha conforme documentação
hp_max = 150;
velocidade_movimento = 1.4; // velocidade conforme documentação
nacao_proprietaria = 1; // 1 = jogador (conforme obj_inimigo usa 2)


// Estado e modo - DEFINIR PRIMEIRO
estado = LanchaState.PARADO;
modo_combate = LanchaMode.PASSIVO;

// Sensores e alcance (adaptados)
radar_alcance = 750; // alcance conforme documentação
missil_alcance = 700; // alcance de tiro
alcance_ataque = missil_alcance;

// Alvo e movimento
alvo_x = x;
alvo_y = y;

// Patrulha
modo_definicao_patrulha = false;
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;
direcao_patrulha = 1; // 1 = horário (avançar), -1 = anti-horário (retroceder)

// === TERRENOS PERMITIDOS ===
terrenos_permitidos = [TERRAIN.AGUA]; // Só água

// Seleção e UI
selecionado = false;

// Controle de taxa de tiro / ataque
reload_time = 60; // steps entre tiros
reload_timer = 0;

// Sistema de rotação
velocidade_rotacao = 0.98; // Velocidade de rotação em graus por frame

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
velocidade_atual = velocidade_movimento; // Mapeamento para compatibilidade
timer_ataque = reload_timer; // Mapeamento para compatibilidade
destino_x = alvo_x; // Mapeamento para compatibilidade
destino_y = alvo_y; // Mapeamento para compatibilidade
indice_patrulha = indice_patrulha_atual; // Mapeamento para compatibilidade
estado_string = "parado"; // Estado em string para compatibilidade

// Funções da lancha
ordem_mover = function(dest_x, dest_y) {
    alvo_x = dest_x;
    alvo_y = dest_y;
    destino_x = dest_x; // Sincronizar
    destino_y = dest_y; // Sincronizar
    estado = LanchaState.MOVENDO;
    estado_string = "movendo"; // Sincronizar
    modo_definicao_patrulha = false;
    
    // ✅ DEBUG: Mostrar apenas se debug estiver ativo
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🚢 Ordem de movimento: (" + string(dest_x) + ", " + string(dest_y) + ")");
    }
}

// Mantém compatibilidade
func_ordem_mover = ordem_mover;

func_adicionar_ponto = function(px, py) {
    ds_list_add(pontos_patrulha, [px, py]);
}

func_iniciar_patrulha = function() {
    if (ds_list_size(pontos_patrulha) > 0) {
        indice_patrulha_atual = 0;
        indice_patrulha = 0; // Sincronizar
        var p = pontos_patrulha[| indice_patrulha_atual];
        alvo_x = p[0];
        alvo_y = p[1];
        destino_x = p[0]; // Sincronizar
        destino_y = p[1]; // Sincronizar
        estado = LanchaState.PATRULHANDO;
        estado_string = "patrulhando"; // Sincronizar
    } else {
        estado = LanchaState.PARADO;
        estado_string = "parado"; // Sincronizar
    }
}

func_proximo_ponto = function() {
    if (ds_list_size(pontos_patrulha) == 0) {
        estado = LanchaState.PARADO;
        estado_string = "parado"; // Sincronizar
        return;
    }
    // ✅ NOVO: Sistema de rotação de patrulha (horário/anti-horário)
    var _total_pontos = ds_list_size(pontos_patrulha);
    if (!variable_instance_exists(id, "direcao_patrulha")) {
        direcao_patrulha = 1; // Padrão: horário
    }
    indice_patrulha_atual = (indice_patrulha_atual + direcao_patrulha + _total_pontos) mod _total_pontos;
    indice_patrulha = indice_patrulha_atual; // Sincronizar
    var p = pontos_patrulha[| indice_patrulha_atual];
    alvo_x = p[0];
    alvo_y = p[1];
    destino_x = p[0]; // Sincronizar
    destino_y = p[1]; // Sincronizar
}

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
        ordem_mover(alvo_unidade.x, alvo_unidade.y);
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

// garantia: se pontos_patrulha não existir, cria
if (!ds_exists(pontos_patrulha, ds_type_list)) {
    pontos_patrulha = ds_list_create();
}

// --- FUNÇÕES DE SINCRONIZAÇÃO (ADICIONADAS) ---
func_sincronizar_timers = function() {
    velocidade_atual = velocidade_movimento;
    timer_ataque = reload_timer;
}

func_atualizar_modo_ataque = function() {
    modo_ataque = (modo_combate == LanchaMode.ATAQUE);
}

func_sincronizar_destino = function() {
    destino_x = alvo_x;
    destino_y = alvo_y;
}

func_sincronizar_estado = function() {
    switch (estado) {
        case LanchaState.PARADO:
            estado_string = "parado";
            break;
        case LanchaState.MOVENDO:
            estado_string = "movendo";
            break;
        case LanchaState.PATRULHANDO:
            estado_string = "patrulhando";
            break;
        case LanchaState.ATACANDO:
            estado_string = "atacando";
            break;
    }
}

func_sincronizar_indice = function() {
    indice_patrulha = indice_patrulha_atual;
}

// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;

// ✅ Timer para controle de efeito de espuma do mar
timer_espuma = 0;

// ✅ CORREÇÃO: Variáveis para controle de rotação infinita
distancia_anterior = 0;
timer_afastando = 0;
angulo_anterior = 0;
timer_girando = 0;

if (global.debug_enabled) show_debug_message("🚢 Lancha Patrulha criada!");
