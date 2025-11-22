// ===============================================
// HEGEMONIA GLOBAL - INPUT MANAGER (Step Corrigido com Patrulha Persistente)
// ===============================================

// === DEBUG: VERIFICAR SE STEP_0 ESTÁ EXECUTANDO ===
if (current_time mod 3000 < 17 && global.debug_enabled) {
    show_debug_message("✅ obj_input_manager Step_0 executando | Room: " + room_get_name(room));
}

// --- LÓGICA DE INPUT DO MOUSE (OTIMIZADA) ---
// ✅ CORREÇÃO: Usar função scr_mouse_to_world() diretamente
var _coords = scr_mouse_to_world();
var _mx = _coords[0];
var _my = _coords[1];

// ✅ CORREÇÃO: Declarar variáveis comuns uma vez no início da função para evitar duplicações
var _nacao_jogador = 1; // Jogador sempre é nação 1
var _obj_abrams = asset_get_index("obj_M1A_Abrams");
var _obj_gepard = asset_get_index("obj_gepard");

// --- MODO DE DEFINIÇÃO DE PATRULHA ---
if (instance_exists(global.definindo_patrulha_unidade)) {
    var _unidade = global.definindo_patrulha_unidade;

    // Clique esquerdo ADICIONA um ponto à rota
    if (mouse_check_button_pressed(mb_left)) {
        if (variable_instance_exists(_unidade, "pontos_patrulha") && ds_exists(_unidade.pontos_patrulha, ds_type_list)) {
            // ✅ CORREÇÃO: Verificar se é unidade terrestre ou aérea/naval
            var _eh_terrestre = (object_get_name(_unidade.object_index) == "obj_infantaria" ||
                                object_get_name(_unidade.object_index) == "obj_tanque" ||
                                object_get_name(_unidade.object_index) == "obj_soldado_antiaereo" ||
                                object_get_name(_unidade.object_index) == "obj_blindado_antiaereo");
            
            // ✅ CORREÇÃO: _obj_abrams e _obj_gepard já foram declarados no início da função
            if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object && _unidade.object_index == _obj_abrams) {
                _eh_terrestre = true;
            }
            if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object && _unidade.object_index == _obj_gepard) {
                _eh_terrestre = true;
            }
            
            if (_eh_terrestre) {
                // ✅ CORREÇÃO: Adicionar ponto apenas para unidades da MESMA CATEGORIA
                var _pontos_adicionados = 0;
                var _categoria_unidade = object_get_name(_unidade.object_index);
                
                // Adicionar para a unidade principal (que está definindo a rota)
                ds_list_add(_unidade.pontos_patrulha, [_mx, _my]);
                _pontos_adicionados++;
                
                // Adicionar apenas para unidades da mesma categoria que estão selecionadas
                if (_categoria_unidade == "obj_infantaria") {
                    with (obj_infantaria) {
                        if (selecionado && id != _unidade && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                            ds_list_add(pontos_patrulha, [_mx, _my]);
                            _pontos_adicionados++;
                        }
                    }
                } else if (_categoria_unidade == "obj_tanque") {
                    with (obj_tanque) {
                        if (selecionado && id != _unidade && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                            ds_list_add(pontos_patrulha, [_mx, _my]);
                            _pontos_adicionados++;
                        }
                    }
                } else if (_categoria_unidade == "obj_soldado_antiaereo") {
                    with (obj_soldado_antiaereo) {
                        if (selecionado && id != _unidade && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                            ds_list_add(pontos_patrulha, [_mx, _my]);
                            _pontos_adicionados++;
                        }
                    }
                } else if (_categoria_unidade == "obj_blindado_antiaereo") {
                    with (obj_blindado_antiaereo) {
                        if (selecionado && id != _unidade && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                            ds_list_add(pontos_patrulha, [_mx, _my]);
                            _pontos_adicionados++;
                        }
                    }
                } else {
                    // M1A Abrams, Gepard ou outra unidade
                    // ✅ CORREÇÃO: _obj_abrams e _obj_gepard já foram declarados no início da função
                    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object && _unidade.object_index == _obj_abrams) {
                        with (_obj_abrams) {
                            if (selecionado && id != _unidade && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                                ds_list_add(pontos_patrulha, [_mx, _my]);
                                _pontos_adicionados++;
                            }
                        }
                    }
                    if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object && _unidade.object_index == _obj_gepard) {
                        with (_obj_gepard) {
                            if (selecionado && id != _unidade && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                                ds_list_add(pontos_patrulha, [_mx, _my]);
                                _pontos_adicionados++;
                            }
                        }
                    }
                }
                
                if (_pontos_adicionados > 1) {
                    show_debug_message("📍 Ponto de patrulha adicionado para " + string(_pontos_adicionados) + " unidades da categoria " + _categoria_unidade);
                } else {
                    show_debug_message("📍 Ponto de patrulha adicionado: (" + string(_mx) + ", " + string(_my) + ")");
                }
            } else {
                // ✅ LÓGICA ORIGINAL: Para aviões/navios, adicionar apenas para a unidade principal
                ds_list_add(_unidade.pontos_patrulha, [_mx, _my]);
                show_debug_message("📍 Ponto de patrulha adicionado: (" + string(_mx) + ", " + string(_my) + ")");
            }
        } else {
            show_debug_message("❌ ERRO: pontos_patrulha não existe para " + object_get_name(_unidade.object_index));
        }
    }

    // Clique direito FINALIZA a rota e inicia a patrulha OU CANCELA
    if (mouse_check_button_pressed(mb_right)) {
        // ✅ CORREÇÃO: Sempre limpar o modo de definição, mesmo se cancelar
        var _pontos_count = 0;
        if (variable_instance_exists(_unidade, "pontos_patrulha") && ds_exists(_unidade.pontos_patrulha, ds_type_list)) {
            _pontos_count = ds_list_size(_unidade.pontos_patrulha);
        }
        
        if (_pontos_count >= 2) {
            // ✅ CORREÇÃO: Verificar se é avião ou navio primeiro (lógica original)
            var _eh_aereo_ou_naval = (object_get_name(_unidade.object_index) == "obj_caca_f5" || 
                                      object_get_name(_unidade.object_index) == "obj_f15" || 
                                      object_get_name(_unidade.object_index) == "obj_su35" ||
                                      object_get_name(_unidade.object_index) == "obj_caca_f35" ||
                                      object_get_name(_unidade.object_index) == "obj_f6" ||
                                      object_get_name(_unidade.object_index) == "obj_c100" ||
                                      object_get_name(_unidade.object_index) == "obj_lancha_patrulha" ||
                                      object_get_name(_unidade.object_index) == "obj_Constellation" ||
                                      object_get_name(_unidade.object_index) == "obj_Independence" ||
                                      object_get_name(_unidade.object_index) == "obj_RonaldReagan" ||
                                      object_get_name(_unidade.object_index) == "obj_navio_transporte" ||
                                      object_get_name(_unidade.object_index) == "obj_wwhendrick" ||
                                      object_get_name(_unidade.object_index) == "obj_submarino_base");
            
            if (_eh_aereo_ou_naval) {
                // ✅ LÓGICA ORIGINAL: Para aviões e navios, usar a lógica original (apenas a unidade principal)
                if (object_get_name(_unidade.object_index) == "obj_caca_f5" || object_get_name(_unidade.object_index) == "obj_f15" || object_get_name(_unidade.object_index) == "obj_su35" || object_get_name(_unidade.object_index) == "obj_caca_f35" || object_get_name(_unidade.object_index) == "obj_f6" || object_get_name(_unidade.object_index) == "obj_c100") {
                    _unidade.estado = "patrulhando";
                } else if (object_get_name(_unidade.object_index) == "obj_lancha_patrulha" ||
                           object_get_name(_unidade.object_index) == "obj_Constellation" ||
                           object_get_name(_unidade.object_index) == "obj_Independence" ||
                           object_get_name(_unidade.object_index) == "obj_RonaldReagan" ||
                           object_get_name(_unidade.object_index) == "obj_navio_transporte" ||
                           object_get_name(_unidade.object_index) == "obj_wwhendrick" ||
                           object_get_name(_unidade.object_index) == "obj_submarino_base") {
                    _unidade.estado = LanchaState.PATRULHANDO;
                    // ✅ NOVO: Atualizar também estado_string para compatibilidade
                    if (variable_instance_exists(_unidade, "estado_string")) {
                        _unidade.estado_string = "patrulhando";
                    }
                    show_debug_message("🚢 Estado da lancha mudado para PATRULHANDO");
                }
                
                // ✅ CORREÇÃO: Garantir que indice_patrulha_atual existe e está inicializado
                if (!variable_instance_exists(_unidade, "indice_patrulha_atual")) {
                    _unidade.indice_patrulha_atual = 0;
                } else {
                    _unidade.indice_patrulha_atual = 0;
                }
                
                // ✅ CORREÇÃO: Definir destino inicial com verificação de segurança
                if (_pontos_count > 0) {
                    var _ponto = _unidade.pontos_patrulha[| 0];
                    if (is_array(_ponto) && array_length(_ponto) >= 2) {
                        _unidade.destino_x = _ponto[0];
                        _unidade.destino_y = _ponto[1];
                        // ✅ NOVO: Definir também target_x/target_y para novo sistema de física (lancha)
                        if (variable_instance_exists(_unidade, "target_x")) {
                            _unidade.target_x = _ponto[0];
                            _unidade.target_y = _ponto[1];
                            _unidade.is_moving = true;
                            _unidade.usar_novo_sistema = true;
                        }
                        show_debug_message("📍 Destino inicial da patrulha: (" + string(_ponto[0]) + ", " + string(_ponto[1]) + ")");
                    } else {
                        show_debug_message("⚠️ ERRO: Ponto de patrulha inválido!");
                    }
                }
                show_debug_message("🔄 PATRULHA INICIADA com " + string(_pontos_count) + " pontos!");
                show_debug_message("🚢 Unidade começará a patrulhar automaticamente");
            } else {
                // ✅ NOVO: Para unidades terrestres, iniciar patrulha para TODAS as unidades selecionadas
                var _unidades_patrulhando = 0;
                
                // Iniciar patrulha para todas as unidades terrestres selecionadas
                with (obj_infantaria) {
                    if (selecionado && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) >= 2) {
                        estado = "patrulhando";
                        if (!variable_instance_exists(id, "indice_patrulha_atual")) {
                            indice_patrulha_atual = 0;
                        } else {
                            indice_patrulha_atual = 0;
                        }
                        var _ponto = pontos_patrulha[| 0];
                        if (is_array(_ponto) && array_length(_ponto) >= 2) {
                            destino_x = _ponto[0];
                            destino_y = _ponto[1];
                        }
                        _unidades_patrulhando++;
                    }
                }
                with (obj_tanque) {
                    if (selecionado && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) >= 2) {
                        estado = "patrulhando";
                        if (!variable_instance_exists(id, "indice_patrulha_atual")) {
                            indice_patrulha_atual = 0;
                        } else {
                            indice_patrulha_atual = 0;
                        }
                        var _ponto = pontos_patrulha[| 0];
                        if (is_array(_ponto) && array_length(_ponto) >= 2) {
                            destino_x = _ponto[0];
                            destino_y = _ponto[1];
                        }
                        _unidades_patrulhando++;
                    }
                }
                with (obj_soldado_antiaereo) {
                    if (selecionado && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) >= 2) {
                        estado = "patrulhando";
                        if (!variable_instance_exists(id, "indice_patrulha_atual")) {
                            indice_patrulha_atual = 0;
                        } else {
                            indice_patrulha_atual = 0;
                        }
                        var _ponto = pontos_patrulha[| 0];
                        if (is_array(_ponto) && array_length(_ponto) >= 2) {
                            destino_x = _ponto[0];
                            destino_y = _ponto[1];
                        }
                        _unidades_patrulhando++;
                    }
                }
                with (obj_blindado_antiaereo) {
                    if (selecionado && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) >= 2) {
                        estado = "patrulhando";
                        if (!variable_instance_exists(id, "indice_patrulha_atual")) {
                            indice_patrulha_atual = 0;
                        } else {
                            indice_patrulha_atual = 0;
                        }
                        var _ponto = pontos_patrulha[| 0];
                        if (is_array(_ponto) && array_length(_ponto) >= 2) {
                            destino_x = _ponto[0];
                            destino_y = _ponto[1];
                        }
                        _unidades_patrulhando++;
                    }
                }
                
                // Verificar M1A Abrams também
                // ✅ CORREÇÃO: _obj_abrams já foi declarado no início da função
                if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
                    with (_obj_abrams) {
                        if (selecionado && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) >= 2) {
                            estado = "patrulhando";
                            if (!variable_instance_exists(id, "indice_patrulha_atual")) {
                                indice_patrulha_atual = 0;
                            } else {
                                indice_patrulha_atual = 0;
                            }
                            var _ponto = pontos_patrulha[| 0];
                            if (is_array(_ponto) && array_length(_ponto) >= 2) {
                                destino_x = _ponto[0];
                                destino_y = _ponto[1];
                            }
                            _unidades_patrulhando++;
                        }
                    }
                }
                
                if (_unidades_patrulhando > 1) {
                    show_debug_message("🔄 PATRULHA INICIADA para " + string(_unidades_patrulhando) + " unidades terrestres com " + string(_pontos_count) + " pontos!");
                } else {
                    show_debug_message("🔄 PATRULHA INICIADA com " + string(_pontos_count) + " pontos!");
                }
            }
        } else {
            // ✅ CORREÇÃO: Cancelar patrulha e limpar pontos se tiver menos de 2
            // Verificar se é unidade terrestre ou aérea/naval
            var _eh_terrestre = (object_get_name(_unidade.object_index) == "obj_infantaria" ||
                                object_get_name(_unidade.object_index) == "obj_tanque" ||
                                object_get_name(_unidade.object_index) == "obj_soldado_antiaereo" ||
                                object_get_name(_unidade.object_index) == "obj_blindado_antiaereo");
            
            // ✅ CORREÇÃO: _obj_abrams já foi declarado no início da função
            if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object && _unidade.object_index == _obj_abrams) {
                _eh_terrestre = true;
            }
            
            if (_eh_terrestre) {
                // Para unidades terrestres, limpar pontos de todas as selecionadas
                with (obj_infantaria) {
                    if (selecionado && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                        ds_list_clear(pontos_patrulha);
                    }
                }
                with (obj_tanque) {
                    if (selecionado && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                        ds_list_clear(pontos_patrulha);
                    }
                }
                with (obj_soldado_antiaereo) {
                    if (selecionado && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                        ds_list_clear(pontos_patrulha);
                    }
                }
                with (obj_blindado_antiaereo) {
                    if (selecionado && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                        ds_list_clear(pontos_patrulha);
                    }
                }
                if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
                    with (_obj_abrams) {
                        if (selecionado && variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                            ds_list_clear(pontos_patrulha);
                        }
                    }
                }
            } else {
                // Para aviões/navios, limpar apenas da unidade principal
                if (variable_instance_exists(_unidade, "pontos_patrulha") && ds_exists(_unidade.pontos_patrulha, ds_type_list)) {
                    ds_list_clear(_unidade.pontos_patrulha);
                }
            }
            show_debug_message("❌ PATRULHA CANCELADA - mínimo de 2 pontos necessários (você tem " + string(_pontos_count) + ")");
        }
        // ✅ CORREÇÃO CRÍTICA: Sempre limpar o modo de definição ao clicar direito
        global.definindo_patrulha_unidade = noone;
    }
}
// --- MODO NORMAL (SELEÇÃO E MOVIMENTO) ---
else {
    // ✅ NOVO: Atualizar tempo para duplo clique
    var _tempo_atual = current_time / 1000.0; // Converter para segundos
    
    // ✅ NOVO: Seleção por área (drag selection)
    mouse_foi_soltou_este_frame = false;
    var _foi_selecao_area = false;
    var _mouse_pressionado_agora = mouse_check_button(mb_left);
    
    // Verificar se mouse foi solto (estava pressionado antes, agora não está)
    if (mouse_pressionado_frame_anterior && !_mouse_pressionado_agora && selecionando_area && !instance_exists(global.definindo_patrulha_unidade)) {
        mouse_foi_soltou_este_frame = true;
        selecionando_area = false;
        
        var _coords_fim = scr_mouse_to_world();
        var _fim_x = _coords_fim[0];
        var _fim_y = _coords_fim[1];
        
        // Verificar se o mouse se moveu o suficiente (evitar seleção acidental)
        var _dist_movida = point_distance(inicio_selecao_x, inicio_selecao_y, _fim_x, _fim_y);
        
        if (_dist_movida > 10) {
            // Seleção por área confirmada
            _foi_selecao_area = true;
            var _min_x = min(inicio_selecao_x, _fim_x);
            var _max_x = max(inicio_selecao_x, _fim_x);
            var _min_y = min(inicio_selecao_y, _fim_y);
            var _max_y = max(inicio_selecao_y, _fim_y);
            
            // Desselecionar todas primeiro
            with (obj_infantaria) { selecionado = false; }
            with (obj_tanque) { selecionado = false; }
            with (obj_soldado_antiaereo) { selecionado = false; }
            with (obj_blindado_antiaereo) { selecionado = false; }
            
            // Selecionar unidades do quartel dentro da área (apenas do jogador)
            // ✅ CORREÇÃO: _nacao_jogador já foi declarado no início da função
            var _contador = 0;
            with (obj_infantaria) {
                if (x >= _min_x && x <= _max_x && y >= _min_y && y <= _max_y) {
                    if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                        selecionado = true;
                        _contador++;
                    }
                }
            }
            with (obj_tanque) {
                if (x >= _min_x && x <= _max_x && y >= _min_y && y <= _max_y) {
                    if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                        selecionado = true;
                        _contador++;
                    }
                }
            }
            with (obj_soldado_antiaereo) {
                if (x >= _min_x && x <= _max_x && y >= _min_y && y <= _max_y) {
                    if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                        selecionado = true;
                        _contador++;
                    }
                }
            }
            with (obj_blindado_antiaereo) {
                if (x >= _min_x && x <= _max_x && y >= _min_y && y <= _max_y) {
                    if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                        selecionado = true;
                        _contador++;
                    }
                }
            }
            
            if (_contador > 0) {
                // Definir primeira unidade selecionada como referência
                var _primeira = noone;
                with (obj_infantaria) {
                    if (selecionado && _primeira == noone) _primeira = id;
                }
                if (_primeira == noone) {
                    with (obj_tanque) {
                        if (selecionado && _primeira == noone) _primeira = id;
                    }
                }
                if (_primeira == noone) {
                    with (obj_soldado_antiaereo) {
                        if (selecionado && _primeira == noone) _primeira = id;
                    }
                }
                if (_primeira == noone) {
                    with (obj_blindado_antiaereo) {
                        if (selecionado && _primeira == noone) _primeira = id;
                    }
                }
                global.unidade_selecionada = _primeira;
                show_debug_message("🖱️ " + string(_contador) + " unidade(s) selecionada(s) por área");
            }
        }
        // Se não houve movimento suficiente, será processado como clique simples abaixo
    }
    
    // Atualizar estado do mouse para próximo frame
    mouse_pressionado_frame_anterior = _mouse_pressionado_agora;
    
    // Iniciar seleção por área quando mouse é pressionado
    if (mouse_check_button_pressed(mb_left) && !instance_exists(global.definindo_patrulha_unidade)) {
        selecionando_area = true;
        var _coords_inicio = scr_mouse_to_world();
        inicio_selecao_x = _coords_inicio[0];
        inicio_selecao_y = _coords_inicio[1];
    }
    
    // Seleção com clique esquerdo (apenas se não foi seleção por área)
    // Processar clique simples se: (mouse foi pressionado E não foi seleção por área) OU (mouse foi solto sem movimento suficiente)
    var _processar_clique_simples = false;
    if (mouse_check_button_pressed(mb_left) && !_foi_selecao_area && !instance_exists(global.definindo_patrulha_unidade)) {
        _processar_clique_simples = true;
    } else if (mouse_foi_soltou_este_frame && !_foi_selecao_area && !instance_exists(global.definindo_patrulha_unidade)) {
        _processar_clique_simples = true;
    }
    
    if (_processar_clique_simples) {
        // Usar coordenadas corretas: se mouse foi solto, usar coordenadas do início; senão usar coordenadas atuais
        var _cx = _mx;
        var _cy = _my;
        if (mouse_foi_soltou_este_frame && !_foi_selecao_area) {
            _cx = inicio_selecao_x;
            _cy = inicio_selecao_y;
        }
        
        // ✅ CORREÇÃO: _nacao_jogador e _obj_abrams já foram declarados no início da função
        var _unidade_aerea = instance_position(_cx, _cy, obj_caca_f5);
        if (_unidade_aerea != noone && (!variable_instance_exists(_unidade_aerea, "nacao_proprietaria") || (_unidade_aerea.nacao_proprietaria != _nacao_jogador && _unidade_aerea.object_index != obj_f6))) _unidade_aerea = noone;
        if (_unidade_aerea == noone) {
            _unidade_aerea = instance_position(_cx, _cy, obj_f15);
            if (_unidade_aerea != noone && (!variable_instance_exists(_unidade_aerea, "nacao_proprietaria") || (_unidade_aerea.nacao_proprietaria != _nacao_jogador && _unidade_aerea.object_index != obj_f6))) _unidade_aerea = noone;
        }
        if (_unidade_aerea == noone) {
            _unidade_aerea = instance_position(_cx, _cy, obj_su35);
            if (_unidade_aerea != noone && (!variable_instance_exists(_unidade_aerea, "nacao_proprietaria") || (_unidade_aerea.nacao_proprietaria != _nacao_jogador && _unidade_aerea.object_index != obj_f6))) _unidade_aerea = noone;
        }
        if (_unidade_aerea == noone) {
            _unidade_aerea = instance_position(_cx, _cy, obj_caca_f35);
            if (_unidade_aerea != noone && (!variable_instance_exists(_unidade_aerea, "nacao_proprietaria") || (_unidade_aerea.nacao_proprietaria != _nacao_jogador && _unidade_aerea.object_index != obj_f6))) _unidade_aerea = noone;
        }
        if (_unidade_aerea == noone) {
            _unidade_aerea = instance_position(_cx, _cy, obj_c100);
            if (_unidade_aerea != noone && (!variable_instance_exists(_unidade_aerea, "nacao_proprietaria") || (_unidade_aerea.nacao_proprietaria != _nacao_jogador && _unidade_aerea.object_index != obj_f6))) _unidade_aerea = noone;
        }
        if (_unidade_aerea == noone) {
            _unidade_aerea = instance_position(_cx, _cy, obj_f6);
            // ✅ F6 pode ser selecionado mesmo sendo da nação 2 (presidente)
            if (_unidade_aerea != noone) {
                // F6 sempre pode ser selecionado, independente da nação
                // Não precisa verificar nação para F6
            } else {
                _unidade_aerea = noone;
            }
        }
        // ✅ CORREÇÃO: Verificar submarinos PRIMEIRO (antes de outros navios) para garantir que sejam clicáveis
        var _unidade_submarino = instance_position(_cx, _cy, obj_submarino_base);
        if (_unidade_submarino != noone && (!variable_instance_exists(_unidade_submarino, "nacao_proprietaria") || _unidade_submarino.nacao_proprietaria != _nacao_jogador)) _unidade_submarino = noone;
        var _unidade_wwhendrick = instance_position(_cx, _cy, obj_wwhendrick);
        if (_unidade_wwhendrick != noone && (!variable_instance_exists(_unidade_wwhendrick, "nacao_proprietaria") || _unidade_wwhendrick.nacao_proprietaria != _nacao_jogador)) _unidade_wwhendrick = noone;
        var _unidade_naval = instance_position(_cx, _cy, obj_lancha_patrulha);
        if (_unidade_naval != noone && (!variable_instance_exists(_unidade_naval, "nacao_proprietaria") || _unidade_naval.nacao_proprietaria != _nacao_jogador)) _unidade_naval = noone;
        var _unidade_transporte = instance_position(_cx, _cy, obj_navio_transporte);
        if (_unidade_transporte != noone && (!variable_instance_exists(_unidade_transporte, "nacao_proprietaria") || _unidade_transporte.nacao_proprietaria != _nacao_jogador)) _unidade_transporte = noone;
        var _unidade_ronald = instance_position(_cx, _cy, obj_RonaldReagan);
        if (_unidade_ronald != noone && (!variable_instance_exists(_unidade_ronald, "nacao_proprietaria") || _unidade_ronald.nacao_proprietaria != _nacao_jogador)) _unidade_ronald = noone;
        var _unidade_constellation = instance_position(_cx, _cy, obj_Constellation);
        if (_unidade_constellation != noone && (!variable_instance_exists(_unidade_constellation, "nacao_proprietaria") || _unidade_constellation.nacao_proprietaria != _nacao_jogador)) _unidade_constellation = noone;
        var _unidade_independence = instance_position(_cx, _cy, obj_Independence);
        if (_unidade_independence != noone && (!variable_instance_exists(_unidade_independence, "nacao_proprietaria") || _unidade_independence.nacao_proprietaria != _nacao_jogador)) _unidade_independence = noone;
        
        // ✅ NOVO: Unidades terrestres
        var _unidade_infantaria = instance_position(_cx, _cy, obj_infantaria);
        if (_unidade_infantaria != noone && (!variable_instance_exists(_unidade_infantaria, "nacao_proprietaria") || _unidade_infantaria.nacao_proprietaria != _nacao_jogador)) _unidade_infantaria = noone;
        var _unidade_tanque = instance_position(_cx, _cy, obj_tanque);
        if (_unidade_tanque != noone && (!variable_instance_exists(_unidade_tanque, "nacao_proprietaria") || _unidade_tanque.nacao_proprietaria != _nacao_jogador)) _unidade_tanque = noone;
        var _unidade_soldado_aa = instance_position(_cx, _cy, obj_soldado_antiaereo);
        if (_unidade_soldado_aa != noone && (!variable_instance_exists(_unidade_soldado_aa, "nacao_proprietaria") || _unidade_soldado_aa.nacao_proprietaria != _nacao_jogador)) _unidade_soldado_aa = noone;
        var _unidade_blindado_aa = instance_position(_cx, _cy, obj_blindado_antiaereo);
        if (_unidade_blindado_aa != noone && (!variable_instance_exists(_unidade_blindado_aa, "nacao_proprietaria") || _unidade_blindado_aa.nacao_proprietaria != _nacao_jogador)) _unidade_blindado_aa = noone;
        
        // ✅ NOVO: M1A Abrams (verificação segura)
        // ✅ CORREÇÃO: _obj_abrams já foi declarado no início da função
        var _unidade_abrams = noone;
        if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
            _unidade_abrams = instance_position(_cx, _cy, _obj_abrams);
            if (_unidade_abrams != noone && (!variable_instance_exists(_unidade_abrams, "nacao_proprietaria") || _unidade_abrams.nacao_proprietaria != _nacao_jogador)) _unidade_abrams = noone;
        }
        
        // ✅ NOVO: Gepard Anti-Aéreo (verificação segura)
        var _unidade_gepard = noone;
        if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object) {
            _unidade_gepard = instance_position(_cx, _cy, _obj_gepard);
            if (_unidade_gepard != noone && (!variable_instance_exists(_unidade_gepard, "nacao_proprietaria") || _unidade_gepard.nacao_proprietaria != _nacao_jogador)) _unidade_gepard = noone;
        }
        
        // Desseleciona TODAS as unidades ANTES de selecionar nova
        // IMPORTANTE: Desselecionar TUDO para garantir que não fica nada marcado
        with (obj_caca_f5) { selecionado = false; }
        with (obj_f15) { selecionado = false; }
        with (obj_su35) { selecionado = false; }
        with (obj_caca_f35) { selecionado = false; }
        with (obj_c100) { selecionado = false; }
        with (obj_f6) { selecionado = false; }
        with (obj_lancha_patrulha) { selecionado = false; }
        with (obj_navio_transporte) { selecionado = false; }
        with (obj_RonaldReagan) { selecionado = false; }
        with (obj_Constellation) { selecionado = false; }
        with (obj_Independence) { selecionado = false; }
        with (obj_wwhendrick) { selecionado = false; }
        with (obj_submarino_base) { selecionado = false; }
        with (obj_tanque) { selecionado = false; }
        with (obj_infantaria) { selecionado = false; }
        with (obj_soldado_antiaereo) { selecionado = false; }
        with (obj_blindado_antiaereo) { selecionado = false; }
        
        // ✅ NOVO: Desselecionar M1A Abrams
        // ✅ CORREÇÃO: _obj_abrams já foi declarado no início da função
        if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
            with (_obj_abrams) { selecionado = false; }
        }
        
        // ✅ NOVO: Desselecionar Gepard Anti-Aéreo
        if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object) {
            with (_obj_gepard) { selecionado = false; }
        }
        
        if (instance_exists(_unidade_aerea)) {
            // Seleciona nova unidade aérea
            global.unidade_selecionada = _unidade_aerea;
            _unidade_aerea.selecionado = true;
            show_debug_message("✈️ Unidade aérea selecionada: " + object_get_name(_unidade_aerea.object_index));
            // Resetar duplo clique ao selecionar unidade não do quartel
            ultimo_clique_tempo = 0;
            ultimo_clique_obj = noone;
        } else if (instance_exists(_unidade_submarino)) {
            // Seleciona Submarino
            global.unidade_selecionada = _unidade_submarino;
            _unidade_submarino.selecionado = true;
            show_debug_message("🌊 Submarino selecionado!");
            // Resetar duplo clique ao selecionar unidade não do quartel
            ultimo_clique_tempo = 0;
            ultimo_clique_obj = noone;
        } else if (instance_exists(_unidade_wwhendrick)) {
            // Seleciona Ww-Hendrick
            global.unidade_selecionada = _unidade_wwhendrick;
            _unidade_wwhendrick.selecionado = true;
            show_debug_message("🌊 Ww-Hendrick selecionado!");
            // Resetar duplo clique ao selecionar unidade não do quartel
            ultimo_clique_tempo = 0;
            ultimo_clique_obj = noone;
        } else if (instance_exists(_unidade_transporte)) {
            // Seleciona Navio Transporte
            global.unidade_selecionada = _unidade_transporte;
            _unidade_transporte.selecionado = true;
            show_debug_message("🚢 Navio Transporte selecionado");
            // Resetar duplo clique ao selecionar unidade não do quartel
            ultimo_clique_tempo = 0;
            ultimo_clique_obj = noone;
        } else if (instance_exists(_unidade_ronald)) {
            // Seleciona Ronald Reagan
            global.unidade_selecionada = _unidade_ronald;
            _unidade_ronald.selecionado = true;
            show_debug_message("🚢 Ronald Reagan selecionado");
            // Resetar duplo clique ao selecionar unidade não do quartel
            ultimo_clique_tempo = 0;
            ultimo_clique_obj = noone;
        } else if (instance_exists(_unidade_naval)) {
            // Seleciona nova unidade naval
            global.unidade_selecionada = _unidade_naval;
            _unidade_naval.selecionado = true;
            show_debug_message("🚢 Lancha Patrulha selecionada");
            // Resetar duplo clique ao selecionar unidade não do quartel
            ultimo_clique_tempo = 0;
            ultimo_clique_obj = noone;
        } else if (instance_exists(_unidade_constellation)) {
            // Seleciona Constellation
            global.unidade_selecionada = _unidade_constellation;
            _unidade_constellation.selecionado = true;
            show_debug_message("🚢 Constellation selecionado");
            // Resetar duplo clique ao selecionar unidade não do quartel
            ultimo_clique_tempo = 0;
            ultimo_clique_obj = noone;
        } else if (instance_exists(_unidade_independence)) {
            // Seleciona Independence
            global.unidade_selecionada = _unidade_independence;
            _unidade_independence.selecionado = true;
            show_debug_message("🚢 Independence selecionada");
            // Resetar duplo clique ao selecionar unidade não do quartel
            ultimo_clique_tempo = 0;
            ultimo_clique_obj = noone;
        } else if (instance_exists(_unidade_infantaria)) {
            // ✅ CORREÇÃO: Cancelar modo de patrulha anterior se houver
            if (variable_global_exists("definindo_patrulha_unidade") && instance_exists(global.definindo_patrulha_unidade) && global.definindo_patrulha_unidade != _unidade_infantaria) {
                if (variable_instance_exists(global.definindo_patrulha_unidade, "pontos_patrulha") && ds_exists(global.definindo_patrulha_unidade.pontos_patrulha, ds_type_list)) {
                    ds_list_clear(global.definindo_patrulha_unidade.pontos_patrulha);
                }
                global.definindo_patrulha_unidade = noone;
                show_debug_message("🔄 Modo de patrulha anterior cancelado");
            }
            
            // ✅ NOVO: Verificar duplo clique para seleção em grupo
            // Verificar se é duplo clique: mesmo objeto E tempo menor que o limite E já tinha clicado antes
            var _eh_duplo_clique = false;
            if (ultimo_clique_tempo > 0 && // Já houve um clique anterior
                instance_exists(ultimo_clique_obj) && // O objeto anterior ainda existe
                ultimo_clique_obj == _unidade_infantaria && // É o mesmo objeto
                (_tempo_atual - ultimo_clique_tempo) < tempo_duplo_clique) { // Dentro do tempo limite
                _eh_duplo_clique = true;
            }
            
            if (_eh_duplo_clique) {
                // Duplo clique confirmado: selecionar todas as infantarias visíveis na câmera
                var _cam = view_camera[0];
                var _cam_x = camera_get_view_x(_cam);
                var _cam_y = camera_get_view_y(_cam);
                var _cam_w = camera_get_view_width(_cam);
                var _cam_h = camera_get_view_height(_cam);
                
                // ✅ CORREÇÃO: _nacao_jogador já foi declarado acima
                var _contador = 0;
                with (obj_infantaria) {
                    // Verificar se está dentro da área visível da câmera E é do jogador
                    if (x >= _cam_x - 100 && x <= _cam_x + _cam_w + 100 &&
                        y >= _cam_y - 100 && y <= _cam_y + _cam_h + 100) {
                        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                            selecionado = true;
                            _contador++;
                        }
                    }
                }
                global.unidade_selecionada = _unidade_infantaria;
                show_debug_message("🪖 " + string(_contador) + " Infantaria(s) selecionada(s) (duplo clique)");
                // Resetar para evitar triplo clique
                ultimo_clique_tempo = 0;
                ultimo_clique_obj = noone;
            } else {
                // Clique simples: selecionar apenas uma
                // ✅ CORREÇÃO: Desselecionar todas as outras unidades terrestres primeiro
                with (obj_infantaria) { selecionado = false; }
                with (obj_tanque) { selecionado = false; }
                with (obj_soldado_antiaereo) { selecionado = false; }
                with (obj_blindado_antiaereo) { selecionado = false; }
                // ✅ CORREÇÃO: _obj_abrams já foi declarado acima
                if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
                    with (_obj_abrams) { selecionado = false; }
                }
                
                global.unidade_selecionada = _unidade_infantaria;
                _unidade_infantaria.selecionado = true;
                show_debug_message("🪖 Infantaria selecionada");
                // Registrar este clique para possível duplo clique
                ultimo_clique_tempo = _tempo_atual;
                ultimo_clique_obj = _unidade_infantaria;
            }
        } else if (instance_exists(_unidade_tanque)) {
            // ✅ CORREÇÃO: Cancelar modo de patrulha anterior se houver
            if (variable_global_exists("definindo_patrulha_unidade") && instance_exists(global.definindo_patrulha_unidade) && global.definindo_patrulha_unidade != _unidade_tanque) {
                if (variable_instance_exists(global.definindo_patrulha_unidade, "pontos_patrulha") && ds_exists(global.definindo_patrulha_unidade.pontos_patrulha, ds_type_list)) {
                    ds_list_clear(global.definindo_patrulha_unidade.pontos_patrulha);
                }
                global.definindo_patrulha_unidade = noone;
                show_debug_message("🔄 Modo de patrulha anterior cancelado");
            }
            
            // ✅ NOVO: Verificar duplo clique para seleção em grupo
            var _eh_duplo_clique = false;
            // Verificar se é duplo clique: mesmo objeto E tempo menor que o limite E já tinha clicado antes
            if (ultimo_clique_tempo > 0 &&
                instance_exists(ultimo_clique_obj) &&
                ultimo_clique_obj == _unidade_tanque &&
                (_tempo_atual - ultimo_clique_tempo) < tempo_duplo_clique) {
                _eh_duplo_clique = true;
            }
            
            if (_eh_duplo_clique) {
                // Duplo clique confirmado: selecionar todos os tanques visíveis na câmera
                var _cam = view_camera[0];
                var _cam_x = camera_get_view_x(_cam);
                var _cam_y = camera_get_view_y(_cam);
                var _cam_w = camera_get_view_width(_cam);
                var _cam_h = camera_get_view_height(_cam);
                
                // ✅ CORREÇÃO: _nacao_jogador já foi declarado acima
                var _contador = 0;
                with (obj_tanque) {
                    if (x >= _cam_x - 100 && x <= _cam_x + _cam_w + 100 &&
                        y >= _cam_y - 100 && y <= _cam_y + _cam_h + 100) {
                        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                            selecionado = true;
                            _contador++;
                        }
                    }
                }
                global.unidade_selecionada = _unidade_tanque;
                show_debug_message("🚗 " + string(_contador) + " Tanque(s) selecionado(s) (duplo clique)");
                // Resetar para evitar triplo clique
                ultimo_clique_tempo = 0;
                ultimo_clique_obj = noone;
            } else {
                // Clique simples: selecionar apenas um
                // ✅ CORREÇÃO: Desselecionar todas as outras unidades terrestres primeiro
                with (obj_infantaria) { selecionado = false; }
                with (obj_tanque) { selecionado = false; }
                with (obj_soldado_antiaereo) { selecionado = false; }
                with (obj_blindado_antiaereo) { selecionado = false; }
                // ✅ CORREÇÃO: _obj_abrams já foi declarado acima
                if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
                    with (_obj_abrams) { selecionado = false; }
                }
                
                global.unidade_selecionada = _unidade_tanque;
                _unidade_tanque.selecionado = true;
                show_debug_message("🚗 Tanque selecionado");
                // Registrar este clique para possível duplo clique
                ultimo_clique_tempo = _tempo_atual;
                ultimo_clique_obj = _unidade_tanque;
            }
        } else if (instance_exists(_unidade_soldado_aa)) {
            // ✅ CORREÇÃO: Cancelar modo de patrulha anterior se houver
            if (variable_global_exists("definindo_patrulha_unidade") && instance_exists(global.definindo_patrulha_unidade) && global.definindo_patrulha_unidade != _unidade_soldado_aa) {
                if (variable_instance_exists(global.definindo_patrulha_unidade, "pontos_patrulha") && ds_exists(global.definindo_patrulha_unidade.pontos_patrulha, ds_type_list)) {
                    ds_list_clear(global.definindo_patrulha_unidade.pontos_patrulha);
                }
                global.definindo_patrulha_unidade = noone;
                show_debug_message("🔄 Modo de patrulha anterior cancelado");
            }
            
            // ✅ NOVO: Verificar duplo clique para seleção em grupo
            var _eh_duplo_clique = false;
            if (ultimo_clique_tempo > 0 &&
                instance_exists(ultimo_clique_obj) &&
                ultimo_clique_obj == _unidade_soldado_aa &&
                (_tempo_atual - ultimo_clique_tempo) < tempo_duplo_clique) {
                _eh_duplo_clique = true;
            }
            
            if (_eh_duplo_clique) {
                var _cam = view_camera[0];
                var _cam_x = camera_get_view_x(_cam);
                var _cam_y = camera_get_view_y(_cam);
                var _cam_w = camera_get_view_width(_cam);
                var _cam_h = camera_get_view_height(_cam);
                
                // ✅ CORREÇÃO: _nacao_jogador já foi declarado acima
                var _contador = 0;
                with (obj_soldado_antiaereo) {
                    if (x >= _cam_x - 100 && x <= _cam_x + _cam_w + 100 &&
                        y >= _cam_y - 100 && y <= _cam_y + _cam_h + 100) {
                        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                            selecionado = true;
                            _contador++;
                        }
                    }
                }
                global.unidade_selecionada = _unidade_soldado_aa;
                show_debug_message("🛡️ " + string(_contador) + " Soldado(s) Anti-Aéreo(s) selecionado(s) (duplo clique)");
                // Resetar para evitar triplo clique
                ultimo_clique_tempo = 0;
                ultimo_clique_obj = noone;
            } else {
                // Clique simples: selecionar apenas um
                // ✅ CORREÇÃO: Desselecionar todas as outras unidades terrestres primeiro
                with (obj_infantaria) { selecionado = false; }
                with (obj_tanque) { selecionado = false; }
                with (obj_soldado_antiaereo) { selecionado = false; }
                with (obj_blindado_antiaereo) { selecionado = false; }
                // ✅ CORREÇÃO: _obj_abrams já foi declarado acima
                if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
                    with (_obj_abrams) { selecionado = false; }
                }
                
                global.unidade_selecionada = _unidade_soldado_aa;
                _unidade_soldado_aa.selecionado = true;
                show_debug_message("🛡️ Soldado Anti-Aéreo selecionado");
                // Registrar este clique para possível duplo clique
                ultimo_clique_tempo = _tempo_atual;
                ultimo_clique_obj = _unidade_soldado_aa;
            }
        } else if (instance_exists(_unidade_blindado_aa)) {
            // ✅ CORREÇÃO: Cancelar modo de patrulha anterior se houver
            if (variable_global_exists("definindo_patrulha_unidade") && instance_exists(global.definindo_patrulha_unidade) && global.definindo_patrulha_unidade != _unidade_blindado_aa) {
                if (variable_instance_exists(global.definindo_patrulha_unidade, "pontos_patrulha") && ds_exists(global.definindo_patrulha_unidade.pontos_patrulha, ds_type_list)) {
                    ds_list_clear(global.definindo_patrulha_unidade.pontos_patrulha);
                }
                global.definindo_patrulha_unidade = noone;
                show_debug_message("🔄 Modo de patrulha anterior cancelado");
            }
            
            // ✅ NOVO: Verificar duplo clique para seleção em grupo
            var _eh_duplo_clique = false;
            if (ultimo_clique_tempo > 0 &&
                instance_exists(ultimo_clique_obj) &&
                ultimo_clique_obj == _unidade_blindado_aa &&
                (_tempo_atual - ultimo_clique_tempo) < tempo_duplo_clique) {
                _eh_duplo_clique = true;
            }
            
            if (_eh_duplo_clique) {
                var _cam = view_camera[0];
                var _cam_x = camera_get_view_x(_cam);
                var _cam_y = camera_get_view_y(_cam);
                var _cam_w = camera_get_view_width(_cam);
                var _cam_h = camera_get_view_height(_cam);
                
                // ✅ CORREÇÃO: _nacao_jogador já foi declarado acima
                var _contador = 0;
                with (obj_blindado_antiaereo) {
                    if (x >= _cam_x - 100 && x <= _cam_x + _cam_w + 100 &&
                        y >= _cam_y - 100 && y <= _cam_y + _cam_h + 100) {
                        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                            selecionado = true;
                            _contador++;
                        }
                    }
                }
                global.unidade_selecionada = _unidade_blindado_aa;
                show_debug_message("🚛 " + string(_contador) + " Blindado(s) Anti-Aéreo(s) selecionado(s) (duplo clique)");
                // Resetar para evitar triplo clique
                ultimo_clique_tempo = 0;
                ultimo_clique_obj = noone;
            } else {
                // Clique simples: selecionar apenas um
                // ✅ CORREÇÃO: Desselecionar todas as outras unidades terrestres primeiro
                with (obj_infantaria) { selecionado = false; }
                with (obj_tanque) { selecionado = false; }
                with (obj_soldado_antiaereo) { selecionado = false; }
                with (obj_blindado_antiaereo) { selecionado = false; }
                // ✅ CORREÇÃO: _obj_abrams já foi declarado acima
                if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
                    with (_obj_abrams) { selecionado = false; }
                }
                
                global.unidade_selecionada = _unidade_blindado_aa;
                _unidade_blindado_aa.selecionado = true;
                show_debug_message("🚛 Blindado Anti-Aéreo selecionado");
                // Registrar este clique para possível duplo clique
                ultimo_clique_tempo = _tempo_atual;
                ultimo_clique_obj = _unidade_blindado_aa;
            }
        } else if (instance_exists(_unidade_abrams)) {
            // ✅ NOVO: M1A Abrams - Verificar duplo clique para seleção em grupo
            var _eh_duplo_clique = false;
            if (ultimo_clique_tempo > 0 &&
                instance_exists(ultimo_clique_obj) &&
                ultimo_clique_obj == _unidade_abrams &&
                (_tempo_atual - ultimo_clique_tempo) < tempo_duplo_clique) {
                _eh_duplo_clique = true;
            }
            
            if (_eh_duplo_clique) {
                var _cam = view_camera[0];
                var _cam_x = camera_get_view_x(_cam);
                var _cam_y = camera_get_view_y(_cam);
                var _cam_w = camera_get_view_width(_cam);
                var _cam_h = camera_get_view_height(_cam);
                
                // ✅ CORREÇÃO: _nacao_jogador e _obj_abrams já foram declarados acima
                var _contador = 0;
                var _obj_abrams_group = _obj_abrams; // Reutilizar variável já declarada
                if (_obj_abrams_group != -1 && asset_get_type(_obj_abrams_group) == asset_object) {
                    with (_obj_abrams_group) {
                        if (x >= _cam_x - 100 && x <= _cam_x + _cam_w + 100 &&
                            y >= _cam_y - 100 && y <= _cam_y + _cam_h + 100) {
                            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                                selecionado = true;
                                _contador++;
                            }
                        }
                    }
                }
                global.unidade_selecionada = _unidade_abrams;
                show_debug_message("🚀 " + string(_contador) + " M1A Abrams selecionado(s) (duplo clique)");
                // Resetar para evitar triplo clique
                ultimo_clique_tempo = 0;
                ultimo_clique_obj = noone;
            } else {
                // Clique simples: selecionar apenas um
                // ✅ CORREÇÃO: Desselecionar todas as outras unidades terrestres primeiro
                with (obj_infantaria) { selecionado = false; }
                with (obj_tanque) { selecionado = false; }
                with (obj_soldado_antiaereo) { selecionado = false; }
                with (obj_blindado_antiaereo) { selecionado = false; }
                // ✅ CORREÇÃO: _obj_abrams e _obj_gepard já foram declarados acima
                if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
                    with (_obj_abrams) { selecionado = false; }
                }
                if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object) {
                    with (_obj_gepard) { selecionado = false; }
                }
                
                global.unidade_selecionada = _unidade_abrams;
                _unidade_abrams.selecionado = true;
                show_debug_message("🚀 M1A Abrams selecionado");
                // Registrar este clique para possível duplo clique
                ultimo_clique_tempo = _tempo_atual;
                ultimo_clique_obj = _unidade_abrams;
            }
        } else if (instance_exists(_unidade_gepard)) {
            // ✅ NOVO: Gepard Anti-Aéreo - Verificar duplo clique para seleção em grupo
            var _eh_duplo_clique = false;
            if (ultimo_clique_tempo > 0 &&
                instance_exists(ultimo_clique_obj) &&
                ultimo_clique_obj == _unidade_gepard &&
                (_tempo_atual - ultimo_clique_tempo) < tempo_duplo_clique) {
                _eh_duplo_clique = true;
            }
            
            if (_eh_duplo_clique) {
                var _cam = view_camera[0];
                var _cam_x = camera_get_view_x(_cam);
                var _cam_y = camera_get_view_y(_cam);
                var _cam_w = camera_get_view_width(_cam);
                var _cam_h = camera_get_view_height(_cam);
                
                var _contador = 0;
                if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object) {
                    with (_obj_gepard) {
                        if (x >= _cam_x - 100 && x <= _cam_x + _cam_w + 100 &&
                            y >= _cam_y - 100 && y <= _cam_y + _cam_h + 100) {
                            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_jogador) {
                                selecionado = true;
                                _contador++;
                            }
                        }
                    }
                }
                global.unidade_selecionada = _unidade_gepard;
                show_debug_message("🚀 " + string(_contador) + " Gepard Anti-Aéreo selecionado(s) (duplo clique)");
                // Resetar para evitar triplo clique
                ultimo_clique_tempo = 0;
                ultimo_clique_obj = noone;
            } else {
                // Clique simples: selecionar apenas um
                // ✅ CORREÇÃO: Desselecionar todas as outras unidades terrestres primeiro
                with (obj_infantaria) { selecionado = false; }
                with (obj_tanque) { selecionado = false; }
                with (obj_soldado_antiaereo) { selecionado = false; }
                with (obj_blindado_antiaereo) { selecionado = false; }
                // ✅ CORREÇÃO: _obj_abrams e _obj_gepard já foram declarados acima
                if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
                    with (_obj_abrams) { selecionado = false; }
                }
                if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object) {
                    with (_obj_gepard) { selecionado = false; }
                }
                
                global.unidade_selecionada = _unidade_gepard;
                _unidade_gepard.selecionado = true;
                show_debug_message("🚀 Gepard Anti-Aéreo selecionado");
                // Registrar este clique para possível duplo clique
                ultimo_clique_tempo = _tempo_atual;
                ultimo_clique_obj = _unidade_gepard;
            }
        } else {
            // Desseleciona se clicou em lugar vazio
            if (instance_exists(global.unidade_selecionada)) {
                // Desselecionar explicitamente
                global.unidade_selecionada.selecionado = false;
                show_debug_message("Desselecionando unidade: " + object_get_name(global.unidade_selecionada.object_index));
            }
            global.unidade_selecionada = noone;
            show_debug_message("✅ Desselecionado - clique no vazio");
            // Resetar duplo clique ao clicar no vazio
            ultimo_clique_tempo = 0;
            ultimo_clique_obj = noone;
        }
    }
    
    // Movimento com clique direito (CÓDIGO ATUALIZADO) - APENAS se NÃO estiver em modo patrulha
    // ✅ CORREÇÃO: Verificar também se não está finalizando patrulha (tem pontos definidos)
    var _nao_esta_definindo_patrulha = (!instance_exists(global.definindo_patrulha_unidade));
    if (_nao_esta_definindo_patrulha && instance_exists(global.unidade_selecionada)) {
        // Verificar se a unidade selecionada tem pontos de patrulha (se tiver, não fazer movimento normal)
        if (variable_instance_exists(global.unidade_selecionada, "pontos_patrulha") && 
            ds_exists(global.unidade_selecionada.pontos_patrulha, ds_type_list) && 
            ds_list_size(global.unidade_selecionada.pontos_patrulha) >= 2) {
            _nao_esta_definindo_patrulha = false; // Tem pontos de patrulha - não fazer movimento normal
        }
    }
    
    if (mouse_check_button_pressed(mb_right) && _nao_esta_definindo_patrulha) {
        // Clamp do destino para evitar ordens fora do mapa (área preta)
        var _tx = clamp(_mx, 8, room_width - 8);
        var _ty = clamp(_my, 8, room_height - 8);
        
        // ✅ NOVO: Verificar se há unidades do quartel selecionadas para movimento em grupo (incluindo Abrams)
        var _unidades_quarte_selecionadas = 0;
        with (obj_infantaria) { if (selecionado) _unidades_quarte_selecionadas++; }
        with (obj_tanque) { if (selecionado) _unidades_quarte_selecionadas++; }
        with (obj_soldado_antiaereo) { if (selecionado) _unidades_quarte_selecionadas++; }
        with (obj_blindado_antiaereo) { if (selecionado) _unidades_quarte_selecionadas++; }
        // ✅ CORREÇÃO: _obj_abrams já foi declarado no início da função
        if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
            with (_obj_abrams) { if (selecionado) _unidades_quarte_selecionadas++; }
        }
        
        if (_unidades_quarte_selecionadas > 0) {
            // ✅ NOVO: Movimento em grupo para unidades do quartel
            var _indice_formacao = 0;
            var _contador = 0;
            
            // Mover infantaria
            with (obj_infantaria) {
                if (selecionado) {
                    var coluna = _indice_formacao mod 4;
                    var linha = _indice_formacao div 4;
                    var offset_x = (coluna - 1.5) * 45;
                    var offset_y = (linha - 1.5) * 45;
                    
                    destino_x = _tx + offset_x;
                    destino_y = _ty + offset_y;
                    estado = "movendo";
                    alvo = noone;
                    image_angle = point_direction(x, y, destino_x, destino_y);
                    
                    // Limpar patrulha
                    if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                        ds_list_clear(pontos_patrulha);
                    }
                    
                    _indice_formacao++;
                    _contador++;
                }
            }
            
            // Mover tanques
            with (obj_tanque) {
                if (selecionado) {
                    var coluna = _indice_formacao mod 4;
                    var linha = _indice_formacao div 4;
                    var offset_x = (coluna - 1.5) * 60;
                    var offset_y = (linha - 1.5) * 60;
                    
                    destino_x = _tx + offset_x;
                    destino_y = _ty + offset_y;
                    estado = "movendo";
                    alvo = noone;
                    image_angle = point_direction(x, y, destino_x, destino_y);
                    
                    // Limpar patrulha
                    if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                        ds_list_clear(pontos_patrulha);
                    }
                    
                    _indice_formacao++;
                    _contador++;
                }
            }
            
            // Mover soldados anti-aéreos
            with (obj_soldado_antiaereo) {
                if (selecionado) {
                    var coluna = _indice_formacao mod 4;
                    var linha = _indice_formacao div 4;
                    var offset_x = (coluna - 1.5) * 50;
                    var offset_y = (linha - 1.5) * 50;
                    
                    destino_x = _tx + offset_x;
                    destino_y = _ty + offset_y;
                    estado = "movendo";
                    alvo = noone;
                    image_angle = point_direction(x, y, destino_x, destino_y);
                    
                    // Limpar patrulha
                    if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                        ds_list_clear(pontos_patrulha);
                    }
                    
                    _indice_formacao++;
                    _contador++;
                }
            }
            
            // Mover blindados anti-aéreos
            with (obj_blindado_antiaereo) {
                if (selecionado) {
                    var coluna = _indice_formacao mod 4;
                    var linha = _indice_formacao div 4;
                    var offset_x = (coluna - 1.5) * 65;
                    var offset_y = (linha - 1.5) * 65;
                    
                    destino_x = _tx + offset_x;
                    destino_y = _ty + offset_y;
                    estado = "movendo";
                    alvo = noone;
                    image_angle = point_direction(x, y, destino_x, destino_y);
                    
                    // Limpar patrulha
                    if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                        ds_list_clear(pontos_patrulha);
                    }
                    
                    _indice_formacao++;
                    _contador++;
                }
            }
            
            // ✅ NOVO: Mover Abrams também
            // ✅ CORREÇÃO: _obj_abrams já foi declarado acima
            if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
                with (_obj_abrams) {
                    if (selecionado) {
                        var coluna = _indice_formacao mod 4;
                        var linha = _indice_formacao div 4;
                        var offset_x = (coluna - 1.5) * 70; // Abrams é maior, então espaçamento maior
                        var offset_y = (linha - 1.5) * 70;
                        
                        destino_x = _tx + offset_x;
                        destino_y = _ty + offset_y;
                        estado = "movendo";
                        alvo = noone;
                        image_angle = point_direction(x, y, destino_x, destino_y);
                        
                        // ✅ CORREÇÃO: Limpar destino original ao receber nova ordem
                        if (variable_instance_exists(id, "destino_original_x")) {
                            destino_original_x = undefined;
                        }
                        if (variable_instance_exists(id, "destino_original_y")) {
                            destino_original_y = undefined;
                        }
                        
                        // Limpar patrulha
                        if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                            ds_list_clear(pontos_patrulha);
                        }
                        
                        _indice_formacao++;
                        _contador++;
                    }
                }
            }
            
            show_debug_message("🎯 Ordem de movimento para " + string(_contador) + " unidade(s) do quartel");
        } else if (instance_exists(global.unidade_selecionada)) {
            // Unidades navais/aéreas - movimento individual (código original)
            var _unidade = global.unidade_selecionada;
            
            // ✅ CORREÇÃO: Usar estados corretos baseados no tipo de unidade
            if (object_get_name(_unidade.object_index) == "obj_caca_f5" || object_get_name(_unidade.object_index) == "obj_f15" || object_get_name(_unidade.object_index) == "obj_su35" || object_get_name(_unidade.object_index) == "obj_caca_f35" || object_get_name(_unidade.object_index) == "obj_f6") {
                // ✅ F6: Se estiver pousado, mudar para decolando; senão, movendo
                if (object_get_name(_unidade.object_index) == "obj_f6" && _unidade.estado == "pousado") {
                    _unidade.estado = "decolando";
                } else {
                    _unidade.estado = "movendo";
                }
            } else if (object_get_name(_unidade.object_index) == "obj_c100") {
                // ✅ CORREÇÃO: Bloquear movimento do C-100 quando em modo de embarque
                if (variable_instance_exists(_unidade, "modo_receber_carga") && _unidade.modo_receber_carga) {
                    show_debug_message("🚁 C-100: Comando de movimento bloqueado - modo embarque ativo");
                    exit; // Não processar movimento do C-100
                }
                _unidade.estado = "movendo";
            }
            
            // ✅ NOVO: Sistema A* para unidades navais
            var _obj_name = object_get_name(_unidade.object_index);
            var _eh_lancha = (_obj_name == "obj_lancha_patrulha");
            var _eh_naval = (_obj_name == "obj_Constellation" || 
                            _obj_name == "obj_Independence" || 
                            _obj_name == "obj_RonaldReagan" ||
                            _obj_name == "obj_navio_transporte" ||
                            _obj_name == "obj_wwhendrick" ||
                            _obj_name == "obj_submarino_base");
            
            // ✅ Lancha - movimento simples
            if (_eh_lancha) {
                if (variable_instance_exists(_unidade, "ordem_mover")) {
                    _unidade.ordem_mover(_tx, _ty);
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("🚢 LANCHA: Movimento para (" + string(_tx) + ", " + string(_ty) + ")");
                    }
                }
            } else if (_eh_naval) {
                // É UM NAVIO - Usar sistema A* (GPS)
                show_debug_message("🚢 NAVIO: Recebida ordem de movimento para (" + string(_tx) + ", " + string(_ty) + ")");
                
                // 1. Limpar patrulha antiga COMPLETAMENTE
                if (variable_instance_exists(_unidade, "pontos_patrulha") && ds_exists(_unidade.pontos_patrulha, ds_type_list)) {
                    ds_list_clear(_unidade.pontos_patrulha);
                    show_debug_message("🔄 NAVIO: Patrulha cancelada por nova ordem.");
                }
                
                // ✅ NOVO: Garantir que o navio NÃO está em modo patrulha
                if (_unidade.estado == LanchaState.PATRULHANDO) {
                    _unidade.estado = LanchaState.MOVENDO;
                    if (variable_instance_exists(_unidade, "estado_string")) {
                        _unidade.estado_string = "movendo";
                    }
                    show_debug_message("🔄 NAVIO: Estado alterado de PATRULHANDO para MOVENDO.");
                }
                
                // 2. Limpar qualquer caminho (path) antigo que o navio possa ter
                if (variable_instance_exists(_unidade, "meu_caminho") && _unidade.meu_caminho != noone) {
                    path_delete(_unidade.meu_caminho);
                    _unidade.meu_caminho = noone;
                }
                
                // Parar qualquer movimento atual
                if (_unidade.path_index != noone) {
                    path_end();
                    // ✅ NOTA: path_index é resetado automaticamente quando path_end() é chamado
                }
                
                // ✅ CANCELAR PATRULHA SE ESTIVER ATIVA
                if (_unidade.estado == LanchaState.PATRULHANDO) {
                    if (variable_instance_exists(_unidade, "pontos_patrulha") && ds_exists(_unidade.pontos_patrulha, ds_type_list)) {
                        ds_list_clear(_unidade.pontos_patrulha);
                    }
                    show_debug_message("🔄 NAVIO: Patrulha cancelada por nova ordem.");
                }
                
                // ✅ DEFINIR DESTINO DIRETAMENTE (SEM PATHFINDING A*)
                _unidade.destino_x = _tx;
                _unidade.destino_y = _ty;
                if (variable_instance_exists(_unidade, "alvo_x")) {
                    _unidade.alvo_x = _tx;
                    _unidade.alvo_y = _ty;
                }
                
                // ✅ DESABILITAR SISTEMA NOVO (usar sistema direto)
                _unidade.usar_novo_sistema = false;
                
                // Mudar para estado movendo
                _unidade.estado = LanchaState.MOVENDO;
                if (variable_instance_exists(_unidade, "estado_string")) {
                    _unidade.estado_string = "movendo";
                }
                
                // ✅ CORREÇÃO: Definir is_moving para mostrar linha de movimento
                _unidade.is_moving = true;
                
                // Resetar timer de presa
                if (variable_instance_exists(_unidade, "timer_presa")) {
                    _unidade.timer_presa = 0;
                }
                if (variable_instance_exists(_unidade, "distancia_anterior")) {
                    _unidade.distancia_anterior = 0;
                }
                
                show_debug_message("🎯 Ordem de movimento para " + (variable_instance_exists(_unidade, "nome_unidade") ? _unidade.nome_unidade : "Navio"));
            } else {
                // NÃO É UM NAVIO (Tanques, infantaria, aviões, etc.)
                // Usa a lógica antiga de definir destino_x e destino_y
                
                // ✅ NOVO: Validar destino antes de definir
                var _validacao = scr_validar_destino_unidade(_unidade, _tx, _ty);
                if (_validacao.valido) {
                    _unidade.destino_x = _tx;
                    _unidade.destino_y = _ty;
                } else if (_validacao.posicao_alternativa != noone) {
                    // Usar posição alternativa se disponível
                    _unidade.destino_x = _validacao.destino_x_alternativo;
                    _unidade.destino_y = _validacao.destino_y_alternativo;
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("⚠️ Destino ajustado para terreno válido: (" + string(_unidade.destino_x) + ", " + string(_unidade.destino_y) + ")");
                    }
                } else {
                    // Destino inválido - não mover
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("❌ Destino inválido para " + object_get_name(_unidade.object_index) + ": " + _validacao.motivo);
                    }
                }
                
                // ======================================================================
                // ✅ NOVA LÓGICA: CANCELAR E LIMPAR A PATRULHA ANTERIOR
                // ======================================================================
                if (variable_instance_exists(_unidade, "pontos_patrulha") && ds_exists(_unidade.pontos_patrulha, ds_type_list) && ds_list_size(_unidade.pontos_patrulha) > 0) {
                    ds_list_clear(_unidade.pontos_patrulha);
                    show_debug_message("🔄 Patrulha cancelada por nova ordem de movimento.");
                }
                // ======================================================================
            }
            
            // Mensagem adaptada ao tipo de unidade
            if (object_get_name(_unidade.object_index) == "obj_caca_f5") {
                show_debug_message("🎯 Ordem de movimento para F-5");
            } else if (object_get_name(_unidade.object_index) == "obj_f15") {
                show_debug_message("🎯 Ordem de movimento para F-15");
            } else if (object_get_name(_unidade.object_index) == "obj_su35") {
                show_debug_message("🎯 Ordem de movimento para SU-35");
            } else if (object_get_name(_unidade.object_index) == "obj_caca_f35") {
                show_debug_message("🎯 Ordem de movimento para F-35");
            } else if (object_get_name(_unidade.object_index) == "obj_lancha_patrulha") {
                show_debug_message("🎯 Ordem de movimento para Lancha Patrulha");
            } else if (object_get_name(_unidade.object_index) == "obj_Constellation") {
                show_debug_message("🎯 Ordem de movimento para Constellation");
            } else if (object_get_name(_unidade.object_index) == "obj_Independence") {
                show_debug_message("🎯 Ordem de movimento para Independence");
            } else if (object_get_name(_unidade.object_index) == "obj_c100") {
                show_debug_message("🎯 Ordem de movimento para C-100");
            } else if (object_get_name(_unidade.object_index) == "obj_f6") {
                show_debug_message("🎯 Ordem de movimento para F-6");
            }
        }
    }
}

