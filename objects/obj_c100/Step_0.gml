// ===============================================
// HEGEMONIA GLOBAL - C-100 Transporte (Step)
// ===============================================

// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando" || estado == "embarcando" || estado == "desembarcando" ||
                              modo_transporte == "embarcando" || modo_transporte == "desembarcando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        // Movimento simplificado para aviões
        if (estado == "patrulhando" || estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            // Movimento básico mantendo direção
            if (variable_instance_exists(id, "velocidade_atual")) {
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
    // ✅ CORREÇÃO: Bloquear comandos de movimento quando em modo de embarque
    if (modo_receber_carga) {
        // Cancelar qualquer movimento em andamento
        if (estado == "movendo" || estado == "patrulhando") {
            estado = "pousado";
            velocidade_atual = 0;
            show_debug_message("🚁 C-100: Movimento cancelado - modo embarque ativo");
        }
    }
    
        // Comando P: Sistema de 3 Modos (FECHADO -> EMBARCANDO -> EMBARCADO -> FECHADO)
        if (keyboard_check_pressed(ord("P"))) { 
            if (altura_voo == 0 && estado == "pousado") {
                switch (modo_transporte) {
                    case "fechado":
                        // FECHADO -> EMBARCANDO
                        modo_transporte = "embarcando";
                        modo_receber_carga = true;
                        pode_voar = false;
                        show_debug_message("🚁 C-100: Modo EMBARCANDO - Portas abertas");
                        break;
                        
                    case "embarcando":
                        // EMBARCANDO -> EMBARCADO
                        modo_transporte = "embarcado";
                        modo_receber_carga = false;
                        pode_voar = true;
                        show_debug_message("🚁 C-100: Modo EMBARCADO - Pronto para voar");
                        break;
                        
                    case "embarcado":
                        // EMBARCADO -> DESEMBARCANDO
                        if (carga_usada > 0) {
                            modo_transporte = "desembarcando";
                            desembarcar_tropas();
                            show_debug_message("🚁 C-100: Desembarcando tropas...");
                        } else {
                            // Se não tem carga, volta direto para FECHADO
                            modo_transporte = "fechado";
                            show_debug_message("🚁 C-100: Modo FECHADO - Sem carga");
                        }
                        break;
                        
                    case "desembarcando":
                        // DESEMBARCANDO -> FECHADO
                        modo_transporte = "fechado";
                        pode_voar = true;
                        show_debug_message("🚁 C-100: Modo FECHADO - Portas fechadas");
                        break;
                }
            } else {
                show_debug_message("🚁 C-100: Pousar para embarcar/desembarcar");
            }
        }
    
    // Comando O: Flares (defesa)
    if (keyboard_check_pressed(ord("O"))) { 
        if (!modo_evadindo && flare_cooldown <= 0) {
            ativar_flares();
            show_debug_message("🚁 C-100: Flares ativados");
        } else if (flare_cooldown > 0) {
            show_debug_message("🚁 C-100: Flares em cooldown (" + string(flare_cooldown) + " frames)");
        }
    }
    
    // Comando L: Pouso (herdado do F-5)
    if (keyboard_check_pressed(ord("L")) && estado != "pousado") {
        estado = "pousando";
    }
}

// --- 2. MÁQUINA DE ESTADOS (SEM ATAQUE) ---
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
        
    // C-100 NÃO TEM ESTADO "atacando" - é transporte puro
}

// --- 3. LÓGICA DE MOVIMENTO E ALTITUDE (HERDADA) ---
var _is_flying = (estado == "movendo" || estado == "patrulhando" || estado == "decolando");
var _is_landing = (estado == "pousando");

