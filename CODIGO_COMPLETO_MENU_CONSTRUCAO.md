# 📋 CÓDIGO COMPLETO DO MENU DE CONSTRUÇÃO

Este documento contém TODO o código relacionado ao menu de construção, incluindo todas as funcionalidades e integrações.

---

## 🎯 **OBJETOS PRINCIPAIS**

### **1. obj_ui_menu_construcao** (Menu Moderno - Tecla V)
Este é o menu principal que abre com a tecla V.

---

## 📁 **ARQUIVOS DO MENU MODERNO (obj_ui_menu_construcao)**

### **Create_0.gml** - Inicialização
```gml
// =========================================================
// HEGEMONIA GLOBAL - MENU DE CONSTRUÇÃO MODERNO
// Sistema completo com animações e efeitos visuais
// =========================================================

// === SISTEMA DE ESTADOS ===
// Estados: 0 = Fechado, 1 = Abrindo, 2 = Aberto, 3 = Fechando
menu_estado = 0; // Inicia fechado
menu_aberto = false;
timer_animacao = 0;
duracao_animacao = 0.3; // 0.3 segundos para abrir/fechar

// === POSICIONAMENTO DO MENU ===
// Menu fixo no lado esquerdo da tela
menu_largura = 280; // Largura do menu
menu_altura = display_get_gui_height(); // Altura da tela
menu_pos_x_fechado = -menu_largura; // Fora da tela quando fechado
menu_pos_x_aberto = 0; // Na borda esquerda quando aberto
menu_pos_y = 0;
menu_pos_x_atual = menu_pos_x_fechado; // Posição atual (para animação)

// === CONFIGURAÇÕES DE BOTÕES ===
botao_largura = 240;
botao_altura = 80;
botao_espacamento = 15; // Espaço entre botões
botao_start_y = 80; // Posição Y inicial dos botões
botao_selecionado = -1; // Nenhum botão selecionado inicialmente

// === LISTA DE BOTÕES ===
// Estrutura de dados para cada botão
lista_botoes = array_create(0);

// Função para criar dados de um botão
function criar_dados_botao(_nome, _icone_tipo, _descricao, _objeto_construir, _custo_dinheiro, _custo_recursos = {}) {
    var _dados = {
        nome: _nome,
        icone_tipo: _icone_tipo, // "casa", "banco", "fazenda", "quartel", "marinha", "aeroporto"
        descricao: _descricao,
        objeto_construir: _objeto_construir,
        custo_dinheiro: _custo_dinheiro,
        custo_recursos: _custo_recursos,
        hover: false,
        selecionado: false
    };
    return _dados;
}

// === INICIALIZAR BOTÕES ===
// Botão 1: Casa
var _botao_casa = criar_dados_botao(
    "CASA",
    "casa",
    "Aumenta população",
    asset_get_index("obj_casa"),
    1000,
    {}
);
array_push(lista_botoes, _botao_casa);

// Botão 2: Banco
var _botao_banco = criar_dados_botao(
    "BANCO",
    "banco",
    "Gera dinheiro",
    asset_get_index("obj_banco"),
    2500,
    {}
);
array_push(lista_botoes, _botao_banco);

// Botão 3: Fazenda
var _botao_fazenda = criar_dados_botao(
    "FAZENDA",
    "fazenda",
    "Produz alimento",
    asset_get_index("obj_fazenda"),
    2500000,
    {}
);
array_push(lista_botoes, _botao_fazenda);

// Botão 4: Quartel
var _botao_quartel = criar_dados_botao(
    "QUARTEL",
    "quartel",
    "Recruta infantaria",
    asset_get_index("obj_quartel"),
    800,
    {minerio: 150}
);
array_push(lista_botoes, _botao_quartel);

// Botão 5: Quartel Marinha
var _botao_marinha = criar_dados_botao(
    "QUARTEL MARINHA",
    "marinha",
    "Recruta navios",
    asset_get_index("obj_quartel_marinha"),
    600,
    {}
);
array_push(lista_botoes, _botao_marinha);

// Botão 6: Aeroporto Militar
var _botao_aeroporto = criar_dados_botao(
    "AEROPORTO",
    "aeroporto",
    "Recruta aviões",
    asset_get_index("obj_aeroporto_militar"),
    1000,
    {}
);
array_push(lista_botoes, _botao_aeroporto);

// === VARIÁVEIS DE ANIMAÇÃO ===
hover_glow_intensity = 0.0; // Intensidade do glow (0.0 a 1.0)
hover_glow_speed = 0.1; // Velocidade da animação de glow

// === CONFIGURAÇÕES VISUAIS ===
cor_fundo = make_color_rgb(20, 25, 35); // Azul muito escuro
cor_borda = make_color_rgb(70, 150, 200); // Azul brilhante
cor_botao_normal = make_color_rgb(35, 40, 50);
cor_botao_hover = make_color_rgb(50, 60, 75);
cor_texto = make_color_rgb(255, 255, 255);
cor_texto_descricao = make_color_rgb(200, 200, 200);

// === DEBUG ===
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("✅ Menu de Construção Moderno inicializado com " + string(array_length(lista_botoes)) + " botões");
}
```