// --- LÓGICA DE INPUT DO TECLADO ---

// COMANDO I - EMERGIR/SUBMERGIR (APENAS SUBMARINOS)
if (keyboard_check_pressed(ord("I")) && instance_exists(global.unidade_selecionada)) {
    // ✅ CORREÇÃO: Verificação de segurança para evitar erro de variável não definida
    if (!variable_instance_exists(global.unidade_selecionada, "object_index")) {
        show_debug_message("⚠️ ERRO: unidade_selecionada não tem object_index válido");
        exit;
    }
    var _nome_obj = object_get_name(global.unidade_selecionada.object_index);
    
    // Se for submarino - usar I para submergir/emergir
    if (_nome_obj == "obj_wwhendrick" || _nome_obj == "obj_submarino_base") {
        if (global.unidade_selecionada.submerso) {
            global.unidade_selecionada.func_emergir();
        } else {
            global.unidade_selecionada.func_submergir();
        }
        show_debug_message("🌊 Submergir/Emergir (I)");
    }
}

// === CONTROLES P, O, L PARA TODAS AS UNIDADES TERRESTRES SELECIONADAS ===
// ✅ NOVO: Aplicar controles para todas as unidades terrestres selecionadas

// Tecla P - Modo Passivo (todas as unidades terrestres selecionadas)
if (keyboard_check_pressed(ord("P"))) {
    var _contador = 0;
    with (obj_infantaria) {
        if (selecionado && variable_instance_exists(id, "modo_ataque")) {
            modo_ataque = false;
            if (variable_instance_exists(id, "alvo")) alvo = noone;
            if (variable_instance_exists(id, "estado") && estado == "atacando") estado = "parado";
            _contador++;
        }
    }
    with (obj_tanque) {
        if (selecionado && variable_instance_exists(id, "modo_ataque")) {
            modo_ataque = false;
            if (variable_instance_exists(id, "alvo")) alvo = noone;
            if (variable_instance_exists(id, "estado") && estado == "atacando") estado = "parado";
            _contador++;
        }
    }
    with (obj_soldado_antiaereo) {
        if (selecionado && variable_instance_exists(id, "modo_ataque")) {
            modo_ataque = false;
            if (variable_instance_exists(id, "alvo")) alvo = noone;
            if (variable_instance_exists(id, "estado") && estado == "atacando") estado = "parado";
            _contador++;
        }
    }
    with (obj_blindado_antiaereo) {
        if (selecionado && variable_instance_exists(id, "modo_ataque")) {
            modo_ataque = false;
            if (variable_instance_exists(id, "alvo")) alvo = noone;
            if (variable_instance_exists(id, "estado") && estado == "atacando") estado = "parado";
            _contador++;
        }
    }
    // ✅ CORREÇÃO: _obj_abrams já foi declarado no início da função
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        with (_obj_abrams) {
            if (selecionado && variable_instance_exists(id, "modo_ataque")) {
                modo_ataque = false;
                if (variable_instance_exists(id, "alvo")) alvo = noone;
                if (variable_instance_exists(id, "estado") && estado == "atacando") estado = "parado";
                _contador++;
            }
        }
    }
    if (_contador > 0) {
        show_debug_message("🛡️ " + string(_contador) + " unidade(s) terrestre(s) em Modo PASSIVO");
    }
}

