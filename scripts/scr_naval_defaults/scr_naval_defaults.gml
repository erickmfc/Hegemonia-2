/// scr_naval_defaults.gml
/// Definições de classes navais e aplicação de atributos padrão

enum NAVAL_CLASS {
    CORVETA,
    FRAGATA,
    DESTROYER,
    CRUZADOR,
    PORTA_AVIOES,
}

function naval_get_defaults(_classe) {
    var stats = {
        hp_max: 100,
        velocidade: 2.6,
        alcance_ataque: 220,
        atira: true,
        dano: 14,
        atq_rate: 45
    };

    switch (_classe) {
        case NAVAL_CLASS.CORVETA:
            stats.hp_max = 90;
            stats.velocidade = 3.4;
            stats.alcance_ataque = 200;
            stats.dano = 12;
            stats.atq_rate = 36;
            break;
        case NAVAL_CLASS.FRAGATA:
            stats.hp_max = 160;
            stats.velocidade = 2.6;
            stats.alcance_ataque = 300;
            stats.dano = 18;
            stats.atq_rate = 42;
            break;
        case NAVAL_CLASS.DESTROYER:
            stats.hp_max = 260;
            stats.velocidade = 2.2;
            stats.alcance_ataque = 420;
            stats.dano = 26;
            stats.atq_rate = 54;
            break;
        case NAVAL_CLASS.CRUZADOR:
            stats.hp_max = 360;
            stats.velocidade = 1.9;
            stats.alcance_ataque = 520;
            stats.dano = 32;
            stats.atq_rate = 60;
            break;
        case NAVAL_CLASS.PORTA_AVIOES:
            stats.hp_max = 500;
            stats.velocidade = 1.4;
            stats.alcance_ataque = 0;    // ataque indireto (aviões/drones)
            stats.atira = false;
            stats.dano = 0;
            stats.atq_rate = 0;
            break;
    }
    return stats;
}

function naval_apply_defaults(_inst, _classe) {
    var s = naval_get_defaults(_classe);
    with (_inst) {
        hp_max = s.hp_max;
        hp_atual = s.hp_max;
        velocidade = s.velocidade;
        alcance_ataque = s.alcance_ataque;
        atira = s.atira;
        dano_ataque = s.dano;
        atq_rate = s.atq_rate;
        if (!variable_instance_exists(id, "classe")) classe = _classe;
    }
}


