// ===============================================
// HEGEMONIA GLOBAL - MINIMAP
// Draw GUI Event - Minimap no canto superior direito
// ===============================================

// Verificar se o minimap deve ser exibido
if (!minimap_visible) {
    exit;
}

// Verificações de segurança
if (!variable_global_exists("map_width") || !variable_global_exists("map_height")) {
    exit;
}
if (!variable_global_exists("map_grid") || !is_array(global.map_grid)) {
    exit;
}
if (!variable_global_exists("tile_size")) {
    exit;
}

// === CONFIGURAÇÃO DO MINIMAP ===
var _minimap_size = minimap_size;
var _minimap_margin = minimap_margin;
var _minimap_x = display_get_gui_width() - _minimap_size - _minimap_margin;
var _minimap_y = _minimap_margin;

// === FUNDO DO MINIMAP ===
draw_set_color(make_color_rgb(20, 20, 30));
draw_set_alpha(0.85);
draw_rectangle(_minimap_x, _minimap_y, _minimap_x + _minimap_size, _minimap_y + _minimap_size, false);

// Borda do minimap
draw_set_color(make_color_rgb(100, 100, 120));
draw_set_alpha(1);
draw_rectangle(_minimap_x - 2, _minimap_y - 2, _minimap_x + _minimap_size + 2, _minimap_y + _minimap_size + 2, true);

// === ESCALA DO MINIMAP ===
var _map_world_width = global.map_width * global.tile_size;
var _map_world_height = global.map_height * global.tile_size;
var _scale_x = _minimap_size / _map_world_width;
var _scale_y = _minimap_size / _map_world_height;

// === DESENHAR TERRENOS E TERRITÓRIOS NO MINIMAP ===
// Amostragem para performance (desenhar a cada N tiles)
var _sample_rate = max(1, floor(global.map_width / 50)); // Ajuste conforme necessário

for (var i = 0; i < global.map_width; i += _sample_rate) {
    for (var j = 0; j < global.map_height; j += _sample_rate) {
        
        if (i >= array_length(global.map_grid)) continue;
        if (j >= array_length(global.map_grid[i])) continue;
        if (is_undefined(global.map_grid[i][j])) continue;
        
        var _tile_data = global.map_grid[i][j];
        if (is_undefined(_tile_data)) continue;
        
        // Calcular posição no minimap
        var _world_x = i * global.tile_size;
        var _world_y = j * global.tile_size;
        var _minimap_px = _minimap_x + (_world_x * _scale_x);
        var _minimap_py = _minimap_y + (_world_y * _scale_y);
        var _tile_w = max(1, global.tile_size * _scale_x * _sample_rate);
        var _tile_h = max(1, global.tile_size * _scale_y * _sample_rate);
        
        // ✅ PRIMEIRO: Desenhar terreno base (sempre visível)
        var _terreno = _tile_data.terreno;
        var _cor_terreno = make_color_rgb(60, 60, 60); // Cinza padrão
        
        if (!is_undefined(_terreno)) {
            switch (_terreno) {
                case TERRAIN.AGUA:
                    _cor_terreno = make_color_rgb(30, 80, 150); // Azul para água
                    break;
                case TERRAIN.DESERTO:
                    _cor_terreno = make_color_rgb(200, 180, 100); // Bege para deserto
                    break;
                case TERRAIN.FLORESTA:
                    _cor_terreno = make_color_rgb(20, 100, 40); // Verde escuro para floresta
                    break;
                case TERRAIN.CAMPO:
                    _cor_terreno = make_color_rgb(100, 130, 80); // Verde claro para campo
                    break;
                default:
                    _cor_terreno = make_color_rgb(60, 60, 60); // Cinza padrão
            }
        }
        
        // Desenhar terreno base
        draw_set_color(_cor_terreno);
        draw_set_alpha(0.7);
        draw_rectangle(_minimap_px, _minimap_py, _minimap_px + _tile_w, _minimap_py + _tile_h, false);
        
        // ✅ SEGUNDO: Desenhar sobreposição de território (se houver)
        var _nacao = _tile_data.nacao;
        if (!is_undefined(_nacao) && _nacao != NATIONS.NEUTRA) {
            var _cor_nacao = c_gray;
            if (_nacao == NATIONS.IMPERIO_DO_SOL) {
                _cor_nacao = make_color_rgb(50, 150, 255); // Azul (jogador)
            } else if (_nacao == NATIONS.REPUBLICA_DA_COSTA) {
                _cor_nacao = make_color_rgb(255, 50, 50); // Vermelho (inimigo)
            } else if (_nacao == NATIONS.FEDERACAO_DAS_ILHAS) {
                _cor_nacao = make_color_rgb(255, 150, 50); // Laranja (outro inimigo)
            } else {
                _cor_nacao = make_color_rgb(100, 100, 100); // Cinza (neutro/outros)
            }
            
            draw_set_color(_cor_nacao);
            draw_set_alpha(0.4); // Semi-transparente para ver o terreno embaixo
            draw_rectangle(_minimap_px, _minimap_py, _minimap_px + _tile_w, _minimap_py + _tile_h, false);
        }
    }
}

