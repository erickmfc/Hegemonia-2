// =========================================================
// SISTEMA AVANÇADO DE FONTE HEGEMONIA MAIN
// Configurações otimizadas e melhorias visuais
// =========================================================

// =========================================================
// FUNÇÃO PARA APLICAR FONTE HEGEMONIA MAIN COM MELHORIAS
// =========================================================

function scr_aplicar_fonte_hegemonia_main_melhorada() {
    // Usar especificamente a fonte hegemonia_main
    if (font_exists(hegemonia_main)) {
        draw_set_font(hegemonia_main);
        
        // Configurações otimizadas para melhor legibilidade
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        // Configurações de qualidade de texto
        draw_set_color(c_white);
        draw_set_alpha(1.0);
        
        return true;
    }
    
    // Fallback para sistema padrão
    scr_aplicar_fonte_hegemonia();
    return false;
}

// =========================================================
// FUNÇÃO PARA DESENHAR TEXTO COM SOMBRA (Efeito 3D)
// =========================================================

function scr_desenhar_texto_hegemonia_com_sombra(_x, _y, _texto, _cor_principal = c_white, _cor_sombra = c_black, _offset_sombra = 1) {
    // Aplicar fonte hegemonia_main
    scr_aplicar_fonte_hegemonia_main_melhorada();
    
    // Desenhar sombra
    draw_set_color(_cor_sombra);
    draw_text(_x + _offset_sombra, _y + _offset_sombra, _texto);
    
    // Desenhar texto principal
    draw_set_color(_cor_principal);
    draw_text(_x, _y, _texto);
    
    // Resetar cor
    draw_set_color(c_white);
}

// =========================================================
// FUNÇÃO PARA DESENHAR TEXTO COM GRADIENTE
// =========================================================

function scr_desenhar_texto_hegemonia_gradiente(_x, _y, _texto, _cor_inicio = c_lime, _cor_fim = c_aqua) {
    // Aplicar fonte hegemonia_main
    scr_aplicar_fonte_hegemonia_main_melhorada();
    
    // Calcular largura do texto
    var _largura_texto = string_width(_texto);
    var _altura_texto = string_height(_texto);
    
    // Desenhar texto com gradiente (simulado com múltiplas linhas)
    var _num_linhas = 5;
    for (var i = 0; i < _num_linhas; i++) {
        var _fator = i / (_num_linhas - 1);
        var _cor_interpolada = merge_color(_cor_inicio, _cor_fim, _fator);
        
        draw_set_color(_cor_interpolada);
        draw_text(_x, _y + i, _texto);
    }
    
    // Resetar cor
    draw_set_color(c_white);
}

// =========================================================
// FUNÇÃO PARA DESENHAR PAINEL AVANÇADO COM HEGEMONIA MAIN
// =========================================================

function scr_desenhar_painel_hegemonia_main_avancado(_x, _y, _largura, _altura, _titulo, _linhas = [], _cor_tema = c_aqua) {
    // Aplicar fonte hegemonia_main
    scr_aplicar_fonte_hegemonia_main_melhorada();
    
    // Desenhar fundo com gradiente
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_x, _y, _x + _largura, _y + _altura, false);
    draw_set_alpha(1.0);
    
    // Desenhar borda com efeito 3D
    draw_set_color(_cor_tema);
    draw_set_alpha(0.9);
    draw_rectangle(_x, _y, _x + _largura, _y + _altura, true);
    
    // Desenhar título com sombra
    scr_desenhar_texto_hegemonia_com_sombra(_x + 10, _y + 8, _titulo, c_white, c_black, 1);
    
    // Desenhar linhas
    var _linha_y = _y + 30;
    for (var i = 0; i < array_length(_linhas); i++) {
        scr_desenhar_texto_hegemonia_com_sombra(_x + 10, _linha_y, _linhas[i], c_white, c_black, 1);
        _linha_y += 18;
    }
    
    // Resetar configurações
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}

// =========================================================
// FUNÇÃO PARA TESTAR TODAS AS MELHORIAS DA FONTE
// =========================================================

function scr_teste_fonte_hegemonia_main_melhorada() {
    show_debug_message("🎨 TESTE DA FONTE HEGEMONIA MAIN MELHORADA");
    show_debug_message("==========================================");
    
    // Teste 1: Fonte básica
    if (scr_aplicar_fonte_hegemonia_main_melhorada()) {
        show_debug_message("✅ Fonte hegemonia_main melhorada aplicada");
    } else {
        show_debug_message("❌ Erro ao aplicar fonte melhorada");
    }
    
    // Teste 2: Texto com sombra
    try {
        scr_desenhar_texto_hegemonia_com_sombra(100, 100, "Texto com Sombra", c_lime, c_black, 2);
        show_debug_message("✅ Texto com sombra funcionando");
    } catch (e) {
        show_debug_message("❌ Erro no texto com sombra: " + string(e));
    }
    
    // Teste 3: Texto com gradiente
    try {
        scr_desenhar_texto_hegemonia_gradiente(100, 130, "Texto com Gradiente", c_lime, c_aqua);
        show_debug_message("✅ Texto com gradiente funcionando");
    } catch (e) {
        show_debug_message("❌ Erro no texto com gradiente: " + string(e));
    }
    
    // Teste 4: Painel avançado
    try {
        var _linhas_teste = ["Linha 1", "Linha 2", "Linha 3"];
        scr_desenhar_painel_hegemonia_main_avancado(200, 200, 300, 150, "Painel Avançado", _linhas_teste, c_aqua);
        show_debug_message("✅ Painel avançado funcionando");
    } catch (e) {
        show_debug_message("❌ Erro no painel avançado: " + string(e));
    }
    
    show_debug_message("==========================================");
    show_debug_message("🏁 Teste da fonte melhorada concluído");
}
