/// scr_recrutar_navio(tipo)
// Este script deve ser chamado no contexto de obj_marinha (usando 'with')
// As variáveis fila_producao e max_fila devem existir na instância que chama o script

// Verificar se o parâmetro foi passado
if (argument_count > 0) {
    var tipo_navio = argument[0];
    
    if (variable_instance_exists(self, "fila_producao") && variable_instance_exists(self, "max_fila")) {
        if (array_length(fila_producao) < max_fila) {
            array_push(fila_producao, tipo_navio);
            show_debug_message("Navio " + tipo_navio + " adicionado à fila de produção");
        } else {
            show_debug_message("Fila de produção cheia! Máximo: " + string(max_fila));
        }
    } else {
        show_debug_message("ERRO: scr_recrutar_navio - variáveis fila_producao ou max_fila não encontradas");
    }
} else {
    show_debug_message("ERRO: scr_recrutar_navio - nenhum parâmetro fornecido");
}