### **Step_0.gml** - Lógica e Animações
```gml
// =========================================================
// HEGEMONIA GLOBAL - MENU DE CONSTRUÇÃO MODERNO
// Step Event - Processamento de estados e animações
// =========================================================

// === PROCESSAR TECLA V (ABRIR/FECHAR MENU) ===
if (keyboard_check_pressed(ord("V"))) {
    if (menu_estado == 0) {
        // Fechado -> Abrindo
        menu_estado = 1;
        menu_aberto = true;
        timer_animacao = 0;
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("✅ Menu de Construção: Abrindo...");
        }
    } else if (menu_estado == 2) {
        // Aberto -> Fechando
        menu_estado = 3;
        menu_aberto = false;
        timer_animacao = 0;
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("✅ Menu de Construção: Fechando...");
        }
    }
}

// === PROCESSAR TECLA ESC (FECHAR MENU) ===
if (keyboard_check_pressed(vk_escape) && menu_estado == 2) {
    menu_estado = 3;
    menu_aberto = false;
    timer_animacao = 0;
}

// === ANIMAÇÃO DE ABERTURA/FECHAMENTO ===
if (menu_estado == 1) {
    // Estado: Abrindo
    timer_animacao += 1.0 / game_get_speed(gamespeed_fps);
    
    // Interpolação suave (ease-out)
    var _progresso = clamp(timer_animacao / duracao_animacao, 0, 1);
    var _ease = 1 - power(1 - _progresso, 3); // Ease-out cubic
    
    menu_pos_x_atual = lerp(menu_pos_x_fechado, menu_pos_x_aberto, _ease);
    
    if (_progresso >= 1.0) {
        menu_estado = 2; // Mudar para Aberto
        menu_pos_x_atual = menu_pos_x_aberto;
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("✅ Menu de Construção: Aberto");
        }
    }
} else if (menu_estado == 3) {
    // Estado: Fechando
    timer_animacao += 1.0 / game_get_speed(gamespeed_fps);
    
    // Interpolação suave (ease-in)
    var _progresso = clamp(timer_animacao / duracao_animacao, 0, 1);
    var _ease = power(_progresso, 3); // Ease-in cubic
    
    menu_pos_x_atual = lerp(menu_pos_x_aberto, menu_pos_x_fechado, _ease);
    
    if (_progresso >= 1.0) {
        menu_estado = 0; // Mudar para Fechado
        menu_pos_x_atual = menu_pos_x_fechado;
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("✅ Menu de Construção: Fechado");
        }
    }
}

// === ANIMAÇÃO DE GLOW (PULSANTE) ===
hover_glow_intensity += hover_glow_speed;
if (hover_glow_intensity > 1.0) {
    hover_glow_intensity = 0.0;
}

// === PROCESSAR HOVER DOS BOTÕES ===
if (menu_estado == 2) {
    // Só processar hover se o menu estiver aberto
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    var _botao_y_atual = botao_start_y;
    var _nenhum_hover = true;
    
    for (var i = 0; i < array_length(lista_botoes); i++) {
        var _botao = lista_botoes[i];
        var _botao_x = menu_pos_x_atual + (menu_largura - botao_largura) / 2;
        var _botao_y = _botao_y_atual;
        
        // Verificar se mouse está sobre o botão
        var _hover = point_in_rectangle(
            _mouse_gui_x, _mouse_gui_y,
            _botao_x, _botao_y,
            _botao_x + botao_largura, _botao_y + botao_altura
        );
        
        _botao.hover = _hover;
        
        if (_hover) {
            _nenhum_hover = false;
            botao_selecionado = i;
        }
        
        _botao_y_atual += botao_altura + botao_espacamento;
    }
    
    // Se nenhum botão está com hover, limpar seleção
    if (_nenhum_hover) {
        botao_selecionado = -1;
    }
}
```

