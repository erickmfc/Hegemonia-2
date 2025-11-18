/// @description Hegemonia Global - Centro de Pesquisa Moderno
/// Design baseado no Quartel de Marinha

// ===============================================
// HEGEMONIA GLOBAL - CENTRO DE PESQUISA MODERNO
// Design baseado no Quartel de Marinha
// ===============================================

if (!global.menu_pesquisa_aberto) return;

// === CONFIGURAÇÃO DE FONTE ===
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}

// === DIMENSÕES E POSICIONAMENTO ===
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Menu ocupa 90% da tela (mesmo padrão do quartel de marinha)
var _menu_w = _gui_w * 0.9;
var _menu_h = _gui_h * 0.9;
var _menu_x = (_gui_w - _menu_w) / 2;
var _menu_y = (_gui_h - _menu_h) / 2;

// === OVERLAY DE FUNDO ===
draw_set_alpha(0.92);
draw_set_color(make_color_rgb(5, 10, 20));
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1.0);
draw_set_color(c_white);

// === FUNDO PRINCIPAL COM GRADIENTE ===
// Sombra
draw_set_color(c_black);
draw_set_alpha(0.6);
draw_roundrect_ext(_menu_x + 10, _menu_y + 10, _menu_x + _menu_w + 10, _menu_y + _menu_h + 10, 25, 25, false);
draw_set_alpha(1.0);
draw_set_color(c_white);

// Fundo principal
draw_set_color(make_color_rgb(15, 25, 40));
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, 25, 25, false);

// Gradiente superior
draw_set_color(make_color_rgb(30, 50, 80));
draw_set_alpha(0.4);
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + 100, 25, 25, false);
draw_set_alpha(1.0);
draw_set_color(c_white);

// Borda principal
draw_set_color(make_color_rgb(60, 120, 200));
draw_set_alpha(0.8);
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, 25, 25, true);
draw_set_alpha(1.0);
draw_set_color(c_white);

// === HEADER ===
var _header_h = 100;
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_menu_x + _menu_w/2, _menu_y + 35, "CENTRO DE PESQUISA TECNOLÓGICA", 1.8, 1.8, 0);

// Subtítulo
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(150, 200, 255));
draw_text_transformed(_menu_x + _menu_w/2, _menu_y + 70, "Desenvolva novas tecnologias para expandir seu império", 1.0, 1.0, 0);

// === PAINEL DE RECURSOS ===
var _recursos_y = _menu_y + _header_h + 10;
var _recursos_h = 60;

draw_set_color(make_color_rgb(25, 40, 60));
draw_set_alpha(0.9);
draw_roundrect_ext(_menu_x + 20, _recursos_y, _menu_x + _menu_w - 20, _recursos_y + _recursos_h, 15, 15, false);
draw_set_alpha(1.0);
draw_set_color(c_white);

// Dinheiro
draw_set_halign(fa_left);
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_menu_x + 40, _recursos_y + 20, "DINHEIRO: $" + string(global.dinheiro), 1.2, 1.2, 0);

// Slots de pesquisa
var _slot_progress = global.slots_pesquisa_usados / global.slots_pesquisa_total;
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(150, 200, 255));
draw_text_transformed(_menu_x + 40, _recursos_y + 45, "SLOTS: " + string(global.slots_pesquisa_usados) + "/" + string(global.slots_pesquisa_total), 0.9, 0.9, 0);

// Barra de progresso dos slots
// ✅ CORREÇÃO: Barra desceu 10% (de 30 para 40)
var _slot_bar_x = _menu_x + 200;
var _slot_bar_y = _recursos_y + 40; // Desceu 10% (de 30 para 40)
var _slot_bar_w = 200;
var _slot_bar_h = 12;

draw_set_color(make_color_rgb(40, 50, 70));
draw_roundrect_ext(_slot_bar_x, _slot_bar_y, _slot_bar_x + _slot_bar_w, _slot_bar_y + _slot_bar_h, 6, 6, false);

var _slot_color = (global.slots_pesquisa_usados < global.slots_pesquisa_total) ? 
    make_color_rgb(100, 200, 100) : make_color_rgb(200, 100, 100);
draw_set_color(_slot_color);
draw_roundrect_ext(_slot_bar_x, _slot_bar_y, _slot_bar_x + (_slot_bar_w * _slot_progress), _slot_bar_y + _slot_bar_h, 6, 6, false);

