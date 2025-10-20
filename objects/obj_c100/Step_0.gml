// ===============================================
// HEGEMONIA GLOBAL - C-100 Transporte (Step)
// ===============================================

// Herda toda a lógica de voo/estados do F-5
event_inherited();

// 1) Tecla P: embarque/desembarque (somente no solo)
if (selecionado && keyboard_check_pressed(ord("P"))) {
    if (altura_voo == 0 && estado == "pousado") {
        if (modo_receber_carga && carga_usada > 0) {
            // Desembarque
            // (spawn em anel será implementado; placeholder de debug)
            show_debug_message("C-100: Desembarcar");
            modo_receber_carga = false;
        } else if (!modo_evadindo && carga_usada < capacidade_total) {
            modo_receber_carga = !modo_receber_carga;
            show_debug_message("C-100: Receber Carga = " + string(modo_receber_carga));
        }
    } else {
        show_debug_message("C-100: Pousar para embarcar/desembarcar");
    }
}

// 2) Tecla O: flares (defesa)
if (selecionado && keyboard_check_pressed(ord("O"))) {
    if (!modo_evadindo && flare_cooldown <= 0) {
        modo_evadindo = true;
        flare_timer_ativo = flare_duracao;
        flare_cooldown = flare_cooldown_max;
        // Criar flares visuais usando obj_fumaca_missil com flags
        var n = 8;
        for (var i = 0; i < n; i++) {
            var ang = image_angle + 180 + irandom_range(-40, 40);
            var fx = instance_create_layer(x - lengthdir_x(12, ang), y - lengthdir_y(12, ang), "Instances", obj_fumaca_missil);
            if (instance_exists(fx)) {
                fx.is_flare = true;
                fx.heat = 100; // bem quente
                fx.flare_ttl = flare_duracao;
                fx.dono = id;
            }
        }
        show_debug_message("C-100: Flares disparados");
    }
}

// 3) Timers de flares
if (modo_evadindo) {
    flare_timer_ativo -= 1;
    if (flare_timer_ativo <= 0) modo_evadindo = false;
}
if (flare_cooldown > 0) flare_cooldown -= 1;
