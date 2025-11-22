# 🚢 PLANO DE LIMPEZA E PADRONIZAÇÃO DE NAVIOS

## 📋 OBJETIVO
Limpar código de navegação problemático e padronizar usando Lancha Patrulha como base.

---

## 🎯 NAVIOS A LIMPAR

### 1. **Constellation** ✅
- Limpar: Sistema de navegação
- Preservar: Sistema de mísseis (Sky/Iron)
- Base: Lancha Patrulha

### 2. **Independence** ✅
- Limpar: Sistema de navegação  
- Preservar: Sistema de canhão/mísseis
- Base: Lancha Patrulha

### 3. **Ww-Hendrick** ✅
- Limpar: Sistema de navegação
- Preservar: Características específicas
- Base: Lancha Patrulha

### 4. **Ronald Reagan** ✅
- Limpar: Sistema de navegação
- Preservar: 
  - Sistema de embarque/desembarque
  - Funções de controle de aeronaves
  - Capacidade de transporte (3 tipos)
- Base: Lancha Patrulha

---

## 🔧 SISTEMA BASE (LANCHA PATRULHA)

### Componentes a Copiar:
1. **Create_0.gml**:
   - Enums: `LanchaState` e `LanchaMode`
   - Física de movimento (novo sistema)
   - Variáveis de navegação
   - Sistema de patrulha
   - Funções: `ordem_mover`, `func_procurar_inimigo`, `func_atacar_alvo`

2. **Step_0.gml**:
   - Frame skip com LOD
   - Comandos P/O/L
   - Sistema de física com inércia
   - Máquina de estados
   - Lógica de patrulha
   - Sistema de ataque

3. **Draw_0.gml**:
   - Feedback visual de seleção
   - Linhas de movimento
   - Rota de patrulha

---

## 📝 ESPECIFICAÇÕES POR NAVIO

### Constellation
```
HP: 1500
Velocidade: 1.5
moveSpeed: 3.0
acceleration: 0.12
turnSpeed: 2.0
Radar: 800
Mísseis: Sky/Iron
```

### Independence
```
HP: 1500
Velocidade: 1.5
moveSpeed: 3.0
acceleration: 0.12
turnSpeed: 2.0
Radar: 800
Canhão + Mísseis: Sky/Iron
```

### Ww-Hendrick
```
HP: 800
Velocidade: 2.0
moveSpeed: 4.0
acceleration: 0.18
turnSpeed: 3.0
Radar: 600
```

### Ronald Reagan
```
HP: 4000
Velocidade: 0.7
moveSpeed: 1.4
acceleration: 0.07
turnSpeed: 1.2
Radar: 1000
Transporte: Aviões/Veículos/Soldados
```

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### Para cada navio:
- [ ] Backup do código atual (documentar)
- [ ] Limpar Create_0.gml (navegação)
- [ ] Copiar base da Lancha
- [ ] Ajustar estatísticas específicas
- [ ] Preservar funções especiais
- [ ] Limpar Step_0.gml (navegação)
- [ ] Copiar lógica da Lancha
- [ ] Reintegrar funções especiais
- [ ] Testar movimento
- [ ] Testar patrulha
- [ ] Testar ataque
- [ ] Testar funções especiais

---

## 🚨 ATENÇÃO - NÃO REMOVER

### Ronald Reagan - Preservar:
- `embarcar_unidade()`
- `desembarcar_proxima()`
- `eh_embarcavel()`
- `tipo_unidade()`
- `funcao_embarcar_unidade()`
- `funcao_embarcar_aeronave()`
- `funcao_embarcar_veiculo()`
- `funcao_desembarcar_soldado()`
- `funcao_desembarcar_aeronave()`
- Variáveis: `avioes_embarcados`, `unidades_embarcadas`, `soldados_embarcados`
- Contadores: `avioes_count`, `unidades_count`, `soldados_count`
- Capacidades: `avioes_max`, `unidades_max`, `soldados_max`

### Constellation/Independence - Preservar:
- Sistema de mísseis específico
- `pode_disparar_missil`
- Lógica de seleção de mísseis

---

## 📊 ORDEM DE EXECUÇÃO

1. ✅ Constellation (mais simples)
2. ✅ Independence (similar ao Constellation)
3. ✅ Ww-Hendrick (intermediário)
4. ✅ Ronald Reagan (mais complexo - muitas funções)

---

**Status**: Pronto para começar
**Próximo**: Limpar Constellation

