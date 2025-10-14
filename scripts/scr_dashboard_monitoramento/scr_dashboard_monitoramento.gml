// Dashboard de Monitoramento em Tempo Real - Hegemonia Global
// Sistema de monitoramento visual da saúde do sistema

// Estrutura do dashboard
global.dashboard = {
    ativo: false,
    posicao_x: 10,
    posicao_y: 10,
    largura: 300,
    altura: 200,
    cor_fundo: c_black,
    cor_texto: c_white,
    cor_alerta: c_red,
    cor_aviso: c_yellow,
    cor_ok: c_green,
    atualizacao_intervalo: 60, // A cada segundo
    ultima_atualizacao: 0
};

// Métricas do sistema
global.metricas_sistema = {
    fps_atual: 60,
    fps_media: 60,
    fps_minimo: 60,
    objetos_ativos: 0,
    memoria_uso: 0,
    memoria_limite: 80,
    unidades_combate: 0,
    problemas_ativos: 0,
    performance_score: 100,
    ultima_atualizacao: 0
};

function scr_inicializar_dashboard() {
    scr_log_sistema("DASHBOARD", "Dashboard de monitoramento inicializado");
    
    global.dashboard.ativo = true;
    global.dashboard.ultima_atualizacao = 0;
    
    // Configurar métricas iniciais
    global.metricas_sistema.fps_atual = fps;
    global.metricas_sistema.fps_media = fps;
    global.metricas_sistema.fps_minimo = fps;
    global.metricas_sistema.objetos_ativos = instance_number(all);
    global.metricas_sistema.memoria_uso = scr_calcular_uso_memoria();
    global.metricas_sistema.unidades_combate = array_length(global.sistema_combate.unidades_em_combate);
    global.metricas_sistema.problemas_ativos = array_length(global.problemas_detectados);
    global.metricas_sistema.performance_score = scr_calcular_performance_score();
}

function scr_atualizar_dashboard() {
    if (!global.dashboard.ativo) return;
    
    // Atualizar métricas periodicamente
    if (global.debug_last_frame - global.dashboard.ultima_atualizacao >= global.dashboard.atualizacao_intervalo) {
        scr_atualizar_metricas_sistema();
        global.dashboard.ultima_atualizacao = global.debug_last_frame;
    }
    
    // Desenhar dashboard
    scr_desenhar_dashboard();
}

function scr_atualizar_metricas_sistema() {
    // Atualizar FPS
    global.metricas_sistema.fps_atual = fps;
    global.metricas_sistema.fps_media = (global.metricas_sistema.fps_media + fps) / 2;
    global.metricas_sistema.fps_minimo = min(global.metricas_sistema.fps_minimo, fps);
    
    // Atualizar objetos
    global.metricas_sistema.objetos_ativos = instance_number(all);
    
    // Atualizar memória
    global.metricas_sistema.memoria_uso = scr_calcular_uso_memoria();
    
    // Atualizar combate
    global.metricas_sistema.unidades_combate = array_length(global.sistema_combate.unidades_em_combate);
    
    // Atualizar problemas
    global.metricas_sistema.problemas_ativos = array_length(global.problemas_detectados);
    
    // Atualizar score de performance
    global.metricas_sistema.performance_score = scr_calcular_performance_score();
    
    global.metricas_sistema.ultima_atualizacao = current_time;
}

function scr_calcular_performance_score() {
    var _score = 100;
    
    // Penalizar FPS baixo
    if (global.metricas_sistema.fps_atual < 30) {
        _score -= 30;
    } else if (global.metricas_sistema.fps_atual < 45) {
        _score -= 15;
    }
    
    // Penalizar memória alta
    if (global.metricas_sistema.memoria_uso > 90) {
        _score -= 25;
    } else if (global.metricas_sistema.memoria_uso > 80) {
        _score -= 15;
    }
    
    // Penalizar muitos objetos
    if (global.metricas_sistema.objetos_ativos > 100) {
        _score -= 20;
    } else if (global.metricas_sistema.objetos_ativos > 50) {
        _score -= 10;
    }
    
    // Penalizar problemas ativos
    _score -= global.metricas_sistema.problemas_ativos * 5;
    
    return max(0, _score);
}