// Tecla O - Modo Ataque (todas as unidades terrestres selecionadas)
if (keyboard_check_pressed(ord("O"))) {
    var _contador = 0;
    with (obj_infantaria) {
        if (selecionado && variable_instance_exists(id, "modo_ataque")) {
            modo_ataque = true;
            _contador++;
        }
    }
    with (obj_tanque) {
        if (selecionado && variable_instance_exists(id, "modo_ataque")) {
            modo_ataque = true;
            _contador++;
        }
    }
    with (obj_soldado_antiaereo) {
        if (selecionado && variable_instance_exists(id, "modo_ataque")) {
            modo_ataque = true;
            _contador++;
        }
    }
    with (obj_blindado_antiaereo) {
        if (selecionado && variable_instance_exists(id, "modo_ataque")) {
            modo_ataque = true;
            _contador++;
        }
    }
    // ✅ CORREÇÃO: _obj_abrams já foi declarado no início da função
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        with (_obj_abrams) {
            if (selecionado && variable_instance_exists(id, "modo_ataque")) {
                modo_ataque = true;
                _contador++;
            }
        }
    }
    if (_contador > 0) {
        show_debug_message("⚔️ " + string(_contador) + " unidade(s) terrestre(s) em Modo ATAQUE AGRESSIVO");
    }
}

