// ================================================
// HEGEMONIA GLOBAL - ESTRUTURA: CASA
// Interface Visual e Indicadores
// ================================================

// === DESENHO BASE ===
draw_self();

// === INDICADOR DE SELEÇÃO ===
if (selecionado) {
    // Desenhar círculo de seleção
    draw_set_color(c_lime);
    draw_circle(x, y, sprite_width / 2 + 5, true);
    draw_circle(x, y, sprite_width / 2 + 6, true);
}

// === INDICADORES DE NÍVEL ===
if (selecionado) {
    // Informações da casa
    var _info_x = x - 50;
    var _info_y = y - 80;
    
    // Fundo das informações
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(_info_x, _info_y, _info_x + 100, _info_y + 60, false);
    draw_set_alpha(1.0);
    
    // Texto das informações
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(x, _info_y + 5, "🏠 Casa Nível " + string(nivel_casa));
    draw_text(x, _info_y + 20, "👥 Capacidade: " + string(capacidade_atual) + " pessoas");
    
    // Mostrar custo de evolução se não estiver no nível máximo
    if (nivel_casa < 3) {
        var _custo_dinheiro = 0;
        var _custo_minerio = 0;
        
        if (nivel_casa == 1) {
            _custo_dinheiro = custo_evolucao_nivel2_dinheiro;
            _custo_minerio = custo_evolucao_nivel2_minerio;
        } else if (nivel_casa == 2) {
            _custo_dinheiro = custo_evolucao_nivel3_dinheiro;
            _custo_minerio = custo_evolucao_nivel3_minerio;
        }
        
        draw_text(x, _info_y + 35, "💰 Evoluir: $" + string(_custo_dinheiro));
        draw_text(x, _info_y + 50, "⛏️ Minério: " + string(_custo_minerio));
        
        // Instrução
        draw_set_color(c_yellow);
        draw_text(x, _info_y + 70, "Clique direito para evoluir");
    } else {
        draw_set_color(c_green);
        draw_text(x, _info_y + 35, "✅ Nível máximo atingido");
    }
}

// === INDICADOR DE LIMITE POPULACIONAL ===
// Mostrar limite global se selecionada
if (selecionado) {
    var _limite_x = x - 60;
    var _limite_y = y + 50;
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(x, _limite_y, "📊 Limite Global: " + string(global.limite_populacional) + " pessoas");
    
    // Barra de progresso do limite
    var _barra_x = _limite_x;
    var _barra_y = _limite_y + 15;
    var _barra_w = 120;
    var _barra_h = 8;
    
    // Fundo da barra
    draw_set_color(make_color_rgb(64, 64, 64)); // c_darkgray
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, false);
    
    // Preenchimento baseado na população atual
    var _percentual = (global.populacao / global.limite_populacional);
    if (_percentual > 1) _percentual = 1;
    
    var _preenchimento_w = _barra_w * _percentual;
    
    // Cor baseada no percentual
    if (_percentual < 0.5) {
        draw_set_color(c_green);
    } else if (_percentual < 0.8) {
        draw_set_color(c_yellow);
    } else {
        draw_set_color(c_red);
    }
    
    draw_rectangle(_barra_x, _barra_y, _barra_x + _preenchimento_w, _barra_y + _barra_h, false);
    
    // Texto do percentual
    draw_set_color(c_white);
    draw_text(x, _barra_y + 10, "População: " + string(global.populacao) + "/" + string(global.limite_populacional) + " (" + string(round(_percentual * 100)) + "%)");
}

