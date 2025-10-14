/// @description Processar clique em unidade naval
/// @param {string} tipo Tipo da unidade
/// @param {real} custo_dinheiro Custo em dinheiro
/// @param {real} custo_populacao Custo em população
/// @param {real} custo_petroleo Custo em petróleo
/// @param {real} tempo_treino Tempo de treino
/// @param {real} buttons_y Posição Y dos botões
/// @param {real} button_width Largura dos botões
/// @param {real} button_height Altura dos botões
/// @param {real} button_spacing Espaçamento dos botões

function scr_processar_clique_unidade_naval(tipo, custo_dinheiro, custo_populacao, custo_petroleo, tempo_treino, buttons_y, button_width, button_height, button_spacing) {
    
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    // Calcular posições dos botões (coordenadas absolutas)
    var _btn1_x = 10;
    var _btn1_y = buttons_y;
    var _btn1_w = button_width;
    var _btn1_h = button_height;
    
    var _btn5_x = _btn1_x + button_width + button_spacing;
    var _btn5_y = buttons_y;
    var _btn5_w = button_width;
    var _btn5_h = button_height;
    
    var _btn10_x = _btn5_x + button_width + button_spacing;
    var _btn10_y = buttons_y;
    var _btn10_w = button_width;
    var _btn10_h = button_height;
    
    // Verificar clique nos botões
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _btn1_x, _btn1_y, _btn1_x + _btn1_w, _btn1_y + _btn1_h)) {
        scr_iniciar_recrutamento_naval(tipo, 1, custo_dinheiro, custo_populacao, custo_petroleo, tempo_treino);
    } else if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _btn5_x, _btn5_y, _btn5_x + _btn5_w, _btn5_y + _btn5_h)) {
        scr_iniciar_recrutamento_naval(tipo, 5, custo_dinheiro, custo_populacao, custo_petroleo, tempo_treino);
    } else if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, _btn10_x, _btn10_y, _btn10_x + _btn10_w, _btn10_y + _btn10_h)) {
        scr_iniciar_recrutamento_naval(tipo, 10, custo_dinheiro, custo_populacao, custo_petroleo, tempo_treino);
    }
}