// Status do centro
draw_set_halign(fa_right);
var _status_text = (global.slots_pesquisa_usados < global.slots_pesquisa_total) ? "DISPONÍVEL" : "LOTADO";
// ✅ CORREÇÃO GM2044: Renomear para evitar duplicação com variável mais abaixo
var _status_color_header = (global.slots_pesquisa_usados < global.slots_pesquisa_total) ? make_color_rgb(100, 255, 100) : make_color_rgb(255, 200, 50);
draw_set_alpha(1.0);
draw_set_color(_status_color_header);
draw_text_transformed(_menu_x + _menu_w - 40, _recursos_y + 30, "STATUS: " + _status_text, 1.0, 1.0, 0);

// === GRID DE PESQUISAS (4 colunas x 3 linhas) ===
var _grid_start_y = _recursos_y + _recursos_h + 20;
var _grid_h = _menu_h - _header_h - _recursos_h - 220; // Espaço para footer e botões

var _cols = 4;
var _rows = 3;
var _card_spacing = 20;
var _card_w = (_menu_w - 40 - (_cols - 1) * _card_spacing) / _cols;
var _card_h = ((_grid_h - (_rows - 1) * _card_spacing) / _rows) * 0.85;

// Mouse position para hover
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

// === DESENHO DOS CARDS DE PESQUISA ===
for (var i = 0; i < array_length(research_names); i++) {
    var _col = i mod _cols;
    var _row = floor(i / _cols);
    var _card_x = _menu_x + 20 + _col * (_card_w + _card_spacing);
    var _card_y = _grid_start_y + _row * (_card_h + _card_spacing);
    
    var research_name = research_names[i];
    var research_sprite = research_sprites[i];
    var status = global.nacao_recursos[? research_name];
    
    // Verificar hover
    var _is_hover = (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _card_w &&
                     _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _card_h);
    
    // Verificar se pode pesquisar
    var _can_research = (status == RESOURCE_STATUS.AVAILABLE && 
                        global.slots_pesquisa_usados < global.slots_pesquisa_total);
    
    // Determinar custo
    var _custo_text = "";
    switch(research_name) {
        case "Borracha": _custo_text = "$2.400"; break;
        case "Petroleo": _custo_text = "$3.000"; break;
        case "Silicio": _custo_text = "$3.200"; break;
        case "Mina": _custo_text = "$2.000"; break;
        case "Aluminio": _custo_text = "$3.600"; break;
        case "Centro": _custo_text = "$4.000"; break;
        case "Ouro": _custo_text = "$6.000"; break;
        case "Serraria": _custo_text = "$1.600"; break;
        case "Cobre": _custo_text = "$2.800"; break;
        case "Uranio": _custo_text = "$10.000"; break;
        case "Litio": _custo_text = "$4.800"; break;
        case "Titanio": _custo_text = "$7.200"; break;
        default: _custo_text = "$2.000"; break;
    }
    
    var _tempo_text = "";
    switch(research_name) {
        case "Borracha": _tempo_text = "40s"; break;
        case "Petroleo": _tempo_text = "45s"; break;
        case "Silicio": _tempo_text = "60s"; break;
        case "Mina": _tempo_text = "30s"; break;
        case "Aluminio": _tempo_text = "50s"; break;
        case "Centro": _tempo_text = "70s"; break;
        case "Ouro": _tempo_text = "80s"; break;
        case "Serraria": _tempo_text = "25s"; break;
        case "Cobre": _tempo_text = "35s"; break;
        case "Uranio": _tempo_text = "120s"; break;
        case "Litio": _tempo_text = "90s"; break;
        case "Titanio": _tempo_text = "100s"; break;
        default: _tempo_text = "30s"; break;
    }
    
    // Cores baseadas em estado
    var _card_color = make_color_rgb(40, 40, 50);
    var _border_color = make_color_rgb(80, 80, 90);
    
    switch(status) {
        case RESOURCE_STATUS.AVAILABLE:
            if (_can_research) {
                _card_color = make_color_rgb(30, 50, 75);
                _border_color = make_color_rgb(60, 120, 200);
            } else {
                _card_color = make_color_rgb(40, 40, 50);
                _border_color = make_color_rgb(80, 80, 90);
            }
            break;
        case RESOURCE_STATUS.RESEARCHING:
            _card_color = make_color_rgb(60, 45, 30);
            _border_color = make_color_rgb(255, 180, 80);
            break;
        case RESOURCE_STATUS.RESEARCHED:
            _card_color = make_color_rgb(35, 65, 45);
            _border_color = make_color_rgb(120, 255, 150);
            break;
    }
    
    if (_is_hover && _can_research) {
        _card_color = make_color_rgb(40, 70, 110);
        _border_color = make_color_rgb(100, 180, 255);
    }
    
    // Sombra do card
    draw_set_color(c_black);
    draw_set_alpha(0.4 + (_is_hover ? 0.2 : 0));
    draw_roundrect_ext(_card_x + 5, _card_y + 5, _card_x + _card_w + 5, _card_y + _card_h + 5, 12, 12, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    
    // Fundo do card
    draw_set_color(_card_color);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 12, 12, false);
    
    // Borda do card
    draw_set_color(_border_color);
    draw_set_alpha(0.7 + (_is_hover ? 0.3 : 0));
    draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 12, 12, true);
    
    // Efeito de brilho no topo
    if (_can_research || status == RESOURCE_STATUS.RESEARCHING) {
        draw_set_color(make_color_rgb(120, 180, 255));
        draw_set_alpha(0.15);
        draw_roundrect_ext(_card_x + 3, _card_y + 3, _card_x + _card_w - 3, _card_y + 30, 10, 10, false);
    }
    
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    
    // === CONTEÚDO DO CARD ===
    var _content_x = _card_x + 15;
    var _content_y = _card_y + 10;
    
    // Nome da pesquisa
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    var _display_name = research_name;
    switch(research_name) {
        case "Borracha": _display_name = "BORRACHA"; break;
        case "Petroleo": _display_name = "PETRÓLEO"; break;
        case "Silicio": _display_name = "SILÍCIO"; break;
        case "Mina": _display_name = "MINERAÇÃO"; break;
        case "Aluminio": _display_name = "ALUMÍNIO"; break;
        case "Centro": _display_name = "CENTRO IND."; break;
        case "Ouro": _display_name = "OURO"; break;
        case "Serraria": _display_name = "SERRARIA"; break;
        case "Cobre": _display_name = "COBRE"; break;
        case "Uranio": _display_name = "URÂNIO"; break;
        case "Litio": _display_name = "LÍTIO"; break;
        case "Titanio": _display_name = "TITÂNIO"; break;
        default: _display_name = string_upper(research_name); break;
    }
    
    draw_set_alpha(1.0);
    var _name_color = make_color_rgb(150, 150, 150);
    if (status == RESOURCE_STATUS.RESEARCHED || _can_research) {
        _name_color = make_color_rgb(255, 255, 255);
    }
    draw_set_color(_name_color);
    draw_text_transformed(_content_x, _content_y, _display_name, 0.95, 0.95, 0);
    
    // === ÍCONE DA PESQUISA ===
    var _icon_y = _content_y + 35;
    var _icon_x = _content_x + (_card_w * 0.6);
    
    if (sprite_exists(research_sprite)) {
        var _icon_scale = 1.5;
        draw_set_alpha(1);
        draw_sprite_ext(research_sprite, 0, _icon_x, _icon_y, _icon_scale, _icon_scale, 0, c_white, 1);
    } else {
        // Placeholder circular
        draw_set_color(_can_research ? make_color_rgb(80, 140, 220) : make_color_rgb(100, 100, 100));
        draw_set_alpha(0.3);
        draw_circle(_icon_x, _icon_y, 25, false);
        draw_set_alpha(1.0);
        draw_set_color(c_white);
    }
    
    // === INFORMAÇÕES (CUSTO E TEMPO) ===
    var _info_y = _card_y + _card_h - 75;
    
    // Custo
    draw_set_halign(fa_left);
    draw_set_alpha(1.0);
    var _cost_color = make_color_rgb(150, 150, 100);
    if (status == RESOURCE_STATUS.RESEARCHED) {
        _cost_color = make_color_rgb(150, 255, 150);
    } else if (_can_research) {
        _cost_color = make_color_rgb(255, 215, 0);
    }
    draw_set_color(_cost_color);
    draw_text_transformed(_content_x, _info_y, _custo_text, 0.9, 0.9, 0);
    
    // Tempo
    draw_set_alpha(1.0);
    var _time_color = make_color_rgb(120, 120, 120);
    if (status == RESOURCE_STATUS.RESEARCHED) {
        _time_color = make_color_rgb(150, 200, 150);
    } else if (_can_research) {
        _time_color = make_color_rgb(150, 200, 255);
    }
    draw_set_color(_time_color);
    draw_text_transformed(_content_x, _info_y + 18, "Tempo: " + _tempo_text, 0.75, 0.75, 0);
    
    // === STATUS INDICATOR ===
    // ✅ CORREÇÃO GM2044: Renomear variável local para evitar duplicação
    var _status_text_card = "";
    var _status_color_indicator = c_white;
    
    switch(status) {
        case RESOURCE_STATUS.AVAILABLE:
            if (_can_research) {
                _status_text_card = "DISPONÍVEL";
                _status_color_indicator = make_color_rgb(100, 200, 255);
            } else {
                _status_text_card = "SEM SLOT";
                _status_color_indicator = make_color_rgb(150, 150, 150);
            }
            break;
        case RESOURCE_STATUS.RESEARCHING:
            _status_text_card = "EM ANDAMENTO";
            _status_color_indicator = make_color_rgb(255, 180, 80);
            break;
        case RESOURCE_STATUS.RESEARCHED:
            _status_text_card = "COMPLETO";
            _status_color_indicator = make_color_rgb(120, 255, 150);
            break;
        default:
            _status_text_card = "BLOQUEADO";
            _status_color_indicator = make_color_rgb(255, 100, 100);
            break;
    }
    
    // Background do status
    var _status_y = _card_y + _card_h - 30;
    draw_set_color(make_color_rgb(20, 25, 35));
    draw_set_alpha(0.8);
    draw_roundrect_ext(_card_x + 5, _status_y - 5, _card_x + _card_w - 5, _status_y + 20, 6, 6, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    
    // Texto do status
    draw_set_halign(fa_center);
    draw_set_color(_status_color_indicator);
    draw_set_alpha(1.0);
    draw_text_transformed(_card_x + _card_w/2, _status_y + 7, _status_text_card, 0.7, 0.7, 0);
}

