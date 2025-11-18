// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-6 (ALVO DE TESTE)
// Step Event - Baseado no F-5 com comportamento automático
// ===============================================

// --- 1. COMPORTAMENTO AUTOMÁTICO DE TESTE ---
if (modo_teste) {
    // Decolagem automática após timer
    if (timer_decolagem_automatica > 0) {
        timer_decolagem_automatica--;
        if (timer_decolagem_automatica <= 0 && estado == "pousado") {
            estado = "decolando";
            show_debug_message("🚀 F-6 iniciando decolagem automática para teste");
        }
    }
    
    // Patrulha automática após decolagem
    if (patrulha_automatica && estado == "decolando") {
        // Cria pontos de patrulha retangular dos soldados inimigos até o meio do mapa
        ds_list_clear(pontos_patrulha);
        
        // Pontos da área retangular de patrulha
        var _pontos_retangulo = [
            [patrulha_x_min, patrulha_y_min],     // Canto inferior esquerdo (soldados inimigos)
            [patrulha_x_max, patrulha_y_min],     // Canto inferior direito
            [patrulha_x_max, patrulha_y_max],     // Canto superior direito (meio do mapa)
            [patrulha_x_min, patrulha_y_max],     // Canto superior esquerdo
            [patrulha_x_min, patrulha_y_min]      // Volta ao início
        ];
        
        // Adicionar pontos intermediários para patrulha mais suave
        for (var i = 0; i < array_length(_pontos_retangulo) - 1; i++) {
            var _p1 = _pontos_retangulo[i];
            var _p2 = _pontos_retangulo[i + 1];
            
            // Adicionar ponto inicial
            ds_list_add(pontos_patrulha, _p1);
            
            // Adicionar pontos intermediários (dividir segmento em 3 partes)
            for (var j = 1; j <= 2; j++) {
                var _px = _p1[0] + (_p2[0] - _p1[0]) * (j / 3);
                var _py = _p1[1] + (_p2[1] - _p1[1]) * (j / 3);
                ds_list_add(pontos_patrulha, [_px, _py]);
            }
        }
        
        estado = "patrulhando";
        indice_patrulha_atual = 0;
        var _ponto = pontos_patrulha[| 0];
        destino_x = _ponto[0];
        destino_y = _ponto[1];
        patrulha_automatica = false; // Evita recriar pontos
        
        show_debug_message("🔄 F-6 iniciando patrulha RETANGULAR automática!");
        show_debug_message("📍 Área: (" + string(patrulha_x_min) + "," + string(patrulha_y_min) + ") até (" + string(patrulha_x_max) + "," + string(patrulha_y_max) + ")");
        show_debug_message("🎯 Pontos de patrulha: " + string(ds_list_size(pontos_patrulha)));
    }
}

// --- 2. MÁQUINA DE ESTADOS (BASEADA NO F-5) ---
switch (estado) {
    case "pousado":
        velocidade_atual = max(0, velocidade_atual - desaceleracao);
        altura_voo = max(0, altura_voo - 0.3);
        break;
        
    case "decolando":
        altura_voo = min(altura_maxima, altura_voo + 0.3);
        velocidade_atual = min(velocidade_maxima, velocidade_atual + aceleracao);
        if (altura_voo >= altura_maxima * 0.8) {
            estado = "movendo";
        }
        break;

    case "movendo":
        // Se chegou no destino, inicia o pouso
        if (point_distance(x, y, destino_x, destino_y) < 15 && velocidade_atual < 0.5) {
            estado = "pousando";
        }
        break;

    case "patrulhando":
        // ✅ CORREÇÃO: Patrulha controlada pelo presidente - não continua automaticamente
        // Se chegou ao ponto atual, vai para o próximo (apenas se presidente ordenou patrulha)
        if (point_distance(x, y, destino_x, destino_y) < 20) {
            // Verificar se ainda há pontos de patrulha definidos pelo presidente
            if (ds_list_size(pontos_patrulha) > 0) {
                indice_patrulha_atual = (indice_patrulha_atual + 1) % ds_list_size(pontos_patrulha);
                var _ponto = pontos_patrulha[| indice_patrulha_atual];
                destino_x = _ponto[0];
                destino_y = _ponto[1];
            } else {
                // Sem mais pontos de patrulha - voltar para pousado e aguardar ordem do presidente
                estado = "pousando";
                show_debug_message("🛬 F-6: Patrulha concluída. Aguardando nova ordem do presidente.");
            }
        }
        break;
    
    case "atacando":
        // ✅ NOVO: Estado "atacando" para responder aos comandos da IA (presidente)
        // Se a IA definiu um alvo, usar esse alvo
        if (variable_instance_exists(id, "alvo") && instance_exists(alvo)) {
            // Converter estado "atacando" para "caçando" (sistema interno do F6)
            if (estado_anterior != "caçando") {
                estado_anterior = "movendo"; // Guardar estado anterior
                estado = "caçando";
                alvo_em_mira = alvo;
                destino_x = alvo.x;
                destino_y = alvo.y;
                show_debug_message("🎯 F-6 recebeu ordem de ataque da IA! Alvo: " + object_get_name(alvo.object_index));
            }
        }
        break;
        
    case "pousando":
        altura_voo = max(0, altura_voo - 0.3);
        velocidade_atual = max(0, velocidade_atual - desaceleracao);
        if (altura_voo == 0 && velocidade_atual == 0) {
            estado = "pousado";
        }
        break;
}

