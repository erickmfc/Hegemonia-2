// ===============================================
// HEGEMONIA GLOBAL - C-100 Draw GUI (HUD)
// ===============================================

// Só desenhar se selecionado
if (!selecionado) exit;

// Configurações de HUD
var _x = 20;
var _y = 20;
var _cor_base = c_white;
var _cor_carga = c_yellow;
var _cor_flares = c_red;

// 1) Informações básicas
draw_set_color(_cor_base);
draw_set_font(-1);
draw_text(_x, _y, "✈️ C-100 Transporte");

// Estado com texto mais claro
var _estado_display = "DESCONHECIDO";
if (estado == "pousado") _estado_display = "POUSADO";
else if (estado == "pousando") _estado_display = "POUSANDO";
else if (estado == "movendo") _estado_display = "VOANDO";
else if (estado == "patrulhando") _estado_display = "PATRULHANDO";
else if (estado == "decolando") _estado_display = "DECOLANDO";

draw_text(_x, _y + 20, "Estado: " + _estado_display);
draw_text(_x, _y + 40, "Altitude: " + string(altura_voo));

// 2) Sistema de carga (melhorado)
draw_set_color(_cor_carga);
draw_text(_x, _y + 70, "📦 CARGA:");
draw_text(_x, _y + 90, "Slots: " + string(carga_usada) + "/" + string(capacidade_total));

// Barra de progresso visual
var _progresso = carga_usada / capacidade_total;
var _barra_largura = 200;
var _barra_altura = 20;
var _barra_x = _x;
var _barra_y = _y + 110;

// Fundo da barra
draw_set_color(c_dkgray);
draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_largura, _barra_y + _barra_altura, false);

// Preenchimento da barra
if (_progresso > 0) {
    draw_set_color(lerp_color(c_green, c_red, _progresso));
    draw_rectangle(_barra_x, _barra_y, _barra_x + (_barra_largura * _progresso), _barra_y + _barra_altura, false);
}

// Borda da barra
draw_set_color(c_white);
draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_largura, _barra_y + _barra_altura, true);

// Texto do modo
if (modo_receber_carga) {
    draw_set_color(c_lime);
    draw_text(_x, _y + 140, "🟢 MODO EMBARQUE ATIVO");
    draw_text(_x, _y + 160, "Unidades próximas embarcam automaticamente");
} else {
    draw_set_color(c_red);
    draw_text(_x, _y + 140, "🔴 MODO EMBARQUE INATIVO");
    if (carga_usada > 0) {
        draw_text(_x, _y + 160, "Pressione P para desembarcar");
    } else {
        draw_text(_x, _y + 160, "Pressione P para ativar embarque");
    }
}

// 3) Sistema de flares
draw_set_color(_cor_flares);
draw_text(_x, _y + 180, "🚀 FLARES:");
if (modo_evadindo) {
    draw_text(_x, _y + 200, "🟢 FLARES ATIVOS (" + string(flare_timer_ativo) + " frames)");
} else if (flare_cooldown > 0) {
    var _segundos = ceil(flare_cooldown / game_get_speed(gamespeed_fps));
    draw_text(_x, _y + 200, "🔴 Cooldown: " + string(_segundos) + "s");
} else {
    draw_text(_x, _y + 200, "🟢 Flares prontos");
}

// 4) Controles
draw_set_color(_cor_base);
draw_text(_x, _y + 240, "CONTROLES:");
draw_text(_x, _y + 260, "P - Embarcar/Desembarcar");
draw_text(_x, _y + 280, "O - Ativar Flares");
draw_text(_x, _y + 300, "L - Pousar");
draw_text(_x, _y + 320, "Shift+Click - Seleção múltipla");

// 5) Lista de carga (melhorada)
if (ds_list_size(lista_carga) > 0) {
    draw_set_color(c_lime);
    draw_text(_x, _y + 340, "📋 CARGA ATUAL (" + string(ds_list_size(lista_carga)) + " unidades):");
    
    var _offset = 0;
    var _contador_tipos = ds_map_create();
    
    // Contar tipos de unidades
    for (var i = 0; i < ds_list_size(lista_carga); i++) {
        var _carga = lista_carga[| i];
        if (ds_map_exists(_contador_tipos, _carga.tipo)) {
            ds_map_set(_contador_tipos, _carga.tipo, ds_map_find_value(_contador_tipos, _carga.tipo) + 1);
        } else {
            ds_map_set(_contador_tipos, _carga.tipo, 1);
        }
    }
    
    // Mostrar resumo por tipo
    var _keys = ds_map_keys_to_array(_contador_tipos);
    for (var i = 0; i < array_length(_keys); i++) {
        var _tipo = _keys[i];
        var _quantidade = ds_map_find_value(_contador_tipos, _tipo);
        var _peso_total = 0;
        
        // Calcular peso total deste tipo
        for (var j = 0; j < ds_list_size(lista_carga); j++) {
            var _carga = lista_carga[| j];
            if (_carga.tipo == _tipo) {
                _peso_total += _carga.peso;
            }
        }
        
        draw_text(_x, _y + 360 + _offset, "• " + _tipo + " x" + string(_quantidade) + " (peso total: " + string(_peso_total) + ")");
        _offset += 20;
    }
    
    ds_map_destroy(_contador_tipos);
} else {
    draw_set_color(c_gray);
    draw_text(_x, _y + 340, "📋 Nenhuma unidade embarcada");
}

// 6) Penalidades (se aplicadas)
if (penalidade_carga_aplicada) {
    draw_set_color(c_orange);
    draw_text(_x, _y + 480, "⚠️ PENALIDADE DE CARGA ATIVA");
    draw_text(_x, _y + 500, "Velocidade: -10% | Agilidade: -15%");
}
