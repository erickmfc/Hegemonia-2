/// @function scr_gerar_nome_objeto(_tipo_objeto, _indice)
/// @description Gera um nome único para objetos baseado no tipo e índice
/// @param {String} _tipo_objeto Tipo do objeto (ex: "F-5", "Helicoptero", "Lancha")
/// @param {Real} _indice Índice numérico do objeto
/// @return {String} Nome gerado para o objeto

function scr_gerar_nome_objeto(_tipo_objeto, _indice) {
    // ===============================================
    // HEGEMONIA GLOBAL - GERADOR DE NOMES
    // Sistema para gerar nomes únicos para objetos
    // ===============================================
    
    var _nome_base = "";
    var _sufixo = "";
    
    // Definir nome base baseado no tipo
    switch (_tipo_objeto) {
        case "F-5":
        case "obj_caca_f5":
            _nome_base = "F-5";
            _sufixo = scr_gerar_codigo_aereo(_indice);
            break;
            
        case "Helicoptero":
        case "obj_helicoptero_militar":
            _nome_base = "Helicóptero";
            _sufixo = scr_gerar_codigo_aereo(_indice);
            break;
            
        case "Lancha":
        case "obj_lancha_patrulha":
            _nome_base = "Lancha";
            _sufixo = scr_gerar_codigo_naval(_indice);
            break;
            
        case "Fragata":
        case "obj_fragata":
            _nome_base = "Fragata";
            _sufixo = scr_gerar_codigo_naval(_indice);
            break;
            
        case "Destroyer":
        case "obj_destroyer":
            _nome_base = "Destroyer";
            _sufixo = scr_gerar_codigo_naval(_indice);
            break;
            
        case "Tanque":
        case "obj_tanque":
            _nome_base = "Tanque";
            _sufixo = scr_gerar_codigo_terrestre(_indice);
            break;
            
        case "Infantaria":
        case "obj_infantaria":
            _nome_base = "Pelotão";
            _sufixo = scr_gerar_codigo_terrestre(_indice);
            break;
            
        default:
            _nome_base = "Unidade";
            _sufixo = "ALPHA-" + string(_indice);
            break;
    }
    
    return _nome_base + " " + _sufixo;
}

/// @function scr_gerar_codigo_aereo(_indice)
/// @description Gera código de identificação para unidades aéreas
/// @param {Real} _indice Índice numérico
/// @return {String} Código aéreo

function scr_gerar_codigo_aereo(_indice) {
    var _letras = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"];
    var _numeros = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10"];
    
    var _letra = _letras[(_indice - 1) mod 10];
    var _numero = _numeros[(_indice - 1) div 10];
    
    return _letra + _numero;
}

/// @function scr_gerar_codigo_naval(_indice)
/// @description Gera código de identificação para unidades navais
/// @param {Real} _indice Índice numérico
/// @return {String} Código naval

function scr_gerar_codigo_naval(_indice) {
    var _prefixos = ["USS", "HMS", "FS", "JS", "INS"];
    var _nomes = ["Vigilante", "Defensor", "Protetor", "Guardião", "Sentinela", 
                  "Valoroso", "Audaz", "Intrépido", "Corajoso", "Destemido"];
    
    var _prefixo = _prefixos[(_indice - 1) mod 5];
    var _nome = _nomes[(_indice - 1) mod 10];
    var _numero = string(_indice);
    
    return _prefixo + " " + _nome + "-" + _numero;
}

/// @function scr_gerar_codigo_terrestre(_indice)
/// @description Gera código de identificação para unidades terrestres
/// @param {Real} _indice Índice numérico
/// @return {String} Código terrestre

function scr_gerar_codigo_terrestre(_indice) {
    var _companhias = ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot"];
    var _pelotoes = ["1º", "2º", "3º", "4º", "5º", "6º"];
    
    var _companhia = _companhias[(_indice - 1) mod 6];
    var _pelotao = _pelotoes[(_indice - 1) div 6];
    
    return _companhia + " " + _pelotao;
}

/// @function scr_gerar_nome_edificio(_tipo_edificio, _indice)
/// @description Gera nome para edifícios
/// @param {String} _tipo_edificio Tipo do edifício
/// @param {Real} _indice Índice numérico
/// @return {String} Nome do edifício

function scr_gerar_nome_edificio(_tipo_edificio, _indice) {
    var _nome_base = "";
    var _sufixo = "";
    
    switch (_tipo_edificio) {
        case "Quartel":
        case "obj_quartel":
            _nome_base = "Quartel";
            _sufixo = "Base " + string(_indice);
            break;
            
        case "Quartel Marinha":
        case "obj_quartel_marinha":
            _nome_base = "Base Naval";
            _sufixo = "Porto " + string(_indice);
            break;
            
        case "Aeroporto":
        case "obj_aeroporto_militar":
            _nome_base = "Aeroporto Militar";
            _sufixo = "Campo " + string(_indice);
            break;
            
        case "Casa":
        case "obj_casa":
            _nome_base = "Residência";
            _sufixo = "Bloco " + string(_indice);
            break;
            
        case "Banco":
        case "obj_banco":
            _nome_base = "Banco Central";
            _sufixo = "Sede " + string(_indice);
            break;
            
        case "Centro Pesquisa":
        case "obj_research_center":
            _nome_base = "Centro de Pesquisa";
            _sufixo = "Laboratório " + string(_indice);
            break;
            
        default:
            _nome_base = "Edifício";
            _sufixo = "Estrutura " + string(_indice);
            break;
    }
    
    return _nome_base + " " + _sufixo;
}

/// @function scr_gerar_nome_cidade(_indice)
/// @description Gera nome para cidades
/// @param {Real} _indice Índice numérico
/// @return {String} Nome da cidade

function scr_gerar_nome_cidade(_indice) {
    var _prefixos = ["Nova", "Vila", "Cidade", "Porto", "Vale"];
    var _sufixos = ["Verde", "Azul", "Dourada", "Branca", "Vermelha", 
                    "do Norte", "do Sul", "do Leste", "do Oeste", "Central"];
    
    var _prefixo = _prefixos[(_indice - 1) mod 5];
    var _sufixo = _sufixos[(_indice - 1) mod 10];
    
    return _prefixo + " " + _sufixo;
}

/// @function scr_gerar_nome_missao(_tipo_missao, _indice)
/// @description Gera nome para missões
/// @param {String} _tipo_missao Tipo da missão
/// @param {Real} _indice Índice numérico
/// @return {String} Nome da missão

function scr_gerar_nome_missao(_tipo_missao, _indice) {
    var _nome_base = "";
    var _codigo = "";
    
    switch (_tipo_missao) {
        case "Patrulha":
            _nome_base = "Patrulha";
            _codigo = "PAT-" + string(_indice);
            break;
            
        case "Reconhecimento":
            _nome_base = "Reconhecimento";
            _codigo = "REC-" + string(_indice);
            break;
            
        case "Ataque":
            _nome_base = "Ataque";
            _codigo = "ATK-" + string(_indice);
            break;
            
        case "Defesa":
            _nome_base = "Defesa";
            _codigo = "DEF-" + string(_indice);
            break;
            
        case "Escolta":
            _nome_base = "Escolta";
            _codigo = "ESC-" + string(_indice);
            break;
            
        default:
            _nome_base = "Missão";
            _codigo = "MIS-" + string(_indice);
            break;
    }
    
    return _nome_base + " " + _codigo;
}