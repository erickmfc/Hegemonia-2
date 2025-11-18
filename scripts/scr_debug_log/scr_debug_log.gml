/// @description Sistema de debug e log - sistema centralizado de logging
/// @param {string} categoria Categoria da mensagem
/// @param {string} mensagem Mensagem a ser registrada
/// @param {string} nivel Nível de log (opcional)
/// @param {struct} dados Dados adicionais (opcional)

function scr_debug_log(categoria, mensagem, nivel = "info", dados = {}) {
    // Inicializar sistema de log se não existir
    if (!variable_global_exists("global.debug_system")) {
        global.debug_system = {
            logs: [],
            max_logs: 1000,
            categorias_ativas: ["ERROR", "WARNING", "INFO", "DEBUG"],
            arquivo_log: "debug_log.txt",
            timestamp_inicial: current_time
        };
    }
    
    var debug_system = global.debug_system;
    
    // Verificar se a categoria está ativa
    if (!scr_categoria_ativa(categoria)) {
        return;
    }
    
    // Criar entrada de log
    // ✅ CORREÇÃO: game_get_frame_count() não existe no GameMaker
    var _frame_count = 0;
    if (variable_global_exists("game_frame")) {
        _frame_count = global.game_frame;
    } else if (variable_global_exists("frame_count")) {
        _frame_count = global.frame_count;
    }
    
    var entrada_log = {
        timestamp: current_time,
        categoria: categoria,
        mensagem: mensagem,
        nivel: nivel,
        dados: dados,
        frame: _frame_count
    };
    
    // Adicionar ao sistema de logs
    debug_system.logs[array_length(debug_system.logs)] = entrada_log;
    
    // Limitar número de logs
    if (array_length(debug_system.logs) > debug_system.max_logs) {
        array_delete(debug_system.logs, 0, 1);
    }
    
    // ✅ CORREÇÃO: Verificar se debug está habilitado globalmente
    var _debug_habilitado = (variable_global_exists("debug_enabled") && global.debug_enabled);
    
    // Exibir no console se debug estiver ativo
    if (_debug_habilitado) {
        var timestamp_str = string(entrada_log.timestamp);
        var frame_str = string(entrada_log.frame);
        var log_str = "[" + timestamp_str + "] [" + frame_str + "] [" + categoria + "] " + mensagem;
        
        switch (nivel) {
            case "error":
                show_debug_message("❌ " + log_str);
                break;
            case "warning":
                show_debug_message("⚠️ " + log_str);
                break;
            case "info":
                show_debug_message("ℹ️ " + log_str);
                break;
            case "debug":
                show_debug_message("🔍 " + log_str);
                break;
            default:
                show_debug_message("📝 " + log_str);
                break;
        }
    }
}

/// @description Verificar se categoria está ativa
function scr_categoria_ativa(categoria) {
    if (!variable_global_exists("global.debug_system")) {
        return true; // Permitir todas se sistema não estiver inicializado
    }
    
    var debug_system = global.debug_system;
    
    for (var i = 0; i < array_length(debug_system.categorias_ativas); i++) {
        if (debug_system.categorias_ativas[i] == categoria) {
            return true;
        }
    }
    
    return false;
}

/// @description Ativar categoria de debug
function scr_ativar_categoria_debug(categoria) {
    if (!variable_global_exists("global.debug_system")) {
        return;
    }
    
    var debug_system = global.debug_system;
    
    // Verificar se categoria já está ativa
    for (var i = 0; i < array_length(debug_system.categorias_ativas); i++) {
        if (debug_system.categorias_ativas[i] == categoria) {
            return; // Já está ativa
        }
    }
    
    // Adicionar categoria
    debug_system.categorias_ativas[array_length(debug_system.categorias_ativas)] = categoria;
}

/// @description Desativar categoria de debug
function scr_desativar_categoria_debug(categoria) {
    if (!variable_global_exists("global.debug_system")) {
        return;
    }
    
    var debug_system = global.debug_system;
    
    // Remover categoria
    for (var i = 0; i < array_length(debug_system.categorias_ativas); i++) {
        if (debug_system.categorias_ativas[i] == categoria) {
            array_delete(debug_system.categorias_ativas, i, 1);
            break;
        }
    }
}

