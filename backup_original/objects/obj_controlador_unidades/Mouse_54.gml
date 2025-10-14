// =========================================================
// HEGEMONIA GLOBAL - CONTROLE DE UNIDADES
// Bloco 5, Fase 3: Ordem de Movimento com Pathfinding
// =========================================================

show_debug_message("=== CLIQUE DIREITO DETECTADO ===");
show_debug_message("Posição do mouse: (" + string(mouse_x) + ", " + string(mouse_y) + ")");

if (global.unidade_selecionada != noone) {
    show_debug_message("Unidade selecionada: ID " + string(global.unidade_selecionada));
    
    with (global.unidade_selecionada) {
        estado = "movendo"; // << ADICIONE ESTA LINHA
        
        // Cria um recurso de caminho (path) vazio
        var _caminho = path_add();
        
        // Pede para a grade de pathfinding calcular a rota e salvar no recurso '_caminho'
        // A função retorna 'true' se um caminho for encontrado
        if (mp_grid_path(global.pathfinding_grid, _caminho, x, y, mouse_x, mouse_y, true)) {
            
            // Se encontrou um caminho, ordena que a unidade inicie o percurso
            // A velocidade é pega da própria unidade. O 'true' no final significa que a posição é relativa à sala.
            path_start(_caminho, velocidade, path_action_stop, true);
            show_debug_message("Caminho encontrado! Ordem de movimento iniciada.");
            
        } else {
            // Se não encontrou um caminho (ex: destino dentro de uma parede)
            path_delete(_caminho); // Deleta o recurso de caminho vazio
            show_debug_message("Não foi possível encontrar um caminho para o destino.");
        }
    }
} else {
    show_debug_message("Nenhuma unidade selecionada para mover.");
}