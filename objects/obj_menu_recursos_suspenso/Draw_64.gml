// =========================================================
// MENU DE RECURSOS SUSPENSO - DRAW GUI EVENT
// Visual com Glow Neon e Efeitos Cinemáticos
// =========================================================

// ✅ VERIFICAÇÃO: Verificar se menu está visível (tecla B)
if (!variable_instance_exists(id, "menu_visible")) {
    menu_visible = true;
}
if (!menu_visible) {
    exit; // Não desenhar se estiver escondido
}

// ✅ VERIFICAÇÃO: Garantir que variáveis existem
if (!variable_instance_exists(id, "menu_estado")) {
    menu_estado = 0;
    menu_altura_atual = menu_altura_recolhido;
}

// ✅ VERIFICAÇÃO: Garantir que lista de recursos existe
if (!variable_instance_exists(id, "lista_recursos")) {
    // Se lista não existe, criar uma básica para teste
    lista_recursos = array_create(0);
    var _recurso_teste = {
        nome: "Teste",
        icone: "$",
        valor: 100,
        valor_display: 100,
        cor: make_color_rgb(255, 255, 255),
        eh_numero: true,
        animando: false,
        valor_anterior: 100
    };
    array_push(lista_recursos, _recurso_teste);
}

if (array_length(lista_recursos) == 0) {
    // Se lista está vazia, não desenha
    exit;
}

// === FUNÇÃO: DESENHAR BORDA COM GLOW NEON ===
function desenhar_borda_neon(_x1, _y1, _x2, _y2, _cor_neon, _intensidade) {
    // ✅ REMOVIDO: Efeito de piscar - usar valor fixo
    var _glow_val = 0.5; // Valor fixo sem animação
    
    // Glow externo (blur simulado)
    draw_set_alpha(_glow_val * _intensidade * 0.5);
    draw_set_color(_cor_neon);
    draw_rectangle(_x1 - 8, _y1 - 8, _x2 + 8, _y2 + 8, false);
    draw_rectangle(_x1 - 6, _y1 - 6, _x2 + 6, _y2 + 6, false);
    draw_rectangle(_x1 - 4, _y1 - 4, _x2 + 4, _y2 + 4, false);
    
    // Borda principal com glow
    draw_set_alpha(_glow_val * _intensidade);
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    
    // Linha interna sutil
    draw_set_alpha(_glow_val * _intensidade * 0.7);
    draw_rectangle(_x1 + 2, _y1 + 2, _x2 - 2, _y2 - 2, true);
}

// === FUNÇÃO: DESENHAR SETA DE TOGGLE ===
function desenhar_seta_toggle(_cx, _cy, _tamanho, _angulo, _cor) {
    var _ang_rad = _angulo * pi / 180;
    
    var _x1 = _cx + cos(_ang_rad) * _tamanho;
    var _y1 = _cy + sin(_ang_rad) * _tamanho;
    
    var _ang_esq = (_ang_rad - 120 * pi / 180);
    var _x2 = _cx + cos(_ang_esq) * (_tamanho * 0.7);
    var _y2 = _cy + sin(_ang_esq) * (_tamanho * 0.7);
    
    var _ang_dir = (_ang_rad + 120 * pi / 180);
    var _x3 = _cx + cos(_ang_dir) * (_tamanho * 0.7);
    var _y3 = _cy + sin(_ang_dir) * (_tamanho * 0.7);
    
    draw_set_color(_cor);
    draw_set_alpha(1.0);
    draw_line(_cx, _cy, _x1, _y1);
    draw_line(_x1, _y1, _x2, _y2);
    draw_line(_x1, _y1, _x3, _y3);
}

// === CALCULAR POSIÇÃO COM ARREDONDAMENTO ===
// ✅ CORREÇÃO: Garantir que variáveis existem antes de usar
if (!variable_instance_exists(id, "menu_pos_x")) menu_pos_x = 30;
if (!variable_instance_exists(id, "menu_pos_y")) menu_pos_y = 30;
if (!variable_instance_exists(id, "menu_largura_expandido")) menu_largura_expandido = 380;
if (!variable_instance_exists(id, "menu_altura_atual")) menu_altura_atual = menu_altura_recolhido;

var _menu_x1 = menu_pos_x;
var _menu_y1 = menu_pos_y;
var _menu_x2 = menu_pos_x + menu_largura_expandido;
var _menu_y2 = menu_pos_y + menu_altura_atual;

