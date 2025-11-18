/// @function scr_validar_sistema_completo()
/// @description Validação completa do sistema - verifica variáveis globais, instâncias órfãs, data structures e corrige problemas automaticamente
/// @return {Struct} Estrutura com estatísticas de validação

function scr_validar_sistema_completo() {
    var _stats = {
        problemas_encontrados: 0,
        correcoes_aplicadas: 0,
        instancias_limpas: 0,
        ds_limpas: 0,
        variaveis_corrigidas: 0,
        erros: []
    };
    
    // === 1. VALIDAR VARIÁVEIS GLOBAIS CRÍTICAS ===
    _stats = scr_validar_variaveis_globais(_stats);
    
    // === 2. DETECTAR E LIMPAR INSTÂNCIAS ÓRFÃS ===
    _stats = scr_validar_instancias_orfas(_stats);
    
    // === 3. DETECTAR E LIMPAR DATA STRUCTURES NÃO DESTRUÍDAS ===
    _stats = scr_validar_data_structures(_stats);
    
    // === 4. VALIDAR INTEGRIDADE DE OBJETOS ===
    _stats = scr_validar_objetos_integridade(_stats);
    
    // === 5. VALIDAR RECURSOS ===
    _stats = scr_validar_recursos_sistema(_stats);
    
    // === 6. VALIDAR PERFORMANCE ===
    _stats = scr_validar_performance_sistema(_stats);
    
    // Log de validação (apenas se houver problemas ou debug ativo)
    if (_stats.problemas_encontrados > 0 || (variable_global_exists("debug_enabled") && global.debug_enabled)) {
        show_debug_message("✅ VALIDAÇÃO: " + string(_stats.problemas_encontrados) + " problemas, " + 
                          string(_stats.correcoes_aplicadas) + " correções aplicadas");
    }
    
    return _stats;
}

/// @function scr_validar_variaveis_globais(_stats)
/// @description Valida variáveis globais críticas e corrige se necessário
function scr_validar_variaveis_globais(_stats) {
    // Lista de variáveis globais críticas que devem existir
    var _variaveis_criticas = [
        "game_frame",
        "dinheiro",
        "populacao",
        "alimento",
        "minerio",
        "petroleo",
        "map_width",
        "map_height",
        "tile_size"
    ];
    
    for (var i = 0; i < array_length(_variaveis_criticas); i++) {
        var _var_name = _variaveis_criticas[i];
        
        if (!variable_global_exists(_var_name)) {
            _stats.problemas_encontrados++;
            
            // Auto-correção: inicializar variável com valor padrão
            switch (_var_name) {
                case "game_frame":
                    global.game_frame = 0;
                    break;
                case "dinheiro":
                    global.dinheiro = 1000;
                    break;
                case "populacao":
                    global.populacao = 10;
                    break;
                case "alimento":
                    global.alimento = 100;
                    break;
                case "minerio":
                    global.minerio = 0;
                    break;
                case "petroleo":
                    global.petroleo = 0;
                    break;
                case "map_width":
                    global.map_width = 50;
                    break;
                case "map_height":
                    global.map_height = 50;
                    break;
                case "tile_size":
                    global.tile_size = 64;
                    break;
            }
            
            _stats.correcoes_aplicadas++;
            _stats.variaveis_corrigidas++;
            
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("🔧 CORRIGIDO: Variável global '" + _var_name + "' inicializada");
            }
        }
    }
    
    // Validar valores inválidos
    if (variable_global_exists("game_frame") && global.game_frame < 0) {
        global.game_frame = 0;
        _stats.correcoes_aplicadas++;
    }
    
    if (variable_global_exists("dinheiro") && global.dinheiro < 0) {
        global.dinheiro = 0;
        _stats.correcoes_aplicadas++;
    }
    
    if (variable_global_exists("populacao") && global.populacao < 0) {
        global.populacao = 0;
        _stats.correcoes_aplicadas++;
    }
    
    return _stats;
}