function scr_desenhar_dashboard() {
    var _x = global.dashboard.posicao_x;
    var _y = global.dashboard.posicao_y;
    var _w = global.dashboard.largura;
    var _h = global.dashboard.altura;
    
    // Fundo do dashboard
    draw_set_color(global.dashboard.cor_fundo);
    draw_set_alpha(0.8);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_alpha(1);
    
    // Borda
    draw_set_color(global.dashboard.cor_texto);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);
    
    // Título
    draw_set_color(global.dashboard.cor_texto);
    draw_set_font(-1);
    draw_text(_x + 10, _y + 10, "🎯 DASHBOARD SISTEMA");
    
    var _linha_y = _y + 35;
    var _linha_altura = 20;
    
    // FPS
    var _cor_fps = scr_obter_cor_status(global.metricas_sistema.fps_atual, 30, 45);
    draw_set_color(_cor_fps);
    draw_text(_x + 10, _linha_y, "FPS: " + string(global.metricas_sistema.fps_atual) + " (min: " + string(global.metricas_sistema.fps_minimo) + ")");
    _linha_y += _linha_altura;
    
    // Performance Score
    var _cor_score = scr_obter_cor_status(global.metricas_sistema.performance_score, 70, 85);
    draw_set_color(_cor_score);
    draw_text(_x + 10, _linha_y, "Performance: " + string(global.metricas_sistema.performance_score) + "%");
    _linha_y += _linha_altura;
    
    // Objetos Ativos
    draw_set_color(global.dashboard.cor_texto);
    draw_text(_x + 10, _linha_y, "Objetos: " + string(global.metricas_sistema.objetos_ativos));
    _linha_y += _linha_altura;
    
    // Memória
    var _cor_memoria = scr_obter_cor_status(100 - global.metricas_sistema.memoria_uso, 20, 10);
    draw_set_color(_cor_memoria);
    draw_text(_x + 10, _linha_y, "Memória: " + string(global.metricas_sistema.memoria_uso) + "%");
    _linha_y += _linha_altura;
    
    // Unidades em Combate
    draw_set_color(global.dashboard.cor_texto);
    draw_text(_x + 10, _linha_y, "Combate: " + string(global.metricas_sistema.unidades_combate));
    _linha_y += _linha_altura;
    
    // Problemas Ativos
    var _cor_problemas = global.metricas_sistema.problemas_ativos > 0 ? global.dashboard.cor_alerta : global.dashboard.cor_ok;
    draw_set_color(_cor_problemas);
    draw_text(_x + 10, _linha_y, "Problemas: " + string(global.metricas_sistema.problemas_ativos));
    _linha_y += _linha_altura;
    
    // Barra de Performance
    scr_desenhar_barra_performance(_x + 10, _linha_y, _w - 20, 15);
    
    // Alertas
    scr_desenhar_alertas(_x + 10, _y + _h - 30);
}

function scr_obter_cor_status(valor, limite_baixo, limite_medio) {
    if (valor < limite_baixo) {
        return global.dashboard.cor_alerta;
    } else if (valor < limite_medio) {
        return global.dashboard.cor_aviso;
    } else {
        return global.dashboard.cor_ok;
    }
}

function scr_desenhar_barra_performance(x, y, largura, altura) {
    var _score = global.metricas_sistema.performance_score;
    var _cor_barra = scr_obter_cor_status(_score, 50, 75);
    
    // Fundo da barra
    draw_set_color(global.dashboard.cor_fundo);
    draw_rectangle(x, y, x + largura, y + altura, false);
    
    // Barra de performance
    var _largura_preenchida = (largura * _score) / 100;
    draw_set_color(_cor_barra);
    draw_rectangle(x, y, x + _largura_preenchida, y + altura, false);
    
    // Borda da barra
    draw_set_color(global.dashboard.cor_texto);
    draw_rectangle(x, y, x + largura, y + altura, true);
}

function scr_desenhar_alertas(x, y) {
    var _alertas = scr_obter_alertas_ativos();
    
    if (array_length(_alertas) > 0) {
        draw_set_color(global.dashboard.cor_alerta);
        draw_text(x, y, "⚠️ ALERTAS:");
        
        for (var i = 0; i < min(array_length(_alertas), 3); i++) {
            draw_text(x + 10, y + 15 + (i * 12), "• " + _alertas[i]);
        }
    }
}

function scr_obter_alertas_ativos() {
    var _alertas = [];
    
    // FPS baixo
    if (global.metricas_sistema.fps_atual < 30) {
        array_push(_alertas, "FPS muito baixo!");
    }
    
    // Memória alta
    if (global.metricas_sistema.memoria_uso > 90) {
        array_push(_alertas, "Memória crítica!");
    }
    
    // Muitos objetos
    if (global.metricas_sistema.objetos_ativos > 100) {
        array_push(_alertas, "Muitos objetos ativos!");
    }
    
    // Problemas ativos
    if (global.metricas_sistema.problemas_ativos > 5) {
        array_push(_alertas, "Muitos problemas detectados!");
    }
    
    // Performance baixa
    if (global.metricas_sistema.performance_score < 50) {
        array_push(_alertas, "Performance crítica!");
    }
    
    return _alertas;
}

