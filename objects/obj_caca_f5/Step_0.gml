// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-5 (Step com Ataque Agressivo)
// ===============================================

// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando" || estado == "pousando" || estado == "decolando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        // Movimento simplificado para aviões
        if (estado == "patrulhando" || estado == "caçando" || estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            // Movimento básico mantendo direção
            if (variable_instance_exists(id, "speed")) {
                x += lengthdir_x(speed * speed_mult, image_angle);
                y += lengthdir_y(speed * speed_mult, image_angle);
            } else if (variable_instance_exists(id, "velocidade_atual")) {
                // ✅ CORREÇÃO: Normalizar velocidade antes de aplicar multiplicador do LOD
                var _vel_normalizada = scr_normalize_unit_speed(velocidade_atual);
                x += lengthdir_x(_vel_normalizada * speed_mult, image_angle);
                y += lengthdir_y(_vel_normalizada * speed_mult, image_angle);
            }
        }
        exit;
    }
    lod_level = current_lod;
}

// --- 1. PROCESSAR INPUTS DO JOGADOR (SE SELECIONADO) ---
if (selecionado) {
    // Comandos de Modo (P/O) - apenas estes ficam no F-5
    if (keyboard_check_pressed(ord("P"))) { 
        modo_ataque = false; 
        show_debug_message("🛡️ F-5 Modo PASSIVO");
    }
    if (keyboard_check_pressed(ord("O"))) { 
        modo_ataque = true; 
        show_debug_message("⚔️ F-5 Modo ATAQUE AGRESSIVO");
    }

    // Comando de Pouso (L)
    if (keyboard_check_pressed(ord("L")) && estado != "pousado") {
        estado = "pousando";
    }
    
    // Comandos K, clique esquerdo e clique direito agora são gerenciados pelo obj_input_manager
    // para evitar conflitos e manter o modo de patrulha persistente
}

