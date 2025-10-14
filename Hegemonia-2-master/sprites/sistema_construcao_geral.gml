// ========================================
// SISTEMA GERAL DE CONSTRUÇÃO COM VALIDAÇÃO
// ========================================
// Use este código no objeto que gerencia o clique de construção
// (ex: obj_game_manager, obj_controlador_construcao, etc.)

// ========================================
// EVENTO: Step (ou Left Pressed)
// ========================================

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

// ========================================
// CONFIGURAÇÃO DAS VARIÁVEIS GLOBAIS
// ========================================
// Adicione estas variáveis no evento Create do seu objeto gerenciador:

/*
// Variáveis globais do sistema de construção
global.modo_construcao = false;
global.objeto_construindo = noone;

// Exemplos de como definir o objeto a ser construído:
// global.objeto_construindo = obj_quartel_marinha;  // Para quartel marinha
// global.objeto_construindo = obj_quartel;          // Para quartel normal
// global.objeto_construindo = obj_casa;             // Para casa
*/

// ========================================
// EXEMPLO DE USO COM BOTÕES
// ========================================
// Use este código nos botões de construção:

/*
// Evento: Left Pressed do botão de construção
// Exemplo para botão do Quartel Marinha:

// Ativa modo de construção
global.modo_construcao = true;
global.objeto_construindo = obj_quartel_marinha;

// Mostra mensagem para o jogador
show_message("Clique em uma posição de água para construir o Quartel Marinha");
*/

// ========================================
// SISTEMA ALTERNATIVO SEM VARIÁVEIS GLOBAIS
// ========================================
// Se preferir não usar variáveis globais, use este código:

/*
// No evento Left Pressed do botão:
if (mouse_check_button_pressed(mb_left)) {
    
    // Define o objeto a ser construído diretamente
    var _objeto_a_construir = obj_quartel_marinha; // ou qualquer outro objeto
    
    // Converte posição para grid
    var _tile_x = floor(mouse_x / 32);
    var _tile_y = floor(mouse_y / 32);
    
    // Valida terreno
    if (scr_validacao_terreno(_objeto_a_construir, _tile_x, _tile_y)) {
        
        // Terreno válido - constrói
        instance_create_layer(mouse_x, mouse_y, "Instances", _objeto_a_construir);
        show_debug_message("Construção bem-sucedida em terreno válido!");
        
    } else {
        
        // Terreno inválido - mostra erro
        show_debug_message("ERRO: Terreno inválido para esta estrutura!");
    }
}
*/

// ========================================
// INSTRUÇÕES DE IMPLEMENTAÇÃO
// ========================================

/*
COMO IMPLEMENTAR:

1. ESCOLHA O OBJETO GERENCIADOR:
   - Pode ser obj_game_manager, obj_controlador, ou qualquer objeto que gerencie o jogo
   - Ou crie um novo objeto específico para construção

2. ADICIONE O CÓDIGO:
   - Copie o código principal (linhas 8-30) para o evento Step
   - Ou copie o código alternativo (linhas 60-85) para o evento Left Pressed

3. CONFIGURE AS VARIÁVEIS:
   - Adicione as variáveis globais no evento Create
   - Ou use o sistema alternativo sem variáveis globais

4. CONFIGURE OS BOTÕES:
   - Use o exemplo das linhas 45-55 para configurar os botões
   - Defina global.objeto_construindo para cada tipo de edifício

5. TESTE:
   - Execute o jogo
   - Clique nos botões de construção
   - Tente construir em terrenos válidos e inválidos
   - Verifique se as mensagens de debug aparecem

AJUSTES NECESSÁRIOS:

- TAMANHO DO TILE: Se seus tiles não são 32x32, ajuste a linha 12
- OBJETOS: Substitua obj_quartel_marinha pelos objetos corretos do seu projeto
- RECURSOS: Adicione lógica para cobrar recursos antes da construção
- SONS: Adicione sons de sucesso/erro se desejar
*/