function scr_alternar_dashboard() {
    global.dashboard.ativo = !global.dashboard.ativo;
    
    if (global.dashboard.ativo) {
        scr_log_sistema("DASHBOARD", "Dashboard ativado");
    } else {
        scr_log_sistema("DASHBOARD", "Dashboard desativado");
    }
}

function scr_configurar_dashboard(pos_x, pos_y, largura, altura) {
    global.dashboard.posicao_x = pos_x;
    global.dashboard.posicao_y = pos_y;
    global.dashboard.largura = largura;
    global.dashboard.altura = altura;
    
    scr_debug_log("DASHBOARD", "Configuração do dashboard atualizada", DEBUG_LEVEL.BASIC);
}

function scr_dashboard_relatorio_completo() {
    scr_debug_log("DASHBOARD", "=== RELATÓRIO COMPLETO DO DASHBOARD ===", DEBUG_LEVEL.BASIC, true);
    
    scr_debug_log("DASHBOARD", "FPS atual: " + string(global.metricas_sistema.fps_atual), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("DASHBOARD", "FPS médio: " + string(global.metricas_sistema.fps_media), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("DASHBOARD", "FPS mínimo: " + string(global.metricas_sistema.fps_minimo), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("DASHBOARD", "Objetos ativos: " + string(global.metricas_sistema.objetos_ativos), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("DASHBOARD", "Uso de memória: " + string(global.metricas_sistema.memoria_uso) + "%", DEBUG_LEVEL.BASIC, true);
    scr_debug_log("DASHBOARD", "Unidades em combate: " + string(global.metricas_sistema.unidades_combate), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("DASHBOARD", "Problemas ativos: " + string(global.metricas_sistema.problemas_ativos), DEBUG_LEVEL.BASIC, true);
    scr_debug_log("DASHBOARD", "Score de performance: " + string(global.metricas_sistema.performance_score) + "%", DEBUG_LEVEL.BASIC, true);
    
    // Alertas
    var _alertas = scr_obter_alertas_ativos();
    if (array_length(_alertas) > 0) {
        scr_debug_log("DASHBOARD", "Alertas ativos:", DEBUG_LEVEL.BASIC, true);
        for (var i = 0; i < array_length(_alertas); i++) {
            scr_debug_log("DASHBOARD", "  - " + _alertas[i], DEBUG_LEVEL.BASIC, true);
        }
    } else {
        scr_debug_log("DASHBOARD", "Nenhum alerta ativo", DEBUG_LEVEL.BASIC, true);
    }
    
    scr_debug_log("DASHBOARD", "=== FIM DO RELATÓRIO ===", DEBUG_LEVEL.BASIC, true);
}

function scr_dashboard_exportar_metricas() {
    // Exportar métricas para análise externa
    var _metricas = {
        timestamp: current_time,
        fps_atual: global.metricas_sistema.fps_atual,
        fps_media: global.metricas_sistema.fps_media,
        fps_minimo: global.metricas_sistema.fps_minimo,
        objetos_ativos: global.metricas_sistema.objetos_ativos,
        memoria_uso: global.metricas_sistema.memoria_uso,
        unidades_combate: global.metricas_sistema.unidades_combate,
        problemas_ativos: global.metricas_sistema.problemas_ativos,
        performance_score: global.metricas_sistema.performance_score
    };
    
    scr_debug_log("DASHBOARD", "Métricas exportadas: " + json_encode(_metricas), DEBUG_LEVEL.BASIC);
    
    return _metricas;
}

function scr_dashboard_historico_performance() {
    // Manter histórico de performance para análise de tendências
    if (!variable_global_exists("historico_performance")) {
        global.historico_performance = [];
    }
    
    var _entrada = {
        timestamp: current_time,
        fps: global.metricas_sistema.fps_atual,
        memoria: global.metricas_sistema.memoria_uso,
        objetos: global.metricas_sistema.objetos_ativos,
        score: global.metricas_sistema.performance_score
    };
    
    array_push(global.historico_performance, _entrada);
    
    // Manter apenas últimas 100 entradas
    if (array_length(global.historico_performance) > 100) {
        array_delete(global.historico_performance, 0, 1);
    }
}
