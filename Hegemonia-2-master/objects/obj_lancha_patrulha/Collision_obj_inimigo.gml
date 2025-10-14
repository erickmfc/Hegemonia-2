// =========================================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA COLLISION EVENT
// Colisão com Inimigos - Sistema de Dano
// =========================================================

// --- VERIFICAÇÃO DE SEGURANÇA ---
if (!variable_instance_exists(id, "hp_atual")) {
    hp_atual = 300;
    hp_max = 300;
}

// --- VERIFICAR SE É INIMIGO ---
if (variable_instance_exists(other.id, "nacao_proprietaria")) {
    if (other.nacao_proprietaria != nacao_proprietaria) {
        // --- CALCULAR DANO DE COLISÃO ---
        var _dano_colisao = 15; // Dano base por colisão
        
        // Dano adicional baseado na velocidade
        if (variable_instance_exists(id, "velocidade_atual")) {
            var _dano_velocidade = round(velocidade_atual * 2);
            _dano_colisao += _dano_velocidade;
        }
        
        // Aplicar dano à lancha
        hp_atual -= _dano_colisao;
        
        show_debug_message("💥 Lancha colidiu com inimigo!");
        show_debug_message("⚔️ Dano recebido: " + string(_dano_colisao));
        show_debug_message("❤️ HP restante: " + string(hp_atual) + "/" + string(hp_max));
        
        // --- VERIFICAR DESTRUIÇÃO ---
        if (hp_atual <= 0) {
            show_debug_message("💀 Lancha destruída por colisão!");
            
            // Efeito visual de destruição
            var _explosao = instance_create_layer(x, y, "Instances", obj_explosao);
            if (instance_exists(_explosao)) {
                _explosao.scale = 1.5; // Explosão maior para navio
            }
            
            // Destruir a lancha
            instance_destroy();
        } else {
            // --- EFEITO VISUAL DE DANO ---
            // Piscar vermelho brevemente
            image_blend = c_red;
            alarm[0] = 5; // Volta ao normal em 5 frames
            
            // Parar movimento temporariamente
            velocidade_atual = max(0, velocidade_atual - 1);
            
            // Feedback de dano
            show_debug_message("⚠️ Lancha danificada - Velocidade reduzida");
        }
    }
}
