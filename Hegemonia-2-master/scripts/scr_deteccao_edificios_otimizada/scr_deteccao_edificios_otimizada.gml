/// @description Sistema otimizado de detecção de edifícios
/// MITIGAÇÃO PARA RISCO 3: Performance
/// Otimizar detecção de edifícios e usar collision_point em vez de loops

function scr_deteccao_edificios_otimizada(_mouse_world_x, _mouse_world_y) {
    // === SISTEMA OTIMIZADO DE DETECÇÃO ===
    // Usar collision_point em vez de loops para melhor performance
    
    var _edificio_clicado = noone;
    var _tipo_edificio = "";
    
    // Lista otimizada de edifícios (ordenada por frequência de uso)
    var _edificios_prioritarios = [
        obj_quartel,
        obj_casa,
        obj_banco,
        obj_quartel_marinha,
        obj_aeroporto_militar,
        obj_research_center
    ];
    
    // Detectar edifício usando collision_point (mais eficiente)
    for (var i = 0; i < array_length(_edificios_prioritarios); i++) {
        var _edificio_obj = _edificios_prioritarios[i];
        
        if (object_exists(_edificio_obj)) {
            var _colisao = collision_point(_mouse_world_x, _mouse_world_y, _edificio_obj, false, true);
            if (_colisao != noone) {
                _edificio_clicado = _colisao;
                _tipo_edificio = object_get_name(_edificio_obj);
                break; // Parar na primeira colisão encontrada
            }
        }
    }
    
    // Retornar resultado otimizado
    if (_edificio_clicado != noone) {
        show_debug_message("🎯 Edifício detectado: " + _tipo_edificio + " ID: " + string(_edificio_clicado));
        return {
            edificio: _edificio_clicado,
            tipo: _tipo_edificio,
            sucesso: true
        };
    } else {
        return {
            edificio: noone,
            tipo: "",
            sucesso: false
        };
    }
}

/// @description Sistema de cache para edifícios
/// Reduzir verificações desnecessárias usando cache
function scr_cache_edificios() {
    // Criar cache global se não existir
    if (!variable_global_exists("cache_edificios")) {
        global.cache_edificios = {
            ultima_atualizacao: 0,
            edificios_validos: [],
            objetos_existentes: []
        };
    }
    
    var _cache = global.cache_edificios;
    var _tempo_atual = current_time;
    
    // Atualizar cache a cada 5 segundos
    if (_tempo_atual - _cache.ultima_atualizacao > 5000000) { // 5 segundos em microssegundos
        show_debug_message("🔄 Atualizando cache de edifícios...");
        
        _cache.edificios_validos = [];
        _cache.objetos_existentes = [];
        
        var _edificios = [
            obj_quartel,
            obj_casa,
            obj_banco,
            obj_quartel_marinha,
            obj_aeroporto_militar,
            obj_research_center
        ];
        
        for (var i = 0; i < array_length(_edificios); i++) {
            var _edificio_obj = _edificios[i];
            if (object_exists(_edificio_obj)) {
                _cache.objetos_existentes[array_length(_cache.objetos_existentes)] = _edificio_obj;
                
                // Verificar instâncias existentes
                var _instancias = instance_number(_edificio_obj);
                if (_instancias > 0) {
                    _cache.edificios_validos[array_length(_cache.edificios_validos)] = {
                        objeto: _edificio_obj,
                        instancias: _instancias,
                        nome: object_get_name(_edificio_obj)
                    };
                }
            }
        }
        
        _cache.ultima_atualizacao = _tempo_atual;
        show_debug_message("✅ Cache atualizado: " + string(array_length(_cache.edificios_validos)) + " edifícios válidos");
    }
    
    return _cache;
}

/// @description Sistema de detecção com cache
/// Usar cache para evitar verificações desnecessárias
function scr_deteccao_edificios_com_cache(_mouse_world_x, _mouse_world_y) {
    var _cache = scr_cache_edificios();
    
    // Se não há edifícios válidos no cache, retornar imediatamente
    if (array_length(_cache.edificios_validos) == 0) {
        return {
            edificio: noone,
            tipo: "",
            sucesso: false
        };
    }
    
    // Usar apenas edifícios válidos do cache
    for (var i = 0; i < array_length(_cache.edificios_validos); i++) {
        var _edificio_data = _cache.edificios_validos[i];
        var _edificio_obj = _edificio_data.objeto;
        
        var _colisao = collision_point(_mouse_world_x, _mouse_world_y, _edificio_obj, false, true);
        if (_colisao != noone) {
            show_debug_message("🎯 Edifício detectado (com cache): " + _edificio_data.nome + " ID: " + string(_colisao));
            return {
                edificio: _colisao,
                tipo: _edificio_data.nome,
                sucesso: true
            };
        }
    }
    
    return {
        edificio: noone,
        tipo: "",
        sucesso: false
    };
}