/// @function scr_validar_instancias_orfas(_stats)
/// @description Detecta e limpa instâncias órfãs (sem referências válidas)
function scr_validar_instancias_orfas(_stats) {
    // Lista de objetos que podem ter instâncias órfãs
    var _objetos_verificar = [
        obj_infantaria,
        obj_tanque,
        obj_soldado_antiaereo,
        obj_blindado_antiaereo,
        obj_helicoptero_militar,
        obj_caca_f5,
        obj_f15,
        obj_lancha_patrulha,
        obj_navio_base,
        obj_Constellation,
        obj_Independence
    ];
    
    for (var i = 0; i < array_length(_objetos_verificar); i++) {
        var _obj = _objetos_verificar[i];
        
        // ✅ SEMPRE VERIFICAR: object_exists antes de usar
        if (!object_exists(_obj)) continue;
        
        with (_obj) {
            // Verificar se a instância tem variáveis críticas válidas
            var _eh_orfa = false;
            
            // Verificar se tem posição válida
            if (!variable_instance_exists(id, "x") || !variable_instance_exists(id, "y")) {
                _eh_orfa = true;
            } else if (x < -1000 || x > room_width + 1000 || y < -1000 || y > room_height + 1000) {
                // Instância fora dos limites do mapa
                _eh_orfa = true;
            }
            
            // Verificar se tem HP válido
            if (!_eh_orfa) {
                var _tem_hp = false;
                if (variable_instance_exists(id, "hp_atual")) {
                    _tem_hp = true;
                    if (hp_atual <= 0 && variable_instance_exists(id, "hp_max") && hp_max > 0) {
                        // Instância morta mas ainda existe - pode ser órfã
                        _eh_orfa = true;
                    }
                } else if (variable_instance_exists(id, "hp")) {
                    _tem_hp = true;
                    if (hp <= 0) {
                        _eh_orfa = true;
                    }
                } else if (variable_instance_exists(id, "vida")) {
                    _tem_hp = true;
                    if (vida <= 0) {
                        _eh_orfa = true;
                    }
                }
                
                // Se não tem HP e deveria ter, pode ser órfã
                if (!_tem_hp && (variable_instance_exists(id, "nacao_proprietaria") || 
                                 variable_instance_exists(id, "selecionado"))) {
                    // Provavelmente é uma unidade, deveria ter HP
                    _eh_orfa = true;
                }
            }
            
            if (_eh_orfa) {
                _stats.problemas_encontrados++;
                _stats.instancias_limpas++;
                
                // Destruir instância órfã
                instance_destroy();
                
                if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                    show_debug_message("🧹 LIMPEZA: Instância órfã destruída - " + object_get_name(_obj));
                }
            }
        }
    }
    
    return _stats;
}

/// @function scr_validar_data_structures(_stats)
/// @description Detecta e limpa data structures não destruídas (limitação: GameMaker não permite listar todas as DS)
function scr_validar_data_structures(_stats) {
    // Nota: GameMaker não permite listar todas as data structures existentes
    // Portanto, validamos apenas as que são conhecidas e gerenciadas globalmente
    
    // Validar data structures globais conhecidas
    var _ds_globais = [
        "estoque_recursos",
        "pontos_patrulha",
        "avioes_embarcados",
        "unidades_embarcadas"
    ];
    
    for (var i = 0; i < array_length(_ds_globais); i++) {
        var _ds_name = _ds_globais[i];
        
        // Verificar se existe e se é válida
        if (variable_global_exists(_ds_name)) {
            // Acessar variável global dinamicamente usando switch
            var _ds = noone;
            switch (_ds_name) {
                case "estoque_recursos":
                    _ds = global.estoque_recursos;
                    break;
                case "pontos_patrulha":
                    _ds = global.pontos_patrulha;
                    break;
                case "avioes_embarcados":
                    _ds = global.avioes_embarcados;
                    break;
                case "unidades_embarcadas":
                    _ds = global.unidades_embarcadas;
                    break;
            }
            
            if (_ds == noone) continue;
            
            // ✅ SEMPRE VERIFICAR: ds_exists antes de usar
            if (ds_exists(_ds, ds_type_list)) {
                // Verificar se a lista não está corrompida
                var _size = ds_list_size(_ds);
                if (_size < 0 || _size > 10000) {
                    // Lista pode estar corrompida
                    _stats.problemas_encontrados++;
                    
                    // Recriar lista
                    ds_list_destroy(_ds);
                    switch (_ds_name) {
                        case "estoque_recursos":
                            global.estoque_recursos = ds_list_create();
                            break;
                        case "pontos_patrulha":
                            global.pontos_patrulha = ds_list_create();
                            break;
                        case "avioes_embarcados":
                            global.avioes_embarcados = ds_list_create();
                            break;
                        case "unidades_embarcadas":
                            global.unidades_embarcadas = ds_list_create();
                            break;
                    }
                    _stats.correcoes_aplicadas++;
                    _stats.ds_limpas++;
                    
                    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                        show_debug_message("🔧 CORRIGIDO: Data structure '" + _ds_name + "' recriada");
                    }
                }
            } else if (ds_exists(_ds, ds_type_map)) {
                // Verificar mapa
                var _size = ds_map_size(_ds);
                if (_size < 0 || _size > 10000) {
                    _stats.problemas_encontrados++;
                    ds_map_destroy(_ds);
                    switch (_ds_name) {
                        case "estoque_recursos":
                            global.estoque_recursos = ds_map_create();
                            break;
                        case "pontos_patrulha":
                            global.pontos_patrulha = ds_map_create();
                            break;
                        case "avioes_embarcados":
                            global.avioes_embarcados = ds_map_create();
                            break;
                        case "unidades_embarcadas":
                            global.unidades_embarcadas = ds_map_create();
                            break;
                    }
                    _stats.correcoes_aplicadas++;
                    _stats.ds_limpas++;
                }
            }
        }
    }
    
    return _stats;
}

