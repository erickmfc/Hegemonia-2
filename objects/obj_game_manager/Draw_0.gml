// Evento Draw de obj_game_manager - ✅ OTIMIZADO COM CULLING

// === VERIFICAÇÕES DE SEGURANÇA ===
if (!variable_global_exists("map_width") || !variable_global_exists("map_height")) {
    exit; // Variáveis não inicializadas
}
if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
    exit; // Grid não criado
}

// === CALCULAR ÁREA VISÍVEL ===
var cam = view_camera[0];
var tile_start_x = 0, tile_start_y = 0, tile_end_x = 0, tile_end_y = 0;

if (cam != noone) {
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);
    
    // Verifica se os valores são válidos
    if (is_real(cam_x) && is_real(cam_y) && is_real(cam_w) && is_real(cam_h) && cam_w > 0 && cam_h > 0) {
        // ✅ OTIMIZADO: Margem dinâmica baseada em LOD para mapas grandes
        // Calcular LOD diretamente para evitar dependência de script
        var zoom = 0.95; // Default
        if (instance_exists(obj_input_manager)) {
            zoom = obj_input_manager.zoom_level;
        }
        var lod = 2; // Default: detalhe normal
        if (zoom >= 2.0) lod = 3;
        else if (zoom >= 0.8) lod = 2;
        else if (zoom >= 0.4) lod = 1;
        else lod = 0;
        
        var margin = 32; // Base
        
        if (lod == 0) {
            margin = 8; // Zoom muito afastado - culling agressivo
        } else if (lod == 1) {
            margin = 16; // Zoom médio-afastado
        }
        
        // Calcula quais tiles desenhar
        tile_start_x = floor((cam_x - margin) / global.tile_size);
        tile_start_y = floor((cam_y - margin) / global.tile_size);
        tile_end_x = ceil((cam_x + cam_w + margin) / global.tile_size);
        tile_end_y = ceil((cam_y + cam_h + margin) / global.tile_size);
        
        // Garante limites do mapa
        tile_start_x = clamp(tile_start_x, 0, max(0, global.map_width - 1));
        tile_start_y = clamp(tile_start_y, 0, max(0, global.map_height - 1));
        tile_end_x = clamp(tile_end_x, 0, max(0, global.map_width - 1));
        tile_end_y = clamp(tile_end_y, 0, max(0, global.map_height - 1));
    } else {
        // Fallback: toda a room se valores inválidos
        tile_start_x = 0;
        tile_start_y = 0;
        tile_end_x = max(0, global.map_width - 1);
        tile_end_y = max(0, global.map_height - 1);
    }
} else {
    // Fallback: toda a room (mapas pequenos)
    tile_start_x = 0;
    tile_start_y = 0;
    tile_end_x = max(0, global.map_width - 1);
    tile_end_y = max(0, global.map_height - 1);
}

draw_set_color(c_black);
draw_set_alpha(0.8);

// ✅ OTIMIZAÇÃO: Sistema de LOD para tiles - pular tiles em zoom out
// Calcular LOD diretamente para evitar dependência de script
var zoom_tiles = 0.95; // Default
if (instance_exists(obj_input_manager)) {
    zoom_tiles = obj_input_manager.zoom_level;
}
var lod_tiles = 2; // Default: detalhe normal
if (zoom_tiles >= 2.0) lod_tiles = 3;
else if (zoom_tiles >= 0.8) lod_tiles = 2;
else if (zoom_tiles >= 0.4) lod_tiles = 1;
else lod_tiles = 0;
var tile_skip = (lod_tiles == 0) ? 4 : ((lod_tiles == 1) ? 2 : 1); // Pular tiles em zoom out

