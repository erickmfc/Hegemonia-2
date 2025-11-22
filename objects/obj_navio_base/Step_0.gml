/// @description Lógica principal do navio (movimento, ataque, patrulha)

// --- 1. PROCESSAR INPUTS DO JOGADOR (SE SELECIONADO) ---
if (selecionado) {
    // Comandos de Modo (P/O) - adaptados para lancha
    if (keyboard_check_pressed(ord("P"))) { 
        modo_combate = LanchaMode.PASSIVO; 
        show_debug_message("🛡️ " + nome_unidade + " em Modo PASSIVO");
    }
    if (keyboard_check_pressed(ord("O"))) { 
        modo_combate = LanchaMode.ATAQUE; 
        show_debug_message("⚔️ " + nome_unidade + " em Modo ATAQUE AGRESSIVO");
    }

    // Comando de Parar (L) - adaptado para lancha
    if (keyboard_check_pressed(ord("L"))) {
        estado = LanchaState.PARADO;
        alvo_unidade = noone;
        show_debug_message("⏹️ " + nome_unidade + " recebeu ordem para PARAR");
    }
    
    // Comandos K, clique esquerdo e clique direito agora são gerenciados pelo obj_input_manager
    // para evitar conflitos e manter o modo de patrulha persistente
}

// ======================================================================
// --- 2. LÓGICA DE AQUISIÇÃO DE ALVO (ADAPTADA PARA NAVAL) ---
// ======================================================================
// Se o modo ataque está ativo E a lancha não está parada E não está já atacando alguém...
if (modo_combate == LanchaMode.ATAQUE && estado != LanchaState.ATACANDO) {
    // Prioriza alvos navais (qualquer objeto filho de obj_navio_base), depois aéreos e terrestres
    var _alvo_submarino = noone;
    // Submarino desabilitado (obj_submarino não existe no projeto)
    
    // ✅ CORREÇÃO: Buscar piratas explicitamente (prioridade alta)
    var _alvo_pirata = noone;
    var _menor_dist_pirata = radar_alcance + 100;
    
    // Buscar navios piratas
    if (object_exists(obj_navio_pirata)) {
        with (obj_navio_pirata) {
            if (nacao_proprietaria == 3) {  // Piratas são sempre inimigos
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.radar_alcance && _dist < _menor_dist_pirata) {
                    _menor_dist_pirata = _dist;
                    _alvo_pirata = id;
                }
            }
        }
    }
    if (object_exists(obj_navio_pirata2)) {
        with (obj_navio_pirata2) {
            if (nacao_proprietaria == 3) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.radar_alcance && _dist < _menor_dist_pirata) {
                    _menor_dist_pirata = _dist;
                    _alvo_pirata = id;
                }
            }
        }
    }
    if (object_exists(obj_navio_pirata3)) {
        with (obj_navio_pirata3) {
            if (nacao_proprietaria == 3) {
                var _dist = point_distance(other.x, other.y, x, y);
                if (_dist <= other.radar_alcance && _dist < _menor_dist_pirata) {
                    _menor_dist_pirata = _dist;
                    _alvo_pirata = id;
                }
            }
        }
    }
    
    var _alvo_naval = noone;
    if (object_exists(obj_navio_base)) {
        _alvo_naval = instance_nearest(x, y, obj_navio_base);
    }
    
    // ✅ Priorizar piratas se encontrados
    if (instance_exists(_alvo_pirata)) {
        _alvo_naval = _alvo_pirata;  // Substituir alvo naval por pirata
    }
    var _alvo_f6 = noone;
    if (object_exists(obj_f6)) {
        _alvo_f6 = instance_nearest(x, y, obj_f6);
    }
    var _alvo_f5 = noone;
    if (object_exists(obj_caca_f5)) {
        _alvo_f5 = instance_nearest(x, y, obj_caca_f5);
    }
    var _alvo_helicoptero = noone;
    if (object_exists(obj_helicoptero_militar)) {
        _alvo_helicoptero = instance_nearest(x, y, obj_helicoptero_militar);
    }
    // ✅ CORREÇÃO: obj_inimigo removido - usar apenas obj_infantaria
    var _alvo_terrestre = noone;
    var _alvo_infantaria = noone;
    if (object_exists(obj_infantaria)) {
        _alvo_infantaria = instance_nearest(x, y, obj_infantaria);
    }
    
    var _alvo_encontrado = noone;
    var _tipo_alvo = "";
    
    // Verifica submarinos primeiro (prioridade MÁXIMA para míssil Ice)
    if (instance_exists(_alvo_submarino) && _alvo_submarino.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_submarino.x, _alvo_submarino.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_submarino;
        _tipo_alvo = "submarino inimigo";
    }
    // Verifica alvos navais (prioridade alta)
    // ✅ CORREÇÃO: Incluir piratas (nação 3) como inimigos
    else if (instance_exists(_alvo_naval) && _alvo_naval != id) {
        var _eh_inimigo = false;
        // Piratas (nação 3) são inimigos de todos
        if (_alvo_naval.nacao_proprietaria == 3) {
            _eh_inimigo = (nacao_proprietaria != 3);
        } else if (nacao_proprietaria == 3) {
            // Se sou pirata, todos os outros são inimigos
            _eh_inimigo = (_alvo_naval.nacao_proprietaria != 3);
        } else {
            // Lógica normal: inimigo se nação diferente
            _eh_inimigo = (_alvo_naval.nacao_proprietaria != nacao_proprietaria);
        }
        
        if (_eh_inimigo && point_distance(x, y, _alvo_naval.x, _alvo_naval.y) <= radar_alcance) {
            _alvo_encontrado = _alvo_naval; // Pode ser Lancha, Constellation, Piratas, etc.
            _tipo_alvo = "naval (" + object_get_name(_alvo_naval.object_index) + ")";
        }
    } else if (instance_exists(_alvo_f6) && _alvo_f6.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_f6.x, _alvo_f6.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_f6;
        _tipo_alvo = "aéreo (F-6 inimigo)";
    } else if (instance_exists(_alvo_f5) && _alvo_f5.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_f5.x, _alvo_f5.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_f5;
        _tipo_alvo = "aéreo (F-5 inimigo)";
    } else if (instance_exists(_alvo_helicoptero) && _alvo_helicoptero.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_helicoptero.x, _alvo_helicoptero.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_helicoptero;
        _tipo_alvo = "aéreo (Helicóptero inimigo)";
    } else if (instance_exists(_alvo_infantaria) && _alvo_infantaria.nacao_proprietaria == 2 && point_distance(x, y, _alvo_infantaria.x, _alvo_infantaria.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_infantaria;
        _tipo_alvo = "inimigo (infantaria)";
    } else if (instance_exists(_alvo_terrestre) && _alvo_terrestre.nacao_proprietaria != nacao_proprietaria && point_distance(x, y, _alvo_terrestre.x, _alvo_terrestre.y) <= radar_alcance) {
        _alvo_encontrado = _alvo_terrestre;
        _tipo_alvo = "terrestre inimigo";
    }
    
    // Se encontrou um inimigo dentro do radar...
    if (instance_exists(_alvo_encontrado)) {
        estado_anterior = estado; // GUARDA o que estava fazendo (ex: "patrulhando")
        estado = LanchaState.ATACANDO;      // MUDA o estado para "atacando"
        alvo_unidade = _alvo_encontrado; // Trava a mira no inimigo
        
        // DEBUG EXTRA PARA INDEPENDENCE
        if (nome_unidade == "Independence") {
            show_debug_message("🎯🎯🎯 INDEPENDENCE detectou alvo " + _tipo_alvo + "! Estado agora: ATACANDO");
        } else {
            show_debug_message("🎯 " + nome_unidade + " detectou alvo " + _tipo_alvo + "! Interrompendo tarefa para atacar.");
        }
    }
}
// ======================================================================

