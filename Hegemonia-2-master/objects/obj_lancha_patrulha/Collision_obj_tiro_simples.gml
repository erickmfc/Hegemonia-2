// =========================================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA COLLISION EVENT
// Colisão com Projéteis - Sistema de Defesa
// =========================================================

// --- VERIFICAÇÃO DE SEGURANÇA ---
if (!variable_instance_exists(id, "hp_atual")) {
    hp_atual = 300;
    hp_max = 300;
}

// --- VERIFICAR SE O PROJÉTIL É INIMIGO ---
if (variable_instance_exists(other.id, "dono")) {
    var _dono_projetil = other.dono;
    
    // Verificar se o dono do projétil é inimigo
    if (instance_exists(_dono_projetil)) {
        if (variable_instance_exists(_dono_projetil.id, "nacao_proprietaria")) {
            if (_dono_projetil.nacao_proprietaria != nacao_proprietaria) {
                
                // --- CALCULAR DANO DO PROJÉTIL ---
                var _dano_projetil = 25; // Dano base
                
                // Dano adicional se especificado no projétil
                if (variable_instance_exists(other.id, "dano")) {
                    _dano_projetil = other.dano;
                }
                
                // Aplicar dano à lancha
                hp_atual -= _dano_projetil;
                
                show_debug_message("🚀 Lancha atingida por projétil!");
                show_debug_message("⚔️ Dano recebido: " + string(_dano_projetil));
                show_debug_message("❤️ HP restante: " + string(hp_atual) + "/" + string(hp_max));
                
                // --- VERIFICAR DESTRUIÇÃO ---
                if (hp_atual <= 0) {
                    show_debug_message("💀 Lancha destruída por projétil!");
                    
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
                    alarm[0] = 8; // Volta ao normal em 8 frames
                    
                    // Reduzir velocidade temporariamente
                    velocidade_atual = max(0, velocidade_atual - 0.5);
                    
                    // Feedback de dano
                    show_debug_message("⚠️ Lancha danificada por projétil");
                }
                
                // --- DESTRUIR O PROJÉTIL ---
                instance_destroy(other.id);
            }
        }
    }
}
