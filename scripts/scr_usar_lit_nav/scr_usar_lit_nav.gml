/// @description Integração do LIT com navios (Constellation, Independence, etc)
/// @note Adicione isso no Step Event quando fizer o disparo de mísseis

function scr_usar_lit_nav() {
    // Exemplo de como adicionar LIT aos navios
    
    /*
    // No obj_navio_base/Step_0.gml, seção de disparo de mísseis:
    
    // Ao invés de usar obj_tiro_simples, usar obj_lit:
    
    if (_distancia_alvo <= missil_alcance && reload_timer <= 0) {
        
        // ✅ Usar LIT para alvos importantes
        var _usar_lit = false;
        var _nome_alvo = object_get_name(alvo_unidade.object_index);
        
        // LIT contra navios/alvos de alto valor
        if (_nome_alvo == "obj_Constellation" || 
            _nome_alvo == "obj_Independence" || 
            _nome_alvo == "obj_RonaldReagan" ||
            _nome_alvo == "obj_navio_base") {
            _usar_lit = true;
        }
        
        // LIT contra aéreos importantes
        if (_nome_alvo == "obj_helicoptero_militar" || 
            _nome_alvo == "obj_c100") {
            _usar_lit = true;
        }
        
        if (_usar_lit) {
            // Disparar LIT
            var _lit = scr_disparar_lit(id, alvo_unidade);
            if (instance_exists(_lit)) {
                reload_timer = reload_time;
                show_debug_message("🔥 " + nome_unidade + " disparou LIT contra " + _nome_alvo);
            }
        } else {
            // Usar míssil padrão
            var _missil = scr_get_projectile_from_pool(obj_tiro_simples, x, y, "Instances");
            // ... resto da lógica de míssil padrão ...
        }
    }
    */
}