// === DESENHAR ÁREA VISÍVEL DA CÂMERA ===
var _cam = view_camera[0];
if (_cam != noone) {
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);
    
    if (is_real(_cam_x) && is_real(_cam_y) && is_real(_cam_w) && is_real(_cam_h) && _cam_w > 0 && _cam_h > 0) {
        // Converter posição da câmera para coordenadas do minimap
        var _view_x = _minimap_x + (_cam_x * _scale_x);
        var _view_y = _minimap_y + (_cam_y * _scale_y);
        var _view_w = _cam_w * _scale_x;
        var _view_h = _cam_h * _scale_y;
        
        // Desenhar retângulo da área visível
        draw_set_color(c_yellow);
        draw_set_alpha(0.4);
        draw_rectangle(_view_x, _view_y, _view_x + _view_w, _view_y + _view_h, false);
        
        // Borda da área visível
        draw_set_color(c_yellow);
        draw_set_alpha(1);
        draw_rectangle(_view_x, _view_y, _view_x + _view_w, _view_y + _view_h, true);
    }
}

// === DESENHAR TODOS OS OBJETOS IMPORTANTES NO MINIMAP ===
// ✅ CORREÇÃO: Armazenar variáveis como variáveis de instância para acesso via 'other' nos blocos 'with'
minimap_draw_x = _minimap_x;
minimap_draw_y = _minimap_y;
minimap_draw_scale_x = _scale_x;
minimap_draw_scale_y = _scale_y;
minimap_unit_size = 2;
minimap_structure_size = 2.5; // Estruturas são um pouco maiores

// === FUNÇÃO AUXILIAR: Obter cor baseada na nação ===
function _get_nation_color(_nacao) {
    if (_nacao == 1) {
        // Jogador (Azul)
        return make_color_rgb(50, 150, 255);
    } else if (_nacao == 2) {
        // Presidente 1 / IA Inimiga (Vermelho)
        return make_color_rgb(255, 50, 50);
    } else if (_nacao == 3) {
        // Outra nação (Laranja)
        return make_color_rgb(255, 150, 50);
    } else {
        // Neutro/Outros (Cinza)
        return make_color_rgb(150, 150, 150);
    }
}

// === NAVIOS ===
with (obj_lancha_patrulha) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

with (obj_Constellation) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

with (obj_Independence) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

with (obj_RonaldReagan) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

with (obj_navio_base) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

with (obj_navio_transporte) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

with (obj_submarino_base) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

// === VEÍCULOS TERRESTRES ===
with (obj_tanque) {
    if (variable_instance_exists(id, "nacao_proprietaria") && visible) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

with (obj_blindado_antiaereo) {
    if (variable_instance_exists(id, "nacao_proprietaria") && visible) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

// === M1A ABRAMS ===
var _obj_abrams = asset_get_index("obj_M1A_Abrams");
if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object && object_exists(_obj_abrams)) {
    with (_obj_abrams) {
        if (variable_instance_exists(id, "nacao_proprietaria") && visible) {
            var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
            var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
            draw_set_color(_get_nation_color(nacao_proprietaria));
            draw_set_alpha(1);
            draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
        }
    }
}

// === GEPARD ANTI-AÉREO ===
var _obj_gepard = asset_get_index("obj_gepard");
if (_obj_gepard != -1 && asset_get_type(_obj_gepard) == asset_object && object_exists(_obj_gepard)) {
    with (_obj_gepard) {
        if (variable_instance_exists(id, "nacao_proprietaria") && visible) {
            var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
            var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
            draw_set_color(_get_nation_color(nacao_proprietaria));
            draw_set_alpha(1);
            draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
        }
    }
}

// === INFANTARIA ===
with (obj_infantaria) {
    if (variable_instance_exists(id, "nacao_proprietaria") && visible) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size - 1, false);
    }
}