// ✅ OTIMIZAÇÃO: Desenhar apenas tiles visíveis com skip baseado em LOD
for (var i = tile_start_x; i <= tile_end_x; i += tile_skip) {
    for (var j = tile_start_y; j <= tile_end_y; j += tile_skip) {
        
        // Verificações de segurança MÁXIMAS
        if (i < 0 || i >= global.map_width || j < 0 || j >= global.map_height) continue;
        if (i >= array_length(global.map_grid)) continue;
        if (j >= array_length(global.map_grid[i])) continue;
        if (is_undefined(global.map_grid[i][j])) continue;  // ✅ NOVO!
        
        var minha_nacao = global.map_grid[i][j].nacao;
        if (is_undefined(minha_nacao) || minha_nacao == NATIONS.NEUTRA) continue;  // ✅ MELHORADO

        var xx = i * global.tile_size;
        var yy = j * global.tile_size;

        // ✅ OTIMIZADO: Reduzir verificações redundantes
        var _j_check = j > 0 && j < array_length(global.map_grid[i]);
        var _i_check = i > 0 && i < array_length(global.map_grid);
        
        // Cima
        if (_j_check && !is_undefined(global.map_grid[i][j-1]) && global.map_grid[i][j-1].nacao != minha_nacao) {
            draw_line(xx, yy, xx + global.tile_size, yy);
        }
        // Baixo
        if (j < global.map_height - 1 && !is_undefined(global.map_grid[i][j+1]) && global.map_grid[i][j+1].nacao != minha_nacao) {
            draw_line(xx, yy + global.tile_size, xx + global.tile_size, yy + global.tile_size);
        }
        // Esquerda
        if (_i_check && !is_undefined(global.map_grid[i-1][j]) && global.map_grid[i-1][j].nacao != minha_nacao) {
            draw_line(xx, yy, xx, yy + global.tile_size);
        }
        // Direita
        if (i < global.map_width - 1 && !is_undefined(global.map_grid[i+1][j]) && global.map_grid[i+1][j].nacao != minha_nacao) {
            draw_line(xx + global.tile_size, yy, xx + global.tile_size, yy + global.tile_size);
        }
    }
}

draw_set_alpha(1);
draw_set_color(c_white);