// === PAINEL DE SLOT EXTRA ===
var _slot_y = _menu_y + _menu_h - 160;
var _slot_h = 80;

draw_set_color(make_color_rgb(25, 40, 60));
draw_set_alpha(0.9);
draw_roundrect_ext(_menu_x + 20, _slot_y, _menu_x + _menu_w - 20, _slot_y + _slot_h, 15, 15, false);
draw_set_alpha(1.0);
draw_set_color(c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(200, 220, 255));
draw_text_transformed(_menu_x + 40, _slot_y + 20, "EXPANSÃO DE SLOTS", 1.0, 1.0, 0);

// Botão de slot extra (se tiver 3 slots)
if (global.slots_pesquisa_total == 3) {
    var _slot_btn_x = _menu_x + 40;
    var _slot_btn_y = _slot_y + 40;
    var _slot_btn_w = 240;
    var _slot_btn_h = 35;
    var _can_afford = global.dinheiro >= global.custo_slot_extra;
    
    // Background do botão
    var _btn_bg_color = _can_afford ? make_color_rgb(60, 100, 60) : make_color_rgb(80, 60, 60);
    draw_set_color(_btn_bg_color);
    draw_set_alpha(0.9);
    draw_roundrect_ext(_slot_btn_x, _slot_btn_y, _slot_btn_x + _slot_btn_w, _slot_btn_y + _slot_btn_h, 8, 8, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    
    // Borda do botão
    var _btn_border_color = _can_afford ? make_color_rgb(120, 200, 120) : make_color_rgb(200, 120, 120);
    draw_set_color(_btn_border_color);
    draw_set_alpha(0.7);
    draw_roundrect_ext(_slot_btn_x, _slot_btn_y, _slot_btn_x + _slot_btn_w, _slot_btn_y + _slot_btn_h, 8, 8, true);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    
    // Texto do botão
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(1.0);
    var _btn_text_color = _can_afford ? make_color_rgb(255, 255, 200) : make_color_rgb(200, 200, 200);
    draw_set_color(_btn_text_color);
    draw_text_transformed(_slot_btn_x + _slot_btn_w/2, _slot_btn_y + _slot_btn_h/2, "SLOT EXTRA ($" + string(global.custo_slot_extra) + ")", 0.85, 0.85, 0);
}

// === BOTÃO FECHAR ===
var _close_w = 140;
var _close_h = 45;
var _close_x = _menu_x + _menu_w - _close_w - 20;
var _close_y = _menu_y + _menu_h - 60;

draw_set_color(make_color_rgb(180, 60, 60));
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 10, 10, false);

draw_set_color(make_color_rgb(255, 255, 255));
draw_set_alpha(0.9);
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 10, 10, true);
draw_set_alpha(1.0);
draw_set_color(c_white);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR", 1.0, 1.0, 0);

// ✅ CORREÇÃO: Instruções removidas conforme solicitado

// === RESET DAS CONFIGURAÇÕES ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
draw_set_font(-1);