### **Draw_64.gml** - Desenho do Menu (GUI)
```gml
// =========================================================
// HEGEMONIA GLOBAL - MENU DE CONSTRUÇÃO MODERNO
// Draw GUI Event - Desenho do menu com efeitos visuais
// =========================================================

// === FUNÇÃO LOCAL PARA DESENHAR BOTÃO ===
function desenhar_botao_menu(_x, _y, _largura, _altura, _dados_botao, _hover) {
    // === CORES BASEADAS NO ESTADO ===
    var _cor_fundo = cor_botao_normal;
    var _cor_borda = make_color_rgb(100, 150, 200);
    var _alpha_glow = 0.3;
    
    if (_hover || _dados_botao.hover) {
        _cor_fundo = cor_botao_hover;
        _cor_borda = cor_borda;
        var _glow_val = hover_glow_intensity;
        _alpha_glow = 0.7 + (sin(_glow_val * 360 * pi / 180) * 0.3); // Glow pulsante
    }
    
    // === SOMBRA DO BOTÃO ===
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.3);
    draw_rectangle(_x + 2, _y + 2, _x + _largura + 2, _y + _altura + 2, false);
    
    // === FUNDO DO BOTÃO ===
    draw_set_alpha(0.9);
    draw_set_color(_cor_fundo);
    draw_rectangle(_x, _y, _x + _largura, _y + _altura, false);
    
    // === GLOW NA BORDA (SE HOVER) ===
    if (_hover || _dados_botao.hover) {
        draw_set_alpha(_alpha_glow);
        draw_set_color(_cor_borda);
        // Borda externa com glow
        draw_rectangle(_x - 2, _y - 2, _x + _largura + 2, _y + _altura + 2, false);
        // Borda interna
        draw_set_alpha(0.5);
        draw_rectangle(_x - 1, _y - 1, _x + _largura + 1, _y + _altura + 1, false);
    } else {
        // Borda normal
        draw_set_alpha(0.4);
        draw_set_color(_cor_borda);
        draw_rectangle(_x - 1, _y - 1, _x + _largura + 1, _y + _altura + 1, false);
    }
    
    // === ÍCONE HEXÁGONO (SIMULADO COM CÍRCULO) ===
    var _icone_x = _x + 20;
    var _icone_y = _y + _altura / 2;
    var _icone_raio = 20;
    
    // Fundo do ícone (hexágono simulado)
    draw_set_alpha(0.6);
    draw_set_color(make_color_rgb(50, 100, 150));
    draw_circle(_icone_x, _icone_y, _icone_raio, false);
    
    // Ícone baseado no tipo
    draw_set_alpha(1);
    draw_set_color(cor_texto);
    var _icone_texto = "?";
    
    switch (_dados_botao.icone_tipo) {
        case "casa":
            _icone_texto = "🏠";
            break;
        case "banco":
            _icone_texto = "$";
            break;
        case "fazenda":
            _icone_texto = "🌾";
            break;
        case "quartel":
            _icone_texto = "⚔";
            break;
        case "marinha":
            _icone_texto = "⚓";
            break;
        case "aeroporto":
            _icone_texto = "✈";
            break;
    }
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_icone_x, _icone_y, _icone_texto);
    
    // === TEXTO DO BOTÃO ===
    var _texto_x = _x + 60;
    var _texto_y = _y + 15;
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(cor_texto);
    draw_set_alpha(1);
    
    // Nome do botão
    if (font_exists(fnt_ui_main)) {
        draw_set_font(fnt_ui_main);
    }
    draw_text(_texto_x, _texto_y, _dados_botao.nome);
    
    // Descrição (menor)
    var _desc_y = _texto_y + 20;
    draw_set_color(cor_texto_descricao);
    draw_set_alpha(0.8);
    var _desc_font_size = 0.7;
    
    // Desenhar descrição (usar função se existir, senão draw_text normal)
    try {
        scr_desenhar_texto_ui(_texto_x, _desc_y, _dados_botao.descricao, _desc_font_size, _desc_font_size);
    } catch (_e) {
        // Fallback: usar draw_text normal se função não existir
        draw_text(_texto_x, _desc_y, _dados_botao.descricao);
    }
    
    // Custo
    var _custo_y = _desc_y + 18;
    draw_set_color(make_color_rgb(255, 255, 100));
    draw_set_alpha(0.9);
    var _custo_texto = "$" + string(_dados_botao.custo_dinheiro);
    
    // Adicionar recursos se houver
    if (is_struct(_dados_botao.custo_recursos)) {
        var _keys = struct_get_names(_dados_botao.custo_recursos);
        if (array_length(_keys) > 0) {
            var _recursos_texto = "";
            for (var i = 0; i < array_length(_keys); i++) {
                var _key = _keys[i];
                var _valor = _dados_botao.custo_recursos[$_key];
                if (_recursos_texto != "") _recursos_texto += ", ";
                _recursos_texto += _key + ": " + string(_valor);
            }
            _custo_texto += " + " + _recursos_texto;
        }
    }
    
    // Desenhar custo (usar função se existir, senão draw_text normal)
    try {
        scr_desenhar_texto_ui(_texto_x, _custo_y, _custo_texto, 0.65, 0.65);
    } catch (_e) {
        // Fallback: usar draw_text normal se função não existir
        draw_text(_texto_x, _custo_y, _custo_texto);
    }
    
    // Resetar configurações
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}

// Só desenhar se o menu não estiver completamente fechado
if (menu_estado == 0 && menu_pos_x_atual <= menu_pos_x_fechado) {
    exit; // Menu completamente fechado, não desenhar
}

// === CONFIGURAÇÃO DE FONTE ===
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}

// === DESENHAR FUNDO DO MENU ===
// Sombra atrás do menu
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.4);
draw_rectangle(menu_pos_x_atual + 4, menu_pos_y + 4, 
               menu_pos_x_atual + menu_largura + 4, menu_pos_y + menu_altura + 4, false);

// Fundo principal do menu
draw_set_alpha(0.95);
draw_set_color(cor_fundo);
draw_rectangle(menu_pos_x_atual, menu_pos_y, 
               menu_pos_x_atual + menu_largura, menu_pos_y + menu_altura, false);

// Borda externa com glow
var _glow_alpha = 0.6 + (sin(hover_glow_intensity * 360 * pi / 180) * 0.2); // Efeito pulsante
draw_set_alpha(_glow_alpha);
draw_set_color(cor_borda);
draw_rectangle(menu_pos_x_atual - 2, menu_pos_y - 2, 
               menu_pos_x_atual + menu_largura + 2, menu_pos_y + menu_altura + 2, false);

// Borda interna sutil
draw_set_alpha(0.5);
draw_set_color(make_color_rgb(100, 150, 200));
draw_rectangle(menu_pos_x_atual - 1, menu_pos_y - 1, 
               menu_pos_x_atual + menu_largura + 1, menu_pos_y + menu_altura + 1, false);

// === CABEÇALHO DO MENU ===
var _header_height = 60;
draw_set_alpha(0.8);
draw_set_color(make_color_rgb(30, 35, 45));
draw_rectangle(menu_pos_x_atual, menu_pos_y, 
               menu_pos_x_atual + menu_largura, menu_pos_y + _header_height, false);

// Linha decorativa no cabeçalho
draw_set_alpha(1);
draw_set_color(cor_borda);
draw_line(menu_pos_x_atual, menu_pos_y + _header_height - 2, 
          menu_pos_x_atual + menu_largura, menu_pos_y + _header_height - 2);

// Título do menu
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(cor_texto);
draw_set_alpha(1);
draw_text(menu_pos_x_atual + menu_largura / 2, menu_pos_y + _header_height / 2, "CONSTRUÇÃO");

// === DESENHAR BOTÕES ===
var _botao_y_atual = botao_start_y;

for (var i = 0; i < array_length(lista_botoes); i++) {
    var _botao = lista_botoes[i];
    var _botao_x = menu_pos_x_atual + (menu_largura - botao_largura) / 2;
    var _botao_y = _botao_y_atual;
    
    // === DESENHAR BOTÃO ===
    desenhar_botao_menu(_botao_x, _botao_y, botao_largura, botao_altura, _botao, i == botao_selecionado);
    
    _botao_y_atual += botao_altura + botao_espacamento;
}

// === DESENHAR INSTRUÇÕES ===
if (menu_estado == 2) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(cor_texto_descricao);
    draw_set_alpha(0.7);
    var _instrucoes_y = menu_pos_y + menu_altura - 30;
    draw_text(menu_pos_x_atual + menu_largura / 2, _instrucoes_y, "Pressione V ou ESC para fechar");
}

// Resetar configurações
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
```