with (obj_soldado_antiaereo) {
    if (variable_instance_exists(id, "nacao_proprietaria") && visible) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size - 1, false);
    }
}

// === AVIÕES E HELICÓPTEROS ===
with (obj_caca_f5) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

with (obj_helicoptero_militar) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

with (obj_c100) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

with (obj_f15) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

with (obj_su35) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
    }
}

// === F6 (se existir) ===
var _obj_f6 = asset_get_index("obj_f6");
if (_obj_f6 != -1 && asset_get_type(_obj_f6) == asset_object && object_exists(_obj_f6)) {
    with (_obj_f6) {
        if (variable_instance_exists(id, "nacao_proprietaria")) {
            var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
            var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
            draw_set_color(_get_nation_color(nacao_proprietaria));
            draw_set_alpha(1);
            draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_unit_size, false);
        }
    }
}

// === ESTRUTURAS MILITARES ===
with (obj_quartel) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_structure_size, true);
    }
}

with (obj_quartel_marinha) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_structure_size, true);
    }
}

with (obj_aeroporto_militar) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_structure_size, true);
    }
}

// === ESTRUTURAS CIVIS ===
with (obj_casa) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_structure_size - 0.5, true);
    }
}

with (obj_banco) {
    if (variable_instance_exists(id, "nacao_proprietaria")) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        draw_set_color(_get_nation_color(nacao_proprietaria));
        draw_set_alpha(1);
        draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_structure_size - 0.5, true);
    }
}

// === CENTRO DE PESQUISA ===
// ✅ CORREÇÃO: Verificar se obj_centro_pesquisa existe antes de usar
var _obj_centro_pesquisa = asset_get_index("obj_centro_pesquisa");
if (_obj_centro_pesquisa != -1 && asset_get_type(_obj_centro_pesquisa) == asset_object && object_exists(_obj_centro_pesquisa)) {
    with (_obj_centro_pesquisa) {
        if (variable_instance_exists(id, "nacao_proprietaria")) {
            var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
            var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
            draw_set_color(_get_nation_color(nacao_proprietaria));
            draw_set_alpha(1);
            draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_structure_size, true);
        }
    }
}

// Verificar também obj_research_center (nome alternativo)
if (object_exists(obj_research_center)) {
    with (obj_research_center) {
        if (variable_instance_exists(id, "nacao_proprietaria")) {
            var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
            var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
            draw_set_color(_get_nation_color(nacao_proprietaria));
            draw_set_alpha(1);
            draw_circle(_unit_minimap_x, _unit_minimap_y, other.minimap_structure_size, true);
        }
    }
}

// === PRESIDENTE 1 (Marcador da IA) ===
var _obj_presidente_1 = asset_get_index("obj_presidente_1");
if (_obj_presidente_1 != -1 && asset_get_type(_obj_presidente_1) == asset_object && object_exists(_obj_presidente_1)) {
    with (_obj_presidente_1) {
        var _unit_minimap_x = other.minimap_draw_x + (x * other.minimap_draw_scale_x);
        var _unit_minimap_y = other.minimap_draw_y + (y * other.minimap_draw_scale_y);
        // Presidente aparece como um quadrado vermelho maior
        draw_set_color(make_color_rgb(255, 0, 0)); // Vermelho brilhante
        draw_set_alpha(1);
        draw_rectangle(_unit_minimap_x - 3, _unit_minimap_y - 3, _unit_minimap_x + 3, _unit_minimap_y + 3, false);
    }
}

// === TÍTULO DO MINIMAP ===
// Removido para não atrapalhar a visualização

// Resetar configurações
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
