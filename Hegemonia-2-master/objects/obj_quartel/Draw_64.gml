// ===============================================
// HEGEMONIA GLOBAL - QUARTEL: INTERFACE DE RECRUTAMENTO
// Interface Avançada com Múltiplas Unidades (FASE 2)
// ===============================================

// Só desenha o menu se estiver ativo
if (mostrar_menu) {
    
    // === BACKGROUND OVERLAY ===
    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(8, 12, 18));
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    
    // === DIMENSÕES E POSICIONAMENTO DO MENU ===
    var _menu_largura = display_get_gui_width() * 0.45;  // 45% da largura da tela
    var _menu_altura = display_get_gui_height() * 0.6;   // 60% da altura da tela
    var _menu_x = (display_get_gui_width() - _menu_largura) / 2;
    var _menu_y = (display_get_gui_height() - _menu_altura) / 2;
    
    // === FUNDO DO MENU MODERNO ===
    draw_set_color(make_color_rgb(25, 35, 50));
    draw_set_alpha(0.98);
    draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_largura, _menu_y + _menu_altura, 16, 16, false);
    
    // Borda com gradiente
    draw_set_color(make_color_rgb(60, 120, 200));
    draw_set_alpha(0.8);
    draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_largura, _menu_y + _menu_altura, 16, 16, true);
    
    // Efeito de brilho no topo
    draw_set_color(make_color_rgb(100, 160, 255));
    draw_set_alpha(0.3);
    draw_roundrect_ext(_menu_x + 2, _menu_y + 2, _menu_x + _menu_largura - 2, _menu_y + 25, 14, 14, false);
    draw_set_alpha(1);
    
    // === HEADER MODERNO ===
    var _header_h = 60;
    var _header_y = _menu_y + 15;
    
    // Background do header
    draw_set_color(make_color_rgb(35, 45, 65));
    draw_set_alpha(0.95);
    draw_roundrect_ext(_menu_x + 15, _header_y, _menu_x + _menu_largura - 15, _header_y + _header_h, 12, 12, false);
    
    // Título principal
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(240, 245, 255));
    draw_text_transformed(_menu_x + _menu_largura/2, _header_y + 20, "QUARTEL MILITAR", 1.3, 1.3, 0);
    
    // Subtítulo
    draw_set_color(make_color_rgb(180, 200, 220));
    draw_text_transformed(_menu_x + _menu_largura/2, _header_y + 40, "Centro de Recrutamento Avançado", 0.9, 0.9, 0);
    
    // === PAINEL DE INFORMAÇÕES ===
    var _info_x = _menu_x + 25;
    var _info_y = _header_y + _header_h + 25;
    var _info_w = _menu_largura - 50;
    var _info_h = 80;
    
    // Background do painel de informações
    draw_set_color(make_color_rgb(30, 40, 55));
    draw_set_alpha(0.9);
    draw_roundrect_ext(_info_x, _info_y, _info_x + _info_w, _info_y + _info_h, 10, 10, false);
    
    // Borda do painel
    draw_set_color(make_color_rgb(80, 140, 220));
    draw_set_alpha(0.6);
    draw_roundrect_ext(_info_x, _info_y, _info_x + _info_w, _info_y + _info_h, 10, 10, true);
    
    // Informações de recursos
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text_transformed(_info_x + 15, _info_y + 15, "RECURSOS DISPONÍVEIS", 0.9, 0.9, 0);
    
    draw_set_color(c_white);
    draw_text_transformed(_info_x + 15, _info_y + 40, "Dinheiro: $" + string(global.dinheiro), 0.85, 0.85, 0);
    draw_text_transformed(_info_x + 15, _info_y + 60, "População: " + string(global.populacao), 0.85, 0.85, 0);
    
    // === LISTA DE TODAS AS UNIDADES DISPONÍVEIS ===
    var _unidades_y = _info_y + _info_h + 20;
    var _unidade_h = 60;
    var _espaco_unidades = 10;
    
    // Desenhar todas as unidades disponíveis
    for (var i = 0; i < ds_list_size(unidades_disponiveis); i++) {
        var unidade_atual = ds_list_find_value(unidades_disponiveis, i);
        var _unidade_y = _unidades_y + (i * (_unidade_h + _espaco_unidades));
        
        // Verificar se a unidade está selecionada
        var _esta_selecionada = (i == unidade_selecionada);
        
        // Cores baseadas na seleção
        var _cor_fundo = _esta_selecionada ? make_color_rgb(60, 100, 140) : make_color_rgb(50, 70, 90);
        var _cor_borda = _esta_selecionada ? make_color_rgb(120, 200, 255) : make_color_rgb(100, 180, 255);
        
        // Background da unidade
        draw_set_color(_cor_fundo);
        draw_set_alpha(0.9);
        draw_roundrect_ext(_menu_x + 25, _unidade_y, _menu_x + 25 + _info_w, _unidade_y + _unidade_h, 8, 8, false);
        
        // Borda da unidade
        draw_set_color(_cor_borda);
        draw_set_alpha(0.7);
        draw_roundrect_ext(_menu_x + 25, _unidade_y, _menu_x + 25 + _info_w, _unidade_y + _unidade_h, 8, 8, true);
        
        // Indicador de seleção
        if (_esta_selecionada) {
            draw_set_color(make_color_rgb(255, 255, 0));
            draw_set_alpha(0.8);
            draw_roundrect_ext(_menu_x + 25, _unidade_y, _menu_x + 30, _unidade_y + _unidade_h, 4, 4, false);
        }
        
        // Nome da unidade
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        draw_text_transformed(_menu_x + 40, _unidade_y + 10, unidade_atual.nome, 0.9, 0.9, 0);
        
        // Custo e tempo
        draw_set_color(make_color_rgb(255, 215, 0));
        draw_text_transformed(_menu_x + 40, _unidade_y + 30, "$" + string(unidade_atual.custo_dinheiro) + " | " + string(unidade_atual.custo_populacao) + " pop | " + string(unidade_atual.tempo_treino/60) + "s", 0.8, 0.8, 0);
        
        // Descrição
        draw_set_color(make_color_rgb(180, 200, 220));
        draw_text_transformed(_menu_x + 40, _unidade_y + 45, unidade_atual.descricao, 0.75, 0.75, 0);
    }
    
    // === BOTÕES DE QUANTIDADE ===
    var _total_unidades = ds_list_size(unidades_disponiveis);
    var _botoes_y = _unidades_y + (_total_unidades * (_unidade_h + _espaco_unidades)) + 20;
    var _botao_qtd_w = 80;
    var _botao_qtd_h = 40;
    var _espaco_botoes = 20;
    
    // Botão 1 unidade
    draw_set_color(make_color_rgb(60, 120, 200));
    draw_set_alpha(0.9);
    draw_roundrect_ext(_menu_x + 25, _botoes_y, _menu_x + 25 + _botao_qtd_w, _botoes_y + _botao_qtd_h, 8, 8, false);
    draw_set_color(make_color_rgb(100, 180, 255));
    draw_set_alpha(0.7);
    draw_roundrect_ext(_menu_x + 25, _botoes_y, _menu_x + 25 + _botao_qtd_w, _botoes_y + _botao_qtd_h, 8, 8, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text_transformed(_menu_x + 25 + _botao_qtd_w/2, _botoes_y + _botao_qtd_h/2 - 8, "1", 1.0, 1.0, 0);
    draw_text_transformed(_menu_x + 25 + _botao_qtd_w/2, _botoes_y + _botao_qtd_h/2 + 8, "$100", 0.8, 0.8, 0);
    
    // Botão 5 unidades
    draw_set_color(make_color_rgb(60, 120, 200));
    draw_set_alpha(0.9);
    draw_roundrect_ext(_menu_x + 25 + _botao_qtd_w + _espaco_botoes, _botoes_y, _menu_x + 25 + (_botao_qtd_w + _espaco_botoes) + _botao_qtd_w, _botoes_y + _botao_qtd_h, 8, 8, false);
    draw_set_color(make_color_rgb(100, 180, 255));
    draw_set_alpha(0.7);
    draw_roundrect_ext(_menu_x + 25 + _botao_qtd_w + _espaco_botoes, _botoes_y, _menu_x + 25 + (_botao_qtd_w + _espaco_botoes) + _botao_qtd_w, _botoes_y + _botao_qtd_h, 8, 8, true);
    
    draw_set_color(c_white);
    draw_text_transformed(_menu_x + 25 + _botao_qtd_w + _espaco_botoes + _botao_qtd_w/2, _botoes_y + _botao_qtd_h/2 - 8, "5", 1.0, 1.0, 0);
    draw_text_transformed(_menu_x + 25 + _botao_qtd_w + _espaco_botoes + _botao_qtd_w/2, _botoes_y + _botao_qtd_h/2 + 8, "$500", 0.8, 0.8, 0);
    
    // Botão 10 unidades
    draw_set_color(make_color_rgb(60, 120, 200));
    draw_set_alpha(0.9);
    draw_roundrect_ext(_menu_x + 25 + (_botao_qtd_w + _espaco_botoes) * 2, _botoes_y, _menu_x + 25 + (_botao_qtd_w + _espaco_botoes) * 2 + _botao_qtd_w, _botoes_y + _botao_qtd_h, 8, 8, false);
    draw_set_color(make_color_rgb(100, 180, 255));
    draw_set_alpha(0.7);
    draw_roundrect_ext(_menu_x + 25 + (_botao_qtd_w + _espaco_botoes) * 2, _botoes_y, _menu_x + 25 + (_botao_qtd_w + _espaco_botoes) * 2 + _botao_qtd_w, _botoes_y + _botao_qtd_h, 8, 8, true);
    
    draw_set_color(c_white);
    draw_text_transformed(_menu_x + 25 + (_botao_qtd_w + _espaco_botoes) * 2 + _botao_qtd_w/2, _botoes_y + _botao_qtd_h/2 - 8, "10", 1.0, 1.0, 0);
    draw_text_transformed(_menu_x + 25 + (_botao_qtd_w + _espaco_botoes) * 2 + _botao_qtd_w/2, _botoes_y + _botao_qtd_h/2 + 8, "$1000", 0.8, 0.8, 0);
    
    // === STATUS DE RECRUTAMENTO ===
    var _status_x = _info_x;
    var _status_y = _botoes_y + _botao_qtd_h + 20;
    var _status_w = _info_w;
    var _status_h = 80;
    
    // Background do status
    draw_set_color(make_color_rgb(30, 40, 55));
    draw_set_alpha(0.9);
    draw_roundrect_ext(_status_x, _status_y, _status_x + _status_w, _status_y + _status_h, 10, 10, false);
    
    // Borda do status
    draw_set_color(make_color_rgb(80, 140, 220));
    draw_set_alpha(0.6);
    draw_roundrect_ext(_status_x, _status_y, _status_x + _status_w, _status_y + _status_h, 10, 10, true);
    
    if (recrutamento_em_andamento) {
        var unidade_atual = ds_list_find_value(unidades_disponiveis, unidade_selecionada);
        draw_set_color(c_yellow);
        draw_text_transformed(_status_x + 15, _status_y + 15, "TREINANDO: " + unidade_atual.nome, 0.9, 0.9, 0);
        
        // Barra de progresso do treinamento
        var progresso = 1 - (tempo_treinamento_restante / unidade_atual.tempo_treino);
        var barra_w = _status_w - 30;
        var barra_h = 8;
        var barra_x = _status_x + 15;
        var barra_y = _status_y + 35;
        
        // Fundo da barra
        draw_set_color(make_color_rgb(40, 50, 70));
        draw_roundrect_ext(barra_x, barra_y, barra_x + barra_w, barra_y + barra_h, 4, 4, false);
        
        // Progresso
        draw_set_color(c_yellow);
        draw_roundrect_ext(barra_x, barra_y, barra_x + (barra_w * progresso), barra_y + barra_h, 4, 4, false);
        
        // Contorno
        draw_set_color(c_white);
        draw_roundrect_ext(barra_x, barra_y, barra_x + barra_w, barra_y + barra_h, 4, 4, true);
        
        // Tempo restante
        draw_set_color(c_white);
        draw_text_transformed(_status_x + 15, _status_y + 50, "Tempo restante: " + string(ceil(tempo_treinamento_restante / 60)) + "s", 0.8, 0.8, 0);
        
        // Fila de recrutamento
        var fila_size = ds_queue_size(fila_recrutamento);
        if (fila_size > 0) {
            draw_text_transformed(_status_x + 15, _status_y + 65, "Fila: " + string(fila_size) + " unidades aguardando", 0.8, 0.8, 0);
        }
        
    } else {
        draw_set_color(c_lime);
        draw_text_transformed(_status_x + 15, _status_y + 20, "PRONTO PARA RECRUTAR", 0.9, 0.9, 0);
        draw_text_transformed(_status_x + 15, _status_y + 40, "Selecione uma unidade e clique em RECRUTAR", 0.8, 0.8, 0);
        
        // Mostrar estatísticas
        draw_set_color(make_color_rgb(180, 200, 220));
        draw_text_transformed(_status_x + 15, _status_y + 60, "Unidades treinadas: " + string(unidades_treinadas_total), 0.75, 0.75, 0);
    }
    
    // === BOTÃO DE RECRUTAMENTO ===
    var _botao_x = _menu_x + 25;
    var _botao_y = _menu_y + _menu_altura - 120;
    var _botao_w = _menu_largura - 50;
    var _botao_h = 45;
    
    // Desenhar botão apenas se não estiver recrutando
    if (!recrutamento_em_andamento) {
        var unidade_atual = ds_list_find_value(unidades_disponiveis, unidade_selecionada);
        
        // Verificar se tem recursos suficientes
        var pode_recrutar = global.dinheiro >= unidade_atual.custo_dinheiro && global.populacao >= unidade_atual.custo_populacao;
        var fila_cheia = ds_queue_size(fila_recrutamento) >= max_fila;
        
        // Background do botão
        var cor_botao = (pode_recrutar && !fila_cheia) ? make_color_rgb(60, 120, 200) : make_color_rgb(80, 60, 60);
        draw_set_color(cor_botao);
        draw_set_alpha(0.9);
        draw_roundrect_ext(_botao_x, _botao_y, _botao_x + _botao_w, _botao_y + _botao_h, 10, 10, false);
        
        // Borda do botão
        var cor_borda = (pode_recrutar && !fila_cheia) ? make_color_rgb(100, 180, 255) : make_color_rgb(200, 120, 120);
        draw_set_color(cor_borda);
        draw_set_alpha(0.7);
        draw_roundrect_ext(_botao_x, _botao_y, _botao_x + _botao_w, _botao_y + _botao_h, 10, 10, true);
        
        // Texto do botão
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var cor_texto = (pode_recrutar && !fila_cheia) ? c_white : make_color_rgb(200, 200, 200);
        draw_set_color(cor_texto);
        draw_set_alpha(1);
        draw_text_transformed(_botao_x + _botao_w/2, _botao_y + _botao_h/2 - 5, "RECRUTAR " + unidade_atual.nome, 0.9, 0.9, 0);
        draw_text_transformed(_botao_x + _botao_w/2, _botao_y + _botao_h/2 + 15, "Fila: " + string(ds_queue_size(fila_recrutamento)) + "/" + string(max_fila), 0.8, 0.8, 0);
    }
    
    // === BOTÃO FECHAR ===
    var _fechar_x = _menu_x + _menu_largura - 80;
    var _fechar_y = _menu_y + 15;
    var _fechar_w = 70;
    var _fechar_h = 30;
    
    // Background do botão fechar
    draw_set_color(make_color_rgb(120, 60, 60));
    draw_set_alpha(0.9);
    draw_roundrect_ext(_fechar_x, _fechar_y, _fechar_x + _fechar_w, _fechar_y + _fechar_h, 8, 8, false);
    
    // Borda do botão fechar
    draw_set_color(make_color_rgb(200, 100, 100));
    draw_set_alpha(0.7);
    draw_roundrect_ext(_fechar_x, _fechar_y, _fechar_x + _fechar_w, _fechar_y + _fechar_h, 8, 8, true);
    
    // Texto do botão fechar
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_text_transformed(_fechar_x + _fechar_w/2, _fechar_y + _fechar_h/2, "FECHAR", 0.9, 0.9, 0);
    
    // === INSTRUÇÕES ===
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(200, 220, 255));
    draw_text_transformed(_menu_x + _menu_largura/2, _menu_y + _menu_altura - 20, "Clique nas unidades para selecionar • Clique fora para fechar", 0.7, 0.7, 0);
    
    // === RESET DE CONFIGURAÇÕES DE DESENHO ===
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}