// Tecla L - Parar (todas as unidades terrestres selecionadas)
if (keyboard_check_pressed(ord("L"))) {
    var _contador = 0;
    with (obj_infantaria) {
        if (selecionado) {
            if (variable_instance_exists(id, "estado")) estado = "parado";
            if (variable_instance_exists(id, "alvo")) alvo = noone;
            if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                ds_list_clear(pontos_patrulha);
            }
            _contador++;
        }
    }
    with (obj_tanque) {
        if (selecionado) {
            if (variable_instance_exists(id, "estado")) estado = "parado";
            if (variable_instance_exists(id, "alvo")) alvo = noone;
            if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                ds_list_clear(pontos_patrulha);
            }
            _contador++;
        }
    }
    with (obj_soldado_antiaereo) {
        if (selecionado) {
            if (variable_instance_exists(id, "estado")) estado = "parado";
            if (variable_instance_exists(id, "alvo")) alvo = noone;
            if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                ds_list_clear(pontos_patrulha);
            }
            _contador++;
        }
    }
    with (obj_blindado_antiaereo) {
        if (selecionado) {
            if (variable_instance_exists(id, "estado")) estado = "parado";
            if (variable_instance_exists(id, "alvo")) alvo = noone;
            if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                ds_list_clear(pontos_patrulha);
            }
            _contador++;
        }
    }
    // ✅ CORREÇÃO: _obj_abrams já foi declarado no início da função
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        with (_obj_abrams) {
            if (selecionado) {
                if (variable_instance_exists(id, "estado")) estado = "parado";
                if (variable_instance_exists(id, "alvo")) alvo = noone;
                if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                // Cancelar modo de definição de patrulha
                if (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id) {
                    global.definindo_patrulha_unidade = noone;
                }
                _contador++;
            }
        }
    }
    if (_contador > 0) {
        show_debug_message("⏹️ " + string(_contador) + " unidade(s) terrestre(s) receberam ordem para PARAR");
    }
}