/// @function scr_validar_objetos_integridade(_stats)
/// @description Valida integridade de objetos críticos
function scr_validar_objetos_integridade(_stats) {
    // Lista de objetos críticos que devem existir
    var _objetos_criticos = [
        obj_game_manager,
        obj_resource_manager,
        obj_controlador_unidades
    ];
    
    for (var i = 0; i < array_length(_objetos_criticos); i++) {
        var _obj = _objetos_criticos[i];
        
        // ✅ SEMPRE VERIFICAR: object_exists antes de usar
        if (!object_exists(_obj)) {
            _stats.problemas_encontrados++;
            array_push(_stats.erros, "Objeto crítico não existe: " + string(_obj));
            continue;
        }
        
        // Verificar se há pelo menos uma instância
        var _count = instance_number(_obj);
        if (_count == 0) {
            _stats.problemas_encontrados++;
            array_push(_stats.erros, "Nenhuma instância de objeto crítico: " + object_get_name(_obj));
            
            // Auto-correção: criar instância se for game_manager
            if (_obj == obj_game_manager) {
                instance_create_layer(0, 0, "Instances", obj_game_manager);
                _stats.correcoes_aplicadas++;
            }
        } else if (_count > 1 && _obj == obj_game_manager) {
            // Deve haver apenas um game_manager
            _stats.problemas_encontrados++;
            
            // Manter apenas a primeira instância
            var _first = instance_find(_obj, 0);
            with (_obj) {
                if (id != _first) {
                    instance_destroy();
                    _stats.correcoes_aplicadas++;
                }
            }
        }
    }
    
    return _stats;
}

/// @function scr_validar_recursos_sistema(_stats)
/// @description Valida recursos do sistema
function scr_validar_recursos_sistema(_stats) {
    // Validar recursos básicos
    if (variable_global_exists("dinheiro") && global.dinheiro < 0) {
        global.dinheiro = 0;
        _stats.correcoes_aplicadas++;
    }
    
    if (variable_global_exists("populacao") && global.populacao < 0) {
        global.populacao = 0;
        _stats.correcoes_aplicadas++;
    }
    
    if (variable_global_exists("alimento") && global.alimento < 0) {
        global.alimento = 0;
        _stats.correcoes_aplicadas++;
    }
    
    // Validar estoque de recursos se existir
    if (variable_global_exists("estoque_recursos")) {
        // ✅ SEMPRE VERIFICAR: ds_exists antes de usar
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            // Validar valores no mapa
            var _keys = ds_map_keys_to_array(global.estoque_recursos);
            for (var i = 0; i < array_length(_keys); i++) {
                var _key = _keys[i];
                var _value = global.estoque_recursos[? _key];
                
                if (_value < 0) {
                    global.estoque_recursos[? _key] = 0;
                    _stats.correcoes_aplicadas++;
                }
            }
        }
    }
    
    return _stats;
}

/// @function scr_validar_performance_sistema(_stats)
/// @description Valida performance do sistema
function scr_validar_performance_sistema(_stats) {
    // Verificar número de instâncias
    var _total_instancias = instance_count;
    
    if (_total_instancias > 5000) {
        _stats.problemas_encontrados++;
        array_push(_stats.erros, "Muitas instâncias: " + string(_total_instancias));
    }
    
    // Verificar FPS se disponível
    if (variable_global_exists("fps_atual")) {
        if (global.fps_atual < 30 && _total_instancias > 1000) {
            _stats.problemas_encontrados++;
            array_push(_stats.erros, "FPS baixo: " + string(global.fps_atual) + " com " + string(_total_instancias) + " instâncias");
        }
    }
    
    return _stats;
}

