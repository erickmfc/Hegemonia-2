/// @function scr_validacao_periodica()
/// @description Executa validação periódica do sistema (chamada a cada frame)
/// @description Configuração: global.timer_validacao controla o intervalo

function scr_validacao_periodica() {
    // ✅ SEMPRE VERIFICAR: variável global existe antes de usar
    if (!variable_global_exists("timer_validacao")) {
        global.timer_validacao = 300; // 5 segundos a 60 FPS (padrão)
    }
    
    // Decrementar timer
    if (global.timer_validacao <= 0) {
        // Executar validação completa
        scr_validar_sistema_completo();
        
        // Resetar timer (5-10 segundos)
        var _intervalo = 300; // 5 segundos padrão
        if (variable_global_exists("validation_interval")) {
            _intervalo = global.validation_interval;
        }
        global.timer_validacao = _intervalo;
    } else {
        global.timer_validacao--;
    }
}

