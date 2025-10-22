// ================================================
// HEGEMONIA GLOBAL - ESTRUTURA: BANCO
// Interface Financeira e Indicadores
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

// === INTERFACE FINANCEIRA ===
if (selecionado) {
    // Informações do banco
    var _info_x = x - 80;
    var _info_y = y - 120;
    
    // Fundo das informações
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_info_x, _info_y, _info_x + 160, _info_y + 100, false);
    draw_set_alpha(1.0);
    
    // Título
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(x, _info_y + 5, "🏦 BANCO CENTRAL");
    
    // Informações financeiras
    draw_text(x, _info_y + 20, "💰 Dinheiro: $" + string(global.dinheiro));
    
    if (global.divida_total > 0) {
        // Mostrar dívida
        draw_set_color(c_red);
        draw_text(x, _info_y + 35, "💸 Dívida: $" + string(global.divida_total));
        draw_text(x, _info_y + 50, "📈 Juros: $" + string(global.juros_mensais) + "/mês");
        
        // Instruções
        draw_set_color(c_yellow);
        draw_text(x, _info_y + 70, "Pressione 'P' para pagar");
        draw_text(x, _info_y + 85, "Clique direito para info");
    } else {
        // Mostrar empréstimo disponível
        draw_set_color(c_green);
        draw_text(x, _info_y + 35, "✅ Sem dívidas");
        
        if (global.emprestimo_disponivel > 0) {
            draw_text(x, _info_y + 50, "💰 Empréstimo: $" + string(global.emprestimo_disponivel));
            draw_text(x, _info_y + 65, "📊 Juros: " + string(round(global.taxa_juros * 100)) + "%/mês");
            
            // Instrução
            draw_set_color(c_yellow);
            draw_text(x, _info_y + 80, "Clique direito para emprestar");
        } else {
            draw_set_color(c_orange);
            draw_text(x, _info_y + 50, "🚫 Empréstimo indisponível");
        }
    }
}

// === INDICADOR DE DÍVIDA GLOBAL ===
// Mostrar alerta se houver dívida
if (global.divida_total > 0) {
    var _alerta_x = x - 60;
    var _alerta_y = y + 50;
    
    // Fundo do alerta
    draw_set_color(c_red);
    draw_set_alpha(0.7);
    draw_rectangle(_alerta_x, _alerta_y, _alerta_x + 120, _alerta_y + 30, false);
    draw_set_alpha(1.0);
    
    // Texto do alerta
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(x, _alerta_y + 5, "⚠️ DÍVIDA ATIVA");
    draw_text(x, _alerta_y + 20, "Juros: $" + string(global.juros_mensais) + "/mês");
}

// === BARRA DE SITUAÇÃO FINANCEIRA ===
if (selecionado) {
    var _barra_x = x - 60;
    var _barra_y = y + 80;
    var _barra_w = 120;
    var _barra_h = 8;
    
    // Fundo da barra
    draw_set_color(c_darkgray);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, false);
    
    // Calcular situação financeira
    var _situacao = 1.0; // 100% = sem dívidas
    if (global.divida_total > 0) {
        _situacao = 1.0 - (global.divida_total / (global.divida_total + global.dinheiro));
    }
    
    var _preenchimento_w = _barra_w * _situacao;
    
    // Cor baseada na situação
    if (_situacao > 0.7) {
        draw_set_color(c_green);
    } else if (_situacao > 0.3) {
        draw_set_color(c_yellow);
    } else {
        draw_set_color(c_red);
    }
    
    draw_rectangle(_barra_x, _barra_y, _barra_x + _preenchimento_w, _barra_y + _barra_h, false);
    
    // Texto da situação
    draw_set_color(c_white);
    var _texto_situacao = "";
    if (global.divida_total == 0) {
        _texto_situacao = "✅ Sem dívidas";
    } else {
        _texto_situacao = "⚠️ Dívida: $" + string(global.divida_total);
    }
    draw_text(x, _barra_y + 10, _texto_situacao);
}
