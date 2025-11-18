/// @function scr_limpeza_automatica_memoria()
/// @description Limpeza automática periódica de memória - remove referências órfãs, paths temporários e objetos inativos
/// @description Chamado periodicamente pelo game_manager

function scr_limpeza_automatica_memoria() {
    var _limpezas = 0;
    
    // === 1. LIMPAR REFERÊNCIAS ÓRFÃS EM UNIDADES ===
    _limpezas += scr_limpar_referencias_orfas();
    
    // === 2. LIMPAR PROJÉTEIS INATIVOS (via pooling) ===
    if (instance_exists(obj_projectile_pool_manager)) {
        _limpezas += scr_limpar_projeteis_inativos();
    }
    
    // === 3. LIMPAR PARTÍCULAS ANTIGAS ===
    _limpezas += scr_limpar_particulas_antigas();
    
    // === 4. LIMPAR PATHS TEMPORÁRIOS ===
    _limpezas += scr_limpar_paths_temporarios();
    
    // === 5. LIMPAR SPRITES TEMPORÁRIOS ===
    _limpezas += scr_limpar_sprites_temporarios();
    
    // Log apenas se houver limpezas ou debug ativo
    if (_limpezas > 0 || (variable_global_exists("debug_enabled") && global.debug_enabled)) {
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("🧹 LIMPEZA: " + string(_limpezas) + " itens limpos");
        }
    }
    
    return _limpezas;
}

/// @function scr_limpar_referencias_orfas()
/// @description Limpa referências órfãs em unidades (alvos que não existem mais)
function scr_limpar_referencias_orfas() {
    var _limpezas = 0;
    
    // Lista de objetos que podem ter referências órfãs
    var _objetos_verificar = [
        obj_infantaria,
        obj_tanque,
        obj_soldado_antiaereo,
        obj_blindado_antiaereo,
        obj_helicoptero_militar,
        obj_caca_f5,
        obj_f15,
        obj_su35,
        obj_lancha_patrulha,
        obj_navio_base,
        obj_submarino_base,
        obj_Constellation,
        obj_Independence,
        obj_RonaldReagan
    ];
    
    for (var i = 0; i < array_length(_objetos_verificar); i++) {
        var _obj = _objetos_verificar[i];
        
        // ✅ SEMPRE VERIFICAR: object_exists antes de usar
        if (!object_exists(_obj)) continue;
        
        with (_obj) {
            // Limpar referência de alvo se não existir mais
            if (variable_instance_exists(id, "alvo")) {
                if (alvo != noone && !instance_exists(alvo)) {
                    alvo = noone;
                    _limpezas++;
                }
            }
            
            // Limpar referência de alvo_unidade se não existir mais
            if (variable_instance_exists(id, "alvo_unidade")) {
                if (alvo_unidade != noone && !instance_exists(alvo_unidade)) {
                    alvo_unidade = noone;
                    _limpezas++;
                }
            }
            
            // Limpar referência de seguir_alvo se não existir mais
            if (variable_instance_exists(id, "seguir_alvo")) {
                if (seguir_alvo != noone && !instance_exists(seguir_alvo)) {
                    seguir_alvo = noone;
                    _limpezas++;
                }
            }
            
            // Limpar referência de alvo_em_mira se não existir mais (aviões)
            if (variable_instance_exists(id, "alvo_em_mira")) {
                if (alvo_em_mira != noone && !instance_exists(alvo_em_mira)) {
                    alvo_em_mira = noone;
                    _limpezas++;
                }
            }
            
            // Limpar referência de missil_criado se não existir mais
            if (variable_instance_exists(id, "missil_criado")) {
                if (missil_criado != noone && !instance_exists(missil_criado)) {
                    missil_criado = noone;
                    _limpezas++;
                }
            }
        }
    }
    
    return _limpezas;
}

/// @function scr_limpar_projeteis_inativos()
/// @description Limpa projéteis inativos usando o sistema de pooling
function scr_limpar_projeteis_inativos() {
    var _limpezas = 0;
    
    // ✅ SEMPRE VERIFICAR: instance_exists antes de usar
    if (!instance_exists(obj_projectile_pool_manager)) {
        return 0;
    }
    
    // O pool manager já tem sistema de limpeza automática
    // Esta função apenas força uma limpeza se necessário
    with (obj_projectile_pool_manager) {
        // Limpar projéteis que estão fora dos limites do mapa
        var _projeteis = [
            obj_tiro_simples,
            obj_tiro_infantaria,
            obj_tiro_tanque,
            obj_tiro_canhao,
            obj_projetil_naval,
            obj_SkyFury_ar,
            obj_Ironclad_terra,
            obj_missil_aereo
        ];
        
        for (var i = 0; i < array_length(_projeteis); i++) {
            var _proj = _projeteis[i];
            
            // ✅ SEMPRE VERIFICAR: object_exists antes de usar
            if (!object_exists(_proj)) continue;
            
            with (_proj) {
                // Verificar se está fora dos limites do mapa
                if (x < -1000 || x > room_width + 1000 || 
                    y < -1000 || y > room_height + 1000) {
                    // Retornar ao pool ou destruir
                    if (variable_instance_exists(id, "timer_vida")) {
                        timer_vida = 0; // Forçar destruição
                    } else {
                        instance_destroy();
                    }
                    _limpezas++;
                }
            }
        }
    }
    
    return _limpezas;
}

/// @function scr_limpar_particulas_antigas()
/// @description Limpa partículas antigas que não foram destruídas
function scr_limpar_particulas_antigas() {
    var _limpezas = 0;
    
    var _particulas = [
        obj_particula_fogo,
        obj_particula_terra,
        obj_explosao_pequena,
        obj_explosao_terra,
        obj_explosao_ar,
        obj_explosao_aquatica
    ];
    
    for (var i = 0; i < array_length(_particulas); i++) {
        var _part = _particulas[i];
        
        // ✅ SEMPRE VERIFICAR: object_exists antes de usar
        if (!object_exists(_part)) continue;
        
        with (_part) {
            // Verificar se tem timer de vida e está expirado
            if (variable_instance_exists(id, "timer_vida")) {
                if (timer_vida <= 0) {
                    instance_destroy();
                    _limpezas++;
                }
            } else {
                // Se não tem timer e está muito longe, destruir
                if (x < -2000 || x > room_width + 2000 || 
                    y < -2000 || y > room_height + 2000) {
                    instance_destroy();
                    _limpezas++;
                }
            }
        }
    }
    
    return _limpezas;
}

/// @function scr_limpar_paths_temporarios()
/// @description Limpa paths temporários que não estão mais em uso
function scr_limpar_paths_temporarios() {
    var _limpezas = 0;
    
    // GameMaker gerencia paths automaticamente, mas podemos verificar paths órfãos
    // Nota: GameMaker não permite listar todos os paths, então esta função
    // apenas garante que paths criados por unidades sejam limpos
    
    // Paths são geralmente gerenciados automaticamente pelo GameMaker
    // Esta função serve como placeholder para limpezas futuras se necessário
    
    return _limpezas;
}

/// @function scr_limpar_sprites_temporarios()
/// @description Limpa sprites temporários que não estão mais em uso
function scr_limpar_sprites_temporarios() {
    var _limpezas = 0;
    
    // Sprites são assets gerenciados pelo GameMaker
    // Não precisam ser destruídos manualmente
    // Esta função serve como placeholder para limpezas futuras se necessário
    
    return _limpezas;
}