// ✅ DEBUG: Verificar se está desenhando
if (variable_global_exists("debug_enabled") && global.debug_enabled && frame_count % 60 == 0) {
    show_debug_message("🎨 Draw GUI executando - Menu altura: " + string(menu_altura_atual));
}

// === SOMBRA DO MENU ===
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.4);
draw_rectangle(_menu_x1 + 4, _menu_y1 + 4, _menu_x2 + 4, _menu_y2 + 4, false);

// === FUNDO DO MENU ===
// ✅ CORREÇÃO: Verificar se cor_fundo existe
if (!variable_instance_exists(id, "cor_fundo")) {
    cor_fundo = make_color_rgb(20, 25, 40);
}
draw_set_alpha(0.92);
draw_set_color(cor_fundo);
draw_rectangle(_menu_x1, _menu_y1, _menu_x2, _menu_y2, false);

// === BORDA COM GLOW NEON ===
// ✅ CORREÇÃO: Verificar se variáveis de cor existem
if (!variable_instance_exists(id, "cor_borda_neon")) {
    cor_borda_neon = make_color_rgb(100, 220, 255);
}
if (!variable_instance_exists(id, "glow_intensity")) {
    glow_intensity = 0;
}

desenhar_borda_neon(_menu_x1, _menu_y1, _menu_x2, _menu_y2, cor_borda_neon, 0.8);

// === CABEÇALHO (SEMPRE VISÍVEL) ===
// ✅ REDUZIDO EM 20%
var _header_height = 40; // 50 * 0.8 = 40

// ✅ GARANTIR: Cabeçalho sempre visível mesmo quando recolhido
if (menu_altura_atual < _header_height) {
    menu_altura_atual = _header_height;
    _menu_y2 = menu_pos_y + menu_altura_atual;
}

// Fundo do cabeçalho
// ✅ CORREÇÃO: Verificar se cor_fundo_header existe
if (!variable_instance_exists(id, "cor_fundo_header")) {
    cor_fundo_header = make_color_rgb(30, 40, 60);
}
draw_set_alpha(0.7);
draw_set_color(cor_fundo_header);
draw_rectangle(_menu_x1, _menu_y1, _menu_x2, _menu_y1 + _header_height, false);

// Linha decorativa no cabeçalho - ✅ REDUZIDO EM 20%
draw_set_alpha(0.6);
draw_set_color(cor_borda_neon);
draw_line(_menu_x1 + 12, _menu_y1 + _header_height - 2, _menu_x2 - 12, _menu_y1 + _header_height - 2); // 15 * 0.8 = 12

// Ícone do cabeçalho
draw_set_alpha(1.0);
if (!variable_instance_exists(id, "cor_texto_titulo")) {
    cor_texto_titulo = make_color_rgb(200, 240, 255);
}
draw_set_color(cor_texto_titulo);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
// ✅ REDUZIDO EM 20% - Posições e tamanhos
draw_text_transformed(_menu_x1 + 16, _menu_y1 + _header_height / 2, "▼", 0.8, 0.8, 0); // 20 * 0.8 = 16

// Título
draw_set_halign(fa_left);
draw_set_color(cor_texto_titulo);
draw_set_alpha(1.0);

if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
}

// ✅ REDUZIDO EM 20% - Tamanho e posição do texto
draw_text_transformed(_menu_x1 + 40, _menu_y1 + _header_height / 2 - 6, "Recursos da Nación", 0.8, 0.8, 0); // 50 * 0.8 = 40, 8 * 0.8 = 6.4 (arredondado para 6)

// Seta de toggle (lado direito) - ✅ REDUZIDO EM 20%
draw_set_alpha(0.8);
draw_set_color(cor_borda_neon);
if (!variable_instance_exists(id, "seta_angulo")) {
    seta_angulo = 0;
}
desenhar_seta_toggle(_menu_x2 - 24, _menu_y1 + _header_height / 2, 8, seta_angulo, cor_borda_neon); // 30 * 0.8 = 24, 10 * 0.8 = 8

// === ITENS DE RECURSOS (SÓ DESENHA SE MENU EXPANDIDO) ===
// ✅ DEBUG: Verificar estado do menu
if (variable_global_exists("debug_enabled") && global.debug_enabled && frame_count % 120 == 0) {
    show_debug_message("📊 Menu estado: " + string(menu_estado) + " | Altura: " + string(menu_altura_atual) + " | Recursos: " + string(array_length(lista_recursos)));
}

