// ========================================
// OBJETO: obj_botao_quartel_marinha
// EVENTO: Left Pressed
// ========================================

// ========================================
// IMPLEMENTAÇÃO COM NOSSA FERRAMENTA scr_validacao_terreno
// ========================================

//======================================================================
// AQUI ESTÁ A ÚNICA MUDANÇA: CHAMAMOS NOSSA FUNÇÃO DE VALIDAÇÃO
//======================================================================
if (scr_validacao_terreno_simples(obj_quartel_marinha, mouse_x, mouse_y)) {
    
    // Se a função retornar 'true', então o terreno é VÁLIDO.
    // Criamos a estrutura e saímos do modo de construção.
    instance_create_layer(mouse_x, mouse_y, "Instances", obj_quartel_marinha);
    
    // Sua lógica para cobrar recursos e desativar o modo de construção aqui...
    show_message("Quartel Marinha construído com sucesso!");
    show_debug_message("Construção bem-sucedida em terreno válido!");

} else {
    
    // Se a função retornar 'false', o terreno é INVÁLIDO.
    // Avisamos o jogador e NÃO construímos nada.
    show_message("ERRO: Quartel Marinha deve ser construído na água!");
    show_debug_message("ERRO: Terreno inválido para esta estrutura!");
    // (Opcional: tocar um som de erro)
}
//======================================================================
