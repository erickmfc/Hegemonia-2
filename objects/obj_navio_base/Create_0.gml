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

// Sensores e alcance (PADRONIZADO COM TODOS OS NAVIOS)
radar_alcance = 1000; // IGUAL aos outros navios
missil_alcance = 1000; // IGUAL aos outros navios
missil_max_alcance = 1000; // Alcance máximo de mísseis
alcance_ataque = missil_alcance;

// Alvo e movimento
alvo_x = x;
alvo_y = y;

// Patrulha
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// ✅ CORREÇÃO: Inicializar is_moving
is_moving = false;

// Seleção e UI
selecionado = false;

// Controle de taxa de tiro / ataque
reload_time = 60; // steps entre tiros
reload_timer = 0;

// Identificador e nome
nome_unidade = "Lancha Patrulha";

// Variáveis auxiliares
alvo_unidade = noone; // id da instancia inimiga a atacar
alvo_pos_anterior_x = -1; // Rastreamento de posição anterior do alvo
alvo_pos_anterior_y = -1; // Rastreamento de posição anterior do alvo

// --- VARIÁVEIS ADAPTADAS DO F5 (APÓS DEFINIR TODAS AS VARIÁVEIS) ---
estado_anterior = LanchaState.PARADO; // Guarda estado anterior para retorno após ataque

// --- MAPEAMENTO DE COMPATIBILIDADE COM SISTEMA GLOBAL ---
modo_ataque = (modo_combate == LanchaMode.ATAQUE);
velocidade_atual = velocidade_movimento; // Mapeamento para compatibilidade
timer_ataque = reload_timer; // Mapeamento para compatibilidade
destino_x = alvo_x; // Mapeamento para compatibilidade
destino_y = alvo_y; // Mapeamento para compatibilidade

// Funções da lancha
ordem_mover = function(dest_x, dest_y) {
    // Clamp destino para dentro da sala
    var _dx = clamp(dest_x, 8, room_width - 8);
    var _dy = clamp(dest_y, 8, room_height - 8);
    destino_x = _dx;
    destino_y = _dy;
    estado = LanchaState.MOVENDO;
    is_moving = true; // ✅ CORREÇÃO: Definir is_moving para mostrar linha de movimento
    alvo_unidade = noone; // Cancela qualquer alvo de ataque
    
    show_debug_message("🚢 " + nome_unidade + " recebeu ordem de movimento para (" + string(dest_x) + ", " + string(dest_y) + "). Estado: MOVENDO");
}

// Mantém compatibilidade
func_ordem_mover = ordem_mover;

func_adicionar_ponto = function(px, py) {
    ds_list_add(pontos_patrulha, [px, py]);
}

func_iniciar_patrulha = function() {
    if (ds_list_size(pontos_patrulha) > 0) {
        indice_patrulha_atual = 0; 
        var p = pontos_patrulha[| indice_patrulha_atual];
        destino_x = p[0];
        destino_y = p[1];
        estado = LanchaState.PATRULHANDO;
    } else {
        estado = LanchaState.PARADO;
    }
}

func_proximo_ponto = function() {
    if (ds_list_size(pontos_patrulha) == 0) {
        estado = LanchaState.PARADO;
        return;
    }
    indice_patrulha_atual = (indice_patrulha_atual + 1) mod ds_list_size(pontos_patrulha);
    var p = pontos_patrulha[| indice_patrulha_atual];
    destino_x = p[0];
    destino_y = p[1];
}

func_procurar_inimigo = function() {
    var melhor = noone;
    var melhor_d = 999999;
    with (obj_inimigo) {
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
        return;
    }
    var d = point_distance(x, y, alvo_unidade.x, alvo_unidade.y);
    if (d <= missil_alcance) {
        if (reload_timer <= 0) {
            var _tiro = scr_get_projectile_from_pool(obj_tiro_simples, x, y, "Instances");
            if (instance_exists(_tiro)) {
                _tiro.alvo = alvo_unidade;
                _tiro.dono = id;
                _tiro.dano = 25;
                _tiro.speed = 8;
                if (variable_instance_exists(_tiro, "timer_vida")) {
                    _tiro.timer_vida = 300;
                }
                _tiro.direction = point_direction(x, y, alvo_unidade.x, alvo_unidade.y);
                reload_timer = reload_time;
                timer_ataque = reload_timer; // Sincronizar
            }
        }
        estado = LanchaState.ATACANDO;
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

show_debug_message("🚢 " + nome_unidade + " base criada!");
