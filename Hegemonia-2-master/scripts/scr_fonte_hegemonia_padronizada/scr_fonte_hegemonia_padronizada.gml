// =========================================================
// SISTEMA DE FONTES PADRONIZADO PARA HEGEMONIA GLOBAL
// Função para aplicar fonte correta com fallback
// =========================================================

function scr_aplicar_fonte_hegemonia() {
    // Prioridade 1: Usar a fonte principal personalizada do projeto
    if (font_exists(hegemonia_main)) {
        draw_set_font(hegemonia_main);
        return true;
    }
    
    // Prioridade 2: Usar fonte UI existente
    if (font_exists(fnt_ui_main)) {
        draw_set_font(fnt_ui_main);
        return true;
    }
    
    // Fallback: Fonte padrão do sistema
    draw_set_font(-1);
    return false;
}

// =========================================================
// FUNÇÃO ESPECÍFICA PARA FONTE HEGEMONIA MAIN
// Configurações otimizadas para a fonte personalizada
// =========================================================

function scr_aplicar_fonte_hegemonia_main() {
    // Usar especificamente a fonte hegemonia_main
    if (font_exists(hegemonia_main)) {
        draw_set_font(hegemonia_main);
        
        // Configurações otimizadas para melhor legibilidade
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        return true;
    }
    
    // Fallback para sistema padrão
    scr_aplicar_fonte_hegemonia();
    return false;
}

// =========================================================
// FUNÇÃO PARA DESENHAR TEXTO COM FONTE HEGEMONIA MAIN
// =========================================================

function scr_desenhar_texto_hegemonia_main(_x, _y, _texto, _cor = c_white, _halign = fa_left, _valign = fa_top, _alpha = 1.0) {
    // Aplicar fonte hegemonia_main
    scr_aplicar_fonte_hegemonia_main();
    
    // Configurar alinhamento
    draw_set_halign(_halign);
    draw_set_valign(_valign);
    
    // Configurar cor e transparência
    draw_set_color(_cor);
    draw_set_alpha(_alpha);
    
    // Desenhar texto
    draw_text(_x, _y, _texto);
    
    // Resetar configurações
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

function scr_desenhar_texto_hegemonia(_x, _y, _texto, _cor = c_white, _halign = fa_left, _valign = fa_top) {
    // Aplicar fonte padronizada
    scr_aplicar_fonte_hegemonia();
    
    // Configurar alinhamento
    draw_set_halign(_halign);
    draw_set_valign(_valign);
    
    // Configurar cor
    draw_set_color(_cor);
    
    // Desenhar texto
    draw_text(_x, _y, _texto);
    
    // Resetar configurações
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// =========================================================
// FUNÇÃO PARA DESENHAR PAINEL COM FONTE PADRONIZADA
// =========================================================

function scr_desenhar_painel_hegemonia(_x, _y, _largura, _altura, _titulo, _linhas = [], _cor_borda = c_aqua) {
    // Aplicar fonte padronizada
    scr_aplicar_fonte_hegemonia();
    
    // Desenhar fundo
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(_x, _y, _x + _largura, _y + _altura, false);
    draw_set_alpha(1.0);
    
    // Desenhar borda
    draw_set_color(_cor_borda);
    draw_set_alpha(0.8);
    draw_rectangle(_x, _y, _x + _largura, _y + _altura, true);
    draw_set_alpha(1.0);
    
    // Desenhar título
    draw_set_color(c_white);
    draw_text(_x + 10, _y + 5, _titulo);
    
    // Desenhar linhas
    var _linha_y = _y + 25;
    for (var i = 0; i < array_length(_linhas); i++) {
        draw_text(_x + 10, _linha_y, _linhas[i]);
        _linha_y += 18;
    }
    
    // Resetar configurações
    draw_set_color(c_white);
}