// COMANDO K - PATRULHA
if (keyboard_check_pressed(ord("K"))) {
    // ✅ NOVO: Verificar se há unidades do quartel selecionadas
    var _unidades_quarte_selecionadas = 0;
    var _primeira_unidade_quarte = noone;
    
    with (obj_infantaria) {
        if (selecionado) {
            _unidades_quarte_selecionadas++;
            if (_primeira_unidade_quarte == noone) _primeira_unidade_quarte = id;
        }
    }
    with (obj_tanque) {
        if (selecionado) {
            _unidades_quarte_selecionadas++;
            if (_primeira_unidade_quarte == noone) _primeira_unidade_quarte = id;
        }
    }
    with (obj_soldado_antiaereo) {
        if (selecionado) {
            _unidades_quarte_selecionadas++;
            if (_primeira_unidade_quarte == noone) _primeira_unidade_quarte = id;
        }
    }
    with (obj_blindado_antiaereo) {
        if (selecionado) {
            _unidades_quarte_selecionadas++;
            if (_primeira_unidade_quarte == noone) _primeira_unidade_quarte = id;
        }
    }
    
    // ✅ NOVO: Verificar M1A Abrams também
    // ✅ CORREÇÃO: _obj_abrams já foi declarado no início da função
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        with (_obj_abrams) {
            if (selecionado) {
                _unidades_quarte_selecionadas++;
                if (_primeira_unidade_quarte == noone) _primeira_unidade_quarte = id;
            }
        }
    }
    
    // ✅ CORREÇÃO: Se há múltiplas unidades selecionadas, TODAS entram em modo de patrulha
    // Mas apenas uma pode estar definindo a rota por vez (a primeira)
    var _definindo_patrulha = noone;
    if (variable_global_exists("definindo_patrulha_unidade")) {
        _definindo_patrulha = global.definindo_patrulha_unidade;
    }
    
    if (_definindo_patrulha == noone) {
        // ✅ NOVO: Ativar modo de patrulha para TODAS as unidades selecionadas
        var _unidades_ativadas = 0;
        var _primeira_unidade_patrulha = noone;
        
        // Ativar patrulha para todas as unidades selecionadas
        with (obj_infantaria) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        with (obj_tanque) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        with (obj_soldado_antiaereo) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        with (obj_blindado_antiaereo) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        
        // Verificar M1A Abrams também
        // ✅ CORREÇÃO: _obj_abrams já foi declarado no início da função
        if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
            with (_obj_abrams) {
                if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                    if (ds_exists(pontos_patrulha, ds_type_list)) {
                        ds_list_clear(pontos_patrulha);
                    }
                    if (_primeira_unidade_patrulha == noone) {
                        _primeira_unidade_patrulha = id;
                    }
                    _unidades_ativadas++;
                }
            }
        }
        
        // ✅ NOVO: Verificar aviões e navios (igual aos aviões)
        with (obj_caca_f5) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        with (obj_f15) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        with (obj_caca_f35) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        with (obj_f6) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        with (obj_helicoptero_militar) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        // ✅ NOVO: Verificar todos os navios que suportam patrulha
        with (obj_lancha_patrulha) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        
        // ✅ CORREÇÃO: Verificar Constellation
        with (obj_Constellation) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        
        // ✅ CORREÇÃO: Verificar Independence
        with (obj_Independence) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        
        // ✅ CORREÇÃO: Verificar Ronald Reagan
        with (obj_RonaldReagan) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        
        // ✅ CORREÇÃO: Verificar Ww-Hendrick
        with (obj_wwhendrick) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        
        // ✅ CORREÇÃO: Verificar Navio Transporte
        with (obj_navio_transporte) {
            if (selecionado && variable_instance_exists(id, "pontos_patrulha")) {
                if (ds_exists(pontos_patrulha, ds_type_list)) {
                    ds_list_clear(pontos_patrulha);
                }
                if (_primeira_unidade_patrulha == noone) {
                    _primeira_unidade_patrulha = id;
                }
                _unidades_ativadas++;
            }
        }
        
        // Se não há unidades selecionadas, usar a unidade global
        if (_unidades_ativadas == 0 && instance_exists(global.unidade_selecionada)) {
            if (variable_instance_exists(global.unidade_selecionada, "pontos_patrulha")) {
                if (ds_exists(global.unidade_selecionada.pontos_patrulha, ds_type_list)) {
                    ds_list_clear(global.unidade_selecionada.pontos_patrulha);
                }
                _primeira_unidade_patrulha = global.unidade_selecionada;
                _unidades_ativadas = 1;
            }
        }
        
        // Definir a primeira unidade como a que está definindo a rota
        if (instance_exists(_primeira_unidade_patrulha)) {
            global.definindo_patrulha_unidade = _primeira_unidade_patrulha;
            if (_unidades_ativadas > 1) {
                show_debug_message("🎯 Modo PATRULHA ATIVADO (K) para " + string(_unidades_ativadas) + " unidades - todas patrulharão juntas!");
            } else {
                show_debug_message("🎯 Modo PATRULHA ATIVADO (K) para: " + string(object_get_name(_primeira_unidade_patrulha.object_index)));
            }
            show_debug_message("💡 INSTRUÇÕES: Clique esquerdo para adicionar pontos, direito para iniciar");
        } else {
            show_debug_message("❌ Nenhuma unidade selecionada suporta patrulha");
        }
    } else {
        show_debug_message("⚠️ Já existe uma unidade em modo patrulha");
    }
}

