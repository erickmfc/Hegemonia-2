// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema de Visualização Independente
// ===============================================

// Desenhar o quartel
draw_self();

// === INDICADOR VISUAL DE SELEÇÃO ===
if (selecionado) {
    // Destacar visualmente o quartel selecionado
    image_blend = make_color_rgb(150, 200, 255); // ✅ Azul mais claro quando selecionado
} else {
    image_blend = make_color_rgb(100, 150, 255); // ✅ Azul marinho normal
}

// === INDICADOR DE PRODUÇÃO ===
if (produzindo) {
    // Desenhar barra de progresso
    var _barra_x = x - 20;
    var _barra_y = y - 30;
    var _barra_w = 40;
    var _barra_h = 5;
    
    // Fundo da barra
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, false);
    
    // Progresso da barra (usar tempo da unidade atual)
    var _unidade_atual = ds_queue_head(fila_producao);
    var _tempo_total = _unidade_atual.tempo_treino;
    var _progresso = 1 - (timer_producao / _tempo_total);
    draw_set_color(c_blue);
    draw_rectangle(_barra_x, _barra_y, _barra_x + (_barra_w * _progresso), _barra_y + _barra_h, false);
    
    // Resetar cor
    draw_set_color(c_white);
}