### **Mouse_4.gml** - Processamento de Cliques
```gml
// =========================================================
// HEGEMONIA GLOBAL - MENU DE CONSTRUÇÃO MODERNO
// Mouse Left Pressed - Processar cliques nos botões
// =========================================================

// Só processar se o menu estiver aberto
if (menu_estado != 2) {
    exit;
}

var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

// Verificar clique em cada botão
var _botao_y_atual = botao_start_y;

for (var i = 0; i < array_length(lista_botoes); i++) {
    var _botao = lista_botoes[i];
    var _botao_x = menu_pos_x_atual + (menu_largura - botao_largura) / 2;
    var _botao_y = _botao_y_atual;
    
    // Verificar se clique foi dentro do botão
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y,
                          _botao_x, _botao_y,
                          _botao_x + botao_largura, _botao_y + botao_altura)) {
        
        // === VERIFICAR RECURSOS ===
        var _tem_recursos = true;
        var _mensagem_erro = "";
        
        // Verificar dinheiro
        if (variable_global_exists("dinheiro") && global.dinheiro < _botao.custo_dinheiro) {
            _tem_recursos = false;
            _mensagem_erro = "Dinheiro insuficiente! Precisa: $" + string(_botao.custo_dinheiro);
        }
        
        // Verificar recursos adicionais
        if (_tem_recursos && is_struct(_botao.custo_recursos)) {
            var _keys = struct_get_names(_botao.custo_recursos);
            if (array_length(_keys) > 0) {
                for (var j = 0; j < array_length(_keys); j++) {
                    var _key = _keys[j];
                    var _valor_necessario = _botao.custo_recursos[$_key];
                    var _valor_atual = 0;
                    
                    // Verificar recurso global
                    if (variable_global_exists(_key)) {
                        _valor_atual = global[$_key];
                    } else if (variable_global_exists(_key + "s")) {
                        _valor_atual = global[$_key + "s"];
                    } else {
                        // Tentar minúsculas
                        var _key_lower = string_lower(_key);
                        if (variable_global_exists(_key_lower)) {
                            _valor_atual = global[$_key_lower];
                        }
                    }
                    
                    if (_valor_atual < _valor_necessario) {
                        _tem_recursos = false;
                        _mensagem_erro = _key + " insuficiente! Precisa: " + string(_valor_necessario);
                        break;
                    }
                }
            }
        }
        
        // === ATIVAR MODO CONSTRUÇÃO ===
        if (_tem_recursos) {
            // Definir objeto a construir
            global.construindo_agora = _botao.objeto_construir;
            
            // Fechar o menu
            menu_estado = 3;
            menu_aberto = false;
            timer_animacao = 0;
            
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("✅ Botão clicado: " + _botao.nome);
                show_debug_message("   Objeto: " + string(_botao.objeto_construir));
                show_debug_message("   Modo construção ativado");
            }
        } else {
            // Mostrar mensagem de erro
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("❌ " + _mensagem_erro);
            }
            // TODO: Adicionar feedback visual (ex: shake do botão, som de erro)
        }
        
        exit; // Sair após processar clique
    }
    
    _botao_y_atual += botao_altura + botao_espacamento;
}
```