// ======================================================================
// --- 2. NOVA LÓGICA: AQUISIÇÃO DE ALVO (PRIORIDADE MÁXIMA) ---
// ======================================================================
// Se o modo ataque está ativo E o avião não está pousando/decolando E não está já caçando alguém...
if (modo_ataque && estado != "pousando" && estado != "decolando" && estado != "atacando") {
    // Prioriza alvos aéreos primeiro, depois terrestres
    var _alvo_aereo = instance_nearest(x, y, obj_caca_f5);
    var _alvo_f6 = instance_nearest(x, y, obj_f6);
    var _alvo_helicoptero = instance_nearest(x, y, obj_helicoptero_militar);
    
    // ✅ NOVO: Procurar TODAS as unidades terrestres inimigas
    // ✅ CORREÇÃO: obj_inimigo removido
    var _alvo_infantaria = instance_nearest(x, y, obj_infantaria);
    var _alvo_tanque = instance_nearest(x, y, obj_tanque);
    var _alvo_soldado_aa = instance_nearest(x, y, obj_soldado_antiaereo);
    var _alvo_blindado_aa = instance_nearest(x, y, obj_blindado_antiaereo);
    
    // ✅ NOVO: Procurar ESTRUTURAS INIMIGAS (casas, quarteis, bancos)
    var _alvo_casa = instance_nearest(x, y, obj_casa);
    var _alvo_banco = instance_nearest(x, y, obj_banco);
    var _alvo_quartel = instance_nearest(x, y, obj_quartel);
    var _alvo_quartel_marinha = instance_nearest(x, y, obj_quartel_marinha);
    var _alvo_aeroporto = instance_nearest(x, y, obj_aeroporto_militar);
    
    var _alvo_encontrado = noone;
    var _tipo_alvo = "";
    
    // Verifica alvos aéreos primeiro (prioridade máxima)
    if (instance_exists(_alvo_aereo) && _alvo_aereo != id && variable_instance_exists(_alvo_aereo, "nacao_proprietaria") && _alvo_aereo.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_aereo.x, _alvo_aereo.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_aereo;
        _tipo_alvo = "aéreo (F-5 inimigo)";
    } else if (instance_exists(_alvo_f6) && variable_instance_exists(_alvo_f6, "nacao_proprietaria") && _alvo_f6.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_f6.x, _alvo_f6.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_f6;
        _tipo_alvo = "aéreo (F-6 TESTE)";
    } else if (instance_exists(_alvo_helicoptero) && variable_instance_exists(_alvo_helicoptero, "nacao_proprietaria") && _alvo_helicoptero.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_helicoptero.x, _alvo_helicoptero.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_helicoptero;
        _tipo_alvo = "aéreo (Helicóptero inimigo)";
    } 
    // ✅ NOVO: Verificar unidades terrestres inimigas
    else if (instance_exists(_alvo_infantaria) && variable_instance_exists(_alvo_infantaria, "nacao_proprietaria") && _alvo_infantaria.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_infantaria.x, _alvo_infantaria.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_infantaria;
        _tipo_alvo = "terrestre (Infantaria inimiga)";
    } else if (instance_exists(_alvo_tanque) && variable_instance_exists(_alvo_tanque, "nacao_proprietaria") && _alvo_tanque.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_tanque.x, _alvo_tanque.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_tanque;
        _tipo_alvo = "terrestre (Tanque inimigo)";
    } else if (instance_exists(_alvo_soldado_aa) && variable_instance_exists(_alvo_soldado_aa, "nacao_proprietaria") && _alvo_soldado_aa.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_soldado_aa.x, _alvo_soldado_aa.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_soldado_aa;
        _tipo_alvo = "terrestre (Soldado Anti-Aéreo inimigo)";
    } else if (instance_exists(_alvo_blindado_aa) && variable_instance_exists(_alvo_blindado_aa, "nacao_proprietaria") && _alvo_blindado_aa.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_blindado_aa.x, _alvo_blindado_aa.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_blindado_aa;
        _tipo_alvo = "terrestre (Blindado Anti-Aéreo inimigo)";
    }
    // ✅ CORREÇÃO CRÍTICA: Removida referência a _alvo_inimigo (obj_inimigo foi removido do projeto)
    // A variável _alvo_inimigo nunca foi definida e causava erro em tempo de execução
    // ✅ NOVO: Verificar estruturas inimigas (prioridade baixa, mas atacáveis)
    else if (instance_exists(_alvo_quartel) && variable_instance_exists(_alvo_quartel, "nacao_proprietaria") && _alvo_quartel.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_quartel.x, _alvo_quartel.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_quartel;
        _tipo_alvo = "estrutura (Quartel inimigo)";
    } else if (instance_exists(_alvo_quartel_marinha) && variable_instance_exists(_alvo_quartel_marinha, "nacao_proprietaria") && _alvo_quartel_marinha.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_quartel_marinha.x, _alvo_quartel_marinha.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_quartel_marinha;
        _tipo_alvo = "estrutura (Quartel Marinha inimigo)";
    } else if (instance_exists(_alvo_aeroporto) && variable_instance_exists(_alvo_aeroporto, "nacao_proprietaria") && _alvo_aeroporto.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_aeroporto.x, _alvo_aeroporto.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_aeroporto;
        _tipo_alvo = "estrutura (Aeroporto inimigo)";
    } else if (instance_exists(_alvo_banco) && variable_instance_exists(_alvo_banco, "nacao_proprietaria") && _alvo_banco.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_banco.x, _alvo_banco.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_banco;
        _tipo_alvo = "estrutura (Banco inimigo)";
    } else if (instance_exists(_alvo_casa) && variable_instance_exists(_alvo_casa, "nacao_proprietaria") && _alvo_casa.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_casa.x, _alvo_casa.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_casa;
        _tipo_alvo = "estrutura (Casa inimiga)";
    }
    
    // Se encontrou um inimigo dentro do radar...
    if (instance_exists(_alvo_encontrado)) {
        estado_anterior = estado; // GUARDA o que estava fazendo (ex: "patrulhando")
        estado = "atacando";      // MUDA o estado para "atacando"
        alvo_em_mira = _alvo_encontrado; // Trava a mira no inimigo
        
        show_debug_message("🎯 Alvo " + _tipo_alvo + " detectado! Interrompendo tarefa para atacar " + string(alvo_em_mira));
    } else {
        // Debug: mostra por que não encontrou alvos
        show_debug_message("🔍 Modo ataque ativo mas nenhum alvo inimigo encontrado no radar (alcance: " + string(radar_alcance) + ")");
    }
}
// ======================================================================

