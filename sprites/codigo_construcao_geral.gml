// ========================================
// CÓDIGO PARA OBJETO GERENCIADOR DE CONSTRUÇÃO
// ========================================
// Cole este código no evento Step do seu objeto que gerencia construção
// (ex: obj_game_manager, obj_controlador_construcao, etc.)

// Verificamos se o jogador está em modo de construção e clicou com o botão esquerdo
if (global.modo_construcao && mouse_check_button_pressed(mb_left)) {

    // Pegamos a posição do mouse e convertemos para a célula do grid
    // IMPORTANTE: Se seu tile for de outro tamanho, ajuste o '32'
    var _tile_x = floor(mouse_x / 32); 
    var _tile_y = floor(mouse_y / 32);

    //======================================================================
    // AQUI ESTÁ A ÚNICA MUDANÇA: CHAMAMOS NOSSA FUNÇÃO DE VALIDAÇÃO
    //======================================================================
    if (scr_validacao_terreno(global.objeto_construindo, _tile_x, _tile_y)) {
        
        // Se a função retornar 'true', então o terreno é VÁLIDO.
        // Criamos a estrutura e saímos do modo de construção.
        instance_create_layer(mouse_x, mouse_y, "Instances", global.objeto_construindo);
        
        // Sua lógica para cobrar recursos e desativar o modo de construção aqui...
        global.modo_construcao = false;
        show_debug_message("Construção bem-sucedida em terreno válido!");

    } else {
        
        // Se a função retornar 'false', o terreno é INVÁLIDO.
        // Avisamos o jogador e NÃO construímos nada.
        show_debug_message("ERRO: Terreno inválido para esta estrutura!");
        // (Opcional: tocar um som de erro)
    }
    //======================================================================
}
