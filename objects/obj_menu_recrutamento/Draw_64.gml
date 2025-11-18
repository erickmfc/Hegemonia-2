// ===============================================
// HEGEMONIA GLOBAL - MENU MILITAR MODERNO
// Interface Grid com Todas as Unidades Terrestres
// Design Verde Militar
// ===============================================

// Verificar se o quartel ainda existe
if (id_do_quartel == noone || !instance_exists(id_do_quartel)) {
    instance_destroy();
    exit;
}

// Incrementar timer de animação
animation_timer++;

// === ESCALA DE RESOLUÇÃO ===
// ✅ CORREÇÃO: Desabilitar escala de resolução para evitar desproporção
// Usar escala fixa de 1.0 para manter proporções corretas
var _escala_resolucao = 1.0;

// === DIMENSÕES E POSICIONAMENTO ===
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Menu ocupa 90% da tela
var _menu_w = _gui_w * 0.9;
var _menu_h = _gui_h * 0.9;
var _menu_x = (_gui_w - _menu_w) / 2;
var _menu_y = (_gui_h - _menu_h) / 2;

// === OVERLAY DE FUNDO ===
draw_set_alpha(0.92);
draw_set_color(make_color_rgb(5, 10, 20));
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1.0);

// === FUNDO PRINCIPAL COM GRADIENTE VERDE MILITAR ===
// Sombra
draw_set_color(c_black);
draw_set_alpha(0.6);
draw_roundrect_ext(_menu_x + 10, _menu_y + 10, _menu_x + _menu_w + 10, _menu_y + _menu_h + 10, 25, 25, false);

// Fundo principal (verde militar em vez de azul naval)
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(15, 40, 25));
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, 25, 25, false);

// Gradiente superior
draw_set_color(make_color_rgb(30, 80, 50));
draw_set_alpha(0.4);
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + 100, 25, 25, false);
draw_set_alpha(1.0);

// Borda principal (verde claro militar)
draw_set_color(make_color_rgb(60, 200, 120));
draw_set_alpha(0.8);
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, 25, 25, true);
draw_set_alpha(1.0);

// === HEADER ===
var _header_h = 100;
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal
// ✅ CORREÇÃO: Reduzido 15% (1.0 → 0.85)
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_menu_x + _menu_w/2, _menu_y + 35, "QUARTEL MILITAR", 0.85, 0.85, 0);

// Subtítulo
// ✅ CORREÇÃO: Reduzido 15% (0.8 → 0.68)
draw_set_color(make_color_rgb(150, 255, 200));
draw_text_transformed(_menu_x + _menu_w/2, _menu_y + 75, "Central de Produção Terrestre - Exército Disponível", 0.68, 0.68, 0);

// === PAINEL DE RECURSOS ===
var _recursos_y = _menu_y + _header_h + 15;
var _recursos_h = 72;

draw_set_color(make_color_rgb(25, 60, 40));
draw_set_alpha(0.9);
draw_roundrect_ext(_menu_x + 20, _recursos_y, _menu_x + _menu_w - 20, _recursos_y + _recursos_h, 15, 15, false);
draw_set_alpha(1.0);

// Recursos
// ✅ CORREÇÃO: Reduzido 15% (0.9 → 0.765)
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_menu_x + 40, _recursos_y + 20, "DINHEIRO: $" + string(global.dinheiro), 0.765, 0.765, 0);

// Verificar se população existe, senão usar valor padrão
var _populacao = 50;
if (variable_global_exists("populacao")) {
    _populacao = global.populacao;
}

// ✅ CORREÇÃO: Reduzido 15% (0.8 → 0.68)
draw_set_color(make_color_rgb(150, 255, 200));
draw_text_transformed(_menu_x + 40, _recursos_y + 50, "População Disponível: " + string(_populacao), 0.68, 0.68, 0);

// Status do quartel
// ✅ CORREÇÃO: Reduzido 15% (0.9 → 0.765)
draw_set_halign(fa_right);
var _status_text = id_do_quartel.esta_treinando ? "TREINANDO" : "OCIOSO";
var _status_color = id_do_quartel.esta_treinando ? make_color_rgb(255, 200, 50) : make_color_rgb(100, 255, 100);
draw_set_color(_status_color);
draw_text_transformed(_menu_x + _menu_w - 40, _recursos_y + 30, "STATUS: " + _status_text, 0.765, 0.765, 0);