---

## 🔧 **SISTEMA DE CONSTRUÇÃO NO MAPA**

### **Integração com obj_input_manager/Step_2.gml**

O sistema de construção no mapa está integrado no `obj_input_manager/Step_2.gml`:

```gml
// === LÓGICA DE CONSTRUÇÃO NO MAPA (COM SUPORTE A ZOOM) ===
// CANCELAMENTO COM CLIQUE DIREITO
if (mouse_check_button_pressed(mb_right) && global.construindo_agora != noone) {
    global.construindo_agora = noone;
    show_debug_message("❌ Construção cancelada");
}

// CONSTRUÇÃO COM CLIQUE ESQUERDO
if (mouse_check_button_pressed(mb_left) && global.construindo_agora != noone) {
    // Obter coordenadas do mundo (com suporte a zoom)
    var _cam = view_camera[0];
    var _world_mouse_x = 0;
    var _world_mouse_y = 0;
    
    if (_cam != -1 && _cam != noone) {
        _world_mouse_x = camera_get_view_x(_cam) + device_mouse_x_to_gui(0);
        _world_mouse_y = camera_get_view_y(_cam) + device_mouse_y_to_gui(0);
    } else {
        _world_mouse_x = mouse_x;
        _world_mouse_y = mouse_y;
    }
    
    // Determinar custo e nome do edifício
    var _building_cost = 0;
    var _building_name = "";
    
    if (global.construindo_agora == asset_get_index("obj_casa")) {
        _building_cost = 1000;
        _building_name = "Casa";
    } else if (global.construindo_agora == asset_get_index("obj_banco")) {
        _building_cost = 2500;
        _building_name = "Banco";
    } else if (global.construindo_agora == asset_get_index("obj_quartel")) {
        _building_cost = 800;
        _building_name = "Quartel";
    } else if (global.construindo_agora == asset_get_index("obj_quartel_marinha")) {
        _building_cost = 600;
        _building_name = "Quartel Marinha";
    } else if (global.construindo_agora == asset_get_index("obj_fazenda")) {
        _building_cost = 2500000;
        _building_name = "Fazenda";
    } else if (global.construindo_agora == asset_get_index("obj_aeroporto_militar")) {
        _building_cost = 1000;
        _building_name = "Aeroporto Militar";
    }
    
    // Verificar se tem dinheiro e construir
    if (global.dinheiro >= _building_cost) {
        // Descontar dinheiro
        global.dinheiro -= _building_cost;
        
        // Criar edifício
        var _new_building = noone;
        
        if (global.construindo_agora == asset_get_index("obj_casa")) {
            _new_building = instance_create_layer(_world_mouse_x, _world_mouse_y, "Instances", obj_casa);
        } else if (global.construindo_agora == asset_get_index("obj_banco")) {
            _new_building = instance_create_layer(_world_mouse_x, _world_mouse_y, "Instances", obj_banco);
        } else if (global.construindo_agora == asset_get_index("obj_quartel")) {
            _new_building = instance_create_layer(_world_mouse_x, _world_mouse_y, "Instances", obj_quartel);
        } else if (global.construindo_agora == asset_get_index("obj_quartel_marinha")) {
            _new_building = instance_create_layer(_world_mouse_x, _world_mouse_y, "Instances", obj_quartel_marinha);
        } else if (global.construindo_agora == asset_get_index("obj_aeroporto_militar")) {
            _new_building = instance_create_layer(_world_mouse_x, _world_mouse_y, "Instances", obj_aeroporto_militar);
        }
        
        if (instance_exists(_new_building)) {
            // Limpar seleção após construir
            global.construindo_agora = noone;
        } else {
            // Reembolsar se falhou
            global.dinheiro += _building_cost;
        }
    }
}
```