// --- 3. LÓGICA DE MOVIMENTO E ALTITUDE ---
var _is_flying = (estado == "movendo" || estado == "patrulhando" || estado == "decolando" || estado == "caçando" || estado == "atacando");
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
} else { // Pousado ou Pousando
    velocidade_atual = max(0, velocidade_atual - desaceleracao);
    if (_is_landing || estado == "pousado") {
        altura_voo = max(0, altura_voo - 0.3);
    }
}

// ✅ CORREÇÃO: Normalizar velocidade baseado no zoom para manter velocidade visual constante
var _vel_normalizada = scr_normalize_unit_speed(velocidade_atual);
// Aplica o movimento (só se move se tiver velocidade)
var _proxima_x = x + lengthdir_x(_vel_normalizada, image_angle);
var _proxima_y = y + lengthdir_y(_vel_normalizada, image_angle);

// ✅ NOVO: Validação de terreno para aviões
// Se está pousado ou pousando (altura_voo == 0 ou muito baixa), deve estar em terra
if (altura_voo <= 5 && (estado == "pousado" || estado == "pousando")) {
    // Verificar se pode estar no terreno (deve ser terra, não água)
    if (!scr_unidade_pode_terreno(id, _proxima_x, _proxima_y)) {
        // Está tentando pousar em água - forçar decolagem
        if (estado == "pousando") {
            estado = "movendo";
            altura_voo = 10; // Forçar altura mínima
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("⚠️ F-6: Tentativa de pouso em água bloqueada - decolando");
            }
        } else if (estado == "pousado") {
            // Já está pousado em água - forçar decolagem imediata
            estado = "decolando";
            altura_voo = 5;
            velocidade_atual = 2; // Velocidade mínima para decolar
            // Tentar encontrar terra próxima
            var _terra_proxima = scr_encontrar_terra_proxima(id, x, y, 1000);
            if (_terra_proxima != noone && array_length(_terra_proxima) >= 2) {
                destino_x = _terra_proxima[0];
                destino_y = _terra_proxima[1];
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("⚠️ F-6: Pousado em água - decolando para terra próxima");
                }
            }
        }
        // Não aplicar movimento se não pode estar no terreno
        exit;
    }
}

// Aplicar movimento se passou na validação
x = _proxima_x;
y = _proxima_y;

// --- 4. SISTEMA DE CAÇA ATIVA (CONTROLADO PELO PRESIDENTE) ---
// ✅ CORREÇÃO: Apenas atacar quando está em movimento ordenado pelo presidente
// Não procurar inimigos quando está pousado ou pousando (aguardando ordem)
if (modo_ataque && estado == "movendo") {
    // Usar scr_buscar_inimigo para encontrar alvos apenas quando está se movendo por ordem
    var _alvo_encontrado = scr_buscar_inimigo(x, y, radar_alcance, nacao_proprietaria);
    if (instance_exists(_alvo_encontrado)) {
        estado_anterior = estado;
        estado = "caçando";
        alvo_em_mira = _alvo_encontrado;
        destino_x = _alvo_encontrado.x;
        destino_y = _alvo_encontrado.y;
        show_debug_message("🎯 F-6 (presidente) encontrou alvo durante movimento: " + object_get_name(_alvo_encontrado.object_index));
    }
}

