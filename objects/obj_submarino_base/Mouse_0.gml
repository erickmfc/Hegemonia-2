// ===============================================
// HEGEMONIA GLOBAL - CLIQUE ESQUERDO (SUBMARINO BASE)
// Sistema de Interação com Clique (SE JÁ ESTIVER SELECIONADO)
// ===============================================

// Se JÁ estiver selecionado - Alternar Submersão/Emergência
// (Se não estiver selecionado, o clique é ignorado - usado apenas para seleção)
if (selecionado && global.unidade_selecionada == id) {
    // Já estava selecionado antes do clique - perguntar sobre submersão
    if (submerso) {
        // Perguntar se quer emergir
        var _resposta = show_question("🌊 Submarino está SUBMERSO\n\nDeseja EMERGIR?");
        if (_resposta) {
            func_emergir();
        }
    } else {
        // Perguntar se quer submergir
        var _resposta = show_question("🌊 Submarino está NA SUPERFÍCIE\n\nDeseja SUBMERGIR?");
        if (_resposta) {
            func_submergir();
        }
    }
}

