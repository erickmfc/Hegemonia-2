// ===============================================
// C-100 Draw_64 - Interface Flutuante (3 MODOS)
// ===============================================

if (!selecionado) exit;

// ✅ CORREÇÃO: Usar coordenadas de mundo para que o status fique sempre perto do C-100, independente do zoom
// Posição acima da unidade (em coordenadas de mundo)
var _world_x = x;
var _world_y = y - 40 + (display_get_gui_height() * 0.05); // ✅ Movido 5% para baixo

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// ✅ MOSTRAR MODO ATUAL COM DESTAQUE ESPECIAL PARA EMBARCANDO
var _modo_texto = "";
var _modo_cor = c_white;
var _fundo_cor = c_black;
var _fundo_alpha = 0.7;

switch (modo_transporte) {
    case "fechado":
        _modo_texto = "FECHADO";
        _modo_cor = c_gray;
        break;
    case "embarcando":
        _modo_texto = "🚪 EMBARCANDO";
        _modo_cor = c_lime;
        _fundo_cor = c_lime;
        _fundo_alpha = 0.4; // Fundo mais chamativo
        break;
    case "embarcado":
        _modo_texto = "EMBARCADO";
        _modo_cor = c_aqua;
        break;
    case "desembarcando":
        _modo_texto = "DESEMBARCANDO";
        _modo_cor = c_yellow;
        break;
}

// Fundo do texto com destaque especial para embarcando
draw_set_color(_fundo_cor);
draw_set_alpha(_fundo_alpha);
draw_rectangle(_world_x - 60, _world_y - 15, _world_x + 60, _world_y + 15, false);

// Texto do modo
draw_set_color(_modo_cor);
draw_set_alpha(1);
draw_text(_world_x, _world_y, _modo_texto);

// Mostrar carga
draw_set_color(c_white);
draw_text(_world_x, _world_y + 16, string(carga_usada) + "/" + string(capacidade_total));

// ✅ MOSTRAR INSTRUÇÕES E STATUS DE EMBARQUE COM EFEITO PULSANTE
if (modo_transporte == "embarcando") {
    // Efeito pulsante para chamar atenção
    var _pulse = 0.5 + 0.3 * sin(current_time * 0.01);
    
    // Fundo destacado pulsante
    draw_set_color(c_lime);
    draw_set_alpha(0.2 + 0.2 * _pulse);
    draw_rectangle(_world_x - 90, _world_y + 25, _world_x + 90, _world_y + 70, false);
    
    // Borda pulsante
    draw_set_color(c_lime);
    draw_set_alpha(_pulse);
    draw_rectangle(_world_x - 90, _world_y + 25, _world_x + 90, _world_y + 70, true);
    
    draw_set_color(c_lime);
    draw_set_alpha(1);
    draw_text(_world_x, _world_y + 32, "🚪 PORTAS ABERTAS");
    draw_text(_world_x, _world_y + 48, "Clique no C-100 com tropas selecionadas");
    
    // Mostrar status de embarque com destaque
    if (carga_usada > 0) {
        draw_set_color(c_yellow);
        draw_set_alpha(1);
        draw_text(_world_x, _world_y + 64, "✅ " + string(carga_usada) + " unidades embarcaram!");
        
        // Efeito de sucesso
        draw_set_color(c_green);
        draw_set_alpha(0.8);
        draw_rectangle(_world_x - 70, _world_y + 60, _world_x + 70, _world_y + 75, false);
    } else {
        draw_set_color(c_orange);
        draw_set_alpha(_pulse);
        draw_text(_world_x, _world_y + 64, "⏳ Aguardando tropas...");
    }
}

if (modo_transporte == "embarcado") {
    if (carga_usada > 0) {
        draw_set_color(c_aqua);
        draw_text(_world_x, _world_y + 32, "✅ " + string(carga_usada) + " tropas a bordo");
        draw_text(_world_x, _world_y + 48, "Pressione P para desembarcar");
    } else {
        draw_set_color(c_gray);
        draw_text(_world_x, _world_y + 32, "Vazio - Pressione P para fechar");
    }
}

if (modo_transporte == "desembarcando") {
    draw_set_color(c_yellow);
    draw_text(_world_x, _world_y + 32, "🚪 DESEMBARCANDO...");
    draw_text(_world_x, _world_y + 48, "Aguarde as tropas saírem");
}

// Flares cooldown
if (flare_cooldown > 0) {
    var _cd = ceil(flare_cooldown / game_get_speed(gamespeed_fps));
    draw_set_color(c_orange);
    draw_text(_world_x, _world_y + 48, "Flares: " + string(_cd) + "s");
}

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);