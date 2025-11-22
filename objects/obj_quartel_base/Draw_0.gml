/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
// ===============================================
// HEGEMONIA GLOBAL - QUARTEL BASE DRAW EVENT
// Indicadores visuais e interface
// ===============================================

// Desenhar sprite base
draw_self();

// === INDICADOR DE SELEÇÃO ===
if (selecionado) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.3);
    draw_circle(x, y, 50, false);
    draw_set_alpha(1);
}

// === INDICADOR DE PRODUÇÃO ===
if (!ds_queue_empty(fila_producao)) {
    var _unidade_data = ds_queue_head(fila_producao);
    var _progresso = timer_producao / _unidade_data.tempo_treino;
    
    // Barra de progresso
    var _barra_w = 60;
    var _barra_h = 8;
    var _barra_x = x - _barra_w/2;
    var _barra_y = y - 40;
    
    // Fundo da barra
    draw_set_color(c_gray);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, false);
    
    // Barra de progresso
    draw_set_color(c_green);
    draw_rectangle(_barra_x, _barra_y, _barra_x + (_barra_w * _progresso), _barra_y + _barra_h, false);
    
    // Texto da unidade
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(x, y - 55, _unidade_data.nome);
}

// === INDICADOR DE MENU ===
if (mostrar_menu) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.7);
    draw_rectangle(x - 100, y - 100, x + 100, y + 100, false);
    draw_set_alpha(1);
    
    // Lista de unidades disponíveis
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    
    for (var i = 0; i < ds_list_size(unidades_disponiveis); i++) {
        var _unidade = unidades_disponiveis[| i];
        var _texto = string(i + 1) + ". " + _unidade.nome + " ($" + string(_unidade.custo_dinheiro) + ")";
        draw_text(x - 90, y - 80 + (i * 20), _texto);
    }
}

// === BARRA DE HP ===
// ✅ CORREÇÃO: Sempre mostrar barra de vida dos quarteis
if (true) {  // Sempre mostrar
    var _barra_w = 40;
    var _barra_h = 4;
    var _hp_percent = hp_atual / hp_max;
    
    // Fundo da barra (vermelho)
    draw_set_color(c_red);
    draw_rectangle(x - _barra_w/2, y - 30, x + _barra_w/2, y - 30 + _barra_h, false);
    
    // Barra de HP (verde)
    draw_set_color(c_green);
    draw_rectangle(x - _barra_w/2, y - 30, x - _barra_w/2 + (_barra_w * _hp_percent), y - 30 + _barra_h, false);
}

// Resetar configurações
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);