// --- CONTROLES DE TECLADO GLOBAIS: TECLAS C E B ---
// ✅ CORREÇÃO: Adicionar no Step_0 para garantir funcionamento em todas as rooms

// Inicializar variáveis se não existirem
if (!variable_global_exists("modo_construcao")) {
    global.modo_construcao = false;
    show_debug_message("⚠️ global.modo_construcao inicializado no Step_0");
}

if (!variable_global_exists("menu_pesquisa_aberto")) {
    global.menu_pesquisa_aberto = false;
    show_debug_message("⚠️ global.menu_pesquisa_aberto inicializado no Step_0");
}

// === TECLA C: MODO DE CONSTRUÇÃO ===
if (keyboard_check_pressed(ord("C"))) {
    show_debug_message("🔨 TECLA C PRESSIONADA! Room: " + room_get_name(room));
    global.modo_construcao = !global.modo_construcao;
    show_debug_message("🔨 Modo construção agora: " + string(global.modo_construcao));
    
    // Debug: Verificar se o menu de construção existe
    var _menu_instance = instance_find(obj_menu_construcao, 0);
    if (instance_exists(_menu_instance)) {
        show_debug_message("✅ Menu encontrado - ID: " + string(_menu_instance) + " | visible será atualizado pelo Step_0 do menu");
    } else {
        show_debug_message("⚠️ Menu não encontrado");
    }
    
    if (!global.modo_construcao) {
        global.construcao_selecionada = "";
        global.construindo_agora = noone;
    }
}

