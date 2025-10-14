// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
function scr_atualizar_recursos_lancha(){
    // === SISTEMA DE COMBUSTÍVEL ===
    var _consumo_total = consumo_combustivel_base;
    
    // Consumo extra por movimento
    if (estado == "movendo" || estado == "patrulhando") {
        _consumo_total += consumo_combustivel_movimento;
    }
    
    // Consumo extra por combate
    if (estado == "atacando" || modo_combate == "ataque") {
        _consumo_total += consumo_combustivel_combate;
    }
    
    // Aplicar consumo
    combustivel_atual -= _consumo_total;
    
    // Limitar combustível
    if (combustivel_atual < 0) {
        combustivel_atual = 0;
        // Lancha para quando sem combustível
        if (estado == "movendo" || estado == "patrulhando") {
            estado = "parado";
            show_debug_message("⛽ Lancha sem combustível - movimento parado");
        }
    }
    
    if (combustivel_atual > combustivel_max) {
        combustivel_atual = combustivel_max;
    }
    
    // === SISTEMA DE MUNIÇÃO ===
    // Consumo de munição por ataque
    if (timer_ataque == intervalo_ataque - 1 && estado == "atacando") {
        // Consumir munição de canhão
        if (municao_canhao_atual > 0) {
            municao_canhao_atual--;
        }
        
        // Se sem munição de canhão, usar mísseis
        if (municao_canhao_atual <= 0 && municao_misseis_atual > 0) {
            municao_misseis_atual--;
            show_debug_message("🚀 Lancha usando míssil - " + string(municao_misseis_atual) + " restantes");
        }
    }
    
    // Limitar munição
    if (municao_canhao_atual < 0) municao_canhao_atual = 0;
    if (municao_misseis_atual < 0) municao_misseis_atual = 0;
    if (municao_canhao_atual > municao_canhao_max) municao_canhao_atual = municao_canhao_max;
    if (municao_misseis_atual > municao_misseis_max) municao_misseis_atual = municao_misseis_max;
    
    // === SISTEMA DE DANO E REPARO ===
    // Reparo natural
    if (dano_estrutural > 0) {
        dano_estrutural -= taxa_reparo_natural;
        if (dano_estrutural < 0) dano_estrutural = 0;
    }
    
    // Verificar se necessita reparo
    necessita_reparo = (dano_estrutural > 50);
    
    // === SISTEMA DE ALERTAS ===
    // Alerta de combustível baixo
    alerta_combustivel_baixo = (combustivel_atual < combustivel_max * 0.2);
    
    // Alerta de munição baixa
    alerta_municao_baixa = (municao_canhao_atual < municao_canhao_max * 0.3 && municao_misseis_atual < municao_misseis_max * 0.3);
    
    // Alerta de dano crítico
    alerta_dano_critico = (dano_estrutural > 80);
    
    // === EFEITOS VISUAIS POR ESTADO DE RECURSOS ===
    if (alerta_combustivel_baixo) {
        image_blend = make_color_rgb(255, 100, 100);  // Vermelho quando combustível baixo
    } else if (alerta_municao_baixa) {
        image_blend = make_color_rgb(255, 200, 100);  // Laranja quando munição baixa
    } else if (alerta_dano_critico) {
        image_blend = make_color_rgb(150, 50, 50);  // Vermelho escuro quando dano crítico
    } else if (selecionado) {
        image_blend = make_color_rgb(255, 255, 100);  // Amarelo quando selecionado
    } else {
        image_blend = make_color_rgb(100, 150, 255);  // Azul normal
    }
    
    // === DEBUG DE RECURSOS (apenas quando selecionado) ===
    if (selecionado && (alerta_combustivel_baixo || alerta_municao_baixa || alerta_dano_critico)) {
        show_debug_message("⚠️ Lancha - Recursos: Combustível: " + string(round(combustivel_atual)) + "/" + string(combustivel_max) + 
                          " | Munição: " + string(municao_canhao_atual) + "/" + string(municao_canhao_max) + 
                          " | Mísseis: " + string(municao_misseis_atual) + "/" + string(municao_misseis_max) + 
                          " | Dano: " + string(round(dano_estrutural)));
    }
}

function scr_consumir_combustivel_lancha(quantidade){
    combustivel_atual -= quantidade;
    if (combustivel_atual < 0) combustivel_atual = 0;
}

function scr_consumir_municao_lancha(tipo_municao, quantidade){
    if (tipo_municao == "canhao") {
        municao_canhao_atual -= quantidade;
        if (municao_canhao_atual < 0) municao_canhao_atual = 0;
    } else if (tipo_municao == "missil") {
        municao_misseis_atual -= quantidade;
        if (municao_misseis_atual < 0) municao_misseis_atual = 0;
    }
}

function scr_aplicar_dano_lancha(dano){
    dano_estrutural += dano;
    hp_atual -= dano;
    
    if (hp_atual < 0) hp_atual = 0;
    if (dano_estrutural > 100) dano_estrutural = 100;
    
    show_debug_message("💥 Lancha recebeu " + string(dano) + " de dano - HP: " + string(hp_atual) + "/" + string(hp_max));
}

function scr_reparar_lancha(quantidade_reparo){
    dano_estrutural -= quantidade_reparo;
    if (dano_estrutural < 0) dano_estrutural = 0;
    
    hp_atual += quantidade_reparo;
    if (hp_atual > hp_max) hp_atual = hp_max;
    
    show_debug_message("🔧 Lancha reparada - HP: " + string(hp_atual) + "/" + string(hp_max));
}

function scr_reabastecer_lancha(combustivel, municao_canhao, municao_misseis){
    combustivel_atual += combustivel;
    if (combustivel_atual > combustivel_max) combustivel_atual = combustivel_max;
    
    municao_canhao_atual += municao_canhao;
    if (municao_canhao_atual > municao_canhao_max) municao_canhao_atual = municao_canhao_max;
    
    municao_misseis_atual += municao_misseis;
    if (municao_misseis_atual > municao_misseis_max) municao_misseis_atual = municao_misseis_max;
    
    show_debug_message("⛽ Lancha reabastecida - Combustível: " + string(combustivel_atual) + "/" + string(combustivel_max));
}
