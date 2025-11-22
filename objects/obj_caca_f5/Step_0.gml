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
// --- 2. SISTEMA OTIMIZADO: AQUISIÇÃO DE ALVO (PRIORIDADE MÁXIMA) ---
// ======================================================================
// ✅ OTIMIZAÇÃO: Buscar alvos periodicamente (não a cada frame)
if (timer_busca_alvo > 0) {
    timer_busca_alvo--;
}

// Se o modo ataque está ativo E o avião não está pousando/decolando E não está já atacando...
if (modo_ataque && estado != "pousando" && estado != "decolando" && estado != "atacando") {
    
    // ✅ Buscar alvos apenas periodicamente (otimização)
    if (timer_busca_alvo <= 0) {
        timer_busca_alvo = intervalo_busca_alvo;
        
        // ✅ SISTEMA OTIMIZADO: Lista de tipos de alvo por prioridade
        var _tipos_alvo_prioridade = [
            // Prioridade 1: Aéreos (caças)
            [obj_caca_f5, "aéreo (F-5)"],
            [obj_f6, "aéreo (F-6)"],
            [obj_f15, "aéreo (F-15)"],
            [obj_su35, "aéreo (SU-35)"],
            [obj_c100, "aéreo (C-100)"],
            [obj_helicoptero_militar, "aéreo (Helicóptero)"],
            
            // Prioridade 2: Anti-aéreos (ameaça direta)
            [obj_soldado_antiaereo, "anti-aéreo (Soldado)"],
            [obj_blindado_antiaereo, "anti-aéreo (Blindado)"],
            
            // Prioridade 3: Terrestres
            [obj_tanque, "terrestre (Tanque)"],
            [obj_infantaria, "terrestre (Infantaria)"],
            
            // Prioridade 4: Estruturas militares
            [obj_aeroporto_militar, "estrutura (Aeroporto)"],
            [obj_quartel_marinha, "estrutura (Quartel Marinha)"],
            [obj_quartel, "estrutura (Quartel)"],
            
            // Prioridade 5: Estruturas civis
            [obj_banco, "estrutura (Banco)"],
            [obj_casa, "estrutura (Casa)"]
        ];
        
        var _alvo_encontrado = noone;
        var _tipo_alvo = "";
        var _menor_distancia = radar_alcance + 100; // Inicializar com valor maior que o alcance
        
        // ✅ Buscar o alvo mais próximo dentro do alcance
        for (var i = 0; i < array_length(_tipos_alvo_prioridade); i++) {
            var _tipo_obj = _tipos_alvo_prioridade[i][0];
            var _nome_tipo = _tipos_alvo_prioridade[i][1];
            
            // Buscar instância mais próxima deste tipo
            var _alvo_candidato = instance_nearest(x, y, _tipo_obj);
            
            if (instance_exists(_alvo_candidato) && _alvo_candidato != id) {
                // Verificar se é inimigo
                var _eh_inimigo = false;
                if (variable_instance_exists(_alvo_candidato, "nacao_proprietaria")) {
                    _eh_inimigo = (_alvo_candidato.nacao_proprietaria != nacao_proprietaria);
                }
                
                if (_eh_inimigo) {
                    var _dist = point_distance(x, y, _alvo_candidato.x, _alvo_candidato.y);
                    
                    // Se está dentro do alcance E é mais próximo que o anterior
                    if (_dist <= radar_alcance && _dist < _menor_distancia) {
                        _alvo_encontrado = _alvo_candidato;
                        _tipo_alvo = _nome_tipo;
                        _menor_distancia = _dist;
                    }
                }
            }
        }
        
        // Se encontrou um inimigo dentro do radar...
        if (instance_exists(_alvo_encontrado)) {
            estado_anterior = estado; // GUARDA o que estava fazendo
            estado = "atacando";      // MUDA o estado para "atacando"
            alvo_em_mira = _alvo_encontrado; // Trava a mira no inimigo
            
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("🎯 F-5: Alvo " + _tipo_alvo + " detectado! Distância: " + string(round(_menor_distancia)) + "px");
            }
        }
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
        
    // --- ESTADO DE COMBATE ---
    case "atacando":
        // ✅ VALIDAÇÃO COMPLETA DO ALVO
        var _alvo_valido = (instance_exists(alvo_em_mira) && 
                           alvo_em_mira != noone && 
                           !is_undefined(alvo_em_mira.x) && 
                           !is_undefined(alvo_em_mira.y) &&
                           alvo_em_mira.x >= 0 && 
                           alvo_em_mira.y >= 0);
        
        if (_alvo_valido) {
            // Perseguir o alvo
            destino_x = alvo_em_mira.x;
            destino_y = alvo_em_mira.y;
            
            // ✅ Verificar distância e alcance de ataque
            var _dist_alvo = point_distance(x, y, alvo_em_mira.x, alvo_em_mira.y);
            var _no_alcance_ataque = (_dist_alvo <= alcance_ataque);
            var _no_alcance_radar = (_dist_alvo <= radar_alcance);
            
            // ✅ DECREMENTAR TIMER LIT (2ª geração - apenas LIT)
            if (variable_instance_exists(id, "timer_lit") && timer_lit > 0) timer_lit--;
            
            // ✅ DISPARAR LIT quando estiver no alcance de ataque (8 segundos - 2ª geração)
            if (_no_alcance_ataque && timer_lit <= 0) {
                // ✅ CRIAR MÍSSIL LIT DIRETAMENTE (sem script para evitar erros)
                var _lit = scr_get_projectile_from_pool(obj_lit, x, y, "Instances");
                
                if (!instance_exists(_lit)) {
                    // Fallback: criar diretamente
                    _lit = instance_create_layer(x, y, "Projectiles", obj_lit);
                }
                
                if (instance_exists(_lit)) {
                    // Configurar míssil LIT básico
                    _lit.alvo = alvo_em_mira;
                    _lit.dono = id;
                    
                    // Calcular direção inicial
                    var _angulo = point_direction(x, y, alvo_em_mira.x, alvo_em_mira.y);
                    _lit.direction = _angulo;
                    _lit.image_angle = _angulo;
                    
                    _lit.sem_som = true; // ✅ Sem som no F-5
                    timer_lit = intervalo_lit;  // ✅ 8 segundos (480 frames) - 2ª geração
                    
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("🔥 F-5 disparou LIT! Alvo: " + object_get_name(alvo_em_mira.object_index) + " | Distância: " + string(round(_dist_alvo)) + "px");
                    }
                }
            }
            
            // ✅ Se saiu do alcance do radar, perder o alvo
            if (!_no_alcance_radar) {
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🔍 F-5: Alvo saiu do alcance do radar. Retornando para: " + estado_anterior);
                }
                estado = estado_anterior;
                alvo_em_mira = noone;
            }
        } 
        // ✅ Alvo foi destruído ou inválido
        else {
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("✅ F-5: Alvo destruído! Retornando para: " + estado_anterior);
            }
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
                show_debug_message("⚠️ F-5: Tentativa de pouso em água bloqueada - decolando");
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
                    show_debug_message("⚠️ F-5: Pousado em água - decolando para terra próxima");
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

// --- 5. LÓGICA DO TIMER DE ATAQUE ---
if (timer_ataque > 0) {
    timer_ataque--;
}