// ✅ CORREÇÃO: Apenas quando está movendo (ordem do presidente) pode entrar em modo de caça
// Removido "patrulhando" para evitar que F6 patrulhe sozinho
if (estado == "movendo") {
    // Detectar inimigos aéreos primeiro (prioridade máxima)
    var _inimigo_aereo = noone;
    var _inimigo_terrestre = noone;
    var _dist_aereo = radar_alcance + 1;
    var _dist_terrestre = radar_alcance + 1;
    
    // Buscar helicópteros militares inimigos
    with (obj_helicoptero_militar) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) { // Apenas helicópteros do jogador
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.radar_alcance && _dist < _dist_aereo) {
                _inimigo_aereo = id;
                _dist_aereo = _dist;
            }
        }
    }
    
    // Buscar caças F-5 inimigos
    with (obj_caca_f5) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) { // Apenas aviões do jogador
            var _dist = point_distance(other.x, other.y, x, y);
            if (_dist <= other.radar_alcance && _dist < _dist_aereo) {
                _inimigo_aereo = id;
                _dist_aereo = _dist;
            }
        }
    }
    
    // Buscar inimigos terrestres se não há alvos aéreos
    if (!instance_exists(_inimigo_aereo)) {
        with (obj_infantaria) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.alcance_missil_ar_terra && _dist < _dist_terrestre) {
                    _inimigo_terrestre = id;
                    _dist_terrestre = _dist;
                }
            }
        }
        
        with (obj_tanque) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.alcance_missil_ar_terra && _dist < _dist_terrestre) {
                    _inimigo_terrestre = id;
                    _dist_terrestre = _dist;
                }
            }
        }
        
        with (obj_blindado_antiaereo) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.alcance_missil_ar_terra && _dist < _dist_terrestre) {
                    _inimigo_terrestre = id;
                    _dist_terrestre = _dist;
                }
            }
        }
    }
    
    // Se encontrou um inimigo, entrar em modo de caça
    if (instance_exists(_inimigo_aereo) || instance_exists(_inimigo_terrestre)) {
        var _alvo = instance_exists(_inimigo_aereo) ? _inimigo_aereo : _inimigo_terrestre;
        var _tipo_alvo = instance_exists(_inimigo_aereo) ? "aéreo" : "terrestre";
        
        show_debug_message("🎯 F-6 detectou alvo " + _tipo_alvo + "! Entrando em modo de caça!");
        
        // Entrar em modo de caça
        estado_anterior = estado; // Guarda o estado anterior
        estado = "caçando";
        alvo_em_mira = _alvo;
        destino_x = _alvo.x;
        destino_y = _alvo.y;
        
        // Aumentar altitude para caça (voar mais alto)
        altura_voo = min(altura_maxima, altura_voo + 5);
    }
}