// === GRID DE UNIDADES (3 colunas x 2 linhas) ===
var _grid_start_y = _recursos_y + _recursos_h + 25;
var _grid_h = _menu_h - _header_h - _recursos_h - 220;

var _cols = 3;
var _rows = 2;
var _card_spacing = 24;
var _card_w = (_menu_w - 40 - (_cols - 1) * _card_spacing) / _cols;
// ✅ AJUSTE: Aumentar cards em 5% para baixo (altura)
var _card_h = ((_grid_h - (_rows - 1) * _card_spacing) / _rows) * 1.05;

// Obter lista de unidades
var _unidades;
if (instance_exists(id_do_quartel) && !is_struct(id_do_quartel.unidades_disponiveis)) {
    _unidades = id_do_quartel.unidades_disponiveis;
} else {
    _unidades = ds_list_create();
}
var _total_unidades = ds_list_size(_unidades);

// Mouse position para hover
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);
unidade_hover = -1;

// Desenhar cada unidade
for (var i = 0; i < min(_total_unidades, 6); i++) {
    var _unidade = ds_list_find_value(_unidades, i);
    
    // Calcular posição do card
    var _col = i mod _cols;
    var _row = floor(i / _cols);
    var _card_x = _menu_x + 20 + _col * (_card_w + _card_spacing);
    var _card_y = _grid_start_y + _row * (_card_h + _card_spacing);
    
    // Verificar hover
    var _is_hover = (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _card_w &&
                     _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _card_h);
    
    if (_is_hover) unidade_hover = i;
    
    // Animação do card
    var _anim = card_animations[i];
    _anim.alpha = lerp(_anim.alpha, 1, 0.1);
    _anim.scale = lerp(_anim.scale, 1, 0.15);
    _anim.hover_intensity = lerp(_anim.hover_intensity, _is_hover ? 1 : 0, 0.2);
    _anim.pulse = (_anim.pulse + 0.05) mod (pi * 2);

    // Verificar se pode produzir
    var _can_produce = (global.dinheiro >= _unidade.custo_dinheiro && 
                        _populacao >= _unidade.custo_populacao &&
                        !id_do_quartel.esta_treinando);
    
    // Cores baseadas em estado (verde militar em vez de azul)
    var _card_color = _can_produce ? make_color_rgb(30, 75, 50) : make_color_rgb(40, 50, 40);
    var _border_color = _can_produce ? make_color_rgb(60, 200, 120) : make_color_rgb(80, 90, 80);
    
    if (_is_hover && _can_produce) {
        _card_color = make_color_rgb(40, 110, 70);
        _border_color = make_color_rgb(100, 255, 180);
    }
    
    // Sombra do card
    draw_set_color(c_black);
    draw_set_alpha(0.4 + _anim.hover_intensity * 0.2);
    draw_roundrect_ext(_card_x + 5, _card_y + 5, _card_x + _card_w + 5, _card_y + _card_h + 5, 12, 12, false);
    
    // Fundo do card
    draw_set_alpha(_anim.alpha);
    draw_set_color(_card_color);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 12, 12, false);
    
    // Borda do card
    draw_set_color(_border_color);
    draw_set_alpha(0.7 + _anim.hover_intensity * 0.3);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 12, 12, true);
    
    // Efeito de brilho no topo
    if (_can_produce) {
        draw_set_color(make_color_rgb(120, 255, 180));
        draw_set_alpha(0.15 + sin(_anim.pulse) * 0.1);
        draw_roundrect_ext(_card_x + 3, _card_y + 3, _card_x + _card_w - 3, _card_y + 30, 10, 10, false);
    }
    
    draw_set_alpha(1.0);
    
    // === CONTEÚDO DO CARD ===
    var _content_x = _card_x + 15;
    var _content_y = _card_y + 15;
    
    // Nome da unidade
    // ✅ AJUSTE: Reduzir fonte em 10% adicional (0.7225 * 0.9 = 0.65025)
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_can_produce ? make_color_rgb(255, 255, 255) : make_color_rgb(150, 150, 150));
    draw_text_transformed(_content_x, _content_y, string_upper(_unidade.nome), 0.65025, 0.65025, 0);
    
    // Ícone/Sprite da unidade - POSIÇÃO CENTRALIZADA E VISÍVEL
    var _icon_y = _content_y + 45; // Posição abaixo do nome
    var _icon_x = _card_x + _card_w * 0.5; // Centralizado no card (não relativo ao content_x)
    draw_set_color(_can_produce ? make_color_rgb(80, 220, 140) : make_color_rgb(100, 100, 100));
    draw_set_alpha(0.3);
    draw_circle(_icon_x, _icon_y, 35, false); // Círculo maior para sprites ficarem visíveis
    draw_set_alpha(1.0);
    
    // === CALCULAR ESCALA FINAL PARA SPRITES ===
    // ✅ AJUSTE: Diminuir imagens em 10% (2.025 * 0.9 = 1.8225)
    var _escala_base = 1.8225; // Escala base reduzida em 10% adicional
    var _escala_final = _escala_base; // Sem escala de resolução
    
    // Desenhar sprite se existir
    var _sprite_desenhado = false;
    if (_unidade.nome == "Infantaria" && sprite_exists(spr_infantaria)) {
        draw_sprite_ext(spr_infantaria, 0, _icon_x, _icon_y, _escala_final, _escala_final, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
    } else if (_unidade.nome == "Soldado Anti-Aéreo" && sprite_exists(spr_soldado_antiaereo)) {
        draw_sprite_ext(spr_soldado_antiaereo, 0, _icon_x, _icon_y, _escala_final, _escala_final, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
    } else if (_unidade.nome == "Tanque" && sprite_exists(spr_tanque)) {
        draw_sprite_ext(spr_tanque, 0, _icon_x, _icon_y, _escala_final, _escala_final, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
    } else if (_unidade.nome == "Blindado Anti-Aéreo" && sprite_exists(spr_blindado_antiaereo)) {
        draw_sprite_ext(spr_blindado_antiaereo, 0, _icon_x, _icon_y, _escala_final, _escala_final, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
    } else if (_unidade.nome == "M1A Abrams") {
        // ✅ NOVO: M1A Abrams - Desenhar casco + torre (igual no jogo)
        // ✅ AJUSTE: Diminuir em 10% (2.025 * 0.9 = 1.8225)
        var _escala_tanque = 1.8225;
        
        var _spr_casco = asset_get_index("spr_abrams_casco");
        var _spr_torre = asset_get_index("spr_abrams_torre");
        
        // Desenhar casco (camada 1)
        if (_spr_casco != -1 && sprite_exists(_spr_casco)) {
            draw_sprite_ext(_spr_casco, 0, _icon_x, _icon_y, _escala_tanque, _escala_tanque, 0, c_white, _anim.alpha);
            _sprite_desenhado = true;
        }
        
        // Desenhar torre (camada 2) - mesma posição, sem rotação no menu
        if (_spr_torre != -1 && sprite_exists(_spr_torre)) {
            draw_sprite_ext(_spr_torre, 0, _icon_x, _icon_y, _escala_tanque, _escala_tanque, 0, c_white, _anim.alpha);
        }
        
        // Fallback: se não encontrar os sprites modulares, usar sprite da unidade
        if (!_sprite_desenhado && variable_instance_exists(_unidade, "sprite") && sprite_exists(_unidade.sprite)) {
            draw_sprite_ext(_unidade.sprite, 0, _icon_x, _icon_y, _escala_tanque, _escala_tanque, 0, c_white, _anim.alpha);
            _sprite_desenhado = true;
        }
    } else if (_unidade.nome == "Gepard Anti-Aéreo") {
        // ✅ NOVO: Gepard Anti-Aéreo - Desenhar casco + torre/lançador + Type_39_4 (míssil) em cima (igual no jogo)
        // ✅ AJUSTE: Diminuir em 10% (2.025 * 0.9 = 1.8225)
        var _escala_tanque = 1.8225;
        
        var _spr_casco = asset_get_index("TYPE_39_SAM_HULL");
        var _spr_torre = asset_get_index("Type_39_SAM");
        var _spr_type39_4 = asset_get_index("Type_39_4"); // ✅ Míssil em cima
        
        // Desenhar casco (camada 1)
        if (_spr_casco != -1 && sprite_exists(_spr_casco)) {
            draw_sprite_ext(_spr_casco, 0, _icon_x, _icon_y, _escala_tanque, _escala_tanque, 0, c_white, _anim.alpha);
            _sprite_desenhado = true;
        }
        
        // Desenhar torre/lançador (camada 2) - mesma posição, sem rotação no menu
        if (_spr_torre != -1 && sprite_exists(_spr_torre)) {
            draw_sprite_ext(_spr_torre, 0, _icon_x, _icon_y, _escala_tanque, _escala_tanque, 0, c_white, _anim.alpha);
        }
        
        // ✅ NOVO: Desenhar Type_39_4 (míssil) em cima (camada 3) - posicionado ligeiramente acima
        if (_spr_type39_4 != -1 && sprite_exists(_spr_type39_4)) {
            // Offset para posicionar o míssil em cima do tanque (ajustado para o menu)
            var _offset_y = -8; // Posição vertical do míssil (acima do centro)
            draw_sprite_ext(_spr_type39_4, 0, _icon_x, _icon_y + _offset_y, _escala_tanque, _escala_tanque, 0, c_white, _anim.alpha);
        }
        
        // Fallback: se não encontrar os sprites modulares, usar sprite da unidade
        if (!_sprite_desenhado && variable_instance_exists(_unidade, "sprite") && sprite_exists(_unidade.sprite)) {
            draw_sprite_ext(_unidade.sprite, 0, _icon_x, _icon_y, _escala_tanque, _escala_tanque, 0, c_white, _anim.alpha);
            _sprite_desenhado = true;
        }
    }
    
    // Descrição
    // ✅ CORREÇÃO: Reduzido 15% (0.7 → 0.595)
    var _desc_y = _icon_y + 60; // Posição abaixo do sprite
    draw_set_color(_can_produce ? make_color_rgb(180, 230, 200) : make_color_rgb(120, 120, 120));
    draw_text_ext_transformed(_content_x, _desc_y, _unidade.descricao, 18, _card_w - 30, 0.595, 0.595, 0);
    
    // Informações - POSIÇÃO AJUSTADA (sincronizada com Step)
    // ✅ AJUSTE: Subir informações em 10% (diminuir offset de 120 para 108)
    var _info_y = _card_y + _card_h - 108; // Posição acima dos botões (subiu 10%)
    
    // Custo (Valor)
    // ✅ AJUSTE: Subir valor em 10% (diminuir Y em 10% do offset atual)
    // ✅ AJUSTE: Diminuir fonte em 10% adicional (0.68 * 0.9 = 0.612)
    draw_set_color(_can_produce ? make_color_rgb(255, 215, 0) : make_color_rgb(150, 150, 100));
    var _valor_y = _info_y - 2; // Subir 10% (diminuir Y em ~2 pixels)
    draw_text_transformed(_content_x, _valor_y, "$ " + string(_unidade.custo_dinheiro), 0.612, 0.612, 0);
    
    // ✅ REMOVIDO: População e Tempo (solicitado pelo usuário)
    
    // === BOTÕES DE QUANTIDADE (1, 5, 10) - MELHORADOS ===
    var _btn_quant_y = _card_y + _card_h - 85; // Sincronizado com Step
    // ✅ MELHORIA: Aumentar botões (28 * 1.2 = 33.6)
    var _btn_quant_h = 33.6;
    // ✅ MELHORIA: Aumentar largura (não reduzir)
    var _btn_quant_w = ((_card_w - 30) / 3 - 2);
    var _btn_quant_spacing = 3; // ✅ MELHORIA: Aumentar espaçamento
    
    var _quantidades = [1, 5, 10];
    var _btn_textos = ["1", "5", "10"];
    
    for (var _q = 0; _q < 3; _q++) {
        var _quant = _quantidades[_q];
        var _btn_q_x = _card_x + 15 + _q * (_btn_quant_w + _btn_quant_spacing);
        var _btn_q_y = _btn_quant_y;
        
        // Verificar hover
        var _mouse_over_qbtn = (_mouse_gui_x >= _btn_q_x && _mouse_gui_x <= _btn_q_x + _btn_quant_w &&
                               _mouse_gui_y >= _btn_q_y && _mouse_gui_y <= _btn_q_y + _btn_quant_h);
        
        // Calcular custo para esta quantidade
        var _custo_q_dinheiro = _unidade.custo_dinheiro * _quant;
        var _custo_q_populacao = _unidade.custo_populacao * _quant;
        var _can_afford_quant = (global.dinheiro >= _custo_q_dinheiro && 
                                _populacao >= _custo_q_populacao &&
                                !id_do_quartel.esta_treinando);
        
        // ✅ MELHORIA: Cores mais vibrantes e feedback visual melhorado
        var _qbtn_color = _can_afford_quant ? make_color_rgb(60, 160, 80) : make_color_rgb(80, 80, 80);
        if (_mouse_over_qbtn && _can_afford_quant) {
            _qbtn_color = make_color_rgb(100, 220, 120); // Verde mais claro no hover
        }
        
        // ✅ MELHORIA: Borda mais visível
        draw_set_color(_qbtn_color);
        draw_roundrect_ext(_btn_q_x, _btn_q_y, _btn_q_x + _btn_quant_w, _btn_q_y + _btn_quant_h, 8, 8, false);
        
        // ✅ MELHORIA: Borda branca mais espessa
        draw_set_color(make_color_rgb(255, 255, 255));
        draw_set_alpha(1.0);
        draw_roundrect_ext(_btn_q_x, _btn_q_y, _btn_q_x + _btn_quant_w, _btn_q_y + _btn_quant_h, 8, 8, true);
        draw_set_alpha(1.0);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(_can_afford_quant ? make_color_rgb(255, 255, 255) : make_color_rgb(150, 150, 150));
        // ✅ MELHORIA: Fonte maior para melhor legibilidade
        draw_text_transformed(_btn_q_x + _btn_quant_w/2, _btn_q_y + _btn_quant_h/2, _btn_textos[_q], 0.75, 0.75, 0);
    }
    
    // Botão TREINAR - SINCRONIZADO COM STEP
    var _btn_y = _card_y + _card_h - 50; // Sincronizado com Step
    // ✅ AJUSTE: Reduzir botão em 20% (36 * 0.8 = 28.8)
    var _btn_h = 28.8;
    // ✅ AJUSTE: Reduzir largura em 20%
    var _btn_w = (_card_w - 30) * 0.8;
    var _btn_x = _card_x + 15;
    
    var _btn_color = _can_produce ? make_color_rgb(60, 140, 60) : make_color_rgb(80, 80, 80);
    if (_is_hover && _can_produce) _btn_color = make_color_rgb(80, 180, 80);
    
    draw_set_color(_btn_color);
    draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 8, 8, false);
    
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_set_alpha(0.9);
    draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 8, 8, true);
    draw_set_alpha(1.0);
        
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_can_produce ? make_color_rgb(255, 255, 255) : make_color_rgb(150, 150, 150));
    // ✅ CORREÇÃO: Reduzido 15% (0.85 → 0.7225)
    draw_text_transformed(_btn_x + _btn_w/2, _btn_y + _btn_h/2, _can_produce ? "TREINAR" : "BLOQUEADO", 0.7225, 0.7225, 0);
}