/// @description Obter logs por categoria
function scr_obter_logs_categoria(categoria) {
    if (!variable_global_exists("global.debug_system")) {
        return [];
    }
    
    var debug_system = global.debug_system;
    var logs_categoria = [];
    
    for (var i = 0; i < array_length(debug_system.logs); i++) {
        var log = debug_system.logs[i];
        if (log.categoria == categoria) {
            logs_categoria[array_length(logs_categoria)] = log;
        }
    }
    
    return logs_categoria;
}

/// @description Obter logs por nível
function scr_obter_logs_nivel(nivel) {
    if (!variable_global_exists("global.debug_system")) {
        return [];
    }
    
    var debug_system = global.debug_system;
    var logs_nivel = [];
    
    for (var i = 0; i < array_length(debug_system.logs); i++) {
        var log = debug_system.logs[i];
        if (log.nivel == nivel) {
            logs_nivel[array_length(logs_nivel)] = log;
        }
    }
    
    return logs_nivel;
}

/// @description Limpar logs
function scr_limpar_logs() {
    if (!variable_global_exists("global.debug_system")) {
        return;
    }
    
    var debug_system = global.debug_system;
    debug_system.logs = [];
    
    show_debug_message("🧹 Logs limpos");
}

/// @description Exportar logs para arquivo
function scr_exportar_logs(arquivo = "debug_log.txt") {
    if (!variable_global_exists("global.debug_system")) {
        return false;
    }
    
    var debug_system = global.debug_system;
    var conteudo = "";
    
    // Cabeçalho
    conteudo += "=== LOG DE DEBUG - HEGEMONIA GLOBAL ===\n";
    conteudo += "Data: " + string(date_get_datetime_string()) + "\n";
    conteudo += "Total de logs: " + string(array_length(debug_system.logs)) + "\n";
    conteudo += "==========================================\n\n";
    
    // Logs
    for (var i = 0; i < array_length(debug_system.logs); i++) {
        var log = debug_system.logs[i];
        var timestamp_str = string(log.timestamp);
        var frame_str = string(log.frame);
        
        conteudo += "[" + timestamp_str + "] [" + frame_str + "] [" + log.categoria + "] [" + log.nivel + "] " + log.mensagem + "\n";
        
        // Adicionar dados se existirem
        if (is_struct(log.dados) && struct_size(log.dados) > 0) {
            conteudo += "  Dados: " + string(log.dados) + "\n";
        }
    }
    
    // Salvar arquivo
    var arquivo_id = file_text_open_write(arquivo);
    if (arquivo_id != -1) {
        file_text_write_string(arquivo_id, conteudo);
        file_text_close(arquivo_id);
        
        show_debug_message("📁 Logs exportados para: " + arquivo);
        return true;
    }
    
    return false;
}

/// @description Obter estatísticas de logs
function scr_obter_estatisticas_logs() {
    if (!variable_global_exists("global.debug_system")) {
        return {};
    }
    
    var debug_system = global.debug_system;
    var estatisticas = {
        total_logs: array_length(debug_system.logs),
        categorias: {},
        niveis: {},
        tempo_total: current_time - debug_system.timestamp_inicial
    };
    
    // Contar por categoria e nível
    for (var i = 0; i < array_length(debug_system.logs); i++) {
        var log = debug_system.logs[i];
        
        // Contar categorias
        if (struct_exists(estatisticas.categorias, log.categoria)) {
            estatisticas.categorias[$log.categoria]++;
        } else {
            estatisticas.categorias[$log.categoria] = 1;
        }
        
        // Contar níveis
        if (struct_exists(estatisticas.niveis, log.nivel)) {
            estatisticas.niveis[$log.nivel]++;
        } else {
            estatisticas.niveis[$log.nivel] = 1;
        }
    }
    
    return estatisticas;
}

/// @description Log de erro
function scr_log_erro(categoria, mensagem, dados = {}) {
    scr_debug_log(categoria, mensagem, "error", dados);
}

/// @description Log de aviso
function scr_log_aviso(categoria, mensagem, dados = {}) {
    scr_debug_log(categoria, mensagem, "warning", dados);
}

/// @description Log de informação
function scr_log_info(categoria, mensagem, dados = {}) {
    scr_debug_log(categoria, mensagem, "info", dados);
}

/// @description Log de debug
function scr_log_debug(categoria, mensagem, dados = {}) {
    scr_debug_log(categoria, mensagem, "debug", dados);
}