// --- 5. ESTADO DE CAÇA ATIVA ---
if (estado == "caçando") {
    // Se o alvo ainda existe, perseguir ativamente
    if (instance_exists(alvo_em_mira)) {
        destino_x = alvo_em_mira.x;
        destino_y = alvo_em_mira.y;
        
        // ✅ NOVO: Atacar usando mísseis SkyFury (ar-ar) e Ironclad (ar-terra)
        // ✅ VALIDAÇÃO: Verificar se alvo é válido antes de disparar
        var _alvo_valido = (instance_exists(alvo_em_mira) && 
                            alvo_em_mira != noone && 
                            !is_undefined(alvo_em_mira.x) && 
                            !is_undefined(alvo_em_mira.y) &&
                            point_distance(x, y, alvo_em_mira.x, alvo_em_mira.y) <= radar_alcance);
        
        if (_alvo_valido && timer_ataque <= 0) {
            var _missil = noone;
            var _tipo_missil = "";
            
            // Verificar tipo de alvo para usar míssil apropriado
            var _eh_alvo_aereo = (alvo_em_mira.object_index == obj_helicoptero_militar || 
                                  alvo_em_mira.object_index == obj_caca_f5 ||
                                  alvo_em_mira.object_index == obj_f15 ||
                                  alvo_em_mira.object_index == obj_f6 ||
                                  alvo_em_mira.object_index == obj_su35 ||
                                  alvo_em_mira.object_index == obj_c100);
            
            if (_eh_alvo_aereo) {
                // ✅ Alvo aéreo - usar SkyFury (míssil ar-ar)
                _missil = scr_get_projectile_from_pool(obj_SkyFury_ar, x, y, "Instances");
                _tipo_missil = "SkyFury (ar-ar)";
            } else {
                // ✅ Alvo terrestre/naval - usar Ironclad (míssil ar-terra)
                _missil = scr_get_projectile_from_pool(obj_Ironclad_terra, x, y, "Instances");
                _tipo_missil = "Ironclad (ar-terra)";
            }
            
            if (instance_exists(_missil)) {
                // ✅ VALIDAÇÃO: Verificar se alvo ainda existe antes de atribuir
                if (instance_exists(alvo_em_mira)) {
                    _missil.target = alvo_em_mira;
                    _missil.alvo = alvo_em_mira;
                    _missil.dono = id;
                    
                    show_debug_message("🚀 F-6 lançou " + _tipo_missil + " em " + object_get_name(alvo_em_mira.object_index) + "!");
                    timer_ataque = intervalo_ataque;
                } else {
                    // Alvo desapareceu - destruir míssil
                    scr_return_projectile_to_pool(_missil);
                    show_debug_message("⚠️ F-6: Alvo desapareceu antes de configurar míssil");
                }
            } else {
                show_debug_message("⚠️ ERRO: F-6 falhou ao criar míssil " + _tipo_missil);
            }
        }
    } 
    // Se o alvo foi destruído, retornar ao estado anterior ou aguardar ordem do presidente
    else {
        show_debug_message("✅ Alvo destruído! F-6 retornando para: " + estado_anterior);
        // ✅ CORREÇÃO: Se estava patrulhando, não voltar para patrulha automática
        // Voltar para "movendo" se tinha destino, ou "pousando" se não tinha
        if (estado_anterior == "patrulhando") {
            // Se tinha destino definido pelo presidente, continuar para lá
            if (point_distance(x, y, destino_x, destino_y) > 20) {
                estado = "movendo";
            } else {
                // Sem destino - pousar e aguardar nova ordem
                estado = "pousando";
                show_debug_message("🛬 F-6: Aguardando nova ordem do presidente.");
            }
        } else {
            estado = estado_anterior;
        }
        alvo_em_mira = noone;
        // Reduzir altitude de volta ao normal
        altura_voo = max(0, altura_voo - 3);
    }
    
    // Reduzir timer de ataque
    if (timer_ataque > 0) {
        timer_ataque--;
    }
}

// --- 6. SISTEMA DE DEBUG DE VIDA ---
// Mostrar informações de vida periodicamente (a cada 3 segundos)
if (modo_teste && (game_get_speed(gamespeed_fps) % 180 == 0)) { // 180 frames = 3 segundos a 60 FPS
    var _vida_percentual = (hp_atual / hp_max) * 100;
    show_debug_message("🛩️ F-6 Status: " + string(hp_atual) + "/" + string(hp_max) + " HP (" + string(_vida_percentual) + "%) | Estado: " + estado);
    
    if (estado == "caçando" && instance_exists(alvo_em_mira)) {
        var _dist_alvo = point_distance(x, y, alvo_em_mira.x, alvo_em_mira.y);
        show_debug_message("🎯 Caçando: " + string(alvo_em_mira.object_index) + " | Distância: " + string(_dist_alvo) + "px");
    }
}

// --- 7. VERIFICAÇÃO DE DESTRUIÇÃO ---
if (hp_atual <= 0) {
    show_debug_message("💥 F-6 DESTRUÍDO! HP: " + string(hp_atual) + "/" + string(hp_max));
    show_debug_message("🎯 Teste de sistema de combate concluído!");
    
    // ✅ NOVO: Criar avião morto antes de destruir
    scr_criar_aviao_morto(x, y, image_angle, sprite_index);
    
    instance_destroy();
}