// --- 3. MÁQUINA DE ESTADOS (ADAPTADA PARA LANCHA) ---
// Gerencia as transições e lógicas de cada estado
switch (estado) {
    case LanchaState.PARADO:
        // Não faz nada, espera ordens.
        is_moving = false; // ✅ CORREÇÃO: Garantir que is_moving está false quando parado
        break;

    case LanchaState.MOVENDO:
        // A lógica de movimento está na seção 4. Se chegar ao destino, a seção 4 o colocará em PARADO.
        break;

    case LanchaState.PATRULHANDO:
        // Se chegou ao ponto atual, vai para o próximo
        if (point_distance(x, y, destino_x, destino_y) < 20) {
            func_proximo_ponto();
            show_debug_message("🚢 " + nome_unidade + " indo para o próximo ponto de patrulha.");
        }
        break;
        
           // --- ESTADO DE COMBATE NAVAL COM ORBITAÇÃO DINÂMICA ---
           case LanchaState.ATACANDO:
               if (instance_exists(alvo_unidade)) {
                   var _distancia_alvo = point_distance(x, y, alvo_unidade.x, alvo_unidade.y);
                   
                   // ✅ SISTEMA DE ORBITAÇÃO DINÂMICA
                   if (_distancia_alvo > missil_alcance) {
                       // Fora do alcance - persegue o inimigo
                       destino_x = alvo_unidade.x;
                       destino_y = alvo_unidade.y;
                   } else {
                       // ✅ DENTRO DO ALCANCE - Sistema de órbita inteligente
                       
                       // Distância ideal para tiro (90% do alcance máximo)
                       var _distancia_ideal = missil_alcance * 0.9;
                       
                       // Verifica se inimigo está se movendo
                       var _inimigo_se_movendo = false;
                       
                       // Verifica velocidade_atual se existir
                       if (variable_instance_exists(alvo_unidade, "velocidade_atual")) {
                           _inimigo_se_movendo = (alvo_unidade.velocidade_atual > 0);
                       }
                       
                       // Verifica estado se existir
                       if (variable_instance_exists(alvo_unidade, "estado")) {
                           _inimigo_se_movendo = _inimigo_se_movendo || (alvo_unidade.estado != "parado");
                       }
                       
                       // Fallback: verifica se está se movendo pela distância
                       if (!_inimigo_se_movendo) {
                           // Se não tem variáveis de movimento, assume que está se movendo se mudou de posição
                           _inimigo_se_movendo = (point_distance(x, y, alvo_unidade.x, alvo_unidade.y) > 5);
                       }
                       
                       if (_inimigo_se_movendo) {
                           // ✅ Inimigo se movendo - orbita para acompanhar
                           var _angulo_atual = point_direction(alvo_unidade.x, alvo_unidade.y, x, y);
                           var _angulo_orbita = _angulo_atual + 5; // Rotaciona 5 graus por frame
                           
                           destino_x = alvo_unidade.x + lengthdir_x(_distancia_ideal, _angulo_orbita);
                           destino_y = alvo_unidade.y + lengthdir_y(_distancia_ideal, _angulo_orbita);
                       } else {
                           // ✅ Inimigo parado - PARA completamente
                           // Não atualiza destino_x e destino_y - lancha fica parada para atirar
                       }
                   }
                   
                   // Sistema de tiro à distância com mísseis
                   // Permitir que objetos individuais desabilitem mísseis via flag `pode_disparar_missil`
                   var _nome_obj = object_get_name(object_index);
                   var _allow_missiles = true;
                   if (variable_instance_exists(id, "pode_disparar_missil")) _allow_missiles = pode_disparar_missil;

                   // ✅ SISTEMA DE MÍSSEIS MÚLTIPLOS PARA INDEPENDENCE (Hash, Sky, Lit)
                   if (_nome_obj == "obj_Independence" && _distancia_alvo <= missil_alcance && _allow_missiles) {
                       var _nome_alvo = object_get_name(alvo_unidade.object_index);
                       
                       // Detectar tipo de alvo
                       var _alvo_aereo = (_nome_alvo == "obj_helicoptero_militar" || 
                                         _nome_alvo == "obj_caca_f5" ||
                                         _nome_alvo == "obj_f6" ||
                                         _nome_alvo == "obj_f15" ||
                                         _nome_alvo == "obj_su35" ||
                                         _nome_alvo == "obj_c100" ||
                                         _nome_alvo == "obj_caca_f35");
                       
                       var _alvo_terrestre = (_nome_alvo == "obj_infantaria" ||
                                             _nome_alvo == "obj_tanque" ||
                                             _nome_alvo == "obj_soldado_antiaereo" ||
                                             _nome_alvo == "obj_blindado_antiaereo" ||
                                             _nome_alvo == "obj_navio_base" ||
                                             _nome_alvo == "obj_Constellation" ||
                                             _nome_alvo == "obj_RonaldReagan");
                       
                       var _alvo_submarino = (_nome_alvo == "obj_submarino_base" ||
                                            _nome_alvo == "obj_wwhendrick");
                       
                       // ✅ SKY (3 segundos) - Para alvos aéreos
                       if (_alvo_aereo && variable_instance_exists(id, "timer_sky") && timer_sky <= 0) {
                           var _missil_sky = scr_get_projectile_from_pool(obj_SkyFury_ar, x, y, "Instances");
                           if (!instance_exists(_missil_sky)) {
                               _missil_sky = instance_create_layer(x, y, "Instances", obj_SkyFury_ar);
                           }
                           if (instance_exists(_missil_sky) && instance_exists(alvo_unidade)) {
                               _missil_sky.alvo = alvo_unidade;
                               _missil_sky.target = alvo_unidade;
                               _missil_sky.dono = id;
                               timer_sky = intervalo_sky; // 3 segundos
                           }
                       }
                       
                       // ✅ HASH (6 segundos) - Para alvos terrestres e submarinos
                       if ((_alvo_terrestre || _alvo_submarino) && variable_instance_exists(id, "timer_hash") && timer_hash <= 0) {
                           var _missil_hash = instance_create_layer(x, y, "Instances", obj_hash);
                           if (instance_exists(_missil_hash) && instance_exists(alvo_unidade)) {
                               _missil_hash.alvo = alvo_unidade;
                               _missil_hash.target = alvo_unidade;
                               _missil_hash.dono = id;
                               timer_hash = intervalo_hash; // 6 segundos
                           }
                       }
                       
                       // ✅ LIT (7 segundos) - Para todos os tipos de alvo
                       if (variable_instance_exists(id, "timer_lit") && timer_lit <= 0) {
                           var _missil_lit = scr_get_projectile_from_pool(obj_lit, x, y, "Instances");
                           if (!instance_exists(_missil_lit)) {
                               _missil_lit = instance_create_layer(x, y, "Instances", obj_lit);
                           }
                           if (instance_exists(_missil_lit) && instance_exists(alvo_unidade)) {
                               _missil_lit.alvo = alvo_unidade;
                               _missil_lit.dono = id;
                               var _angulo = point_direction(x, y, alvo_unidade.x, alvo_unidade.y);
                               _missil_lit.direction = _angulo;
                               _missil_lit.image_angle = _angulo;
                               timer_lit = intervalo_lit; // 7 segundos
                           }
                       }
                   } else if (_distancia_alvo <= missil_alcance && reload_timer <= 0 && _allow_missiles) {
                       // Sistema padrão para outros navios (Constellation, etc)
                       // Determinar tipo de míssil baseado no alvo
                       var _missil_obj = obj_tiro_simples; // Padrão
                       var _missil_nome = "Tiro Simples";
                       
                       // === PRIMEIRO: Verificar se é um submarino ===
                       var _nome_alvo = object_get_name(alvo_unidade.object_index);
                       if (_nome_alvo == "obj_submarino") {
                           // Alvo é submarino - usar Míssil Ice anti-submarino
                           _missil_obj = obj_missel_ice;
                           _missil_nome = "Míssil Ice (Anti-Submarino)";
                       } else {
                           // Verificar se é Constellation (usa mísseis especiais)
                           if (_nome_obj == "obj_Constellation") {
                               // Verificar tipo de alvo para escolher míssil
                               if (_nome_alvo == "obj_helicoptero_militar" || 
                                   _nome_alvo == "obj_caca_f5" ||
                                   _nome_alvo == "obj_f6") {
                                   // Alvo aéreo - usar SkyFury
                                   _missil_obj = obj_SkyFury_ar;
                                   _missil_nome = "SkyFury Ar-Ar";
                               } else {
                                   // Alvo terrestre/naval - usar Ironclad
                                   _missil_obj = obj_Ironclad_terra;
                                   _missil_nome = "Ironclad Terra-Terra";
                               }
                           }
                       }
                       
                       var _missil = instance_create_layer(x, y, "Instances", _missil_obj);
                       if (instance_exists(_missil)) {
                           _missil.dono = id;
                           _missil.direction = point_direction(x, y, alvo_unidade.x, alvo_unidade.y);
                           
                           // Configurações específicas para cada tipo de míssil
                           if (_missil_obj == obj_tiro_simples) {
                               // Míssil simples padrão
                               _missil.target = alvo_unidade;
                               _missil.alvo = alvo_unidade;
                               _missil.dano = 25;
                               _missil.speed = 8;
                           } else if (_missil_obj == obj_missel_ice) {
                               // Míssil Ice anti-submarino
                               _missil.target = alvo_unidade;
                               _missil.alvo = alvo_unidade;
                               // Dano já configurado no Create (75 base + bônus)
                               show_debug_message("❄️ Míssil Ice configurado contra submarino!");
                           } else if (_missil_obj == obj_SkyFury_ar || _missil_obj == obj_Ironclad_terra) {
                               // Mísseis especiais do Constellation
                               _missil.target = alvo_unidade;
                               _missil.alvo = alvo_unidade;
                               show_debug_message("🎯 Míssil especial configurado: " + _missil_nome);
                           }
                           
                           reload_timer = reload_time; // Reseta o timer
                           show_debug_message("🚀 " + nome_unidade + " disparou " + _missil_nome + " contra " + _nome_alvo + "! Distância: " + string(round(_distancia_alvo)) + "px");
                       }
                   }
               } else {
                   show_debug_message("✅ Alvo destruído! " + nome_unidade + " retornando para estado anterior: " + string(estado_anterior));
                   estado = estado_anterior;
                   alvo_unidade = noone;
               }
               break;
}