if (menu_altura_atual > menu_altura_recolhido + 10) {
    // ✅ REDUZIDO EM 20%
    var _item_y = _menu_y1 + _header_height + 12; // 15 * 0.8 = 12
    var _item_altura = 36; // 45 * 0.8 = 36
    var _padding_horizontal = 12; // 15 * 0.8 = 12
    
    for (var i = 0; i < array_length(lista_recursos); i++) {
        var _recurso = lista_recursos[i];
        var _item_x1 = _menu_x1 + _padding_horizontal;
        var _item_x2 = _menu_x2 - _padding_horizontal;
        var _item_y1 = _item_y;
        var _item_y2 = _item_y + _item_altura;
        
        // Verificar se está no viewport (para não desenhar fora)
        if (_item_y2 > _menu_y2) {
            break;
        }
        
        // Fundo do item (hover effect)
        // ✅ CORREÇÃO: Verificar se cor_fundo_item existe
        if (!variable_instance_exists(id, "cor_fundo_item")) {
            cor_fundo_item = make_color_rgb(25, 35, 55);
        }
        // ✅ CORREÇÃO: Verificar se hover_item existe
        if (!variable_instance_exists(id, "hover_item")) {
            hover_item = -1;
        }
        if (hover_item == i) {
            draw_set_alpha(0.35);
            draw_set_color(_recurso.cor);
        } else {
            draw_set_alpha(0.15);
            draw_set_color(cor_fundo_item);
        }
        draw_rectangle(_item_x1, _item_y1, _item_x2, _item_y2, false);
        
        // Borda do item (subtle)
        // ✅ CORREÇÃO: Verificar se cor_linha existe
        if (!variable_instance_exists(id, "cor_linha")) {
            cor_linha = make_color_rgb(100, 180, 255);
        }
        if (hover_item == i) {
            draw_set_alpha(0.5);
            draw_set_color(_recurso.cor);
        } else {
            draw_set_alpha(0.2);
            draw_set_color(cor_linha);
        }
        draw_rectangle(_item_x1, _item_y1, _item_x2, _item_y2, true);
        
        // Ícone - ✅ REDUZIDO EM 20%
        // ✅ CORREÇÃO: Verificar se cor_texto_normal existe
        if (!variable_instance_exists(id, "cor_texto_normal")) {
            cor_texto_normal = make_color_rgb(180, 200, 220);
        }
        draw_set_alpha(1.0);
        draw_set_color(cor_texto_normal);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text_transformed(_item_x1 + 10, _item_y1 + _item_altura / 2, _recurso.icone, 0.8, 0.8, 0); // 12 * 0.8 = 9.6 (arredondado para 10)
        
        // Nome do recurso - ✅ REDUZIDO EM 20%
        draw_set_color(cor_texto_normal);
        draw_set_alpha(0.9);
        draw_text_transformed(_item_x1 + 40, _item_y1 + 8, _recurso.nome, 0.8, 0.8, 0); // 50 * 0.8 = 40, 10 * 0.8 = 8
        
        // Valor do recurso (destacado à direita) - ✅ REDUZIDO EM 15%
        draw_set_halign(fa_right);
        draw_set_color(_recurso.cor);
        draw_set_alpha(1.0);
        
        // Formatar valor
        var _valor_display = "";
        if (_recurso.eh_numero) {
            _valor_display = string(_recurso.valor);
            if (_recurso.valor >= 1000 && _recurso.valor < 1000000) {
                _valor_display = string(round(_recurso.valor / 1000)) + "K";
            } else if (_recurso.valor >= 1000000) {
                _valor_display = string(round(_recurso.valor / 1000000)) + "M";
            }
            if (_recurso.nome == "Dinheiro") {
                _valor_display = "$" + _valor_display;
            } else if (_recurso.nome == "Polaridade") {
                _valor_display = "+" + _valor_display;
            }
        } else {
            _valor_display = string(_recurso.valor);
        }
        
        draw_text_transformed(_item_x2 - 10, _item_y1 + 8, _valor_display, 0.8, 0.8, 0); // 12 * 0.8 = 9.6 (arredondado para 10), 10 * 0.8 = 8
        
        // Linha separadora (subtle) - ✅ REDUZIDO EM 20%
        if (i < array_length(lista_recursos) - 1) {
            draw_set_alpha(0.1);
            draw_set_color(cor_linha);
            draw_line(_item_x1 + 8, _item_y2 + 2, _item_x2 - 8, _item_y2 + 2); // 10 * 0.8 = 8, 2.5 * 0.8 = 2
        }
        
        _item_y += _item_altura + 4; // 5 * 0.8 = 4
    }
}

// Resetar
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
