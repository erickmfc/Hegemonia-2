/// @description Inicialização da Lancha Patrulha

// === ENUMS GLOBAIS ===
// Os enums LanchaState e LanchaMode agora estão no script global scr_enums_navais

// Atributos básicos (adaptados para o jogo)
hp_atual = 150;  // HP da lancha conforme documentação
hp_max = 150;
velocidade_movimento = 1.8; // velocidade conforme documentação
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

// ✅ NOVO: Sistema de pathfinding A* (GPS)
meu_caminho = noone; // Path do GameMaker para seguir
velocidade_max = velocidade_movimento; // Velocidade para seguir o path
destino_final_x = x; // Destino final (para referência)
destino_final_y = y;
distancia_minima_costa = 150; // Distância mínima da terra em pixels (usado no pathfinding)

// ✅ COMPATIBILIDADE: Manter variáveis antigas para compatibilidade
waypoints = []; // Array vazio (não usado mais, mas mantido para compatibilidade)
waypoint_atual = 0;
timer_pathfinding = 0;
timer_progresso = 0;
distancia_anterior_progresso = 0;

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
    // Clamp destino para dentro da sala
    var _dx = clamp(dest_x, 8, room_width - 8);
    var _dy = clamp(dest_y, 8, room_height - 8);
    
    // ✅ NOVO: Verificar caminho ANTES de iniciar movimento
    destino_final_x = _dx;
    destino_final_y = _dy;
    
    // Limpar waypoints anteriores
    waypoints = [];
    waypoint_atual = 0;
    timer_progresso = 0;
    distancia_anterior_progresso = 0;
    
    // Verificar se caminho direto está livre (com zona de segurança)
    var _funcao_caminho_seguranca_existe = script_exists(asset_get_index("scr_validar_caminho_terreno_com_seguranca"));
    var _caminho_livre = false;
    if (_funcao_caminho_seguranca_existe) {
        _caminho_livre = scr_validar_caminho_terreno_com_seguranca(id, x, y, _dx, _dy, 20, distancia_minima_costa);
    } else {
        _caminho_livre = scr_validar_caminho_terreno(id, x, y, _dx, _dy, 20);
    }
    
    if (_caminho_livre) {
        // Caminho direto está livre - usar destino direto
        alvo_x = _dx;
        alvo_y = _dy;
        destino_x = _dx;
        destino_y = _dy;
        show_debug_message("🚢 " + nome_unidade + " - Caminho direto livre para (" + string(_dx) + ", " + string(_dy) + ")");
    } else {
        // Caminho bloqueado - calcular contorno
        show_debug_message("🚢 " + nome_unidade + " - Caminho bloqueado, calculando contorno...");
        var _caminho_contorno = scr_calcular_contorno_massa_terreno(id, x, y, _dx, _dy, 1000);
        
        if (array_length(_caminho_contorno) > 0) {
            // Usar waypoints do contorno
            waypoints = _caminho_contorno;
            waypoint_atual = 0;
            
            // Definir primeiro waypoint como destino imediato
            if (array_length(waypoints) > 0) {
                alvo_x = waypoints[0][0];
                alvo_y = waypoints[0][1];
                destino_x = alvo_x;
                destino_y = alvo_y;
                show_debug_message("🚢 " + nome_unidade + " - " + string(array_length(waypoints)) + " waypoints calculados. Primeiro: (" + string(round(destino_x)) + ", " + string(round(destino_y)) + ")");
            }
        } else {
            // Não conseguiu calcular contorno - tentar encontrar água próxima
            var _agua_proxima = scr_encontrar_agua_proxima(_dx, _dy, 1000);
            if (_agua_proxima != noone && array_length(_agua_proxima) >= 2) {
                alvo_x = _agua_proxima[0];
                alvo_y = _agua_proxima[1];
                destino_x = alvo_x;
                destino_y = alvo_y;
                show_debug_message("🚢 " + nome_unidade + " - Usando água próxima: (" + string(round(destino_x)) + ", " + string(round(destino_y)) + ")");
            } else {
                // Sem caminho possível - parar
                estado = LanchaState.PARADO;
                estado_string = "parado";
                show_debug_message("⚠️ " + nome_unidade + " - Sem caminho possível para (" + string(_dx) + ", " + string(_dy) + ")");
                return;
            }
        }
    }
    
    estado = LanchaState.MOVENDO;
    estado_string = "movendo";
    modo_definicao_patrulha = false;
    
    // ✅ DEBUG: Mostrar apenas se debug estiver ativo
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🚢 Ordem de movimento: (" + string(_dx) + ", " + string(_dy) + ")");
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