---

## 📊 **VARIÁVEIS GLOBAIS UTILIZADAS**

- `global.construindo_agora` - ID do objeto a ser construído (ou `noone` se não estiver construindo)
- `global.dinheiro` - Dinheiro disponível
- `global.modo_construcao` - Usado pelo menu antigo (tecla C)
- `global.debug_enabled` - Ativa/desativa mensagens de debug

---

## 🎨 **FUNCIONALIDADES IMPLEMENTADAS**

### ✅ **Menu Moderno (obj_ui_menu_construcao)**
- Abre/fecha com tecla V
- Animações suaves de slide
- Hover nos botões com glow pulsante
- Verificação de recursos antes de construir
- 6 botões: Casa, Banco, Fazenda, Quartel, Quartel Marinha, Aeroporto
- Sistema de custos (dinheiro + recursos opcionais)

### ✅ **Sistema de Construção**
- Ativação via clique no botão
- Validação de recursos
- Integração com sistema de construção no mapa
- Cancelamento com clique direito

---

## 🔗 **INTEGRAÇÕES**

1. **obj_input_manager** - Processa construção no mapa
2. **Sistema de recursos** - Verifica dinheiro e recursos
3. **Sistema de validação de terreno** - Verifica se pode construir

---

## 📝 **NOTAS IMPORTANTES**