// --- 4. LÓGICA DE MOVIMENTO NAVAL (ADAPTADA DO F5) ---
// ✅ CORREÇÃO: Definir is_moving como variável de instância
is_moving = (estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO || (estado == LanchaState.ATACANDO && point_distance(x, y, destino_x, destino_y) > 5));

if (is_moving) {
    var _dist = point_distance(x, y, destino_x, destino_y);
    if (_dist > 5) {
        var _dir = point_direction(x, y, destino_x, destino_y);
        // Rotação suave
        image_angle = angle_difference(image_angle, _dir) * -0.1 + image_angle;
        
        // ✅ VALIDAÇÃO: Verificar se próxima posição é água antes de mover
        var _novo_x = x + lengthdir_x(velocidade_movimento, _dir);
        var _novo_y = y + lengthdir_y(velocidade_movimento, _dir);
        
        if (!scr_unidade_pode_terreno(id, _novo_x, _novo_y)) {
            // Próxima posição é terra - tentar desviar
            var _dir_desvio = _dir + 45; // Tentar 45 graus à direita
            _novo_x = x + lengthdir_x(velocidade_movimento * 0.7, _dir_desvio);
            _novo_y = y + lengthdir_y(velocidade_movimento * 0.7, _dir_desvio);
            
            if (!scr_unidade_pode_terreno(id, _novo_x, _novo_y)) {
                // Tentar à esquerda
                _dir_desvio = _dir - 45;
                _novo_x = x + lengthdir_x(velocidade_movimento * 0.7, _dir_desvio);
                _novo_y = y + lengthdir_y(velocidade_movimento * 0.7, _dir_desvio);
                
                if (!scr_unidade_pode_terreno(id, _novo_x, _novo_y)) {
                    // Não conseguiu desviar - parar
                    show_debug_message("❌ " + nome_unidade + ": Caminho bloqueado por terra!");
                    estado = LanchaState.PARADO;
                    is_moving = false;
                }
            }
            if (is_moving) {
                show_debug_message("🔄 " + nome_unidade + ": Desviando de terra");
            }
        }
        
        // Movimento (se ainda estiver movendo)
        if (is_moving) {
            x = _novo_x;
            y = _novo_y;
        }
    } else {
        // Chegou ao destino (se estava se movendo)
        if (estado == LanchaState.MOVENDO) {
            estado = LanchaState.PARADO;
            is_moving = false; // ✅ CORREÇÃO: Parar de mostrar linha quando chegou
            show_debug_message("🚢 " + nome_unidade + " chegou ao destino. Estado: PARADO");
        }
    }
} else {
    // ✅ CORREÇÃO: Garantir que is_moving está false quando não está se movendo
    is_moving = false;
}

// --- 5. LÓGICA DO TIMER DE ATAQUE ---
if (reload_timer > 0) {
    reload_timer--;
}

// --- 6. VERIFICAR DESTRUIÇÃO E CRIAR NAVIO MORTO ---
if (hp_atual <= 0) {
    // ✅ Criar navio morto antes de destruir
    var _script_navio_morto = asset_get_index("scr_criar_navio_morto");
    if (_script_navio_morto != -1) {
        scr_criar_navio_morto(id);
    }
    instance_destroy();
}