// ===============================================
// SISTEMA DE BARRAS DE VIDA INTEGRADO (OTIMIZADO)
// ===============================================
// ✅ OTIMIZAÇÃO: Desenhar barras TODOS os frames (removido frame skip que causava piscar)
// ✅ CORREÇÃO: Desenhar sempre para evitar piscar - performance já está otimizada com culling
if (global.barras_vida_ativas) {
    
    // === FUNÇÃO LOCAL PARA DESENHAR BARRA BÁSICA ===
    function desenhar_barra_basica(_obj, _offset_y) {
        if (!instance_exists(_obj)) return;
        if (!_obj.visible) return;  // ✅ RE-ADICIONADO: Verificar visibilidade
        
        // ✅ CORREÇÃO: Aceitar tanto hp_atual/hp_max quanto vida/vida_max
        var _hp_atual = 0;
        var _hp_max = 1;
        
        if (variable_instance_exists(_obj, "hp_atual") && variable_instance_exists(_obj, "hp_max")) {
            _hp_atual = _obj.hp_atual;
            _hp_max = _obj.hp_max;
        } else if (variable_instance_exists(_obj, "vida") && variable_instance_exists(_obj, "vida_max")) {
            _hp_atual = _obj.vida;
            _hp_max = _obj.vida_max;
        } else {
            return; // Não tem variáveis de vida
        }
        
        if (_hp_atual <= 0) return;
        
        var _barra_w = 50;
        var _barra_h = 6;
        var _barra_x = _obj.x - _barra_w/2;
        var _barra_y = _obj.y + _offset_y;
        
        // Fundo
        draw_set_color(c_maroon);
        draw_set_alpha(0.8);
        draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, false);
        
        // Vida atual
        var _vida_percentual = _hp_atual / _hp_max;
        var _vida_w = _barra_w * _vida_percentual;
        
        var _cor_vida = c_green;
        if (_vida_percentual < 0.3) _cor_vida = c_red;
        else if (_vida_percentual < 0.6) _cor_vida = c_yellow;
        
        draw_set_color(_cor_vida);
        draw_set_alpha(0.9);
        draw_rectangle(_barra_x, _barra_y, _barra_x + _vida_w, _barra_y + _barra_h, false);
        
        // Borda
        draw_set_color(c_white);
        draw_set_alpha(1.0);
        draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, true);
        
        // Texto HP
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(_barra_x + _barra_w/2, _barra_y - 8, string(_hp_atual) + "/" + string(_hp_max));
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_alpha(1.0);
    }
    
    // === FUNÇÃO LOCAL PARA DESENHAR BARRA AVANÇADA ===
    function desenhar_barra_avancada(_obj, _offset_y) {
        if (!instance_exists(_obj)) return;
        if (!_obj.visible) return;  // ✅ RE-ADICIONADO: Verificar visibilidade
        
        // ✅ CORREÇÃO: Aceitar tanto hp_atual/hp_max quanto vida/vida_max
        var _hp_atual = 0;
        var _hp_max = 1;
        
        if (variable_instance_exists(_obj, "hp_atual") && variable_instance_exists(_obj, "hp_max")) {
            _hp_atual = _obj.hp_atual;
            _hp_max = _obj.hp_max;
        } else if (variable_instance_exists(_obj, "vida") && variable_instance_exists(_obj, "vida_max")) {
            _hp_atual = _obj.vida;
            _hp_max = _obj.vida_max;
        } else {
            return; // Não tem variáveis de vida
        }
        
        if (_hp_atual <= 0) return;
        
        var _barra_w = 60;
        var _barra_h = 8;
        var _barra_x = _obj.x - _barra_w/2;
        var _barra_y = _obj.y + _offset_y;
        
        // Fundo
        draw_set_color(c_maroon);
        draw_set_alpha(0.7);
        draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, false);
        
        // Vida atual
        var _vida_percentual = _hp_atual / _hp_max;
        var _vida_w = _barra_w * _vida_percentual;
        
        var _cor_vida = c_green;
        if (_vida_percentual < 0.3) _cor_vida = c_red;
        else if (_vida_percentual < 0.6) _cor_vida = c_yellow;
        
        draw_set_color(_cor_vida);
        draw_set_alpha(0.8);
        draw_rectangle(_barra_x, _barra_y, _barra_x + _vida_w, _barra_y + _barra_h, false);
        
        // Borda
        draw_set_color(c_white);
        draw_set_alpha(1.0);
        draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, true);
        
        // Texto HP
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(_barra_x + _barra_w/2, _barra_y - 12, string(_hp_atual) + "/" + string(_hp_max));
        
        // Estado (se existir)
        if (variable_instance_exists(_obj, "estado")) {
            var _estado_texto = "";
            var _cor_estado = c_white;
            
            switch (_obj.estado) {
                case "pousado": _estado_texto = "POUSADO"; _cor_estado = c_gray; break;
                case "decolando": _estado_texto = "DECOLANDO"; _cor_estado = c_yellow; break;
                case "patrulhando": _estado_texto = "PATRULHANDO"; _cor_estado = c_blue; break;
                case "caçando": _estado_texto = "CAÇANDO!"; _cor_estado = c_red; break;
                case "atacando": _estado_texto = "ATACANDO!"; _cor_estado = c_red; break;
                case "movendo": _estado_texto = "MOVENDO"; _cor_estado = c_lime; break;
                case "pousando": _estado_texto = "POUSANDO"; _cor_estado = c_orange; break;
                default: _estado_texto = _obj.estado; _cor_estado = c_white; break;
            }
            
            draw_set_color(_cor_estado);
            draw_text(_barra_x + _barra_w/2, _barra_y - 25, _estado_texto);
        }
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_alpha(1.0);
    }
    
    // === DESENHAR BARRAS PARA TODAS AS UNIDADES ===
    
    // F-5 CAÇA
    with (obj_caca_f5) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            desenhar_barra_avancada(id, -30);
        }
    }

    // HELICÓPTERO MILITAR
    with (obj_helicoptero_militar) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            desenhar_barra_avancada(id, -25);
        }
    }

    // C-100 TRANSPORTE
    with (obj_c100) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            desenhar_barra_avancada(id, -30);
        }
    }

    // F-6 INIMIGO
    with (obj_f6) {
        desenhar_barra_avancada(id, -30);
    }

    // UNIDADES TERRESTRES - NÃO MOSTRAR STATUS SE ESTIVEREM DENTRO DO AVIÃO
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1 && visible) { // Só mostrar se estiver visível (não embarcada)
            desenhar_barra_basica(id, -20);
        }
    }

    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1 && visible) { // Só mostrar se estiver visível (não embarcada)
            desenhar_barra_basica(id, -25);
        }
    }

    with (obj_blindado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1 && visible) { // Só mostrar se estiver visível (não embarcada)
            desenhar_barra_basica(id, -25);
        }
    }

    with (obj_soldado_antiaereo) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1 && visible) { // Só mostrar se estiver visível (não embarcada)
            desenhar_barra_basica(id, -20);
        }
    }

    // UNIDADES INIMIGAS
    // ✅ CORREÇÃO: obj_inimigo removido - não há mais unidades inimigas específicas
}

// === DEBUG DE CULLING (Tecla F3) ===
if (keyboard_check_pressed(vk_f3)) {
    var tiles_visiveis = (tile_end_x - tile_start_x + 1) * (tile_end_y - tile_start_y + 1);
    var tiles_totais = global.map_width * global.map_height;
    var porcentagem = (tiles_visiveis / tiles_totais) * 100;
    
    show_debug_message("=== CULLING STATS (F3) ===");
    show_debug_message("Tiles visíveis: " + string(tiles_visiveis));
    show_debug_message("Tiles totais: " + string(tiles_totais));
    show_debug_message("Economia: " + string(round(porcentagem * 10) / 10) + "%");
    show_debug_message("Área: (" + string(tile_start_x) + "," + string(tile_start_y) + ") a (" + string(tile_end_x) + "," + string(tile_end_y) + ")");
    show_debug_message("Room: " + string(room_width) + "x" + string(room_height));
}
