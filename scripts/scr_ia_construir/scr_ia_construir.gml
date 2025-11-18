/// @description Módulo de Construção da IA
/// @param _ia_id ID da IA
/// @param _objeto_tipo Tipo de objeto a construir (ex: obj_fazenda, obj_quartel)
/// @param _x Posição X
/// @param _y Posição Y
/// @return true se construiu com sucesso, false caso contrário

function scr_ia_construir(_ia_id, _objeto_tipo, _x, _y) {
    var _ia = _ia_id;
    
    show_debug_message("🔨 IA CONSTRUIR: Iniciando construção - Objeto: " + string(_objeto_tipo) + " | Posição: (" + string(_x) + ", " + string(_y) + ")");
    
    // ✅ NOVO: Usar posicionamento estratégico se tipo for conhecido
    var _tipo_estrutura = "economia"; // Default
    
    if (_objeto_tipo == obj_fazenda || _objeto_tipo == obj_mina) {
        _tipo_estrutura = "economia";
    } else if (_objeto_tipo == obj_quartel) {
        _tipo_estrutura = "militar";
    } else if (_objeto_tipo == obj_quartel_marinha) {
        _tipo_estrutura = "naval";
    } else if (_objeto_tipo == obj_aeroporto_militar) {
        _tipo_estrutura = "aereo";
    }
    
    // ✅ NOVO: Encontrar posição estratégica (evita grudar)
    var _pos_estrategica = scr_ia_encontrar_posicao_estrategica(_ia, _tipo_estrutura, 250);
    
    // Usar posição estratégica se válida, senão usar a recebida
    if (_pos_estrategica.valida) {
        _x = _pos_estrategica.x;
        _y = _pos_estrategica.y;
        show_debug_message("✅ IA encontrou posição estratégica válida: (" + string(_x) + ", " + string(_y) + ")");
    } else {
        show_debug_message("⚠️ AVISO: Posição estratégica inválida, usando posição recebida: (" + string(_x) + ", " + string(_y) + ")");
        // Tentar encontrar posição alternativa próxima
        var _tentativas = 10;
        var _encontrou_posicao = false;
        for (var i = 0; i < _tentativas && !_encontrou_posicao; i++) {
            var _angulo = random(360);
            var _dist = 200 + random(200);
            var _px = _ia.base_x + lengthdir_x(_dist, _angulo);
            var _py = _ia.base_y + lengthdir_y(_dist, _angulo);
            
            // Verificar se não há overlap
            var _overlap = instance_position(_px, _py, _objeto_tipo);
            if (_overlap == noone) {
                _x = _px;
                _y = _py;
                _encontrou_posicao = true;
                show_debug_message("✅ IA encontrou posição alternativa: (" + string(_x) + ", " + string(_y) + ")");
            }
        }
    }
    
    // 1. Obter custos
    var _custo_d = 0;
    var _custo_m = 0;
    var _nome_edificio = "";
    
    if (_objeto_tipo == obj_fazenda) {
        _custo_d = 500; // Custo reduzido para IA
        _custo_m = 0;
        _nome_edificio = "Fazenda";
    } else if (_objeto_tipo == obj_quartel) {
        _custo_d = 250; // ✅ REDUZIDO de 400 para 250
        _custo_m = 150; // ✅ REDUZIDO de 250 para 150
        _nome_edificio = "Quartel";
    } else if (_objeto_tipo == obj_mina) {
        _custo_d = 150; // ✅ REDUZIDO de 300 para 150
        _custo_m = 50;  // ✅ REDUZIDO de 100 para 50
        _nome_edificio = "Mina";
    } else if (_objeto_tipo == obj_quartel_marinha) {
        _custo_d = 400; // ✅ REDUZIDO de 600 para 400
        _custo_m = 250; // ✅ REDUZIDO de 350 para 250
        _nome_edificio = "Quartel Naval";
    } else if (_objeto_tipo == obj_aeroporto_militar) {
        _custo_d = 600; // ✅ REDUZIDO de 800 para 600
        _custo_m = 400; // ✅ REDUZIDO de 500 para 400
        _nome_edificio = "Aeroporto Militar";
    }
    
    // === VALIDAÇÃO 1: VERIFICAR RECURSOS (PRIMEIRO) ===
    if (!variable_global_exists("ia_dinheiro") || !variable_global_exists("ia_minerio")) {
        show_debug_message("❌ ERRO: Variáveis globais de recursos da IA não existem!");
        return false;
    }
    
    if (global.ia_dinheiro < _custo_d || global.ia_minerio < _custo_m) {
        show_debug_message("❌ IA sem recursos: $" + string(global.ia_dinheiro) + " < $" + string(_custo_d) + " ou " + string(global.ia_minerio) + " < " + string(_custo_m));
        return false;
    }
    
    show_debug_message("💰 IA tem recursos suficientes: $" + string(global.ia_dinheiro) + " >= $" + string(_custo_d) + " e " + string(global.ia_minerio) + " >= " + string(_custo_m));
    
    // === OBTER DIMENSÕES DA ESTRUTURA ===
    var _largura = 64;
    var _altura = 64;
    
    if (_objeto_tipo == obj_quartel_marinha) {
        _largura = 96;
        _altura = 96;
    } else if (_objeto_tipo == obj_aeroporto_militar) {
        _largura = 128;
        _altura = 128;
    }
    
    // === VALIDAÇÃO 2: VERIFICAR TERRENO VÁLIDO ===
    // Para edifícios terrestres, verificar se estão em terreno válido
    if (_objeto_tipo == obj_fazenda || _objeto_tipo == obj_quartel || _objeto_tipo == obj_mina || _objeto_tipo == obj_aeroporto_militar) {
        if (!scr_validar_terreno_construcao(_objeto_tipo, _x, _y, _largura, _altura)) {
            show_debug_message("❌ IA: Terreno inválido para " + _nome_edificio + " em (" + string(_x) + ", " + string(_y) + ")");
            // Tentar encontrar terreno válido próximo
            var _tile_size = global.tile_size;
            var _tile_x = floor(_x / _tile_size);
            var _tile_y = floor(_y / _tile_size);
            var _encontrou_terreno = false;
            
            for (var _raio = 1; _raio <= 15 && !_encontrou_terreno; _raio++) {
                for (var _dx = -_raio; _dx <= _raio && !_encontrou_terreno; _dx++) {
                    for (var _dy = -_raio; _dy <= _raio && !_encontrou_terreno; _dy++) {
                        var _check_x = _tile_x + _dx;
                        var _check_y = _tile_y + _dy;
                        
                        if (_check_x >= 0 && _check_x < global.map_width && 
                            _check_y >= 0 && _check_y < global.map_height) {
                            var _px = _check_x * _tile_size + _tile_size / 2;
                            var _py = _check_y * _tile_size + _tile_size / 2;
                            
                            if (scr_validar_terreno_construcao(_objeto_tipo, _px, _py, _largura, _altura)) {
                                _x = _px;
                                _y = _py;
                                _encontrou_terreno = true;
                                show_debug_message("✅ IA ajustou posição para terreno válido: (" + string(_x) + ", " + string(_y) + ")");
                            }
                        }
                    }
                }
            }
            
            if (!_encontrou_terreno) {
                show_debug_message("❌ IA não encontrou terreno válido próximo para " + _nome_edificio);
                return false;
            }
        }
    }
    
    if (_objeto_tipo == obj_quartel_marinha) {
        // Quartel naval precisa estar em água
        if (!scr_validar_terreno_construcao(_objeto_tipo, _x, _y, _largura, _altura)) {
            // ✅ NOVO: Primeiro tentar usar posições de costa conhecidas
            var _encontrou_agua = false;
            
            if (variable_instance_exists(_ia, "territorio_identificado") && _ia.territorio_identificado) {
                if (variable_instance_exists(_ia, "posicoes_costa") && ds_list_size(_ia.posicoes_costa) > 0) {
                    // Encontrar posição de costa mais próxima da posição sugerida
                    var _menor_distancia = 999999;
                    var _melhor_pos_costa = noone;
                    
                    for (var i = 0; i < ds_list_size(_ia.posicoes_costa); i++) {
                        var _pos_costa = ds_list_find_value(_ia.posicoes_costa, i);
                        if (is_struct(_pos_costa) && variable_struct_exists(_pos_costa, "x")) {
                            var _dist = point_distance(_x, _y, _pos_costa.x, _pos_costa.y);
                            if (_dist < _menor_distancia) {
                                _menor_distancia = _dist;
                                _melhor_pos_costa = _pos_costa;
                            }
                        }
                    }
                    
                    if (_melhor_pos_costa != noone) {
                        _x = _melhor_pos_costa.x;
                        _y = _melhor_pos_costa.y;
                        _encontrou_agua = true;
                        show_debug_message("🌊 IA usando posição de costa conhecida: (" + string(_x) + ", " + string(_y) + ")");
                    }
                }
            }
            
            // Se não encontrou usando costa conhecida, buscar água próxima usando o grid
            if (!_encontrou_agua) {
                var _tile_size = global.tile_size;
                var _tile_x = floor(_x / _tile_size);
                var _tile_y = floor(_y / _tile_size);
                
                // Procurar água em um raio de 30 tiles (aumentado)
                for (var _raio = 1; _raio <= 30 && !_encontrou_agua; _raio++) {
                    for (var _dx = -_raio; _dx <= _raio && !_encontrou_agua; _dx++) {
                        for (var _dy = -_raio; _dy <= _raio && !_encontrou_agua; _dy++) {
                            var _check_x = _tile_x + _dx;
                            var _check_y = _tile_y + _dy;
                            
                            if (_check_x >= 0 && _check_x < global.map_width && 
                                _check_y >= 0 && _check_y < global.map_height) {
                                var _tile_data = global.map_grid[_check_x][_check_y];
                                if (!is_undefined(_tile_data) && _tile_data.terreno == TERRAIN.AGUA) {
                                    _x = _check_x * _tile_size + _tile_size / 2;
                                    _y = _check_y * _tile_size + _tile_size / 2;
                                    _encontrou_agua = true;
                                    show_debug_message("🌊 IA ajustou posição do quartel naval para água: (" + string(_x) + ", " + string(_y) + ")");
                                }
                            }
                        }
                    }
                }
            }
            
            if (!_encontrou_agua) {
                show_debug_message("❌ IA não encontrou água próxima para quartel naval em (" + string(_x) + ", " + string(_y) + ")");
                return false;
            }
        }
    }
    
    // === VALIDAÇÃO 3: VERIFICAR LIMITES DO MAPA ===
    var _dentro_limites = true;
    
    // Verificação inline dos limites do mapa
    if (variable_global_exists("map_width") && variable_global_exists("map_height") && variable_global_exists("tile_size")) {
        var _tile_size = global.tile_size;
        var _mapa_largura_pixels = global.map_width * _tile_size;
        var _mapa_altura_pixels = global.map_height * _tile_size;
        
        var _area_x1 = _x - _largura / 2;
        var _area_y1 = _y - _altura / 2;
        var _area_x2 = _x + _largura / 2;
        var _area_y2 = _y + _altura / 2;
        
        var _margem = 10;
        if (_area_x1 < _margem || _area_x2 > _mapa_largura_pixels - _margem || 
            _area_y1 < _margem || _area_y2 > _mapa_altura_pixels - _margem) {
            _dentro_limites = false;
        }
    } else {
        _dentro_limites = false;
    }
    
    if (!_dentro_limites) {
        show_debug_message("❌ IA: Estrutura fora dos limites do mapa!");
        return false;
    }
    
    // === VALIDAÇÃO 4: VERIFICAR SOBREPOSIÇÃO COM OUTRAS ESTRUTURAS ===
    // Aplicar variação aleatória para evitar estruturas grudadas
    var _variacao_x = random_range(-50, 50); // Variação de ±50 pixels
    var _variacao_y = random_range(-50, 50); // Variação de ±50 pixels
    var _pos_x_final = _x + _variacao_x;
    var _pos_y_final = _y + _variacao_y;
    
    // Se a variação saiu do terreno válido, tentar ajustar
    if (_objeto_tipo == obj_quartel_marinha) {
        if (!scr_validar_terreno_construcao(_objeto_tipo, _pos_x_final, _pos_y_final, _largura, _altura)) {
            // Se a variação saiu da água, usar posição original (já validada como água)
            _pos_x_final = _x;
            _pos_y_final = _y;
        }
    }
    
    // Verificar sobreposição completa
    var _tentativas_sobreposicao = 5;
    var _posicao_valida = false;
    
    for (var _tentativa = 0; _tentativa < _tentativas_sobreposicao && !_posicao_valida; _tentativa++) {
        if (_tentativa > 0) {
            // Tentar nova variação
            _variacao_x = random_range(-80, 80);
            _variacao_y = random_range(-80, 80);
            _pos_x_final = _x + _variacao_x;
            _pos_y_final = _y + _variacao_y;
            
            // Se for quartel naval, verificar água novamente
            if (_objeto_tipo == obj_quartel_marinha) {
                if (!scr_validar_terreno_construcao(_objeto_tipo, _pos_x_final, _pos_y_final, _largura, _altura)) {
                    continue; // Tentar próxima variação
                }
            }
        }
        
        // Verificar limites do mapa novamente com a nova posição
        var _dentro_limites_final = true;
        if (variable_global_exists("map_width") && variable_global_exists("map_height") && variable_global_exists("tile_size")) {
            var _tile_size_f = global.tile_size;
            var _mapa_largura_pixels_f = global.map_width * _tile_size_f;
            var _mapa_altura_pixels_f = global.map_height * _tile_size_f;
            
            var _area_x1_f = _pos_x_final - _largura / 2;
            var _area_y1_f = _pos_y_final - _altura / 2;
            var _area_x2_f = _pos_x_final + _largura / 2;
            var _area_y2_f = _pos_y_final + _altura / 2;
            
            var _margem_f = 10;
            if (_area_x1_f < _margem_f || _area_x2_f > _mapa_largura_pixels_f - _margem_f || 
                _area_y1_f < _margem_f || _area_y2_f > _mapa_altura_pixels_f - _margem_f) {
                _dentro_limites_final = false;
            }
        } else {
            _dentro_limites_final = false;
        }
        
        if (!_dentro_limites_final) {
            continue; // Tentar próxima variação
        }
        
        // Verificar sobreposição completa
        // ✅ CORREÇÃO: Verificação de sobreposição com fallback seguro
        var _sem_sobreposicao = true;
        
        // Verificação básica: verificar se há instância na posição e áreas próximas
        var _estruturas_verificar = [obj_fazenda, obj_quartel, obj_quartel_marinha, obj_aeroporto_militar, obj_mina, obj_banco, obj_casa];
        var _casa_moeda = asset_get_index("obj_casa_da_moeda");
        if (_casa_moeda != -1 && object_exists(_casa_moeda)) {
            array_push(_estruturas_verificar, _casa_moeda);
        }
        
        // Verificar múltiplos pontos na área para garantir detecção completa
        var _area_x1 = _pos_x_final - _largura / 2;
        var _area_y1 = _pos_y_final - _altura / 2;
        var _area_x2 = _pos_x_final + _largura / 2;
        var _area_y2 = _pos_y_final + _altura / 2;
        
        var _pontos_verificacao = [
            [_pos_x_final, _pos_y_final],  // Centro
            [_area_x1 + 10, _area_y1 + 10],  // Canto superior esquerdo
            [_area_x2 - 10, _area_y1 + 10],  // Canto superior direito
            [_area_x1 + 10, _area_y2 - 10],  // Canto inferior esquerdo
            [_area_x2 - 10, _area_y2 - 10]   // Canto inferior direito
        ];
        
        for (var _i = 0; _i < array_length(_estruturas_verificar); _i++) {
            var _tipo_estr = _estruturas_verificar[_i];
            if (!object_exists(_tipo_estr)) continue;
            
            // Se for o mesmo tipo de objeto, permitir (será substituído)
            if (_tipo_estr == _objeto_tipo) continue;
            
            // Verificar cada ponto de verificação
            for (var _j = 0; _j < array_length(_pontos_verificacao); _j++) {
                var _check_x = _pontos_verificacao[_j][0];
                var _check_y = _pontos_verificacao[_j][1];
                
                var _inst = instance_position(_check_x, _check_y, _tipo_estr);
                if (_inst != noone) {
                    _sem_sobreposicao = false;
                    break;
                }
            }
            
            if (!_sem_sobreposicao) break;
            
            // Verificação adicional: distância mínima entre estruturas
            var _distancia_minima = 50;
            with (_tipo_estr) {
                var _dist = point_distance(x, y, _pos_x_final, _pos_y_final);
                if (_dist < _distancia_minima) {
                    _sem_sobreposicao = false;
                    break;
                }
            }
            
            if (!_sem_sobreposicao) break;
        }
        
        if (_sem_sobreposicao) {
            _posicao_valida = true;
        }
    }
    
    if (!_posicao_valida) {
        show_debug_message("❌ IA: Não encontrou posição sem sobreposição após " + string(_tentativas_sobreposicao) + " tentativas");
        return false;
    }
    
    // === VALIDAÇÃO 5: VERIFICAR SE O OBJETO EXISTE ===
    if (!object_exists(_objeto_tipo)) {
        show_debug_message("❌ ERRO: Objeto " + string(_objeto_tipo) + " não existe!");
        return false;
    }
    
    // === TODAS AS VALIDAÇÕES PASSARAM - CRIAR ESTRUTURA ===
    show_debug_message("🔨 IA criando " + _nome_edificio + " em (" + string(_pos_x_final) + ", " + string(_pos_y_final) + ")");
    
    var _nova_estrutura = noone;
    if (layer_exists("Instances")) {
        _nova_estrutura = instance_create_layer(_pos_x_final, _pos_y_final, "Instances", _objeto_tipo);
    } else {
        // Fallback: tentar criar sem especificar layer
        _nova_estrutura = instance_create(_pos_x_final, _pos_y_final, _objeto_tipo);
    }
    
    // === VALIDAÇÃO 6: VERIFICAR SE A INSTÂNCIA FOI CRIADA COM SUCESSO ===
    if (!instance_exists(_nova_estrutura)) {
        show_debug_message("❌ IA falhou ao criar " + _nome_edificio + " - instance_create retornou noone");
        return false;
    }
    
    // === SUCESSO: CONFIGURAR ESTRUTURA E DESCONTAR RECURSOS ===
    // IMPORTANTE: Definir nacao_proprietaria
    if (variable_instance_exists(_nova_estrutura, "nacao_proprietaria")) {
        _nova_estrutura.nacao_proprietaria = _ia.nacao_proprietaria;
    }
    
    // ✅ CRÍTICO: Descontar recursos APENAS DEPOIS de confirmar que a estrutura foi criada
    global.ia_dinheiro -= _custo_d;
    global.ia_minerio -= _custo_m;
    
    show_debug_message("✅ IA construiu " + _nome_edificio + " em (" + string(_pos_x_final) + ", " + string(_pos_y_final) + ")");
    show_debug_message("💰 IA recursos restantes: $" + string(global.ia_dinheiro) + " | Minério: " + string(global.ia_minerio));
    
    return true;
}