// ✅ CORREÇÃO: Não voar quando não pode voar (portas abertas)
if (_is_flying && pode_voar) {
    altura_voo = min(altura_maxima, altura_voo + 0.3);
    
    var _dist = point_distance(x, y, destino_x, destino_y);
    if (_dist > 5) {
        var _dir = point_direction(x, y, destino_x, destino_y);
        var _diff = angle_difference(_dir, image_angle);
        image_angle += clamp(_diff, -velocidade_rotacao, velocidade_rotacao);
        velocidade_atual = min(velocidade_maxima, velocidade_atual + aceleracao);
    }
} else { // Pousado, Pousando ou Definindo Patrulha
    // ✅ CORREÇÃO: Parar completamente quando não pode voar
    if (!pode_voar) {
        velocidade_atual = 0;
        estado = "pousado";
        altura_voo = 0;
    } else {
        velocidade_atual = max(0, velocidade_atual - desaceleracao);
        if (_is_landing || estado == "pousado") {
            altura_voo = max(0, altura_voo - 0.3);
        }
        if (altura_voo == 0 && velocidade_atual == 0 && estado == "pousando") {
            estado = "pousado";
        }
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
            pode_voar = true;
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("⚠️ C-100: Tentativa de pouso em água bloqueada - decolando");
            }
        } else if (estado == "pousado") {
            // Já está pousado em água - forçar decolagem imediata
            estado = "decolando";
            altura_voo = 5;
            pode_voar = true;
            velocidade_atual = 2; // Velocidade mínima para decolar
            // Tentar encontrar terra próxima
            var _terra_proxima = scr_encontrar_terra_proxima(id, x, y, 1000);
            if (_terra_proxima != noone && array_length(_terra_proxima) >= 2) {
                destino_x = _terra_proxima[0];
                destino_y = _terra_proxima[1];
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("⚠️ C-100: Pousado em água - decolando para terra próxima");
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

// --- 4. SISTEMA DE EMBARQUE SIMPLIFICADO (10 UNIDADES MÁXIMO) ---
if (modo_receber_carga && altura_voo == 0 && estado == "pousado") {
    // ✅ CORREÇÃO: Verificar unidades terrestres específicas em vez de "all" (incluindo Abrams)
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    var _tipos_embarcaveis = [obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo];
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        array_push(_tipos_embarcaveis, _obj_abrams); // ✅ NOVO: Adicionar Abrams
    }
    var _unidade_proxima = noone;
    
    // ✅ AUMENTADO: Procurar unidades próximas de cada tipo com raio maior (30% maior que antes)
    var _raio_deteccao = 130; // ✅ AUMENTADO 30%: era 100, agora 130 (100 * 1.3 = 130) para pegar múltiplas unidades
    for (var i = 0; i < array_length(_tipos_embarcaveis); i++) {
        var _tipo = _tipos_embarcaveis[i];
        if (object_exists(_tipo)) {
            var _inst = instance_position(x, y, _tipo);
            if (_inst != noone && point_distance(x, y, _inst.x, _inst.y) <= _raio_deteccao) {
                _unidade_proxima = _inst;
                break;
            }
        }
    }
    
    if (instance_exists(_unidade_proxima)) {
        var _nome_obj = object_get_name(_unidade_proxima.object_index);
        show_debug_message("🔍 C-100: Detectou unidade próxima: " + _nome_obj);
        
        if (eh_unidade_embarcavel(_unidade_proxima)) {
            show_debug_message("✅ C-100: Unidade é embarcável!");
            var _peso = calcular_peso_unidade(_unidade_proxima);
            if (embarcar_unidade(_unidade_proxima, _peso)) {
                // Atualizar penalidades se necessário
                atualizar_penalidade_carga();
            }
        } else {
            show_debug_message("❌ C-100: Unidade NÃO é embarcável: " + _nome_obj);
            // Debug adicional para entender por que não é embarcável
            if (variable_instance_exists(_unidade_proxima, "nacao_proprietaria")) {
                show_debug_message("   Nação da unidade: " + string(_unidade_proxima.nacao_proprietaria) + " | Nação do C-100: " + string(nacao_proprietaria));
            } else {
                show_debug_message("   Unidade não tem nacao_proprietaria definida!");
            }
        }
    }
    
    // ✅ CORREÇÃO: Sistema de embarque múltiplo
    // Verificar se há unidades selecionadas tentando embarcar
    if (variable_global_exists("unidades_selecionadas") && ds_list_size(global.unidades_selecionadas) > 0) {
        var _unidades_embarcadas = 0;
        
        // ✅ CORREÇÃO: Também verificar unidades próximas mesmo que não estejam selecionadas (incluindo Abrams)
        // ✅ AUMENTADO 30%: Raio maior para pegar múltiplas unidades
        var _raio_deteccao_multipla = 130; // ✅ AUMENTADO 30%: era 100, agora 130 (100 * 1.3 = 130) para pegar múltiplas unidades
        // ✅ CORREÇÃO: Reutilizar variáveis já declaradas acima
        // _obj_abrams e _tipos_embarcaveis já foram declarados no início do bloco
        if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
            array_push(_tipos_embarcaveis, _obj_abrams); // ✅ NOVO: Adicionar Abrams
        }
        for (var j = 0; j < array_length(_tipos_embarcaveis); j++) {
            var _tipo = _tipos_embarcaveis[j];
            if (object_exists(_tipo)) {
                with (_tipo) {
                    var _dist = point_distance(other.x, other.y, x, y);
                    if (_dist <= _raio_deteccao_multipla && other.eh_unidade_embarcavel(id)) {
                        var _peso = other.calcular_peso_unidade(id);
                        if (other.embarcar_unidade(id, _peso)) {
                            other.atualizar_penalidade_carga();
                            _unidades_embarcadas++;
                            show_debug_message("✅ C-100: Unidade embarcada automaticamente!");
                        }
                    }
                }
            }
        }
        
        // Processar todas as unidades selecionadas (de trás para frente para evitar problemas de índice)
        for (var i = ds_list_size(global.unidades_selecionadas) - 1; i >= 0; i--) {
            var _unidade = global.unidades_selecionadas[| i];
            
            if (instance_exists(_unidade) && _unidade != id) {
                var _distancia = point_distance(x, y, _unidade.x, _unidade.y);
                
                // ✅ AUMENTADO 30%: Raio maior para pegar unidades selecionadas
                var _raio_selecionadas = 130; // ✅ AUMENTADO 30%: era 100, agora 130 (100 * 1.3 = 130)
                if (_distancia <= _raio_selecionadas) {
                    // Tentar embarcar a unidade se estiver dentro do raio
                    if (eh_unidade_embarcavel(_unidade)) {
                        var _peso = calcular_peso_unidade(_unidade);
                        if (embarcar_unidade(_unidade, _peso)) {
                            ds_list_delete(global.unidades_selecionadas, i); // Remove da seleção
                            _unidades_embarcadas++;
                            // Atualizar penalidades se necessário
                            atualizar_penalidade_carga();
                        }
                    }
                }
            } else if (!instance_exists(_unidade)) {
                // Remove unidades que não existem mais da seleção
                ds_list_delete(global.unidades_selecionadas, i);
            }
        }
        
        // Atualizar unidade principal se necessário
        if (ds_list_size(global.unidades_selecionadas) > 0) {
            global.unidade_selecionada = global.unidades_selecionadas[| 0];
        } else {
            global.unidade_selecionada = noone;
        }
        
        if (_unidades_embarcadas > 0) {
            show_debug_message("🚁 C-100: " + string(_unidades_embarcadas) + " unidades embarcaram!");
        }
    }
}

// --- 5. TIMERS DE FLARES ---
if (modo_evadindo) {
    flare_timer_ativo -= 1;
    if (flare_timer_ativo <= 0) {
        modo_evadindo = false;
        show_debug_message("🚁 C-100: Flares expiraram");
    }
}
if (flare_cooldown > 0) flare_cooldown -= 1;

// --- 6. APLICAR PENALIDADES DE CARGA ---
atualizar_penalidade_carga();
