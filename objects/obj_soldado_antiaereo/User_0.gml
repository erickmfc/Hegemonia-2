// ==========================================
// EVENTO USER 0 - APLICAR DANO EXTERNO
// ==========================================

// Este evento pode ser chamado de fora para aplicar dano a esta unidade
// Útil para testar a lógica de retaliação

// Verificar se os parâmetros foram passados
if (variable_instance_exists(id, "dano_recebido")) {
    var dano = dano_recebido;
    // Remover a variável temporária
    variable_instance_remove(id, "dano_recebido");
    
    // Aplicar o dano
    vida_atual -= dano;
    show_debug_message("Unidade " + string(id) + " recebeu " + string(dano) + " de dano. Vida restante: " + string(vida_atual));
    
    // Verificar se a unidade ainda está viva
    if (vida_atual <= 0) {
        show_debug_message("Unidade " + string(id) + " foi destruída!");
        instance_destroy();
    } else {
        // Se a unidade não estava atacando, ela pode retaliar
        if (estado != "atacando") {
            show_debug_message("Unidade " + string(id) + " foi atacada e vai retaliar!");
            // Aqui poderíamos implementar lógica para identificar o atacante
            // Por enquanto, vamos apenas reiniciar a detecção
            alarm[2] = 10;
        }
    }
} else {
    show_debug_message("Evento User 0 chamado sem parâmetro de dano!");
}
