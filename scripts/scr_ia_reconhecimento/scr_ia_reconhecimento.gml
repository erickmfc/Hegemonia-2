/// @description Sistema de reconhecimento da IA - explora o mapa para encontrar alvos
/// @param {real} _ia_id ID da IA

function scr_ia_reconhecimento(_ia_id) {
    // ✅ CORREÇÃO: Verificar se a instância existe antes de usar
    if (!instance_exists(_ia_id)) {
        show_debug_message("❌ ERRO: scr_ia_reconhecimento - Instância IA não existe! ID: " + string(_ia_id));
        return;
    }
    
    var _ia = _ia_id;
    
    // ✅ CORREÇÃO: Verificar se propriedades existem antes de acessar
    if (!variable_instance_exists(_ia, "nacao_proprietaria")) {
        show_debug_message("❌ ERRO: scr_ia_reconhecimento - Instância IA não tem nacao_proprietaria! ID: " + string(_ia));
        return;
    }
    
    if (!variable_instance_exists(_ia, "base_x") || !variable_instance_exists(_ia, "base_y")) {
        show_debug_message("❌ ERRO: scr_ia_reconhecimento - Instância IA não tem base_x/base_y! ID: " + string(_ia));
        return;
    }
    
    if (!variable_instance_exists(_ia, "raio_expansao")) {
        show_debug_message("❌ ERRO: scr_ia_reconhecimento - Instância IA não tem raio_expansao! ID: " + string(_ia));
        return;
    }
    
    // Atualizar tempo do último reconhecimento
    if (!variable_instance_exists(_ia, "ultimo_reconhecimento")) {
        _ia.ultimo_reconhecimento = 0;
    }
    _ia.ultimo_reconhecimento = current_time;
    
    // === ENVIAR UNIDADES DE RECONHECIMENTO ===
    var _unidades_recon = [];
    var _idx = 0;
    
    // ✅ CORREÇÃO: Garantir que nacao_proprietaria existe e é válida
    var _nacao_ia = variable_instance_exists(_ia, "nacao_proprietaria") ? _ia.nacao_proprietaria : 2;
    if (_nacao_ia == -2147483648 || _nacao_ia <= 0) {
        _nacao_ia = 2; // Valor padrão
    }
    
    // Priorizar unidades rápidas para reconhecimento
    var _tipos_recon = [obj_caca_f5, obj_f6, obj_helicoptero_militar, obj_lancha_patrulha];
    
    for (var i = 0; i < array_length(_tipos_recon); i++) {
        if (!object_exists(_tipos_recon[i])) continue;
        
        with (_tipos_recon[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                // Se unidade não estiver ocupada, usar para reconhecimento
                if (!variable_instance_exists(id, "alvo") || alvo == noone) {
                    if (!variable_instance_exists(id, "estado") || estado != "atacando") {
                        _unidades_recon[_idx] = id;
                        _idx++;
                    }
                }
            }
        }
    }
    
    if (array_length(_unidades_recon) == 0) {
        // Se não houver unidades rápidas, usar infantaria
        with (obj_infantaria) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                if (!variable_instance_exists(id, "alvo") || alvo == noone) {
                    if (!variable_instance_exists(id, "estado") || estado != "atacando") {
                        _unidades_recon[_idx] = id;
                        _idx++;
                    }
                }
            }
        }
    }
    
    if (array_length(_unidades_recon) == 0) return; // Nenhuma unidade disponível
    
    // === DEFINIR PONTOS DE RECONHECIMENTO ===
    var _pontos_recon = [];
    
    // ✅ CORREÇÃO: Garantir que propriedades existem e têm valores válidos
    var _raio_expansao_valido = variable_instance_exists(_ia, "raio_expansao") ? _ia.raio_expansao : 3000;
    if (_raio_expansao_valido <= 0 || _raio_expansao_valido > 100000) {
        _raio_expansao_valido = 3000; // Valor padrão seguro
    }
    
    var _base_x_valido = variable_instance_exists(_ia, "base_x") ? _ia.base_x : _ia.x;
    var _base_y_valido = variable_instance_exists(_ia, "base_y") ? _ia.base_y : _ia.y;
    
    // ✅ CORREÇÃO: Verificar se valores são válidos (não são -2147483648)
    if (_base_x_valido == -2147483648 || _base_y_valido == -2147483648) {
        _base_x_valido = _ia.x;
        _base_y_valido = _ia.y;
    }
    
    var _raio_exploracao = _raio_expansao_valido * 2;
    
    // Criar grade de pontos ao redor da base
    var _num_pontos = 8;
    var _angulo_inicial = random(360);
    
    for (var i = 0; i < _num_pontos; i++) {
        var _angulo = _angulo_inicial + (i * 45);
        var _dist = _raio_exploracao * (0.5 + random(0.5)); // Variação de distância
        var _x = _base_x_valido + lengthdir_x(_dist, _angulo);
        var _y = _base_y_valido + lengthdir_y(_dist, _angulo);
        
        // Garantir que está dentro dos limites do mapa
        _x = clamp(_x, 100, room_width - 100);
        _y = clamp(_y, 100, room_height - 100);
        
        _pontos_recon[i] = {x: _x, y: _y, explorado: false};
    }
    
    // === ENVIAR UNIDADES PARA EXPLORAR ===
    var _unidades_enviadas = 0;
    var _max_unidades = min(array_length(_unidades_recon), 4); // Máximo 4 unidades
    
    // ✅ CORREÇÃO: Verificar se _pontos_recon tem elementos válidos
    if (array_length(_pontos_recon) == 0) {
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("⚠️ scr_ia_reconhecimento - Nenhum ponto de reconhecimento criado!");
        }
        return;
    }
    
    for (var i = 0; i < _max_unidades; i++) {
        // ✅ CORREÇÃO: Verificar se índice é válido
        if (i >= array_length(_unidades_recon)) break;
        
        var _unidade = _unidades_recon[i];
        if (!instance_exists(_unidade)) continue;
        
        // ✅ CORREÇÃO: Verificar se ponto existe
        var _ponto_idx = i % _num_pontos;
        if (_ponto_idx >= array_length(_pontos_recon)) continue;
        
        var _ponto = _pontos_recon[_ponto_idx];
        if (!is_struct(_ponto) || !variable_struct_exists(_ponto, "x") || !variable_struct_exists(_ponto, "y")) {
            continue;
        }
        
        with (_unidade) {
            // Definir destino de reconhecimento
            if (variable_instance_exists(id, "destino_x")) {
                destino_x = _ponto.x;
                destino_y = _ponto.y;
            }
            
            // Ativar modo de reconhecimento
            if (variable_instance_exists(id, "modo_recon")) {
                modo_recon = true;
            }
            
            if (variable_instance_exists(id, "estado")) {
                estado = "explorando";
            }
            
            if (variable_instance_exists(id, "alvo")) {
                alvo = noone; // Limpar alvos anteriores
            }
        }
        
        _unidades_enviadas++;
    }
    
    if (variable_global_exists("debug_enabled") && global.debug_enabled) {
        show_debug_message("🔍 IA RECONHECIMENTO: " + string(_unidades_enviadas) + " unidades enviadas para explorar");
    }
    
    // === SISTEMA DE INTELIGÊNCIA ===
    // Registrar áreas exploradas
    if (!variable_instance_exists(_ia, "areas_exploradas")) {
        _ia.areas_exploradas = [];
    }
    
    // ✅ CORREÇÃO: Verificar se array existe antes de usar
    if (is_array(_ia.areas_exploradas)) {
        for (var i = 0; i < array_length(_pontos_recon); i++) {
            array_push(_ia.areas_exploradas, _pontos_recon[i]);
        }
        
        // Limitar histórico para não consumir muita memória
        if (array_length(_ia.areas_exploradas) > 50) {
            array_delete(_ia.areas_exploradas, 0, 10); // Remover 10 primeiros
        }
    } else {
        // Se não for array, criar novo
        _ia.areas_exploradas = [];
        for (var i = 0; i < array_length(_pontos_recon); i++) {
            array_push(_ia.areas_exploradas, _pontos_recon[i]);
        }
    }
}