// === TECLA B: MENU DE PESQUISA ===
if (keyboard_check_pressed(ord("B"))) {
    show_debug_message("🔬 TECLA B PRESSIONADA! Room: " + room_get_name(room));
    global.menu_pesquisa_aberto = !global.menu_pesquisa_aberto;
    show_debug_message("🔬 Menu pesquisa agora: " + string(global.menu_pesquisa_aberto));
    
    // ✅ CORREÇÃO: Desativar/ativar minimapa quando abrir/fechar menu de pesquisa
    var _minimap_instance = instance_find(obj_minimap, 0);
    if (instance_exists(_minimap_instance)) {
        _minimap_instance.minimap_visible = !global.menu_pesquisa_aberto; // Desativar quando menu aberto
        show_debug_message("✅ Minimapa " + (global.menu_pesquisa_aberto ? "desativado" : "ativado"));
    }
    
    // Debug: Verificar se o centro de pesquisa existe
    var _research_instance = instance_find(obj_research_center, 0);
    if (_research_instance == noone) {
        _research_instance = instance_find(obj_centro_pesquisa, 0);
    }
    if (instance_exists(_research_instance)) {
        show_debug_message("✅ Centro encontrado - ID: " + string(_research_instance));
    } else {
        show_debug_message("⚠️ Centro não encontrado");
    }
}

// --- CONTROLES DE CÂMERA ---
mouse_x_previous = window_mouse_get_x();
mouse_y_previous = window_mouse_get_y();