// --- 3. MÁQUINA DE ESTADOS ---
// Gerencia as transições e lógicas de cada estado
switch (estado) {
    case "movendo":
        // Se chegou no destino, inicia o pouso
        if (point_distance(x, y, destino_x, destino_y) < 15 && velocidade_atual < 0.5) {
            estado = "pousando";
        }
        break;

    case "patrulhando":
        // Se chegou ao ponto atual, vai para o próximo
        if (point_distance(x, y, destino_x, destino_y) < 20) {
            indice_patrulha_atual = (indice_patrulha_atual + 1) % ds_list_size(pontos_patrulha);
            var _ponto = pontos_patrulha[| indice_patrulha_atual];
            destino_x = _ponto[0];
            destino_y = _ponto[1];
        }
        break;
        
    // --- NOVO ESTADO DE COMBATE ---
    case "atacando":
        // Se o alvo ainda existe, o persegue
        if (instance_exists(alvo_em_mira)) {
            destino_x = alvo_em_mira.x;
            destino_y = alvo_em_mira.y;
            
            // Atira se estiver no alcance e o timer permitir
            // ✅ VALIDAÇÃO: Verificar se alvo é válido antes de disparar
            var _alvo_valido = (instance_exists(alvo_em_mira) && 
                                alvo_em_mira != noone && 
                                !is_undefined(alvo_em_mira.x) && 
                                !is_undefined(alvo_em_mira.y) &&
                                point_distance(x, y, alvo_em_mira.x, alvo_em_mira.y) <= radar_alcance);
            
            if (_alvo_valido && timer_ataque <= 0) {
                // ✅ CORREÇÃO: Criar míssil na altura correta (mesma altura visual do avião)
                var _missil_y = y - altura_voo;
                
                // Verifica se o alvo é uma unidade aérea para usar míssil ar-ar
                var _missil;
                if (alvo_em_mira.object_index == obj_caca_f5 || alvo_em_mira.object_index == obj_f6 || alvo_em_mira.object_index == obj_helicoptero_militar || alvo_em_mira.object_index == obj_f15 || alvo_em_mira.object_index == obj_su35 || alvo_em_mira.object_index == obj_c100) {
                    // Alvo aéreo - usa míssil SkyFury (ar-ar)
                    _missil = scr_get_projectile_from_pool(obj_SkyFury_ar, x, _missil_y, "Instances");
                } else {
                    // Alvo terrestre - usa míssil Ironclad (terra-terra)
                    _missil = scr_get_projectile_from_pool(obj_Ironclad_terra, x, _missil_y, "Instances");
                }
                
                if (instance_exists(_missil)) {
                    // ✅ VALIDAÇÃO: Verificar se alvo ainda existe antes de atribuir
                    if (instance_exists(alvo_em_mira)) {
                        _missil.alvo = alvo_em_mira;
                        _missil.target = alvo_em_mira;
                        _missil.dono = id;
                        _missil.sem_som = true; // ✅ Flag para não tocar som
                        if (variable_instance_exists(_missil, "timer_vida")) {
                            _missil.timer_vida = 300;
                        }
                        timer_ataque = intervalo_ataque;
                    } else {
                        // Alvo desapareceu - destruir míssil
                        if (variable_instance_exists(_missil, "scr_return_projectile_to_pool")) {
                            scr_return_projectile_to_pool(_missil);
                        } else {
                            instance_destroy(_missil);
                        }
                    }
                }
            }
        } 
        // Se o alvo foi destruído...
        else {
            show_debug_message("✅ Alvo destruído! Retornando para: " + estado_anterior);
            estado = estado_anterior; // RETORNA para o que estava fazendo antes
            alvo_em_mira = noone;       // Limpa a mira
        }
        break;
}

// --- 4. LÓGICA DE MOVIMENTO E ALTITUDE (CÓDIGO UNIFICADO) ---
var _is_flying = (estado == "movendo" || estado == "patrulhando" || estado == "decolando" || estado == "atacando");
var _is_landing = (estado == "pousando");

if (_is_flying) {
    altura_voo = min(altura_maxima, altura_voo + 0.3);
    
    var _dist = point_distance(x, y, destino_x, destino_y);
    if (_dist > 5) {
        var _dir = point_direction(x, y, destino_x, destino_y);
        var _diff = angle_difference(_dir, image_angle);
        image_angle += clamp(_diff, -velocidade_rotacao, velocidade_rotacao);
        velocidade_atual = min(velocidade_maxima, velocidade_atual + aceleracao);
    }
} else { // Pousado, Pousando ou Definindo Patrulha
    velocidade_atual = max(0, velocidade_atual - desaceleracao);
    if (_is_landing || estado == "pousado") {
        altura_voo = max(0, altura_voo - 0.3);
    }
    if (altura_voo == 0 && velocidade_atual == 0 && estado == "pousando") {
        estado = "pousado";
    }
}

// Aplica o movimento (só se move se tiver velocidade)
// ✅ CORREÇÃO: Normalizar velocidade baseado no zoom para manter velocidade visual constante
var _vel_normalizada = scr_normalize_unit_speed(velocidade_atual);
x += lengthdir_x(_vel_normalizada, image_angle);
y += lengthdir_y(_vel_normalizada, image_angle);

// --- 5. LÓGICA DO TIMER DE ATAQUE ---
if (timer_ataque > 0) {
    timer_ataque--;
}