- O menu usa **Draw GUI Event (Draw_64)** para desenhar na interface
- As coordenadas do mouse são convertidas para GUI com `device_mouse_x_to_gui()`
- O menu antigo (`obj_menu_construcao`) usa tecla C e ainda existe no projeto
- O menu moderno (`obj_ui_menu_construcao`) usa tecla V
- Ambos os menus podem coexistir, mas o moderno é o recomendado

---

## 🎯 **PRÓXIMOS PASSOS PARA NOVO DESIGN**

Para criar um novo design sem perder funcionalidades:

1. **Manter a estrutura de dados** (`lista_botoes` e função `criar_dados_botao`)
2. **Manter a lógica de estados** (menu_estado: 0, 1, 2, 3)
3. **Manter a integração** (`global.construindo_agora`)
4. **Modificar apenas o Draw_64.gml** para novo visual
5. **Manter Step_0.gml e Mouse_4.gml** (ou adaptar se necessário)

---

## 📦 **MENU ANTIGO (obj_menu_construcao) - Tecla C**

Este menu ainda existe no projeto e usa a tecla C. Ele é mais simples e centralizado.

### **Draw_64.gml** - Menu Antigo
```gml
// Só desenha se o modo de construção estiver ativo
if (global.modo_construcao) {
    var _menu_width = 360;
    var _menu_height = 480;
    var _menu_x = display_get_gui_width() / 2 - _menu_width / 2;
    var _menu_y = display_get_gui_height() / 2 - _menu_height / 2;
    
    // ... código de desenho ...
    
    // Botões: Casa, Banco, Fazenda, Quartel, Quartel Marinha, Aeroporto
}
```

### **Mouse_56.gml** - Cliques do Menu Antigo
```gml
if (global.modo_construcao && mouse_check_button_released(mb_left)) {
    // Verificar cliques nos botões
    // Define global.construindo_agora e fecha o menu
}
```

---

## 🎮 **CONTROLES**

- **Tecla V**: Abre/fecha menu moderno (`obj_ui_menu_construcao`)
- **Tecla C**: Abre/fecha menu antigo (`obj_menu_construcao`)
- **Tecla ESC**: Fecha menu moderno quando aberto
- **Clique Esquerdo**: Seleciona botão no menu OU constrói no mapa
- **Clique Direito**: Cancela construção no mapa

---

## 🔄 **FLUXO DE FUNCIONAMENTO**

1. **Jogador pressiona V** → Menu abre (slide da esquerda)
2. **Jogador clica em um botão** → Verifica recursos → Define `global.construindo_agora` → Fecha menu
3. **Jogador clica no mapa** → Verifica dinheiro → Cria edifício → Deduz recursos → Limpa `global.construindo_agora`
4. **Jogador clica direito** → Cancela construção → Limpa `global.construindo_agora`

---

## 💡 **DICAS PARA NOVO DESIGN**

1. **Mantenha a estrutura de dados** - Não mude `lista_botoes` ou `criar_dados_botao()`
2. **Mantenha as variáveis de estado** - `menu_estado`, `menu_pos_x_atual`, etc.
3. **Mantenha a integração** - `global.construindo_agora` é essencial
4. **Modifique apenas o visual** - Draw_64.gml pode ser completamente redesenhado
5. **Teste a funcionalidade** - Após mudar o design, teste se tudo ainda funciona

---

**FIM DO DOCUMENTO**