// === FILA DE PRODUÇÃO ===
var _fila_y = _menu_y + _menu_h - 156; // AUMENTADO (130 * 1.2 = 156)
var _fila_h = 96; // AUMENTADO 20% (80 * 1.2 = 96)

draw_set_color(make_color_rgb(25, 60, 40));
draw_set_alpha(0.9);
draw_roundrect_ext(_menu_x + 20, _fila_y, _menu_x + _menu_w - 20, _fila_y + _fila_h, 15, 15, false);
draw_set_alpha(1.0);

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(200, 255, 220));
// ✅ CORREÇÃO: Reduzido 15% (0.9 → 0.765)
draw_text_transformed(_menu_x + 40, _fila_y + 20, "FILA DE RECRUTAMENTO", 0.765, 0.765, 0);

var _fila_size = ds_queue_size(id_do_quartel.fila_recrutamento);
draw_set_color(make_color_rgb(255, 255, 255));
// ✅ CORREÇÃO: Reduzido 15% (0.8 → 0.68)
draw_text_transformed(_menu_x + 40, _fila_y + 54, "Unidades na fila: " + string(_fila_size), 0.68, 0.68, 0);

draw_set_halign(fa_right);
draw_set_color(make_color_rgb(150, 255, 200));
// ✅ CORREÇÃO: Reduzido 15% (0.8 → 0.68)
draw_text_transformed(_menu_x + _menu_w - 40, _fila_y + 54, "Total treinado: " + string(id_do_quartel.unidades_criadas), 0.68, 0.68, 0);

// === BOTÃO FECHAR - SINCRONIZADO COM STEP ===
var _close_w = 168; // Sincronizado com Step
var _close_h = 54; // Sincronizado com Step
var _close_x = _menu_x + _menu_w - _close_w - 20;
var _close_y = _menu_y + _menu_h - 72; // Sincronizado com Step

draw_set_color(make_color_rgb(180, 60, 60));
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 10, 10, false);

draw_set_color(make_color_rgb(255, 255, 255));
draw_set_alpha(0.9);
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 10, 10, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(255, 255, 255));
// ✅ CORREÇÃO: Reduzido 15% (0.9 → 0.765)
draw_text_transformed(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR", 0.765, 0.765, 0);
draw_set_alpha(1.0);

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
