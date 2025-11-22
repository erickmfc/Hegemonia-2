/// @function scr_ia_decisao_guerra()
/// @description Cérebro focado puramente em GUERRA e DOMINAÇÃO. Ignora economia.
/// @param {instance} _presidente_id ID da instância do presidente IA
/// @return {string} Decisão a ser tomada (construir_militar, recrutar_*, etc)

function scr_ia_decisao_guerra(_presidente_id) {
    // =================================================================================
    // 1. INTELIGÊNCIA DE COMBATE (Espionagem instantânea)
    // =================================================================================
    
    var dinheiro = global.ia_dinheiro;
    var minerio = global.ia_minerio;
    
    // O que o Jogador tem? (Para fazer o Counter)
    var ameaca_aerea = instance_number(obj_f15) + instance_number(obj_su35) + instance_number(obj_helicoptero_militar);
    
    // Verificar se obj_fragata e obj_destroyer existem antes de usar
    var _ameaca_naval = instance_number(obj_submarino_base);
    var _obj_fragata = asset_get_index("obj_fragata");
    if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object) {
        _ameaca_naval += instance_number(_obj_fragata);
    }
    var _obj_destroyer = asset_get_index("obj_destroyer");
    if (_obj_destroyer != -1 && asset_get_type(_obj_destroyer) == asset_object) {
        _ameaca_naval += instance_number(_obj_destroyer);
    }
    var ameaca_naval = _ameaca_naval;
    
    var ameaca_tanque = instance_number(obj_tanque);
    var _obj_abrams = asset_get_index("obj_M1A_Abrams");
    if (_obj_abrams != -1 && asset_get_type(_obj_abrams) == asset_object) {
        ameaca_tanque += instance_number(_obj_abrams);
    }
    
    // O que a IA tem?
    var meus_quartel = instance_number(obj_quartel);
    var meus_porto = instance_number(obj_quartel_marinha);
    var meus_aero = instance_number(obj_aeroporto_militar);
    
    // Contar exército total (somar todas as unidades da IA)
    var meu_exercito_total = 0;
    var _tipos_contar = [
        obj_infantaria, obj_tanque, obj_blindado_antiaereo, obj_soldado_antiaereo,
        obj_helicoptero_militar, obj_caca_f5, obj_f15, obj_f6, obj_su35, obj_c100,
        obj_lancha_patrulha, obj_RonaldReagan, obj_Constellation, obj_Independence,
        obj_navio_transporte, obj_wwhendrick, obj_submarino_base, obj_navio_base
    ];
    for (var _i = 0; _i < array_length(_tipos_contar); _i++) {
        if (object_exists(_tipos_contar[_i])) {
            with (_tipos_contar[_i]) {
                if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _presidente_id.nacao_proprietaria) {
                    meu_exercito_total++;
                }
            }
        }
    }
    
    // =================================================================================
    // 2. PRIORIDADE DE INFRAESTRUTURA MILITAR (Criar coisas!)
    // =================================================================================
    
    // ✅ AJUSTADO: Construir apenas o mínimo necessário, depois RECRUTAR
    // Se não tenho onde fazer unidades, ISSO é prioridade zero.
    if (meus_quartel < 1 && dinheiro > 500) return "construir_militar"; // Pelo menos 1 quartel
    if (meus_porto < 1 && dinheiro > 600 && meus_quartel >= 1) return "construir_naval"; // Preciso de porto (mas só se já tenho quartel)
    if (meus_aero < 1 && dinheiro > 1000 && meus_quartel >= 1) return "construir_aereo"; // Preciso de aeroporto (mas só se já tenho quartel)
    
    // ✅ CRÍTICO: Se já tenho pelo menos 1 de cada estrutura, PARAR de construir e RECRUTAR
    // Não ficar construindo infinitamente - começar a recrutar AGORA!
    if (meus_quartel >= 1 && meus_porto >= 1 && meus_aero >= 1) {
        // Já tenho tudo - FORÇAR recrutamento (pular para seção 3)
        // Não retornar nada aqui - continuar para a seção de recrutamento
    } else if (meus_quartel >= 1 && (meus_porto >= 1 || meus_aero >= 1)) {
        // Tenho quartel e pelo menos uma estrutura naval/aérea - começar a recrutar
        // Não retornar nada aqui - continuar para a seção de recrutamento
    } else {
        // Ainda falta infraestrutura básica - continuar construindo
        // Mas limitar a expansão - máximo 2 quartéis antes de começar a recrutar
        if (dinheiro > 2000 && meus_quartel < 2 && (meus_porto == 0 || meus_aero == 0)) {
            return "construir_militar";
        }
        // Se já tem 2 quartéis mas falta porto/aeroporto, construir essas
    }

    // =================================================================================
    // 3. ESTRATÉGIA DE RECRUTAMENTO (Counter-Pick)
    // =================================================================================
    
    // --- PRIORIDADE 1: LOGÍSTICA DE INVASÃO ---
    // Se tenho exército mas não tenho como chegar no inimigo, preciso de transporte AGORA.
    var _raio_busca = 5000;
    if (variable_instance_exists(_presidente_id, "raio_expansao")) {
        _raio_busca = _presidente_id.raio_expansao;
    }
    var inimigo = scr_buscar_inimigo(_presidente_id.x, _presidente_id.y, _raio_busca, _presidente_id.nacao_proprietaria);
    var preciso_transporte = false;
    
    if (instance_exists(inimigo)) {
        var dist = point_distance(_presidente_id.x, _presidente_id.y, inimigo.x, inimigo.y);
        // Se longe (>2000) ou se o pathfinding falhar (lógica simplificada aqui)
        if (dist > 2500) preciso_transporte = true;
    }
    
    if (preciso_transporte) {
        var transportes = instance_number(obj_c100) + instance_number(obj_navio_base);
        // Mantém uma proporção: 1 transporte a cada 10 unidades
        if (transportes * 10 < meu_exercito_total) {
            if (meus_aero > 0) return "recrutar_transporte_aereo"; // C-100
            if (meus_porto > 0) return "recrutar_transporte_naval"; // Navio Base
        }
    }

    // --- PRIORIDADE 2: REAÇÃO AO INIMIGO (Counter) ---
    
    // Se o jogador está spamando aviões, foca em Anti-Aéreo
    if (ameaca_aerea > 3) {
        if (random(100) < 70) return "recrutar_antiaereo"; // Gepard ou Soldado AA
        return "recrutar_caca"; // Combate ar-ar
    }
    
    // Se o jogador tem marinha forte, spam de Submarinos (Barato e letal)
    if (ameaca_naval > 2 && meus_porto > 0) {
        return "recrutar_submarino";
    }
    
    // Se o jogador tem muitos tanques, preciso de Tanques Pesados ou Aéreo (Ataque ao solo)
    // ✅ CORREÇÃO: Verificar recursos antes de recrutar bombardeiros
    if (ameaca_tanque > 5) {
        if (meus_aero > 0 && dinheiro >= 2000 && minerio >= 1000) {
            return "recrutar_bombardeiro"; // F-15 ou Su-35 (custo: $2000, 1000 minério)
        }
        if (dinheiro >= 1200 && minerio >= 500) {
            return "recrutar_tanque_pesado"; // M1A Abrams (custo: $1200, 500 minério)
        }
        // Se não tem recursos para nenhum, recrutar tanque básico
        if (dinheiro >= 500 && minerio >= 250) {
            return "recrutar_tanque"; // Tanque básico
        }
    }
    
    // --- PRIORIDADE 3: ATAQUE PADRÃO (Massificar) ---
    
    // ✅ AJUSTADO: Forçar recrutamento mesmo sem ameaças específicas
    // Se não tem ameaça específica, cria o "Meta" (melhores unidades custo-benefício)
    var sorteio = irandom(100);
    
    // ✅ PRIORIDADE NAVAL: Se tem porto, recrutar navios (70% de chance - ALTA PRIORIDADE)
    if (meus_porto > 0) {
        if (sorteio < 70) {
            // Tentar recrutar submarino primeiro (barato e letal)
            if (dinheiro >= 2000 && minerio >= 1000) return "recrutar_submarino";
            // Se não tem recursos para submarino, tentar destroyer
            if (dinheiro >= 1500 && minerio >= 750) return "recrutar_destroyer";
        }
    }
    
    // ✅ PRIORIDADE AÉREA: Se tem aeroporto, recrutar aviões (80% de chance - ALTA PRIORIDADE)
    if (meus_aero > 0) {
        if (sorteio < 80) {
            // Tentar recrutar helicóptero (mais barato)
            if (dinheiro >= 800 && minerio >= 300) return "recrutar_helicoptero";
            // Se não, tentar caça
            if (dinheiro >= 1500 && minerio >= 500) return "recrutar_caca";
        }
    }
    
    // ✅ FORÇAR RECRUTAMENTO: Se tem infraestrutura, sempre recrutar algo
    // Padrãozão: Infantaria e Tanques para fazer volume
    if (meus_quartel > 0) {
        if (minerio >= 250 && dinheiro >= 500) return "recrutar_tanque";
        if (dinheiro >= 100) return "recrutar_infantaria";
    }
    
    // ✅ FALLBACK: Se não tem recursos para nada, pelo menos tentar construir mais infraestrutura
    if (dinheiro > 500 && meus_quartel < 2) return "construir_militar";
    
    // Último fallback: recrutar infantaria (sempre disponível)
    return "recrutar_infantaria";
}
