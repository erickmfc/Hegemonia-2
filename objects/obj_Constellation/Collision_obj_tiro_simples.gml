// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION FUNCIONAL
// Sistema de Dano
// ===============================================

// Verificar se o tiro é de inimigo
if (other.dono != id && other.dono.nacao_proprietaria != nacao_proprietaria) {
    // Receber dano
    hp_atual -= other.dano;
    
    // Feedback visual
    ultima_acao = "Recebeu " + string(other.dano) + " de dano!";
    cor_feedback = c_red;
    feedback_timer = 60;
    
    show_debug_message("💥 Constellation recebeu " + string(other.dano) + " de dano!");
    show_debug_message("   HP restante: " + string(hp_atual) + "/" + string(hp_max));
    
    // Verificar se morreu
    if (hp_atual <= 0) {
        ultima_acao = "DESTRUÍDO!";
        cor_feedback = c_red;
        feedback_timer = 120;
        show_debug_message("💀 Constellation DESTRUÍDO!");
        
        // Criar efeito de explosão
        var _explosao = instance_create_layer(x, y, "Instances", obj_explosao_terra);
        if (instance_exists(_explosao)) {
            _explosao.image_scale = 3.0; // Explosão maior para navio
        }
        
        // Destruir Constellation
        instance_destroy();
    }
    
    // Destruir projétil
    instance_destroy(other);
}
